-- =============================================================================
-- Fix Groups SELECT: Allow creators to see their own groups
-- =============================================================================
--
-- Root cause:
--   createGroup() does: INSERT into groups ... .select().single()
--   The INSERT succeeds, but the chained .select() fails because
--   the SELECT policies on `groups` only allow viewing groups where
--   the user is already in `group_members`. The creator hasn't been
--   added to `group_members` yet (that's step 2), so the SELECT
--   returns nothing and the whole operation throws.
--
-- Also cleans up orphan policies from 001_initial_schema.sql that
-- were never explicitly dropped by any subsequent migration:
--   - "Users can view groups they're members of" (SELECT, uses raw subquery)
--   - "Admins can update their groups" (UPDATE, uses raw subquery)
-- These use direct subqueries into group_members which could cause
-- recursion and are superseded by SECURITY DEFINER-based policies.
-- =============================================================================

-- Drop orphan SELECT policy from 001 (raw subquery, never cleaned up)
DROP POLICY IF EXISTS "Users can view groups they're members of" ON public.groups;

-- Drop orphan UPDATE policy from 001 (raw subquery, never cleaned up)
DROP POLICY IF EXISTS "Admins can update their groups" ON public.groups;

-- Drop and recreate the SELECT policy to also cover creators
DROP POLICY IF EXISTS "Users can view their groups" ON public.groups;

CREATE POLICY "Users can view their groups"
  ON public.groups FOR SELECT
  USING (
    -- User is a member of the group (via SECURITY DEFINER function)
    id IN (SELECT public.get_user_group_ids(auth.uid()))
    OR
    -- User is the creator of the group (allows SELECT right after INSERT)
    created_by = auth.uid()
  );
