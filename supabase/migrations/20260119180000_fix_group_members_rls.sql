-- Fix infinite recursion in group_members RLS policies
-- The problem: policies on group_members were querying group_members, causing infinite recursion

-- First, create a security definer function to get user's group IDs without triggering RLS
CREATE OR REPLACE FUNCTION public.get_user_group_ids(user_uuid UUID)
RETURNS SETOF UUID
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT group_id FROM public.group_members WHERE user_id = user_uuid;
$$;

-- Create function to check if user is admin of a group
CREATE OR REPLACE FUNCTION public.is_group_admin(user_uuid UUID, check_group_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.group_members
    WHERE user_id = user_uuid AND group_id = check_group_id AND role = 'admin'
  );
$$;

-- Drop the problematic policies
DROP POLICY IF EXISTS "Users can view members of their groups" ON public.group_members;
DROP POLICY IF EXISTS "Admins can manage group members" ON public.group_members;

-- Recreate with fixed policies using security definer functions
CREATE POLICY "Users can view members of their groups"
  ON public.group_members FOR SELECT
  USING (
    user_id = auth.uid() OR
    group_id IN (SELECT public.get_user_group_ids(auth.uid()))
  );

CREATE POLICY "Admins can manage group members"
  ON public.group_members FOR ALL
  USING (
    public.is_group_admin(auth.uid(), group_id)
  );

-- Also fix shares policy that references group_members
DROP POLICY IF EXISTS "Users can view shares involving them" ON public.shares;

CREATE POLICY "Users can view shares involving them"
  ON public.shares FOR SELECT
  USING (
    auth.uid() = shared_by OR
    auth.uid() = shared_with OR
    group_id IN (SELECT public.get_user_group_ids(auth.uid()))
  );

-- Fix groups policies that may also have recursion issues
DROP POLICY IF EXISTS "Users can view their groups" ON public.groups;
DROP POLICY IF EXISTS "Admins can manage groups" ON public.groups;

CREATE POLICY "Users can view their groups"
  ON public.groups FOR SELECT
  USING (
    id IN (SELECT public.get_user_group_ids(auth.uid()))
  );

CREATE POLICY "Admins can manage groups"
  ON public.groups FOR ALL
  USING (
    public.is_group_admin(auth.uid(), id)
  );
