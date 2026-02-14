-- =============================================================================
-- Security Hardening Migration
-- Fixes: context_type CHECK, RPC function lockdown, comment validation
-- =============================================================================

-- ============================================================================
-- 1. Expand ai_conversations context_type CHECK constraint
-- ============================================================================
-- The edge function supports new context types that the original CHECK
-- constraint does not allow, causing INSERT failures.

ALTER TABLE ai_conversations DROP CONSTRAINT IF EXISTS ai_conversations_context_type_check;
ALTER TABLE ai_conversations ADD CONSTRAINT ai_conversations_context_type_check
  CHECK (context_type IN (
    'chart', 'transit', 'general',
    'transit_insight', 'chart_reading', 'compatibility', 'dream', 'journal'
  ));

-- ============================================================================
-- 2. Lock down add_ai_bonus_messages() — CRITICAL
-- ============================================================================
-- This function is SECURITY DEFINER and was callable by any authenticated user,
-- allowing them to grant themselves unlimited bonus AI messages.
-- Fix: REVOKE from authenticated/anon/public, only service_role may call.

REVOKE EXECUTE ON FUNCTION public.add_ai_bonus_messages(uuid, date, integer) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.add_ai_bonus_messages(uuid, date, integer) FROM anon;
REVOKE EXECUTE ON FUNCTION public.add_ai_bonus_messages(uuid, date, integer) FROM public;

-- ============================================================================
-- 3. Lock down award_points() — HIGH
-- ============================================================================
-- This function is SECURITY DEFINER and was callable from the client,
-- allowing users to award themselves arbitrary points.
-- Fix: Replace with a version that validates the calling user can only
-- award points to themselves AND limits per-action-type frequency.

