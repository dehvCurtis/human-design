-- ============================================================================
-- Seed Test Social Data for Human Design App
-- Run this in Supabase SQL Editor after signing up with test@humandesign.app
-- ============================================================================

-- Step 1: Create fake auth users for testing (using Supabase admin functions)
-- This creates users in auth.users which then auto-creates profiles

DO $$
DECLARE
  test_user_id UUID;
  user_alice UUID;
  user_bob UUID;
  user_carol UUID;
  user_david UUID;
  user_emma UUID;
  user_frank UUID;
  user_grace UUID;
  user_henry UUID;
BEGIN
  -- Get the real test user's ID
  SELECT id INTO test_user_id FROM auth.users WHERE email = 'test@humandesign.app';

  IF test_user_id IS NULL THEN
    RAISE EXCEPTION 'Test user not found. Please sign up with test@humandesign.app first!';
  END IF;

  RAISE NOTICE 'Found test user: %', test_user_id;

  -- Create test auth users (these will auto-create profiles via trigger)
  INSERT INTO auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, aud, role)
  VALUES
    ('11111111-2222-3333-4444-555555550001', '00000000-0000-0000-0000-000000000000', 'alice@test.hd', crypt('TestPassword123!', gen_salt('bf')), NOW(), NOW() - INTERVAL '30 days', NOW(), '{"provider": "email", "providers": ["email"]}', '{"name": "Alice Chen"}', 'authenticated', 'authenticated'),
    ('11111111-2222-3333-4444-555555550002', '00000000-0000-0000-0000-000000000000', 'bob@test.hd', crypt('TestPassword123!', gen_salt('bf')), NOW(), NOW() - INTERVAL '45 days', NOW(), '{"provider": "email", "providers": ["email"]}', '{"name": "Bob Martinez"}', 'authenticated', 'authenticated'),
    ('11111111-2222-3333-4444-555555550003', '00000000-0000-0000-0000-000000000000', 'carol@test.hd', crypt('TestPassword123!', gen_salt('bf')), NOW(), NOW() - INTERVAL '20 days', NOW(), '{"provider": "email", "providers": ["email"]}', '{"name": "Carol Johnson"}', 'authenticated', 'authenticated'),
    ('11111111-2222-3333-4444-555555550004', '00000000-0000-0000-0000-000000000000', 'david@test.hd', crypt('TestPassword123!', gen_salt('bf')), NOW(), NOW() - INTERVAL '60 days', NOW(), '{"provider": "email", "providers": ["email"]}', '{"name": "David Kim"}', 'authenticated', 'authenticated'),
    ('11111111-2222-3333-4444-555555550005', '00000000-0000-0000-0000-000000000000', 'emma@test.hd', crypt('TestPassword123!', gen_salt('bf')), NOW(), NOW() - INTERVAL '15 days', NOW(), '{"provider": "email", "providers": ["email"]}', '{"name": "Emma Wilson"}', 'authenticated', 'authenticated'),
    ('11111111-2222-3333-4444-555555550006', '00000000-0000-0000-0000-555555550006', 'frank@test.hd', crypt('TestPassword123!', gen_salt('bf')), NOW(), NOW() - INTERVAL '90 days', NOW(), '{"provider": "email", "providers": ["email"]}', '{"name": "Frank Thompson"}', 'authenticated', 'authenticated'),
    ('11111111-2222-3333-4444-555555550007', '00000000-0000-0000-0000-000000000000', 'grace@test.hd', crypt('TestPassword123!', gen_salt('bf')), NOW(), NOW() - INTERVAL '25 days', NOW(), '{"provider": "email", "providers": ["email"]}', '{"name": "Grace Lee"}', 'authenticated', 'authenticated'),
    ('11111111-2222-3333-4444-555555550008', '00000000-0000-0000-0000-000000000000', 'henry@test.hd', crypt('TestPassword123!', gen_salt('bf')), NOW(), NOW() - INTERVAL '40 days', NOW(), '{"provider": "email", "providers": ["email"]}', '{"name": "Henry Brown"}', 'authenticated', 'authenticated')
  ON CONFLICT (id) DO NOTHING;

  -- Set the UUIDs
  user_alice := '11111111-2222-3333-4444-555555550001';
  user_bob := '11111111-2222-3333-4444-555555550002';
  user_carol := '11111111-2222-3333-4444-555555550003';
  user_david := '11111111-2222-3333-4444-555555550004';
  user_emma := '11111111-2222-3333-4444-555555550005';
  user_frank := '11111111-2222-3333-4444-555555550006';
  user_grace := '11111111-2222-3333-4444-555555550007';
  user_henry := '11111111-2222-3333-4444-555555550008';

  RAISE NOTICE 'Created 8 test auth users';

  -- Update profiles with HD data
  UPDATE public.profiles SET
    bio = 'Manifestor exploring my design. Love sharing insights about initiating energy!',
    avatar_url = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice',
    hd_type = 'Manifestor', hd_profile = '1/3', hd_authority = 'Splenic', is_public = true,
    birth_date = '1990-03-15 14:30:00+00'
  WHERE id = user_alice;

  UPDATE public.profiles SET
    bio = 'Generator life! Sacral response is my guide. Always looking to connect with fellow Generators.',
    avatar_url = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob',
    hd_type = 'Generator', hd_profile = '2/4', hd_authority = 'Sacral', is_public = true,
    birth_date = '1985-07-22 08:15:00+00'
  WHERE id = user_bob;

  UPDATE public.profiles SET
    bio = 'MG with emotional authority. Learning to ride my emotional wave and respond correctly.',
    avatar_url = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carol',
    hd_type = 'Manifesting Generator', hd_profile = '3/5', hd_authority = 'Emotional', is_public = true,
    birth_date = '1992-11-08 22:45:00+00'
  WHERE id = user_carol;

  UPDATE public.profiles SET
    bio = 'Projector waiting for invitations. Here to guide and support others on their HD journey.',
    avatar_url = 'https://api.dicebear.com/7.x/avataaars/svg?seed=David',
    hd_type = 'Projector', hd_profile = '4/6', hd_authority = 'Self-Projected', is_public = true,
    birth_date = '1988-01-30 05:00:00+00'
  WHERE id = user_david;

  UPDATE public.profiles SET
    bio = 'Reflector sampling the cosmic weather. New moon is my time to make decisions!',
    avatar_url = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Emma',
    hd_type = 'Reflector', hd_profile = '5/1', hd_authority = 'Lunar', is_public = true,
    birth_date = '1995-09-12 11:20:00+00'
  WHERE id = user_emma;

  UPDATE public.profiles SET
    bio = 'Generator with splenic authority. Quick decisions are my thing!',
    avatar_url = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Frank',
    hd_type = 'Generator', hd_profile = '6/2', hd_authority = 'Splenic', is_public = true,
    birth_date = '1983-04-28 16:40:00+00'
  WHERE id = user_frank;

  UPDATE public.profiles SET
    bio = 'Projector focused on relationships and connection. Love analyzing composite charts!',
    avatar_url = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Grace',
    hd_type = 'Projector', hd_profile = '2/5', hd_authority = 'Emotional', is_public = true,
    birth_date = '1991-12-03 09:30:00+00'
  WHERE id = user_grace;

  UPDATE public.profiles SET
    bio = 'MG living my design. Multi-passionate and always busy with multiple projects!',
    avatar_url = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Henry',
    hd_type = 'Manifesting Generator', hd_profile = '1/4', hd_authority = 'Sacral', is_public = true,
    birth_date = '1987-06-18 20:15:00+00'
  WHERE id = user_henry;

  RAISE NOTICE 'Updated profiles with HD data';

  -- ============================================================================
  -- Create Friendships
  -- ============================================================================

  -- Accepted friends (mutual)
  INSERT INTO public.friendships (user_id, friend_id, status, created_at) VALUES
    (test_user_id, user_alice, 'accepted', NOW() - INTERVAL '25 days'),
    (user_alice, test_user_id, 'accepted', NOW() - INTERVAL '25 days'),
    (test_user_id, user_bob, 'accepted', NOW() - INTERVAL '20 days'),
    (user_bob, test_user_id, 'accepted', NOW() - INTERVAL '20 days'),
    (test_user_id, user_carol, 'accepted', NOW() - INTERVAL '15 days'),
    (user_carol, test_user_id, 'accepted', NOW() - INTERVAL '15 days'),
    (test_user_id, user_david, 'accepted', NOW() - INTERVAL '10 days'),
    (user_david, test_user_id, 'accepted', NOW() - INTERVAL '10 days')
  ON CONFLICT (user_id, friend_id) DO NOTHING;

  -- Pending requests TO test user
  INSERT INTO public.friendships (user_id, friend_id, status, created_at) VALUES
    (user_emma, test_user_id, 'pending', NOW() - INTERVAL '2 days'),
    (user_frank, test_user_id, 'pending', NOW() - INTERVAL '1 day')
  ON CONFLICT (user_id, friend_id) DO NOTHING;

  -- Test user's pending request
  INSERT INTO public.friendships (user_id, friend_id, status, created_at) VALUES
    (test_user_id, user_grace, 'pending', NOW() - INTERVAL '3 days')
  ON CONFLICT (user_id, friend_id) DO NOTHING;

  RAISE NOTICE 'Created friendships';

  -- ============================================================================
  -- Create Follow Relationships
  -- ============================================================================

  -- Followers of test user
  INSERT INTO public.user_follows (follower_id, following_id, created_at) VALUES
    (user_alice, test_user_id, NOW() - INTERVAL '28 days'),
    (user_bob, test_user_id, NOW() - INTERVAL '22 days'),
    (user_carol, test_user_id, NOW() - INTERVAL '18 days'),
    (user_david, test_user_id, NOW() - INTERVAL '12 days'),
    (user_emma, test_user_id, NOW() - INTERVAL '8 days'),
    (user_frank, test_user_id, NOW() - INTERVAL '5 days'),
    (user_grace, test_user_id, NOW() - INTERVAL '3 days')
  ON CONFLICT (follower_id, following_id) DO NOTHING;

  -- Test user following others
  INSERT INTO public.user_follows (follower_id, following_id, created_at) VALUES
    (test_user_id, user_alice, NOW() - INTERVAL '27 days'),
    (test_user_id, user_bob, NOW() - INTERVAL '21 days'),
    (test_user_id, user_carol, NOW() - INTERVAL '16 days'),
    (test_user_id, user_david, NOW() - INTERVAL '9 days'),
    (test_user_id, user_henry, NOW() - INTERVAL '4 days')
  ON CONFLICT (follower_id, following_id) DO NOTHING;

  -- Cross-follows for realistic network
  INSERT INTO public.user_follows (follower_id, following_id, created_at) VALUES
    (user_alice, user_bob, NOW() - INTERVAL '35 days'),
    (user_bob, user_alice, NOW() - INTERVAL '34 days'),
    (user_carol, user_david, NOW() - INTERVAL '30 days'),
    (user_david, user_emma, NOW() - INTERVAL '25 days'),
    (user_emma, user_frank, NOW() - INTERVAL '20 days'),
    (user_frank, user_grace, NOW() - INTERVAL '15 days'),
    (user_grace, user_henry, NOW() - INTERVAL '10 days'),
    (user_henry, user_alice, NOW() - INTERVAL '8 days')
  ON CONFLICT (follower_id, following_id) DO NOTHING;

  RAISE NOTICE 'Created follows';

  -- ============================================================================
  -- Create Test Posts
  -- ============================================================================

  INSERT INTO public.posts (user_id, content, post_type, visibility, created_at) VALUES
    (user_alice, 'Just had an amazing manifestor moment - initiated a new project without waiting for permission! #Manifestor #HumanDesign', 'insight', 'public', NOW() - INTERVAL '5 days'),
    (user_bob, 'Sacral said YES today and I followed it. Best decision ever. Trust your gut, fellow Generators! #Generator #SacralResponse', 'reflection', 'public', NOW() - INTERVAL '4 days'),
    (user_carol, 'Riding my emotional wave today. Feeling the highs and lows. Reminder: clarity comes with time. #EmotionalAuthority #MG', 'insight', 'public', NOW() - INTERVAL '3 days'),
    (user_david, 'Received an amazing invitation today! Projectors, trust the process. Recognition always comes. #Projector #WaitForInvitation', 'reflection', 'public', NOW() - INTERVAL '2 days'),
    (user_emma, 'New moon tonight! Making my monthly decisions. Fellow Reflectors, how do you honor your lunar cycle? #Reflector #LunarCycle', 'question', 'public', NOW() - INTERVAL '1 day'),
    (user_frank, 'Gate 34 transit hitting different today. Anyone else feeling the power? #Transits #Gate34', 'transit_share', 'public', NOW() - INTERVAL '12 hours'),
    (user_grace, 'Just analyzed my first composite chart with a friend. Mind blown by our electromagnetic connection! #CompositeChart #Connection', 'insight', 'public', NOW() - INTERVAL '6 hours'),
    (user_henry, 'Multi-passionate MG life: started 3 new projects today. My sacral is lit! Who else relates? #ManifestingGenerator #MultiPassionate', 'reflection', 'public', NOW() - INTERVAL '2 hours')
  ON CONFLICT DO NOTHING;

  RAISE NOTICE 'Created posts';

  -- ============================================================================
  -- Update Counts
  -- ============================================================================

  UPDATE public.profiles SET
    follower_count = (SELECT COUNT(*) FROM public.user_follows WHERE following_id = profiles.id),
    following_count = (SELECT COUNT(*) FROM public.user_follows WHERE follower_id = profiles.id)
  WHERE id IN (test_user_id, user_alice, user_bob, user_carol, user_david, user_emma, user_frank, user_grace, user_henry);

  RAISE NOTICE '';
  RAISE NOTICE '=== SUCCESS! Test social data seeded ===';
  RAISE NOTICE '';
  RAISE NOTICE 'Your test user (test@humandesign.app) now has:';
  RAISE NOTICE '  - 4 accepted friends: Alice, Bob, Carol, David';
  RAISE NOTICE '  - 2 pending friend requests from: Emma, Frank';
  RAISE NOTICE '  - 1 outgoing friend request to: Grace';
  RAISE NOTICE '  - 7 followers';
  RAISE NOTICE '  - 5 following';
  RAISE NOTICE '';
  RAISE NOTICE 'Test users created (all types represented):';
  RAISE NOTICE '  - Alice Chen (Manifestor 1/3, Splenic)';
  RAISE NOTICE '  - Bob Martinez (Generator 2/4, Sacral)';
  RAISE NOTICE '  - Carol Johnson (MG 3/5, Emotional)';
  RAISE NOTICE '  - David Kim (Projector 4/6, Self-Projected)';
  RAISE NOTICE '  - Emma Wilson (Reflector 5/1, Lunar)';
  RAISE NOTICE '  - Frank Thompson (Generator 6/2, Splenic)';
  RAISE NOTICE '  - Grace Lee (Projector 2/5, Emotional)';
  RAISE NOTICE '  - Henry Brown (MG 1/4, Sacral)';

END $$;
