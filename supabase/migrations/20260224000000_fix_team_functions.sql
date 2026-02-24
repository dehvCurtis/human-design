-- ============================================================================
-- Fix team functions: reference challenge_teams instead of non-existent teams
-- ============================================================================
-- The functions increment_team_member_count, decrement_team_member_count,
-- and contribute_points_to_team were created referencing public.teams,
-- but the actual table is public.challenge_teams.
-- ============================================================================

-- Fix increment_team_member_count
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

  UPDATE public.challenge_teams SET member_count = member_count + 1 WHERE id = p_team_id;
END;
$$;

-- Fix decrement_team_member_count
DROP FUNCTION IF EXISTS public.decrement_team_member_count(uuid);
CREATE OR REPLACE FUNCTION public.decrement_team_member_count(p_team_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  UPDATE public.challenge_teams SET member_count = GREATEST(member_count - 1, 0) WHERE id = p_team_id;
END;
$$;

-- Fix contribute_points_to_team
DROP FUNCTION IF EXISTS public.contribute_points_to_team(uuid, uuid, integer);
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
  UPDATE public.challenge_teams
  SET weekly_points = weekly_points + points,
      monthly_points = monthly_points + points
  WHERE id = target_team_id;

  -- Update member contribution
  UPDATE public.team_members
  SET points_contributed = COALESCE(points_contributed, 0) + points
  WHERE team_id = target_team_id AND user_id = contributor_id;
END;
$$;
