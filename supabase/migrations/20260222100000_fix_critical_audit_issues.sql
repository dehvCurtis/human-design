-- ============================================================================
-- Fix Critical & High Priority Audit Issues (RLS & Database)
-- ============================================================================

-- ============================================================================
-- Fix #12: circle_members RLS infinite recursion
-- The current SELECT policy on circle_members references circle_members itself,
-- causing infinite recursion. Use a SECURITY DEFINER function instead.
-- ============================================================================

-- Helper function to get circle IDs for a user (avoids RLS recursion)
CREATE OR REPLACE FUNCTION public.get_user_circle_ids(p_user_id UUID)
RETURNS SETOF UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT circle_id FROM public.circle_members WHERE user_id = p_user_id;
$$;

-- Drop the recursive policy
DROP POLICY IF EXISTS "Circle members are viewable by circle members" ON public.circle_members;

-- Create new policy using the helper function
CREATE POLICY "Circle members are viewable by circle members"
  ON public.circle_members FOR SELECT
  USING (
    circle_id IN (SELECT public.get_user_circle_ids(auth.uid()))
  );

-- ============================================================================
-- Fix #13: user_points open SELECT policy
-- The "Users can view leaderboard (limited data)" policy uses USING (TRUE),
-- which makes all user_points visible to everyone and overrides the restrictive
-- "Users can view their own points" policy.
-- ============================================================================

DROP POLICY IF EXISTS "Users can view leaderboard (limited data)" ON public.user_points;

-- ============================================================================
-- Fix #14: pentas missing WITH CHECK
-- The current FOR ALL policy only has USING but no WITH CHECK,
-- allowing any authenticated user to insert pentas with any created_by value.
-- ============================================================================

DROP POLICY IF EXISTS "Users can manage their pentas" ON public.pentas;

CREATE POLICY "Users can view their pentas"
  ON public.pentas FOR SELECT
  USING (auth.uid() = created_by);

CREATE POLICY "Users can create pentas"
  ON public.pentas FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update their pentas"
  ON public.pentas FOR UPDATE
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can delete their pentas"
  ON public.pentas FOR DELETE
  USING (auth.uid() = created_by);

-- ============================================================================
-- Fix #15: direct_messages UPDATE too broad
-- The current UPDATE policy allows any conversation participant to update
-- any column on any message. Restrict to only setting is_read/read_at
-- on messages sent by others (i.e., marking received messages as read).
-- ============================================================================

DROP POLICY IF EXISTS "Users can update their own messages (read status)" ON public.direct_messages;

-- Only allow participants to mark messages as read (not their own messages)
CREATE POLICY "Users can mark received messages as read"
  ON public.direct_messages FOR UPDATE
  USING (
    public.is_conversation_participant(conversation_id, auth.uid())
    AND sender_id != auth.uid()
  )
  WITH CHECK (
    public.is_conversation_participant(conversation_id, auth.uid())
    AND sender_id != auth.uid()
  );
