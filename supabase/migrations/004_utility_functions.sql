-- ==================== Utility Functions ====================
-- Generic increment/decrement functions used by various features

-- Increment a counter column on any table
CREATE OR REPLACE FUNCTION public.increment(
  table_name TEXT,
  row_id UUID,
  column_name TEXT,
  amount INTEGER DEFAULT 1
)
RETURNS VOID AS $$
BEGIN
  EXECUTE format(
    'UPDATE public.%I SET %I = COALESCE(%I, 0) + $1 WHERE id = $2',
    table_name, column_name, column_name
  ) USING amount, row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Decrement a counter column on any table (with floor at 0)
CREATE OR REPLACE FUNCTION public.decrement(
  table_name TEXT,
  row_id UUID,
  column_name TEXT,
  amount INTEGER DEFAULT 1
)
RETURNS VOID AS $$
BEGIN
  EXECUTE format(
    'UPDATE public.%I SET %I = GREATEST(COALESCE(%I, 0) - $1, 0) WHERE id = $2',
    table_name, column_name, column_name
  ) USING amount, row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION public.increment TO authenticated;
GRANT EXECUTE ON FUNCTION public.decrement TO authenticated;
