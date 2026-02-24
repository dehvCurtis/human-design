-- ============================================================================
-- Test User Setup
-- Creates 5 test users with different tiers, privacy, and relationships
-- ============================================================================

-- Fixed UUIDs for test users
DO $$
DECLARE
  v_free     UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0001';
  v_premium  UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0002';
  v_private  UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0003';
  v_blocked  UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0004';
  v_stranger UUID := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeee0005';
  v_group_id UUID;
  v_circle_id UUID;
  v_conv_id  UUID;
  v_post_free_public UUID;
  v_post_free_followers UUID;
  v_post_premium_public UUID;
  v_story_free_public UUID;
  v_story_free_followers UUID;
  v_story_expired UUID;
BEGIN
  RAISE NOTICE '=== Setting up test users ===';

  -- ---- 1. Create auth.users ----
  INSERT INTO auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, aud, role)
  VALUES
    (v_free,     '00000000-0000-0000-0000-000000000000', 'test_free@rls.test',     extensions.crypt('TestPass123!', extensions.gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{"name":"Test Free"}',     'authenticated', 'authenticated'),
    (v_premium,  '00000000-0000-0000-0000-000000000000', 'test_premium@rls.test',  extensions.crypt('TestPass123!', extensions.gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{"name":"Test Premium"}',  'authenticated', 'authenticated'),
    (v_private,  '00000000-0000-0000-0000-000000000000', 'test_private@rls.test',  extensions.crypt('TestPass123!', extensions.gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{"name":"Test Private"}',  'authenticated', 'authenticated'),
    (v_blocked,  '00000000-0000-0000-0000-000000000000', 'test_blocked@rls.test',  extensions.crypt('TestPass123!', extensions.gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{"name":"Test Blocked"}',  'authenticated', 'authenticated'),
    (v_stranger, '00000000-0000-0000-0000-000000000000', 'test_stranger@rls.test', extensions.crypt('TestPass123!', extensions.gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{"name":"Test Stranger"}', 'authenticated', 'authenticated')
  ON CONFLICT (id) DO NOTHING;

  -- ---- 2. Create profiles ----
  INSERT INTO public.profiles (id, email, name, bio, hd_type, hd_profile, hd_authority, is_public, is_premium, birth_date)
  VALUES
    (v_free,     'test_free@rls.test',     'Test Free User',     'Free tier test user',     'Generator',              '2/4', 'Sacral',      true,  false, '1990-01-15 10:00:00+00'),
    (v_premium,  'test_premium@rls.test',  'Test Premium User',  'Premium tier test user',  'Projector',              '4/6', 'Emotional',   true,  true,  '1988-06-22 14:30:00+00'),
    (v_private,  'test_private@rls.test',  'Test Private User',  'Private profile user',    'Manifestor',             '1/3', 'Splenic',     false, false, '1992-11-08 22:00:00+00'),
    (v_blocked,  'test_blocked@rls.test',  'Test Blocked User',  'Blocked user for tests',  'Manifesting Generator',  '3/5', 'Emotional',   true,  false, '1985-03-20 08:00:00+00'),
    (v_stranger, 'test_stranger@rls.test', 'Test Stranger User', 'No relationships',        'Reflector',              '5/1', 'Lunar',       true,  false, '1995-09-01 16:00:00+00')
  ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    bio = EXCLUDED.bio,
    hd_type = EXCLUDED.hd_type,
    is_public = EXCLUDED.is_public,
    is_premium = EXCLUDED.is_premium;

  -- ---- 4. Follow relationships ----
  -- user_free <-> user_premium (mutual follows)
  INSERT INTO public.user_follows (follower_id, following_id) VALUES
    (v_free, v_premium),
    (v_premium, v_free)
  ON CONFLICT DO NOTHING;

  -- user_private follows user_free (one-way)
  INSERT INTO public.user_follows (follower_id, following_id) VALUES
    (v_private, v_free)
  ON CONFLICT DO NOTHING;

  -- ---- 5. Block relationship ----
  -- user_free blocks user_blocked
  INSERT INTO public.blocked_users (blocker_id, blocked_id) VALUES
    (v_free, v_blocked)
  ON CONFLICT DO NOTHING;

  -- ---- 6. Test posts ----
  v_post_free_public := gen_random_uuid();
  v_post_free_followers := gen_random_uuid();
  v_post_premium_public := gen_random_uuid();

  INSERT INTO public.posts (id, user_id, content, post_type, visibility) VALUES
    (v_post_free_public,    v_free,    'Free user public post #test',     'insight',    'public'),
    (v_post_free_followers, v_free,    'Free user followers-only post',   'reflection', 'followers'),
    (v_post_premium_public, v_premium, 'Premium user public post #test',  'insight',    'public')
  ON CONFLICT (id) DO NOTHING;

  -- ---- 7. Test stories ----
  v_story_free_public := gen_random_uuid();
  v_story_free_followers := gen_random_uuid();
  v_story_expired := gen_random_uuid();

  INSERT INTO public.stories (id, user_id, content, visibility, expires_at) VALUES
    (v_story_free_public,    v_free, 'Public story from free user',    'public',    NOW() + INTERVAL '23 hours'),
    (v_story_free_followers, v_free, 'Followers-only story',           'followers', NOW() + INTERVAL '23 hours'),
    (v_story_expired,        v_free, 'This story is expired',          'public',    NOW() - INTERVAL '1 hour')
  ON CONFLICT (id) DO NOTHING;

  -- ---- 8. Test group ----
  v_group_id := gen_random_uuid();

  INSERT INTO public.groups (id, name, description, created_by) VALUES
    (v_group_id, 'RLS Test Group', 'Group for RLS testing', v_free)
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.group_members (group_id, user_id, role) VALUES
    (v_group_id, v_free, 'admin'),
    (v_group_id, v_premium, 'member')
  ON CONFLICT DO NOTHING;

  INSERT INTO public.group_posts (group_id, user_id, content) VALUES
    (v_group_id, v_free, 'Group post from free user')
  ON CONFLICT DO NOTHING;

  -- ---- 9. Test circle ----
  v_circle_id := gen_random_uuid();

  INSERT INTO public.compatibility_circles (id, name, description, creator_id, is_private) VALUES
    (v_circle_id, 'RLS Test Circle', 'Private circle for testing', v_free, true)
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.circle_members (circle_id, user_id, role) VALUES
    (v_circle_id, v_free, 'creator'),
    (v_circle_id, v_premium, 'member')
  ON CONFLICT DO NOTHING;

  -- ---- 10. Test conversation + messages ----
  v_conv_id := gen_random_uuid();

  INSERT INTO public.conversations (id, participant_ids) VALUES
    (v_conv_id, ARRAY[v_free, v_premium])
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.direct_messages (conversation_id, sender_id, content) VALUES
    (v_conv_id, v_free, 'Hello from free user'),
    (v_conv_id, v_premium, 'Hello from premium user')
  ON CONFLICT DO NOTHING;

  -- ---- 11. Test AI data ----
  INSERT INTO public.ai_conversations (id, user_id, context_type, title, last_message_at) VALUES
    (gen_random_uuid(), v_free, 'general', 'Test AI convo', NOW())
  ON CONFLICT DO NOTHING;

  INSERT INTO public.ai_usage (user_id, period_start, messages_count) VALUES
    (v_free, date_trunc('month', NOW())::date, 2)
  ON CONFLICT (user_id, period_start) DO NOTHING;

  -- ---- 12. Test gamification data ----
  INSERT INTO public.user_points (user_id, total_points, current_level, weekly_points, monthly_points) VALUES
    (v_free, 100, 2, 50, 100),
    (v_premium, 500, 5, 200, 500)
  ON CONFLICT (user_id) DO NOTHING;

  -- ---- 13. Test charts ----
  INSERT INTO public.charts (id, user_id, name, birth_datetime, birth_location, timezone, type, authority, profile, definition, defined_centers, conscious_gates, unconscious_gates) VALUES
    (gen_random_uuid(), v_free,    'Free User Chart',    '1990-01-15 10:00:00+00', '{"city":"Test"}'::jsonb, 'UTC', 'Generator',  'Sacral',    '2/4', 'Single', '{Sacral}', '{34}', '{20}'),
    (gen_random_uuid(), v_premium, 'Premium User Chart', '1988-06-22 14:30:00+00', '{"city":"Test"}'::jsonb, 'UTC', 'Projector',  'Emotional', '4/6', 'Single', '{"Solar Plexus"}', '{36}', '{6}')
  ON CONFLICT (id) DO NOTHING;

  -- ---- 14. Test journal entries ----
  INSERT INTO public.journal_entries (user_id, content, entry_type) VALUES
    (v_free, 'My journal entry', 'journal')
  ON CONFLICT DO NOTHING;

  -- ---- 15. Store test IDs for other test files ----
  -- We use a temp table so other test blocks can reference these UUIDs
  CREATE TEMP TABLE IF NOT EXISTS test_ids (
    key TEXT PRIMARY KEY,
    val UUID
  );
  INSERT INTO test_ids VALUES
    ('free',     v_free),
    ('premium',  v_premium),
    ('private',  v_private),
    ('blocked',  v_blocked),
    ('stranger', v_stranger),
    ('group',    v_group_id),
    ('circle',   v_circle_id),
    ('conv',     v_conv_id),
    ('post_free_public',    v_post_free_public),
    ('post_free_followers', v_post_free_followers),
    ('post_premium_public', v_post_premium_public),
    ('story_free_public',    v_story_free_public),
    ('story_free_followers', v_story_free_followers),
    ('story_expired',        v_story_expired)
  ON CONFLICT (key) DO UPDATE SET val = EXCLUDED.val;

  RAISE NOTICE '=== Test users and data created successfully ===';
END $$;
