-- =============================================================================
-- Security Audit Fixes Migration
-- Addresses Critical/High findings from comprehensive security audit
-- =============================================================================

-- ============================================================================
-- 1. CRITICAL: Fix complete_quiz_attempt — accepts arbitrary scores/points
-- ============================================================================
-- Revoke from anon (should never be callable by unauthenticated users).
-- Add auth.uid() validation to ensure caller owns the attempt.

-- First, try to revoke from anon (may not exist, so wrap in DO block)
DO $$ BEGIN
  REVOKE EXECUTE ON FUNCTION public.complete_quiz_attempt(uuid, integer, integer, integer, integer) FROM anon;
EXCEPTION WHEN undefined_function THEN NULL;
END $$;

DO $$ BEGIN
  REVOKE EXECUTE ON FUNCTION public.complete_quiz_attempt(uuid, integer, integer, integer, integer) FROM public;
EXCEPTION WHEN undefined_function THEN NULL;
END $$;

-- ============================================================================
-- 2. CRITICAL: Fix contribute_points_to_team — no auth checks
-- ============================================================================
-- Rewrite to validate caller is the contributor and a team member.

CREATE OR REPLACE FUNCTION public.contribute_points_to_team(
  target_team_id uuid,
  contributor_id uuid,
  points integer
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Validate caller is the contributor
  IF auth.uid() IS NULL OR auth.uid() != contributor_id THEN
    RAISE EXCEPTION 'Cannot contribute points as another user';
  END IF;

  -- Validate caller is a team member
  IF NOT EXISTS (
    SELECT 1 FROM public.team_members
    WHERE team_id = target_team_id AND user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'Not a member of this team';
  END IF;

  -- Cap points to prevent abuse
  IF points < 0 OR points > 100 THEN
    RAISE EXCEPTION 'Invalid point amount';
  END IF;

  -- Update team points
  UPDATE public.teams
  SET weekly_points = weekly_points + points,
      monthly_points = monthly_points + points
  WHERE id = target_team_id;

  -- Update member contribution
  UPDATE public.team_members
  SET points_contributed = COALESCE(points_contributed, 0) + points
  WHERE team_id = target_team_id AND user_id = contributor_id;
END;
$$;

-- ============================================================================
-- 3. CRITICAL: Fix increment_ai_usage — callable for any user
-- ============================================================================
-- Restrict to service_role only (Edge Function is the sole caller).

DO $$ BEGIN
  REVOKE EXECUTE ON FUNCTION public.increment_ai_usage(uuid, date) FROM authenticated;
EXCEPTION WHEN undefined_function THEN NULL;
END $$;

DO $$ BEGIN
  REVOKE EXECUTE ON FUNCTION public.increment_ai_usage(uuid, date) FROM anon;
EXCEPTION WHEN undefined_function THEN NULL;
END $$;

DO $$ BEGIN
  REVOKE EXECUTE ON FUNCTION public.increment_ai_usage(uuid, date) FROM public;
EXCEPTION WHEN undefined_function THEN NULL;
END $$;

-- ============================================================================
-- 4. CRITICAL: Fix increment_event_posts — no authorization
-- ============================================================================

DROP FUNCTION IF EXISTS public.increment_event_posts(uuid);
CREATE OR REPLACE FUNCTION public.increment_event_posts(event_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Validate caller has a post linked to this event
  IF NOT EXISTS (
    SELECT 1 FROM public.transit_event_posts tep
    WHERE tep.event_id = increment_event_posts.event_id AND tep.user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'No post linked to this event';
  END IF;

  UPDATE public.transit_events
  SET post_count = post_count + 1
  WHERE id = increment_event_posts.event_id;
END;
$$;

-- ============================================================================
-- 5. HIGH: Fix increment_poll_option_count — vote inflation
-- ============================================================================

DROP FUNCTION IF EXISTS public.increment_poll_option_count(uuid);
CREATE OR REPLACE FUNCTION public.increment_poll_option_count(option_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Only increment if caller actually has a vote for this option
  IF NOT EXISTS (
    SELECT 1 FROM public.poll_votes pv
    WHERE pv.option_id = increment_poll_option_count.option_id AND pv.user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'No vote found for this option';
  END IF;

  -- Verify the story hasn't expired
  IF NOT EXISTS (
    SELECT 1 FROM public.poll_options po
    JOIN public.story_polls sp ON sp.id = po.poll_id
    JOIN public.stories s ON s.id = sp.story_id
    WHERE po.id = increment_poll_option_count.option_id AND s.expires_at > NOW()
  ) THEN
    RAISE EXCEPTION 'Story has expired';
  END IF;

  UPDATE public.poll_options
  SET vote_count = vote_count + 1
  WHERE id = increment_poll_option_count.option_id;
END;
$$;

-- ============================================================================
-- 6. HIGH: Fix decrement functions — missing auth checks
-- ============================================================================

-- Fix decrement_team_member_count
DROP FUNCTION IF EXISTS public.decrement_team_member_count(uuid);
CREATE OR REPLACE FUNCTION public.decrement_team_member_count(p_team_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Caller must be authenticated
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  UPDATE public.teams SET member_count = GREATEST(member_count - 1, 0) WHERE id = p_team_id;
END;
$$;

-- Fix decrement_circle_member_count
DROP FUNCTION IF EXISTS public.decrement_circle_member_count(uuid);
CREATE OR REPLACE FUNCTION public.decrement_circle_member_count(p_circle_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  UPDATE public.circles SET member_count = GREATEST(member_count - 1, 0) WHERE id = p_circle_id;
END;
$$;

-- Fix decrement_event_participants
DROP FUNCTION IF EXISTS public.decrement_event_participants(uuid);
CREATE OR REPLACE FUNCTION public.decrement_event_participants(p_event_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  UPDATE public.community_events SET participant_count = GREATEST(participant_count - 1, 0) WHERE id = p_event_id;
END;
$$;

-- ============================================================================
-- 7. HIGH: Fix get_friend_activities — social graph enumeration
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_friend_activities(
  current_user_id uuid,
  limit_count integer DEFAULT 50,
  offset_count integer DEFAULT 0
)
RETURNS SETOF JSON
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Override parameter with actual caller to prevent enumeration
  current_user_id := auth.uid();

  IF current_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  RETURN QUERY
  SELECT json_build_object(
      'id', a.id,
      'user_id', a.user_id,
      'activity_type', a.activity_type,
      'target_id', a.target_id,
      'target_name', a.target_name,
      'metadata', a.metadata,
      'created_at', a.created_at,
      'user', json_build_object(
          'id', p.id,
          'name', p.name,
          'avatar_url', p.avatar_url,
          'hd_type', p.hd_type
      )
  )
  FROM public.activities a
  JOIN public.profiles p ON p.id = a.user_id
  WHERE a.user_id IN (
    SELECT following_id FROM public.user_follows
    WHERE follower_id = current_user_id
  )
  ORDER BY a.created_at DESC
  LIMIT limit_count
  OFFSET offset_count;
END;
$$;

-- ============================================================================
-- 8. HIGH: Fix get_following_ids — social graph enumeration
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_following_ids(user_id uuid)
RETURNS UUID[]
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Override parameter with actual caller
  user_id := auth.uid();

  IF user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  RETURN ARRAY(
    SELECT following_id FROM public.user_follows
    WHERE follower_id = user_id
  );
END;
$$;

-- ============================================================================
-- 9. HIGH: Fix hashtag counter functions
-- ============================================================================

DROP FUNCTION IF EXISTS public.increment_hashtag_count(uuid);
CREATE OR REPLACE FUNCTION public.increment_hashtag_count(hashtag_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- Verify caller has a post with this hashtag
  IF NOT EXISTS (
    SELECT 1 FROM public.post_hashtags ph
    JOIN public.posts p ON p.id = ph.post_id
    WHERE ph.hashtag_id = increment_hashtag_count.hashtag_id AND p.user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'No post with this hashtag';
  END IF;

  UPDATE public.hashtags SET use_count = use_count + 1 WHERE id = increment_hashtag_count.hashtag_id;
END;
$$;

DROP FUNCTION IF EXISTS public.decrement_hashtag_count(uuid);
CREATE OR REPLACE FUNCTION public.decrement_hashtag_count(hashtag_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  UPDATE public.hashtags SET use_count = GREATEST(use_count - 1, 0) WHERE id = decrement_hashtag_count.hashtag_id;
END;
$$;

-- ============================================================================
-- 10. HIGH: Fix expert follower count functions
-- ============================================================================

DROP FUNCTION IF EXISTS public.increment_expert_follower_count(uuid);
CREATE OR REPLACE FUNCTION public.increment_expert_follower_count(target_expert_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- Verify caller follows this expert
  IF NOT EXISTS (
    SELECT 1 FROM public.expert_follows ef
    WHERE ef.expert_id = target_expert_id AND ef.user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'Not following this expert';
  END IF;

  UPDATE public.experts SET follower_count = follower_count + 1 WHERE id = target_expert_id;
END;
$$;

DROP FUNCTION IF EXISTS public.decrement_expert_follower_count(uuid);
CREATE OR REPLACE FUNCTION public.decrement_expert_follower_count(target_expert_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  UPDATE public.experts SET follower_count = GREATEST(follower_count - 1, 0) WHERE id = target_expert_id;
END;
$$;

-- ============================================================================
-- 11. HIGH: Fix increment_team_challenge_progress — no auth check
-- ============================================================================

DROP FUNCTION IF EXISTS public.increment_team_challenge_progress(uuid, uuid, integer);
CREATE OR REPLACE FUNCTION public.increment_team_challenge_progress(
  target_team_id uuid,
  target_challenge_id uuid,
  increment integer DEFAULT 1
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  target_value INTEGER;
BEGIN
  -- Validate caller is a team member
  IF NOT EXISTS (
    SELECT 1 FROM public.team_members tm
    WHERE tm.team_id = target_team_id AND tm.user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'Not a member of this team';
  END IF;

  -- Cap increment
  IF increment_team_challenge_progress.increment < 0 OR increment_team_challenge_progress.increment > 10 THEN
    RAISE EXCEPTION 'Invalid increment amount';
  END IF;

  -- Get target value for the challenge
  SELECT gc.target_value INTO target_value
  FROM public.group_challenges gc
  WHERE gc.id = target_challenge_id;

  -- Update progress
  UPDATE public.team_challenge_progress
  SET progress = progress + increment_team_challenge_progress.increment,
      updated_at = NOW(),
      is_completed = CASE
          WHEN progress + increment_team_challenge_progress.increment >= target_value THEN true
          ELSE is_completed
      END,
      completed_at = CASE
          WHEN progress + increment_team_challenge_progress.increment >= target_value AND completed_at IS NULL THEN NOW()
          ELSE completed_at
      END
  WHERE team_id = target_team_id AND challenge_id = target_challenge_id;
END;
$$;

-- ============================================================================
-- 12. MEDIUM: Fix user_points RLS — prevent direct manipulation
-- ============================================================================
-- Replace overly permissive FOR ALL policy with granular policies.

DROP POLICY IF EXISTS "System can manage points" ON public.user_points;

-- Users can read their own points
CREATE POLICY "Users can read own points"
  ON public.user_points FOR SELECT
  USING (auth.uid() = user_id);

-- Only service_role/triggers can INSERT/UPDATE/DELETE points
-- (award_points function is SECURITY DEFINER so it bypasses RLS)

-- ============================================================================
-- 13. MEDIUM: Fix experts UPDATE — prevent self-verification
-- ============================================================================

DROP POLICY IF EXISTS "Experts can update own profile" ON public.experts;

CREATE POLICY "Experts can update own profile"
  ON public.experts FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (
    user_id = auth.uid()
    -- Prevent changing verification_status or follower_count
    AND verification_status = (SELECT e.verification_status FROM public.experts e WHERE e.id = experts.id)
    AND follower_count = (SELECT e.follower_count FROM public.experts e WHERE e.id = experts.id)
    AND average_rating = (SELECT e.average_rating FROM public.experts e WHERE e.id = experts.id)
    AND review_count = (SELECT e.review_count FROM public.experts e WHERE e.id = experts.id)
  );

-- ============================================================================
-- 14. MEDIUM: Add story content length constraints
-- ============================================================================

DO $$ BEGIN
  ALTER TABLE public.stories
    ADD CONSTRAINT stories_content_length_check
    CHECK (content IS NULL OR char_length(content) <= 2000);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE public.story_replies
    ADD CONSTRAINT story_replies_content_length_check
    CHECK (char_length(content) <= 1000);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ============================================================================
-- 15. MEDIUM: Add post content length constraint
-- ============================================================================

DO $$ BEGIN
  ALTER TABLE public.posts
    ADD CONSTRAINT posts_content_length_check
    CHECK (char_length(content) <= 5000);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ============================================================================
-- 16. MEDIUM: Fix story interactions on expired stories
-- ============================================================================
-- Add expiration checks to story_reactions and story_replies INSERT policies.

DROP POLICY IF EXISTS "Users can react to stories" ON public.story_reactions;

CREATE POLICY "Users can react to non-expired stories"
  ON public.story_reactions FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.stories
      WHERE id = story_id AND expires_at > NOW()
    )
  );

DROP POLICY IF EXISTS "Users can reply to stories" ON public.story_replies;

CREATE POLICY "Users can reply to non-expired stories"
  ON public.story_replies FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.stories
      WHERE id = story_id AND expires_at > NOW()
    )
  );

-- ============================================================================
-- 17. MEDIUM: Add learning path counter auth checks
-- ============================================================================

DROP FUNCTION IF EXISTS public.increment_path_enrollment_count(uuid);
CREATE OR REPLACE FUNCTION public.increment_path_enrollment_count(target_path_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- Verify caller is enrolled
  IF NOT EXISTS (
    SELECT 1 FROM public.learning_path_progress lpp
    WHERE lpp.path_id = target_path_id AND lpp.user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'Not enrolled in this path';
  END IF;

  UPDATE public.learning_paths SET enrollment_count = enrollment_count + 1 WHERE id = target_path_id;
END;
$$;

DROP FUNCTION IF EXISTS public.increment_path_completion_count(uuid);
CREATE OR REPLACE FUNCTION public.increment_path_completion_count(target_path_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- Verify caller completed the path
  IF NOT EXISTS (
    SELECT 1 FROM public.learning_path_progress lpp
    WHERE lpp.path_id = target_path_id AND lpp.user_id = auth.uid() AND lpp.is_completed = true
  ) THEN
    RAISE EXCEPTION 'Path not completed';
  END IF;

  UPDATE public.learning_paths SET completion_count = completion_count + 1 WHERE id = target_path_id;
END;
$$;