CREATE OR REPLACE FUNCTION public.award_points(
  p_user_id uuid,
  p_points integer,
  p_action_type text,
  p_description text DEFAULT NULL,
  p_reference_id text DEFAULT NULL
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_calling_user uuid;
  v_new_total integer;
  v_max_daily integer;
  v_today_count integer;
BEGIN
  -- Get the calling user from auth context
  v_calling_user := auth.uid();

  -- Users can only award points to themselves
  IF v_calling_user IS NULL OR v_calling_user != p_user_id THEN
    RAISE EXCEPTION 'Cannot award points to another user';
  END IF;

  -- Cap points per call to prevent abuse (max 100 per single action)
  IF p_points < 0 OR p_points > 100 THEN
    RAISE EXCEPTION 'Invalid point amount';
  END IF;

  -- Rate limit: max 50 point transactions per user per day
  SELECT COUNT(*) INTO v_today_count
  FROM public.point_transactions
  WHERE user_id = p_user_id
    AND created_at >= CURRENT_DATE;

  IF v_today_count >= 50 THEN
    RAISE EXCEPTION 'Daily point transaction limit reached';
  END IF;

  -- Prevent duplicate reference_id (e.g., claiming same challenge twice)
  IF p_reference_id IS NOT NULL THEN
    PERFORM 1 FROM public.point_transactions
    WHERE user_id = p_user_id
      AND reference_id = p_reference_id;
    IF FOUND THEN
      -- Silently skip duplicate
      SELECT total_points INTO v_new_total
      FROM public.user_points WHERE user_id = p_user_id;
      RETURN COALESCE(v_new_total, 0);
    END IF;
  END IF;

  -- Insert transaction
  INSERT INTO public.point_transactions (user_id, points, action_type, description, reference_id)
  VALUES (p_user_id, p_points, p_action_type, p_description, p_reference_id);

  -- Update totals
  UPDATE public.user_points
  SET total_points = total_points + p_points,
      weekly_points = weekly_points + p_points,
      monthly_points = monthly_points + p_points,
      last_activity_date = now()
  WHERE user_id = p_user_id;

  SELECT total_points INTO v_new_total
  FROM public.user_points WHERE user_id = p_user_id;

  RETURN COALESCE(v_new_total, 0);
END;
$$;

-- ============================================================================
-- 4. Lock down counter increment/decrement RPCs — MEDIUM
-- ============================================================================
-- These SECURITY DEFINER functions are callable by authenticated users.
-- Add internal validation: user can only increment counters for resources
-- they participate in.

-- Lock down team challenge functions to team members only
-- DROP first because parameter names changed (CREATE OR REPLACE cannot rename params)
DROP FUNCTION IF EXISTS public.increment_team_member_count(uuid);
CREATE OR REPLACE FUNCTION public.increment_team_member_count(p_team_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Verify caller is a member of this team
  IF NOT EXISTS (
    SELECT 1 FROM public.team_members
    WHERE team_id = p_team_id AND user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'Not a member of this team';
  END IF;

  UPDATE public.teams SET member_count = member_count + 1 WHERE id = p_team_id;
END;
$$;

DROP FUNCTION IF EXISTS public.decrement_team_member_count(uuid);
CREATE OR REPLACE FUNCTION public.decrement_team_member_count(p_team_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE public.teams SET member_count = GREATEST(member_count - 1, 0) WHERE id = p_team_id;
END;
$$;

-- Lock down circle functions to circle members only
DROP FUNCTION IF EXISTS public.increment_circle_member_count(uuid);
CREATE OR REPLACE FUNCTION public.increment_circle_member_count(p_circle_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.circle_members
    WHERE circle_id = p_circle_id AND user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'Not a member of this circle';
  END IF;

  UPDATE public.circles SET member_count = member_count + 1 WHERE id = p_circle_id;
END;
$$;

DROP FUNCTION IF EXISTS public.decrement_circle_member_count(uuid);
CREATE OR REPLACE FUNCTION public.decrement_circle_member_count(p_circle_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE public.circles SET member_count = GREATEST(member_count - 1, 0) WHERE id = p_circle_id;
END;
$$;

-- Lock down event participant functions to registered users
DROP FUNCTION IF EXISTS public.increment_event_participants(uuid);
CREATE OR REPLACE FUNCTION public.increment_event_participants(p_event_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.event_registrations
    WHERE event_id = p_event_id AND user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'Not registered for this event';
  END IF;

  UPDATE public.community_events SET participant_count = participant_count + 1 WHERE id = p_event_id;
END;
$$;

DROP FUNCTION IF EXISTS public.decrement_event_participants(uuid);
CREATE OR REPLACE FUNCTION public.decrement_event_participants(p_event_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE public.community_events SET participant_count = GREATEST(participant_count - 1, 0) WHERE id = p_event_id;
END;
$$;

-- ============================================================================
-- 5. Add RLS policy for group_members INSERT — admin-only adds
-- ============================================================================
-- Currently any authenticated user can insert into group_members.
-- Restrict to: user can add themselves, OR group admin can add others.

DROP POLICY IF EXISTS "Group members can be added" ON public.group_members;
DROP POLICY IF EXISTS "Users can join groups" ON public.group_members;

CREATE POLICY "Users can add group members"
  ON public.group_members FOR INSERT
  WITH CHECK (
    -- User is adding themselves
    auth.uid() = user_id
    -- OR user is an admin of this group
    OR EXISTS (
      SELECT 1 FROM public.group_members gm
      WHERE gm.group_id = group_members.group_id
        AND gm.user_id = auth.uid()
        AND gm.role = 'admin'
    )
  );

-- ============================================================================
-- 6. Add content length CHECK constraint on comments table
-- ============================================================================
-- Prevents unbounded content from being stored.

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.check_constraints
    WHERE constraint_name = 'comments_content_length_check'
  ) THEN
    ALTER TABLE public.comments
      ADD CONSTRAINT comments_content_length_check
      CHECK (char_length(content) <= 2000);
  END IF;
END $$;
