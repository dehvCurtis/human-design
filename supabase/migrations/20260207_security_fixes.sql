-- ==================== Security Fixes Migration ====================
-- Addresses critical/high severity findings from the security audit.

-- ============================================================================
-- 1. Whitelist generic increment/decrement functions
-- ============================================================================
-- The original functions accept any table_name + column_name, allowing
-- attackers to increment arbitrary columns (e.g. profiles.is_premium).
-- Replace with versions that validate against a strict whitelist.

CREATE OR REPLACE FUNCTION public.increment(
  table_name TEXT,
  row_id UUID,
  column_name TEXT,
  amount INTEGER DEFAULT 1
)
RETURNS VOID AS $$
BEGIN
  -- Validate against allowed table+column combinations
  IF NOT (
    (table_name = 'content_library' AND column_name IN ('view_count', 'like_count')) OR
    (table_name = 'live_sessions' AND column_name = 'current_participants')
  ) THEN
    RAISE EXCEPTION 'increment not allowed on %.%', table_name, column_name;
  END IF;

  EXECUTE format(
    'UPDATE public.%I SET %I = COALESCE(%I, 0) + $1 WHERE id = $2',
    table_name, column_name, column_name
  ) USING amount, row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.decrement(
  table_name TEXT,
  row_id UUID,
  column_name TEXT,
  amount INTEGER DEFAULT 1
)
RETURNS VOID AS $$
BEGIN
  -- Validate against allowed table+column combinations
  IF NOT (
    (table_name = 'content_library' AND column_name IN ('view_count', 'like_count')) OR
    (table_name = 'live_sessions' AND column_name = 'current_participants')
  ) THEN
    RAISE EXCEPTION 'decrement not allowed on %.%', table_name, column_name;
  END IF;

  EXECUTE format(
    'UPDATE public.%I SET %I = GREATEST(COALESCE(%I, 0) - $1, 0) WHERE id = $2',
    table_name, column_name, column_name
  ) USING amount, row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 2. Protect is_premium from self-update via RLS
-- ============================================================================
-- The existing UPDATE policy lets users change any column on their own row,
-- including is_premium. Replace it with a policy that blocks users from
-- setting is_premium = TRUE on themselves.

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;

CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (
    auth.uid() = id
    AND (
      -- Allow if is_premium is not being changed to TRUE
      is_premium IS NOT TRUE
      -- Or if it was already TRUE (user is not escalating)
      OR is_premium = (SELECT p.is_premium FROM public.profiles p WHERE p.id = auth.uid())
    )
  );

-- ============================================================================
-- 3. Server-side share limit enforcement via RLS
-- ============================================================================
-- The BEFORE INSERT trigger already enforces the limit, but adding RLS-level
-- enforcement provides defense-in-depth. Create a helper function that the
-- INSERT policy can call.

CREATE OR REPLACE FUNCTION public.check_share_limit_rls(user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  user_is_premium BOOLEAN;
  monthly_shares INTEGER;
BEGIN
  SELECT is_premium INTO user_is_premium
  FROM public.profiles
  WHERE id = user_id;

  IF user_is_premium THEN
    RETURN TRUE;
  END IF;

  SELECT COUNT(*) INTO monthly_shares
  FROM public.shares
  WHERE shared_by = user_id
    AND created_at >= date_trunc('month', NOW());

  RETURN monthly_shares < 3;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Update the INSERT policy to also check share limits
DROP POLICY IF EXISTS "Users can create shares for their charts" ON public.shares;

CREATE POLICY "Users can create shares for their charts"
  ON public.shares FOR INSERT
  WITH CHECK (
    auth.uid() = shared_by
    AND chart_id IN (SELECT id FROM public.charts WHERE user_id = auth.uid())
    AND public.check_share_limit_rls(auth.uid())
  );
