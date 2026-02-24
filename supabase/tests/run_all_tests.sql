-- ============================================================================
-- RLS & Functional Test Runner
-- Runs all test files in order, then cleans up test data
--
-- Usage:
--   psql $DATABASE_URL -f supabase/tests/run_all_tests.sql
--   Or paste into Supabase SQL Editor
--
-- Prerequisites:
--   This file includes all test SQL inline via \i (psql) or can be
--   run after manually executing 00, 01, 02 in order.
-- ============================================================================

\set ON_ERROR_STOP on
\set QUIET on

\echo ''
\echo '╔══════════════════════════════════════════════════════════╗'
\echo '║     Inside Me: Human Design — RLS & Functional Tests    ║'
\echo '╚══════════════════════════════════════════════════════════╝'
\echo ''

-- ============================================================================
-- Phase 0: Setup test users and data
-- ============================================================================
\echo '>>> Phase 0: Setting up test users and data...'
\i 00_setup_test_users.sql
\echo '>>> Phase 0 complete.'
\echo ''

-- ============================================================================
-- Phase 1: RLS Privacy Tests
-- ============================================================================
\echo '>>> Phase 1: Running RLS privacy tests...'
\i 01_rls_privacy_tests.sql
\echo '>>> Phase 1 complete.'
\echo ''

-- ============================================================================
-- Phase 2: Functional Smoke Tests
-- ============================================================================
\echo '>>> Phase 2: Running functional smoke tests...'
\i 02_functional_tests.sql
\echo '>>> Phase 2 complete.'
\echo ''

-- ============================================================================
-- Phase 3: Cleanup
-- Remove all test users and cascading data
-- ============================================================================
\echo '>>> Phase 3: Cleaning up test data...'

DO $$
DECLARE
  v_free     UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0001';
  v_premium  UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0002';
  v_private  UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0003';
  v_blocked  UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0004';
  v_stranger UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0005';
  v_ids      UUID[] := ARRAY[
    'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0001',
    'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0002',
    'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0003',
    'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0004',
    'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0005'
  ];
BEGIN
  RAISE NOTICE '=== Cleaning up test data ===';

  -- Reset to postgres for full access (needed for auth schema and RLS-protected tables)
  SET ROLE postgres;

  -- Delete in dependency order (child tables first)

  -- AI data
  DELETE FROM public.ai_messages WHERE conversation_id IN (
    SELECT id FROM public.ai_conversations WHERE user_id = ANY(v_ids)
  );
  DELETE FROM public.ai_conversations WHERE user_id = ANY(v_ids);
  DELETE FROM public.ai_usage WHERE user_id = ANY(v_ids);
  DELETE FROM public.ai_rate_limits WHERE user_id = ANY(v_ids);

  -- Gamification
  DELETE FROM public.point_transactions WHERE user_id = ANY(v_ids);
  DELETE FROM public.user_badges WHERE user_id = ANY(v_ids);
  DELETE FROM public.user_challenges WHERE user_id = ANY(v_ids);
  DELETE FROM public.user_points WHERE user_id = ANY(v_ids);

  -- Journal
  DELETE FROM public.journal_entries WHERE user_id = ANY(v_ids);

  -- Charts
  DELETE FROM public.charts WHERE user_id = ANY(v_ids);

  -- Messaging
  DELETE FROM public.direct_messages WHERE conversation_id IN (
    SELECT id FROM public.conversations WHERE participant_ids && v_ids
  );
  DELETE FROM public.conversations WHERE participant_ids && v_ids;

  -- Stories
  DELETE FROM public.story_reactions WHERE story_id IN (
    SELECT id FROM public.stories WHERE user_id = ANY(v_ids)
  );
  DELETE FROM public.story_views WHERE story_id IN (
    SELECT id FROM public.stories WHERE user_id = ANY(v_ids)
  );
  DELETE FROM public.stories WHERE user_id = ANY(v_ids);

  -- Feed
  DELETE FROM public.reactions WHERE post_id IN (
    SELECT id FROM public.posts WHERE user_id = ANY(v_ids)
  );
  DELETE FROM public.post_comments WHERE post_id IN (
    SELECT id FROM public.posts WHERE user_id = ANY(v_ids)
  );
  DELETE FROM public.posts WHERE user_id = ANY(v_ids);

  -- Chart comments
  DELETE FROM public.comments WHERE user_id = ANY(v_ids);

  -- Circles
  DELETE FROM public.circle_posts WHERE user_id = ANY(v_ids);
  DELETE FROM public.circle_members WHERE user_id = ANY(v_ids);
  DELETE FROM public.compatibility_circles WHERE creator_id = ANY(v_ids);

  -- Groups
  DELETE FROM public.group_posts WHERE user_id = ANY(v_ids);
  DELETE FROM public.group_members WHERE user_id = ANY(v_ids);
  DELETE FROM public.groups WHERE created_by = ANY(v_ids);

  -- Social graph
  DELETE FROM public.user_follows WHERE follower_id = ANY(v_ids) OR following_id = ANY(v_ids);
  DELETE FROM public.blocked_users WHERE blocker_id = ANY(v_ids) OR blocked_id = ANY(v_ids);

  -- Purchases
  DELETE FROM public.ai_purchases WHERE user_id = ANY(v_ids);

  -- Notifications
  DELETE FROM public.notifications WHERE user_id = ANY(v_ids);

  -- Quiz
  DELETE FROM public.quiz_attempts WHERE user_id = ANY(v_ids);

  -- Sharing
  DELETE FROM public.shares WHERE shared_by = ANY(v_ids);

  -- Profiles (must be before auth.users due to FK)
  DELETE FROM public.profiles WHERE id = ANY(v_ids);

  -- Auth users
  DELETE FROM auth.users WHERE id = ANY(v_ids);

  -- Drop temp table
  DROP TABLE IF EXISTS test_ids;

  RAISE NOTICE '=== Cleanup complete ===';
END $$;

\echo '>>> Phase 3 complete.'
\echo ''
\echo '╔══════════════════════════════════════════════════════════╗'
\echo '║                  All tests finished!                    ║'
\echo '║  Review NOTICE output above for [PASS] / [FAIL] lines  ║'
\echo '╚══════════════════════════════════════════════════════════╝'
\echo ''
