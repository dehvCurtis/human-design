-- =============================================================================
-- Fix infinite recursion in profiles RLS policy
-- =============================================================================
-- The UPDATE policy on profiles does a subselect back into profiles to check
-- if is_premium was already TRUE. Postgres evaluates RLS on that inner SELECT,
-- which triggers the same policy chain → infinite recursion (error 42P17).
--
-- Fix: use a SECURITY DEFINER helper that bypasses RLS to read the old value.

-- Helper function to check if a user is already premium (bypasses RLS)
CREATE OR REPLACE FUNCTION public.get_is_premium(user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT COALESCE(is_premium, FALSE) FROM public.profiles WHERE id = user_id;
$$;

-- Recreate the UPDATE policy using the helper instead of a direct subselect
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;

CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (
    auth.uid() = id
    AND (
      -- Allow if is_premium is not being set to TRUE
      is_premium IS NOT TRUE
      -- Or if it was already TRUE (user is not escalating)
      OR public.get_is_premium(auth.uid())
    )
  );
