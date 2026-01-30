-- Fix groups INSERT policy
-- The "Admins can manage groups" FOR ALL policy doesn't allow INSERT
-- because the user isn't an admin until after the group is created.
-- We need a separate INSERT policy.

-- Drop the existing FOR ALL policy if it exists
DROP POLICY IF EXISTS "Admins can manage groups" ON public.groups;

-- Recreate as UPDATE/DELETE only (not INSERT)
CREATE POLICY "Admins can update groups"
  ON public.groups FOR UPDATE
  USING (
    public.is_group_admin(auth.uid(), id)
  );

CREATE POLICY "Admins can delete groups"
  ON public.groups FOR DELETE
  USING (
    public.is_group_admin(auth.uid(), id)
  );

-- Ensure the INSERT policy exists (re-create if missing)
DROP POLICY IF EXISTS "Users can create groups" ON public.groups;

CREATE POLICY "Users can create groups"
  ON public.groups FOR INSERT
  WITH CHECK (auth.uid() = created_by);
