-- Fix group_members INSERT policy
-- Allow group creators to add themselves as the first member (admin)
-- This fixes the chicken-and-egg problem where you need to be an admin
-- to insert into group_members, but you can't be an admin until you're inserted.

-- Create a function to check if user is the group creator
CREATE OR REPLACE FUNCTION public.is_group_creator(user_uuid UUID, check_group_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.groups
    WHERE id = check_group_id AND created_by = user_uuid
  );
$$;

-- Drop the existing policy
DROP POLICY IF EXISTS "Admins can manage group members" ON public.group_members;

-- Create separate policies for better control

-- SELECT: Users can view members of groups they belong to (existing)
-- (Already handled by the fixed policy)

-- INSERT: Group creators can add themselves, admins can add others
CREATE POLICY "Group creators and admins can add members"
  ON public.group_members FOR INSERT
  WITH CHECK (
    -- Group creator can add themselves
    (user_id = auth.uid() AND public.is_group_creator(auth.uid(), group_id))
    OR
    -- Existing admins can add anyone
    public.is_group_admin(auth.uid(), group_id)
  );

-- UPDATE: Only admins can update member roles
CREATE POLICY "Admins can update group members"
  ON public.group_members FOR UPDATE
  USING (
    public.is_group_admin(auth.uid(), group_id)
  );

-- DELETE: Admins can remove members, users can remove themselves
CREATE POLICY "Admins can delete group members or users can leave"
  ON public.group_members FOR DELETE
  USING (
    public.is_group_admin(auth.uid(), group_id)
    OR user_id = auth.uid()
  );
