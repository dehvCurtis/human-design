-- Seed Test Social Data Migration
-- Creates test users for social feature testing
-- Run this AFTER creating the test user account (test@humandesign.app)

-- ============================================================================
-- Create Test User Profiles (bypassing auth.users FK for testing)
-- Note: These are synthetic test profiles for development purposes
-- ============================================================================

-- First, temporarily disable the FK constraint (only works in dev)
-- Or we create profiles that will be orphaned but usable for testing

-- Create test user UUIDs (fixed for consistency)
DO $$
DECLARE
  test_user_id UUID;
  user_alice UUID := '11111111-2222-3333-4444-555555550001';
  user_bob UUID := '11111111-2222-3333-4444-555555550002';
  user_carol UUID := '11111111-2222-3333-4444-555555550003';
  user_david UUID := '11111111-2222-3333-4444-555555550004';
  user_emma UUID := '11111111-2222-3333-4444-555555550005';
  user_frank UUID := '11111111-2222-3333-4444-555555550006';
  user_grace UUID := '11111111-2222-3333-4444-555555550007';
  user_henry UUID := '11111111-2222-3333-4444-555555550008';
BEGIN
  -- Get the test user's ID
  SELECT id INTO test_user_id FROM public.profiles WHERE email = 'test@humandesign.app';

  IF test_user_id IS NULL THEN
    RAISE NOTICE 'Test user not found. Please sign up with test@humandesign.app first.';
    RETURN;
  END IF;

  RAISE NOTICE 'Found test user: %', test_user_id;

  -- Insert test profiles (with ON CONFLICT to avoid duplicates)
  -- Note: We insert directly to profiles, bypassing auth.users for test data
  INSERT INTO public.profiles (id, email, name, bio, avatar_url, hd_type, hd_profile, hd_authority, is_public, birth_date, created_at)
  VALUES
    (user_alice, 'alice@test.hd', 'Alice Chen', 'Manifestor exploring my design. Love sharing insights about initiating energy!', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice', 'Manifestor', '1/3', 'Splenic', true, '1990-03-15 14:30:00+00', NOW() - INTERVAL '30 days'),
    (user_bob, 'bob@test.hd', 'Bob Martinez', 'Generator life! Sacral response is my guide. Always looking to connect with fellow Generators.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob', 'Generator', '2/4', 'Sacral', true, '1985-07-22 08:15:00+00', NOW() - INTERVAL '45 days'),
    (user_carol, 'carol@test.hd', 'Carol Johnson', 'MG with emotional authority. Learning to ride my emotional wave and respond correctly.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carol', 'Manifesting Generator', '3/5', 'Emotional', true, '1992-11-08 22:45:00+00', NOW() - INTERVAL '20 days'),
    (user_david, 'david@test.hd', 'David Kim', 'Projector waiting for invitations. Here to guide and support others on their HD journey.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=David', 'Projector', '4/6', 'Self-Projected', true, '1988-01-30 05:00:00+00', NOW() - INTERVAL '60 days'),
    (user_emma, 'emma@test.hd', 'Emma Wilson', 'Reflector sampling the cosmic weather. New moon is my time to make decisions!', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Emma', 'Reflector', '5/1', 'Lunar', true, '1995-09-12 11:20:00+00', NOW() - INTERVAL '15 days'),
    (user_frank, 'frank@test.hd', 'Frank Thompson', 'Generator with splenic authority. Quick decisions are my thing!', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Frank', 'Generator', '6/2', 'Splenic', true, '1983-04-28 16:40:00+00', NOW() - INTERVAL '90 days'),
    (user_grace, 'grace@test.hd', 'Grace Lee', 'Projector focused on relationships and connection. Love analyzing composite charts!', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Grace', 'Projector', '2/5', 'Emotional', true, '1991-12-03 09:30:00+00', NOW() - INTERVAL '25 days'),
    (user_henry, 'henry@test.hd', 'Henry Brown', 'MG living my design. Multi-passionate and always busy with multiple projects!', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Henry', 'Manifesting Generator', '1/4', 'Sacral', true, '1987-06-18 20:15:00+00', NOW() - INTERVAL '40 days')
  ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    bio = EXCLUDED.bio,
    hd_type = EXCLUDED.hd_type,
    hd_profile = EXCLUDED.hd_profile,
    hd_authority = EXCLUDED.hd_authority;

  RAISE NOTICE 'Created 8 test user profiles';

  -- ============================================================================
  -- Create Friendships (accepted)
  -- ============================================================================

  -- Test user is friends with Alice, Bob, Carol, David (accepted)
  INSERT INTO public.friendships (user_id, friend_id, status, created_at)
  VALUES
    -- Mutual friendships (both directions for accepted friends)
    (test_user_id, user_alice, 'accepted', NOW() - INTERVAL '25 days'),
    (user_alice, test_user_id, 'accepted', NOW() - INTERVAL '25 days'),
    (test_user_id, user_bob, 'accepted', NOW() - INTERVAL '20 days'),
    (user_bob, test_user_id, 'accepted', NOW() - INTERVAL '20 days'),
    (test_user_id, user_carol, 'accepted', NOW() - INTERVAL '15 days'),
    (user_carol, test_user_id, 'accepted', NOW() - INTERVAL '15 days'),
    (test_user_id, user_david, 'accepted', NOW() - INTERVAL '10 days'),
    (user_david, test_user_id, 'accepted', NOW() - INTERVAL '10 days')
  ON CONFLICT (user_id, friend_id) DO NOTHING;

  -- Pending friend requests TO test user
  INSERT INTO public.friendships (user_id, friend_id, status, created_at)
  VALUES
    (user_emma, test_user_id, 'pending', NOW() - INTERVAL '2 days'),
    (user_frank, test_user_id, 'pending', NOW() - INTERVAL '1 day')
  ON CONFLICT (user_id, friend_id) DO NOTHING;

  -- Test user sent pending request
  INSERT INTO public.friendships (user_id, friend_id, status, created_at)
  VALUES
    (test_user_id, user_grace, 'pending', NOW() - INTERVAL '3 days')
  ON CONFLICT (user_id, friend_id) DO NOTHING;

  RAISE NOTICE 'Created friendship relationships';

  -- ============================================================================
  -- Create Follow Relationships
  -- ============================================================================

  -- People following the test user (followers)
  INSERT INTO public.user_follows (follower_id, following_id, created_at)
  VALUES
    (user_alice, test_user_id, NOW() - INTERVAL '28 days'),
    (user_bob, test_user_id, NOW() - INTERVAL '22 days'),
    (user_carol, test_user_id, NOW() - INTERVAL '18 days'),
    (user_david, test_user_id, NOW() - INTERVAL '12 days'),
    (user_emma, test_user_id, NOW() - INTERVAL '8 days'),
    (user_frank, test_user_id, NOW() - INTERVAL '5 days'),
    (user_grace, test_user_id, NOW() - INTERVAL '3 days')
  ON CONFLICT (follower_id, following_id) DO NOTHING;

  -- Test user following others
  INSERT INTO public.user_follows (follower_id, following_id, created_at)
  VALUES
    (test_user_id, user_alice, NOW() - INTERVAL '27 days'),
    (test_user_id, user_bob, NOW() - INTERVAL '21 days'),
    (test_user_id, user_carol, NOW() - INTERVAL '16 days'),
    (test_user_id, user_david, NOW() - INTERVAL '9 days'),
    (test_user_id, user_henry, NOW() - INTERVAL '4 days')
  ON CONFLICT (follower_id, following_id) DO NOTHING;

  -- Cross-follows between test users (for a realistic network)
  INSERT INTO public.user_follows (follower_id, following_id, created_at)
  VALUES
    (user_alice, user_bob, NOW() - INTERVAL '35 days'),
    (user_bob, user_alice, NOW() - INTERVAL '34 days'),
    (user_carol, user_david, NOW() - INTERVAL '30 days'),
    (user_david, user_emma, NOW() - INTERVAL '25 days'),
    (user_emma, user_frank, NOW() - INTERVAL '20 days'),
    (user_frank, user_grace, NOW() - INTERVAL '15 days'),
    (user_grace, user_henry, NOW() - INTERVAL '10 days'),
    (user_henry, user_alice, NOW() - INTERVAL '8 days')
  ON CONFLICT (follower_id, following_id) DO NOTHING;

  RAISE NOTICE 'Created follow relationships';

  -- ============================================================================
  -- Update follower/following counts
  -- ============================================================================

  -- Update test user counts
  UPDATE public.profiles
  SET follower_count = (SELECT COUNT(*) FROM public.user_follows WHERE following_id = test_user_id),
      following_count = (SELECT COUNT(*) FROM public.user_follows WHERE follower_id = test_user_id)
  WHERE id = test_user_id;

  -- Update all test profile counts
  UPDATE public.profiles p
  SET
    follower_count = (SELECT COUNT(*) FROM public.user_follows WHERE following_id = p.id),
    following_count = (SELECT COUNT(*) FROM public.user_follows WHERE follower_id = p.id)
  WHERE id IN (user_alice, user_bob, user_carol, user_david, user_emma, user_frank, user_grace, user_henry);

  RAISE NOTICE 'Updated follower/following counts';

  -- ============================================================================
  -- Create some test posts from test users
  -- ============================================================================

  INSERT INTO public.posts (id, user_id, content, post_type, visibility, created_at)
  VALUES
    (gen_random_uuid(), user_alice, 'Just had an amazing manifestor moment - initiated a new project without waiting for permission! #Manifestor #HumanDesign', 'insight', 'public', NOW() - INTERVAL '5 days'),
    (gen_random_uuid(), user_bob, 'Sacral said YES today and I followed it. Best decision ever. Trust your gut, fellow Generators! #Generator #SacralResponse', 'reflection', 'public', NOW() - INTERVAL '4 days'),
    (gen_random_uuid(), user_carol, 'Riding my emotional wave today. Feeling the highs and lows. Reminder: clarity comes with time. #EmotionalAuthority #MG', 'insight', 'public', NOW() - INTERVAL '3 days'),
    (gen_random_uuid(), user_david, 'Received an amazing invitation today! Projectors, trust the process. Recognition always comes. #Projector #WaitForInvitation', 'reflection', 'public', NOW() - INTERVAL '2 days'),
    (gen_random_uuid(), user_emma, 'New moon tonight! Making my monthly decisions. Fellow Reflectors, how do you honor your lunar cycle? #Reflector #LunarCycle', 'question', 'public', NOW() - INTERVAL '1 day'),
    (gen_random_uuid(), user_frank, 'Gate 34 transit hitting different today. Anyone else feeling the power? #Transits #Gate34', 'transit_share', 'public', NOW() - INTERVAL '12 hours'),
    (gen_random_uuid(), user_grace, 'Just analyzed my first composite chart with a friend. Mind blown by our electromagnetic connection! #CompositeChart #Connection', 'insight', 'public', NOW() - INTERVAL '6 hours'),
    (gen_random_uuid(), user_henry, 'Multi-passionate MG life: started 3 new projects today. My sacral is lit! Who else relates? #ManifestingGenerator #MultiPassionate', 'reflection', 'public', NOW() - INTERVAL '2 hours')
  ON CONFLICT (id) DO NOTHING;

  RAISE NOTICE 'Created test posts';

  -- ============================================================================
  -- Create some activity feed entries
  -- ============================================================================

  INSERT INTO public.activities (user_id, activity_type, target_type, target_id, metadata, created_at)
  VALUES
    (user_alice, 'badge_earned', 'badge', 'first_post', '{"badge_name": "First Post", "badge_emoji": "\U0001F4DD"}', NOW() - INTERVAL '4 days'),
    (user_bob, 'challenge_completed', 'challenge', gen_random_uuid()::text, '{"challenge_name": "Daily Login Streak", "points_earned": 50}', NOW() - INTERVAL '3 days'),
    (user_carol, 'level_up', 'level', '5', '{"new_level": 5, "points_total": 500}', NOW() - INTERVAL '2 days'),
    (user_david, 'chart_shared', 'chart', gen_random_uuid()::text, '{"chart_name": "My Chart"}', NOW() - INTERVAL '1 day'),
    (user_emma, 'badge_earned', 'badge', 'reflector_insight', '{"badge_name": "Reflector Insight", "badge_emoji": "\U0001F319"}', NOW() - INTERVAL '12 hours')
  ON CONFLICT DO NOTHING;

  RAISE NOTICE 'Created activity feed entries';

  RAISE NOTICE '=== Test social data seeded successfully! ===';
  RAISE NOTICE 'Your test user (test@humandesign.app) now has:';
  RAISE NOTICE '- 4 accepted friends (Alice, Bob, Carol, David)';
  RAISE NOTICE '- 2 pending friend requests (from Emma, Frank)';
  RAISE NOTICE '- 1 outgoing friend request (to Grace)';
  RAISE NOTICE '- 7 followers';
  RAISE NOTICE '- 5 following';

END $$;
