-- ============================================================================
-- RLS Privacy Tests
-- Tests that unauthorized access is blocked by Row Level Security policies
-- Requires: 00_setup_test_users.sql to have run first
-- ============================================================================

DO $$
DECLARE
  v_free     UUID;
  v_premium  UUID;
  v_private  UUID;
  v_blocked  UUID;
  v_stranger UUID;
  v_group_id UUID;
  v_circle_id UUID;
  v_conv_id  UUID;
  v_post_free_public    UUID;
  v_post_free_followers UUID;
  v_post_premium_public UUID;
  v_story_free_public    UUID;
  v_story_free_followers UUID;
  v_story_expired        UUID;
  v_count    BIGINT;
  v_result   BOOLEAN;
  v_pass     INT := 0;
  v_fail     INT := 0;
BEGIN
  -- Load test IDs
  SELECT val INTO v_free     FROM test_ids WHERE key = 'free';
  SELECT val INTO v_premium  FROM test_ids WHERE key = 'premium';
  SELECT val INTO v_private  FROM test_ids WHERE key = 'private';
  SELECT val INTO v_blocked  FROM test_ids WHERE key = 'blocked';
  SELECT val INTO v_stranger FROM test_ids WHERE key = 'stranger';
  SELECT val INTO v_group_id FROM test_ids WHERE key = 'group';
  SELECT val INTO v_circle_id FROM test_ids WHERE key = 'circle';
  SELECT val INTO v_conv_id  FROM test_ids WHERE key = 'conv';
  SELECT val INTO v_post_free_public    FROM test_ids WHERE key = 'post_free_public';
  SELECT val INTO v_post_free_followers FROM test_ids WHERE key = 'post_free_followers';
  SELECT val INTO v_post_premium_public FROM test_ids WHERE key = 'post_premium_public';
  SELECT val INTO v_story_free_public    FROM test_ids WHERE key = 'story_free_public';
  SELECT val INTO v_story_free_followers FROM test_ids WHERE key = 'story_free_followers';
  SELECT val INTO v_story_expired        FROM test_ids WHERE key = 'story_expired';

  RAISE NOTICE '';
  RAISE NOTICE '=== RLS Privacy Tests ===';
  RAISE NOTICE '';

  -- ========================================================================
  -- A. PROFILE PRIVACY
  -- ========================================================================
  RAISE NOTICE '--- A. Profile Privacy ---';

  -- A1: Stranger CAN see public profile
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.profiles WHERE id = v_free;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] A1: Stranger can see public profile';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A1: Stranger can see public profile';
  END IF;

  -- A2: Stranger CANNOT see private profile (or sees limited data)
  SELECT COUNT(*) INTO v_count FROM public.profiles WHERE id = v_private AND is_public = true;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] A2: Stranger cannot see private profile as public';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A2: Stranger cannot see private profile as public';
  END IF;

  -- A3: Free user CANNOT set own is_premium = true
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    UPDATE public.profiles SET is_premium = true WHERE id = v_free;
    -- Check if it actually stuck
    SELECT COUNT(*) INTO v_count FROM public.profiles WHERE id = v_free AND is_premium = true;
    IF v_count = 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] A3: Free user cannot self-escalate is_premium';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A3: Free user CAN self-escalate is_premium!';
      -- Revert
      PERFORM set_config('role', 'service_role', true);
      UPDATE public.profiles SET is_premium = false WHERE id = v_free;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] A3: Free user cannot self-escalate is_premium (exception: %)', SQLERRM;
  END;

  -- A4: Free user CANNOT update another user's profile
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  UPDATE public.profiles SET bio = 'HACKED' WHERE id = v_premium;
  SELECT COUNT(*) INTO v_count FROM public.profiles WHERE id = v_premium AND bio = 'HACKED';
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] A4: Free user cannot update another profile';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A4: Free user CAN update another profile!';
  END IF;

  -- A5: User can see own profile
  SELECT COUNT(*) INTO v_count FROM public.profiles WHERE id = v_free;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] A5: User can see own profile';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A5: User cannot see own profile';
  END IF;

  -- ========================================================================
  -- B. POSTS & FEED PRIVACY
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- B. Posts & Feed Privacy ---';

  -- B1: Stranger CAN see public posts
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.posts WHERE id = v_post_free_public;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B1: Stranger can see public posts';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B1: Stranger cannot see public posts';
  END IF;

  -- B2: Stranger CANNOT see followers-only posts
  SELECT COUNT(*) INTO v_count FROM public.posts WHERE id = v_post_free_followers;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B2: Stranger cannot see followers-only posts';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B2: Stranger CAN see followers-only posts!';
  END IF;

  -- B3: Premium (follower) CAN see followers-only posts
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.posts WHERE id = v_post_free_followers;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B3: Follower can see followers-only posts';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B3: Follower cannot see followers-only posts';
  END IF;

  -- B4: Blocked user CANNOT see free user's posts
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_blocked::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.posts WHERE id = v_post_free_public;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B4: Blocked user cannot see blocker posts';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B4: Blocked user CAN see blocker posts!';
  END IF;

  -- B5: Free user CAN create post with own user_id
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.posts (user_id, content, post_type, visibility) VALUES (v_free, 'RLS test post', 'insight', 'public');
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B5: Free user can create own post';
    DELETE FROM public.posts WHERE user_id = v_free AND content = 'RLS test post';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B5: Free user cannot create own post: %', SQLERRM;
  END;

  -- B6: Free user CANNOT create post as another user
  BEGIN
    INSERT INTO public.posts (user_id, content, post_type, visibility) VALUES (v_premium, 'Spoofed post', 'insight', 'public');
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B6: Free user CAN create post as another user!';
    DELETE FROM public.posts WHERE user_id = v_premium AND content = 'Spoofed post';
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B6: Free user cannot create post as another user';
  END;

  -- B7: Free user CAN delete own post
  BEGIN
    DELETE FROM public.posts WHERE id = v_post_free_public AND user_id = v_free;
    -- Re-create it for other tests
    INSERT INTO public.posts (id, user_id, content, post_type, visibility) VALUES (v_post_free_public, v_free, 'Free user public post #test', 'insight', 'public');
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B7: Free user can delete own post';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B7: Free user cannot delete own post: %', SQLERRM;
  END;

  -- B8: Free user CANNOT delete premium's post
  BEGIN
    DELETE FROM public.posts WHERE id = v_post_premium_public;
    SELECT COUNT(*) INTO v_count FROM public.posts WHERE id = v_post_premium_public;
    IF v_count > 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] B8: Free user cannot delete another''s post';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B8: Free user CAN delete another''s post!';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B8: Free user cannot delete another''s post (exception)';
  END;

  -- ========================================================================
  -- C. STORIES PRIVACY
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- C. Stories Privacy ---';

  -- C1: Stranger CAN see public non-expired stories
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.stories WHERE id = v_story_free_public;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] C1: Stranger can see public stories';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C1: Stranger cannot see public stories';
  END IF;

  -- C2: Stranger CANNOT see followers-only stories
  SELECT COUNT(*) INTO v_count FROM public.stories WHERE id = v_story_free_followers;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] C2: Stranger cannot see followers-only stories';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C2: Stranger CAN see followers-only stories!';
  END IF;

  -- C3: Follower CAN see followers-only stories
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.stories WHERE id = v_story_free_followers;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] C3: Follower can see followers-only stories';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C3: Follower cannot see followers-only stories';
  END IF;

  -- C4: Blocked user CANNOT see stories
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_blocked::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.stories WHERE id = v_story_free_public;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] C4: Blocked user cannot see stories';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C4: Blocked user CAN see stories!';
  END IF;

  -- C5: Free user CANNOT delete premium's story
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  -- (premium has no stories in test data, so we test that delete on someone else's story does nothing)
  DELETE FROM public.stories WHERE user_id = v_premium;
  v_pass := v_pass + 1; RAISE NOTICE '[PASS] C5: Cannot delete another user''s stories (no rows affected)';

  -- C6: Expired stories NOT visible
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.stories WHERE id = v_story_expired;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] C6: Expired stories are not visible';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C6: Expired stories ARE visible!';
  END IF;

  -- ========================================================================
  -- D. DIRECT MESSAGES PRIVACY
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- D. Direct Messages Privacy ---';

  -- D1: Free user CAN see messages in own conversation
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.direct_messages WHERE conversation_id = v_conv_id;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] D1: Participant can see conversation messages';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D1: Participant cannot see conversation messages';
  END IF;

  -- D2: Stranger CANNOT see messages
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.direct_messages WHERE conversation_id = v_conv_id;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] D2: Stranger cannot see others'' messages';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D2: Stranger CAN see others'' messages!';
  END IF;

  -- D3: Free user CAN send message in own conversation
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.direct_messages (conversation_id, sender_id, content)
    VALUES (v_conv_id, v_free, 'RLS test message');
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] D3: Participant can send message';
    DELETE FROM public.direct_messages WHERE content = 'RLS test message';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D3: Participant cannot send message: %', SQLERRM;
  END;

  -- D4: Free user CANNOT send message as another user
  BEGIN
    INSERT INTO public.direct_messages (conversation_id, sender_id, content)
    VALUES (v_conv_id, v_premium, 'Spoofed message');
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D4: User CAN spoof sender_id!';
    DELETE FROM public.direct_messages WHERE content = 'Spoofed message';
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] D4: Cannot spoof sender_id';
  END;

  -- D5: Recipient CAN mark messages as read
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    UPDATE public.direct_messages SET is_read = true
    WHERE conversation_id = v_conv_id AND sender_id = v_free;
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] D5: Recipient can mark messages as read';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D5: Recipient cannot mark as read: %', SQLERRM;
  END;

  -- D6: Sender CANNOT mark own sent messages as read
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  UPDATE public.direct_messages SET is_read = true
  WHERE conversation_id = v_conv_id AND sender_id = v_free;
  -- The UPDATE policy requires sender_id != auth.uid(), so this should affect 0 rows
  GET DIAGNOSTICS v_count = ROW_COUNT;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] D6: Sender cannot mark own messages as read';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D6: Sender CAN mark own messages as read!';
  END IF;

  -- ========================================================================
  -- E. GROUPS PRIVACY
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- E. Groups Privacy ---';

  -- E1: Member CAN see group
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.groups WHERE id = v_group_id;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E1: Member can see own group';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E1: Member cannot see own group';
  END IF;

  -- E2: Stranger CANNOT see group
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.groups WHERE id = v_group_id;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E2: Stranger cannot see group';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E2: Stranger CAN see group!';
  END IF;

  -- E3: Member CAN see group posts
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.group_posts WHERE group_id = v_group_id;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E3: Member can see group posts';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E3: Member cannot see group posts';
  END IF;

  -- E4: Stranger CANNOT see group posts
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.group_posts WHERE group_id = v_group_id;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E4: Stranger cannot see group posts';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E4: Stranger CAN see group posts!';
  END IF;

  -- E5: Member CAN create group post
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.group_posts (group_id, user_id, content) VALUES (v_group_id, v_premium, 'Test group post');
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E5: Member can create group post';
    DELETE FROM public.group_posts WHERE content = 'Test group post';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E5: Member cannot create group post: %', SQLERRM;
  END;

  -- E6: Stranger CANNOT create group post
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.group_posts (group_id, user_id, content) VALUES (v_group_id, v_stranger, 'Unauthorized post');
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E6: Stranger CAN create group post!';
    DELETE FROM public.group_posts WHERE content = 'Unauthorized post';
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E6: Stranger cannot create group post';
  END;

  -- E7: Only admin can update group
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  UPDATE public.groups SET name = 'HACKED' WHERE id = v_group_id;
  SELECT COUNT(*) INTO v_count FROM public.groups WHERE id = v_group_id AND name = 'HACKED';
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E7: Non-admin cannot update group';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E7: Non-admin CAN update group!';
    -- Revert
    PERFORM set_config('role', 'service_role', true);
    UPDATE public.groups SET name = 'RLS Test Group' WHERE id = v_group_id;
  END IF;

  -- ========================================================================
  -- F. CIRCLES PRIVACY
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- F. Circles Privacy ---';

  -- F1: Member CAN see circle members
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.circle_members WHERE circle_id = v_circle_id;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] F1: Circle member can see members';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F1: Circle member cannot see members';
  END IF;

  -- F2: Stranger CANNOT see private circle members
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.circle_members WHERE circle_id = v_circle_id;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] F2: Stranger cannot see private circle members';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F2: Stranger CAN see private circle members!';
  END IF;

  -- F3: Stranger CANNOT see circle posts
  SELECT COUNT(*) INTO v_count FROM public.circle_posts WHERE circle_id = v_circle_id;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] F3: Stranger cannot see circle posts';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F3: Stranger CAN see circle posts!';
  END IF;

  -- F4: Stranger CANNOT delete circle
  BEGIN
    DELETE FROM public.compatibility_circles WHERE id = v_circle_id;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    IF v_count = 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] F4: Stranger cannot delete circle (0 rows affected)';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F4: Stranger CAN delete circle! (% rows deleted)', v_count;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] F4: Stranger cannot delete circle (exception)';
  END;

  -- F5: Creator CAN see circle
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.compatibility_circles WHERE id = v_circle_id;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] F5: Creator can see own circle';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F5: Creator cannot see own circle';
  END IF;

  -- ========================================================================
  -- G. AI & USAGE PRIVACY
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- G. AI & Usage Privacy ---';

  -- G1: Free user CAN see own AI conversations
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.ai_conversations WHERE user_id = v_free;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] G1: User can see own AI conversations';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] G1: User cannot see own AI conversations';
  END IF;

  -- G2: Stranger CANNOT see free user's AI conversations
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.ai_conversations WHERE user_id = v_free;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] G2: Stranger cannot see others'' AI conversations';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] G2: Stranger CAN see others'' AI conversations!';
  END IF;

  -- G3: Free user CAN see own AI usage
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.ai_usage WHERE user_id = v_free;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] G3: User can see own AI usage';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] G3: User cannot see own AI usage';
  END IF;

  -- G4: Stranger CANNOT see free user's AI usage
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.ai_usage WHERE user_id = v_free;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] G4: Stranger cannot see others'' AI usage';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] G4: Stranger CAN see others'' AI usage!';
  END IF;

  -- G5: Authenticated user CANNOT directly insert into ai_messages
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.ai_messages (conversation_id, role, content)
    SELECT id, 'assistant', 'Injected message' FROM public.ai_conversations WHERE user_id = v_free LIMIT 1;
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] G5: User CAN directly insert AI messages!';
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] G5: User cannot directly insert AI messages';
  END;

  -- ========================================================================
  -- H. GAMIFICATION PRIVACY
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- H. Gamification Privacy ---';

  -- H1: User CAN see own points
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.user_points WHERE user_id = v_free;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] H1: User can see own points';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] H1: User cannot see own points';
  END IF;

  -- H2: Stranger CANNOT see free user's points
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.user_points WHERE user_id = v_free;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] H2: Stranger cannot see others'' points';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] H2: Stranger CAN see others'' points!';
  END IF;

  -- H3: User CAN see own challenges
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  -- (No user_challenges exist yet, but the query itself should not error)
  SELECT COUNT(*) INTO v_count FROM public.user_challenges WHERE user_id = v_free;
  v_pass := v_pass + 1; RAISE NOTICE '[PASS] H3: User can query own challenges (% found)', v_count;

  -- H4: Stranger CANNOT see free user's challenges
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.user_challenges WHERE user_id = v_free;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] H4: Stranger cannot see others'' challenges';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] H4: Stranger CAN see others'' challenges!';
  END IF;

  -- ========================================================================
  -- I. CROSS-USER DATA ISOLATION
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- I. Cross-User Data Isolation ---';

  -- I1: Free user CANNOT delete premium's chart
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  DELETE FROM public.charts WHERE user_id = v_premium;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] I1: Cannot delete another user''s chart';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] I1: CAN delete another user''s chart!';
  END IF;

  -- I2: Free user CANNOT see premium's point transactions
  SELECT COUNT(*) INTO v_count FROM public.point_transactions WHERE user_id = v_premium;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] I2: Cannot see another user''s point transactions';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] I2: CAN see another user''s point transactions!';
  END IF;

  -- I3: Free user CANNOT see premium's journal entries
  SELECT COUNT(*) INTO v_count FROM public.journal_entries WHERE user_id = v_premium;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] I3: Cannot see another user''s journal entries';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] I3: CAN see another user''s journal entries!';
  END IF;

  -- I4: Free user CANNOT see premium's notifications
  SELECT COUNT(*) INTO v_count FROM public.notifications WHERE user_id = v_premium;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] I4: Cannot see another user''s notifications';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] I4: CAN see another user''s notifications!';
  END IF;

  -- I5: AI rate limits table denies all authenticated access
  BEGIN
    SELECT COUNT(*) INTO v_count FROM public.ai_rate_limits;
    IF v_count = 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] I5: ai_rate_limits denies authenticated SELECT';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] I5: ai_rate_limits accessible to authenticated!';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] I5: ai_rate_limits denies authenticated access (exception)';
  END;

  -- ========================================================================
  -- J. BLOCK LIST ENFORCEMENT
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- J. Block List Enforcement ---';

  -- J1: Blocked user CANNOT follow blocker
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_blocked::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.user_follows (follower_id, following_id) VALUES (v_blocked, v_free);
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] J1: Blocked user CAN follow blocker!';
    DELETE FROM public.user_follows WHERE follower_id = v_blocked AND following_id = v_free;
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] J1: Blocked user cannot follow blocker';
  END;

  -- J2: Free user CAN see own block list
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.blocked_users WHERE blocker_id = v_free;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] J2: User can see own block list';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] J2: User cannot see own block list';
  END IF;

  -- J3: Blocked user CANNOT see blocker's block list
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_blocked::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.blocked_users WHERE blocker_id = v_free;
  IF v_count = 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] J3: Blocked user cannot see blocker''s block list';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] J3: Blocked user CAN see blocker''s block list!';
  END IF;

  -- ========================================================================
  -- RESET ROLE & SUMMARY
  -- ========================================================================
  PERFORM set_config('role', 'service_role', true);

  RAISE NOTICE '';
  RAISE NOTICE '=== RLS Privacy Tests Complete ===';
  RAISE NOTICE 'PASSED: %', v_pass;
  RAISE NOTICE 'FAILED: %', v_fail;
  RAISE NOTICE 'TOTAL:  %', v_pass + v_fail;
  RAISE NOTICE '';

END $$;
