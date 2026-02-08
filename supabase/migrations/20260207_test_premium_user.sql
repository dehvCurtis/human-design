-- ============================================================================
-- Set alice@test.hd as premium for paywall testing
-- ============================================================================
-- Test accounts:
--   Premium: alice@test.hd / TestPassword123!
--   Free:    bob@test.hd / TestPassword123!

UPDATE public.profiles
SET is_premium = TRUE
WHERE id = 'cfe69875-592a-467a-bc20-883eee3cc690';
