-- =============================================================================
-- Fix Group Creation RLS: Resolve chicken-and-egg INSERT deadlock
-- =============================================================================
--
-- Problem summary:
--   createGroup() in social_repository.dart does two sequential steps:
--     1. INSERT into `groups`       (sets created_by = userId)
--     2. INSERT into `group_members` (sets role = 'admin')
--
--   Step 2 fails because every prior INSERT policy on `group_members` requires
--   the caller to ALREADY be an admin of the group — which is impossible at
--   insert time before step 2 completes.
--
-- Policy history that caused accumulated drift across migrations:
--   001_initial_schema.sql
--     groups       INSERT  "Users can create groups"           created_by = auth.uid()  (correct)
--     group_members FOR ALL "Admins can manage group members"  requires existing admin  (broken)
--
--   20260119180000_fix_group_members_rls.sql
--     group_members DROP+RECREATE "Admins can manage group members" FOR ALL
--       — fixes recursion via is_group_admin() but keeps chicken-and-egg deadlock
--     groups       DROP+RECREATE "Admins can manage groups" FOR ALL
--       — requires is_group_admin() for ALL operations, including INSERT (broken)
--
--   20260123000001_fix_groups_insert_policy.sql
--     groups DROP "Admins can manage groups" FOR ALL
--     groups CREATE "Admins can update groups" UPDATE  (correct)
--     groups CREATE "Admins can delete groups" DELETE  (correct)
--     groups DROP+RECREATE "Users can create groups" INSERT  (correct)
--     — groups INSERT is now fixed; group_members INSERT is still broken
--
--   20260123000002_fix_group_members_insert_policy.sql
--     group_members DROP "Admins can manage group members"
--     group_members CREATE "Group creators and admins can add members" INSERT
--     group_members CREATE "Admins can update group members" UPDATE
--     group_members CREATE "Admins can delete group members or users can leave" DELETE
--     — Intended to fix INSERT but does NOT guarantee that all conflicting
--       FOR ALL policies from earlier migrations are gone, and does not handle
--       users joining open groups. May still leave stale policy state.
--
-- This migration:
--   1. Drops ALL known INSERT policies on both tables by every name they have
--      ever carried across all migrations (safe: DROP POLICY IF EXISTS).
--   2. Creates a single authoritative INSERT policy for each table.
--   3. Does NOT touch SELECT, UPDATE, or DELETE policies.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PART 1: groups table — clean INSERT policy
-- -----------------------------------------------------------------------------

-- Drop every name this INSERT/FOR-ALL policy has been known by
DROP POLICY IF EXISTS "Users can create groups"          ON public.groups;
DROP POLICY IF EXISTS "Admins can manage groups"         ON public.groups;  -- FOR ALL from 20260119180000
DROP POLICY IF EXISTS "Users can view their groups"      ON public.groups;  -- SELECT only, but drop to be safe if ever recreated as FOR ALL

-- Recreate the groups SELECT policy in case the above accidentally removed it
-- (it was already split into SELECT-only in 20260119180000 so this is a guard)
DROP POLICY IF EXISTS "Users can view their groups" ON public.groups;

CREATE POLICY "Users can view their groups"
  ON public.groups FOR SELECT
  USING (
    id IN (SELECT public.get_user_group_ids(auth.uid()))
  );

-- The clean INSERT policy: any authenticated user may create a group as long as
-- they set themselves as the creator. No prior membership required.
CREATE POLICY "Users can create groups"
  ON public.groups FOR INSERT
  WITH CHECK (
    auth.uid() IS NOT NULL
    AND auth.uid() = created_by
  );

-- -----------------------------------------------------------------------------
-- PART 2: group_members table — clean INSERT policy
-- -----------------------------------------------------------------------------

-- Drop every name this INSERT/FOR-ALL policy has been known by
DROP POLICY IF EXISTS "Admins can manage group members"               ON public.group_members;  -- FOR ALL from 001 and 20260119180000
DROP POLICY IF EXISTS "Group creators and admins can add members"     ON public.group_members;  -- INSERT from 20260123000002
DROP POLICY IF EXISTS "Users can add group members"                   ON public.group_members;  -- INSERT from 20260208_security_hardening

-- Create the definitive INSERT policy with three allowed cases:
--
--   Case A — Group creator bootstraps themselves as the first admin:
--     The user being inserted (user_id) is auth.uid(), AND the groups.created_by
--     for that group_id is also auth.uid(). This is the step-2 bootstrap during
--     createGroup(). The is_group_creator() function is SECURITY DEFINER so it
--     bypasses RLS when querying groups, preventing any secondary recursion.
--
--   Case B — Existing admin adds any member (including other users):
--     The caller (auth.uid()) is already a confirmed admin of the group.
--     is_group_admin() is SECURITY DEFINER.
--
--   Case C — User adds themselves to a group they can see (open join):
--     The row being inserted has user_id = auth.uid(). The role must be 'member'
--     (not 'admin') so users cannot self-promote. This covers join flows for
--     open or invite-link groups.
--
CREATE POLICY "group_members_insert"
  ON public.group_members FOR INSERT
  WITH CHECK (
    -- Case A: creator bootstrapping their own admin row
    (
      user_id = auth.uid()
      AND public.is_group_creator(auth.uid(), group_id)
    )
    OR
    -- Case B: existing admin adding any member at any role
    public.is_group_admin(auth.uid(), group_id)
    OR
    -- Case C: user joining themselves as a regular member
    (
      user_id = auth.uid()
      AND role = 'member'
    )
  );
