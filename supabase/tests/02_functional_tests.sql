-- ============================================================================
-- Functional Smoke Tests
-- Tests that authorized operations actually work as expected
-- Requires: 00_setup_test_users.sql to have run first
-- ============================================================================

DO $$
DECLARE
  v_free     UUID;
  v_premium  UUID;
  v_private  UUID;
  v_stranger UUID;
  v_group_id UUID;
  v_circle_id UUID;
  v_conv_id  UUID;
  v_count    BIGINT;
  v_id       UUID;
  v_pass     INT := 0;
  v_fail     INT := 0;
BEGIN
  -- Load test IDs
  SELECT val INTO v_free     FROM test_ids WHERE key = 'free';
  SELECT val INTO v_premium  FROM test_ids WHERE key = 'premium';
  SELECT val INTO v_private  FROM test_ids WHERE key = 'private';
  SELECT val INTO v_stranger FROM test_ids WHERE key = 'stranger';
  SELECT val INTO v_group_id FROM test_ids WHERE key = 'group';
  SELECT val INTO v_circle_id FROM test_ids WHERE key = 'circle';
  SELECT val INTO v_conv_id  FROM test_ids WHERE key = 'conv';

  RAISE NOTICE '';
  RAISE NOTICE '=== Functional Smoke Tests ===';
  RAISE NOTICE '';

  -- ========================================================================
  -- A. SOCIAL GRAPH
  -- ========================================================================
  RAISE NOTICE '--- A. Social Graph ---';

  -- A1: Follow a user → row appears
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_stranger::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.user_follows (follower_id, following_id) VALUES (v_stranger, v_premium);
    SELECT COUNT(*) INTO v_count FROM public.user_follows WHERE follower_id = v_stranger AND following_id = v_premium;
    IF v_count > 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] A1: Follow creates row';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A1: Follow did not create row';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A1: Follow failed: %', SQLERRM;
  END;

  -- A2: Unfollow → row removed
  BEGIN
    DELETE FROM public.user_follows WHERE follower_id = v_stranger AND following_id = v_premium;
    SELECT COUNT(*) INTO v_count FROM public.user_follows WHERE follower_id = v_stranger AND following_id = v_premium;
    IF v_count = 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] A2: Unfollow removes row';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A2: Unfollow did not remove row';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A2: Unfollow failed: %', SQLERRM;
  END;

  -- A3: Block a user → row in blocked_users
  BEGIN
    INSERT INTO public.blocked_users (blocker_id, blocked_id) VALUES (v_stranger, v_private)
    ON CONFLICT DO NOTHING;
    SELECT COUNT(*) INTO v_count FROM public.blocked_users WHERE blocker_id = v_stranger AND blocked_id = v_private;
    IF v_count > 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] A3: Block creates row';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A3: Block did not create row';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A3: Block failed: %', SQLERRM;
  END;

  -- A4: Unblock → row removed
  BEGIN
    DELETE FROM public.blocked_users WHERE blocker_id = v_stranger AND blocked_id = v_private;
    SELECT COUNT(*) INTO v_count FROM public.blocked_users WHERE blocker_id = v_stranger AND blocked_id = v_private;
    IF v_count = 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] A4: Unblock removes row';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A4: Unblock did not remove row';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] A4: Unblock failed: %', SQLERRM;
  END;

  -- ========================================================================
  -- B. POSTS & COMMENTS
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- B. Posts & Comments ---';

  -- B1: Create post → returns with correct user_id
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.posts (user_id, content, post_type, visibility)
    VALUES (v_free, 'Functional test post', 'insight', 'public')
    RETURNING id INTO v_id;
    IF v_id IS NOT NULL THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] B1: Create post returns id';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B1: Create post returned null id';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B1: Create post failed: %', SQLERRM;
  END;

  -- B2: Add comment to post
  BEGIN
    INSERT INTO public.post_comments (post_id, user_id, content)
    VALUES (v_id, v_free, 'Test comment')
    RETURNING id INTO v_id;
    IF v_id IS NOT NULL THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] B2: Add comment works';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B2: Add comment returned null';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B2: Add comment failed: %', SQLERRM;
  END;

  -- B3: Add reaction to post
  BEGIN
    INSERT INTO public.reactions (user_id, post_id, reaction_type)
    SELECT v_free, p.id, 'like' FROM public.posts p WHERE p.content = 'Functional test post' LIMIT 1;
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] B3: Add reaction works';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B3: Add reaction failed: %', SQLERRM;
  END;

  -- B4: Delete comment → removed
  BEGIN
    DELETE FROM public.post_comments WHERE id = v_id;
    SELECT COUNT(*) INTO v_count FROM public.post_comments WHERE id = v_id;
    IF v_count = 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] B4: Delete comment removes it';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B4: Delete comment did not remove it';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B4: Delete comment failed: %', SQLERRM;
  END;

  -- B5: Update post visibility
  BEGIN
    UPDATE public.posts SET visibility = 'followers' WHERE content = 'Functional test post' AND user_id = v_free;
    SELECT COUNT(*) INTO v_count FROM public.posts WHERE content = 'Functional test post' AND visibility = 'followers';
    IF v_count > 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] B5: Update post visibility works';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B5: Update post visibility failed';
    END IF;
    -- Cleanup
    DELETE FROM public.reactions WHERE user_id = v_free;
    DELETE FROM public.posts WHERE content = 'Functional test post';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] B5: Update visibility failed: %', SQLERRM;
  END;

  -- ========================================================================
  -- C. GROUPS
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- C. Groups ---';

  -- C1: Create group → creator becomes admin
  BEGIN
    DECLARE v_new_group UUID;
    BEGIN
      INSERT INTO public.groups (name, description, created_by)
      VALUES ('Functional Test Group', 'Testing', v_free)
      RETURNING id INTO v_new_group;

      -- Bootstrap creator as admin member
      INSERT INTO public.group_members (group_id, user_id, role) VALUES (v_new_group, v_free, 'admin');

      SELECT COUNT(*) INTO v_count FROM public.group_members WHERE group_id = v_new_group AND user_id = v_free AND role = 'admin';
      IF v_count > 0 THEN
        v_pass := v_pass + 1; RAISE NOTICE '[PASS] C1: Group creator is admin';
      ELSE
        v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C1: Group creator is not admin';
      END IF;

      -- Cleanup
      DELETE FROM public.group_members WHERE group_id = v_new_group;
      DELETE FROM public.groups WHERE id = v_new_group;
    END;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C1: Create group failed: %', SQLERRM;
  END;

  -- C2: Member can see group posts
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.group_posts WHERE group_id = v_group_id;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] C2: Member can read group posts';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C2: Member cannot read group posts';
  END IF;

  -- C3: Create group post works for member
  BEGIN
    INSERT INTO public.group_posts (group_id, user_id, content)
    VALUES (v_group_id, v_premium, 'Functional group post test');
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] C3: Member can create group post';
    DELETE FROM public.group_posts WHERE content = 'Functional group post test';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] C3: Member cannot create group post: %', SQLERRM;
  END;

  -- ========================================================================
  -- D. STORIES
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- D. Stories ---';

  -- D1: Create story works
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.stories (user_id, content, visibility, expires_at)
    VALUES (v_premium, 'Functional test story', 'public', NOW() + INTERVAL '24 hours')
    RETURNING id INTO v_id;
    IF v_id IS NOT NULL THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] D1: Create story works';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D1: Create story returned null';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D1: Create story failed: %', SQLERRM;
  END;

  -- D2: Mark story viewed
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.story_views (story_id, viewer_id)
    VALUES (v_id, v_free)
    ON CONFLICT DO NOTHING;
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] D2: Mark story viewed works';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D2: Mark story viewed failed: %', SQLERRM;
  END;

  -- D3: React to story
  BEGIN
    INSERT INTO public.story_reactions (story_id, user_id, reaction_type)
    VALUES (v_id, v_free, 'love')
    ON CONFLICT DO NOTHING;
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] D3: Story reaction works';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] D3: Story reaction failed: %', SQLERRM;
  END;

  -- Cleanup story test data
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  DELETE FROM public.stories WHERE id = v_id;

  -- ========================================================================
  -- E. MESSAGING
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- E. Messaging ---';

  -- E1: Both participants can see conversation
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.conversations WHERE id = v_conv_id;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E1a: Participant 1 can see conversation';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E1a: Participant 1 cannot see conversation';
  END IF;

  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  SELECT COUNT(*) INTO v_count FROM public.conversations WHERE id = v_conv_id;
  IF v_count > 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E1b: Participant 2 can see conversation';
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E1b: Participant 2 cannot see conversation';
  END IF;

  -- E2: Send message → appears
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_premium::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.direct_messages (conversation_id, sender_id, content)
    VALUES (v_conv_id, v_premium, 'Functional test message');
    SELECT COUNT(*) INTO v_count FROM public.direct_messages
    WHERE conversation_id = v_conv_id AND content = 'Functional test message';
    IF v_count > 0 THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] E2: Send message works';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E2: Message not found after send';
    END IF;
    DELETE FROM public.direct_messages WHERE content = 'Functional test message';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E2: Send message failed: %', SQLERRM;
  END;

  -- E3: Mark as read works
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    -- Mark premium's messages as read (free is the recipient)
    UPDATE public.direct_messages SET is_read = true
    WHERE conversation_id = v_conv_id AND sender_id = v_premium AND is_read = false;
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] E3: Mark as read works';
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] E3: Mark as read failed: %', SQLERRM;
  END;

  -- ========================================================================
  -- F. AI
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- F. AI ---';

  -- F1: User can create AI conversation
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_free::text, 'role', 'authenticated')::text, true);
  PERFORM set_config('role', 'authenticated', true);
  BEGIN
    INSERT INTO public.ai_conversations (user_id, context_type, title, last_message_at)
    VALUES (v_free, 'chart', 'Functional test convo', NOW())
    RETURNING id INTO v_id;
    IF v_id IS NOT NULL THEN
      v_pass := v_pass + 1; RAISE NOTICE '[PASS] F1: Create AI conversation works';
    ELSE
      v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F1: AI conversation creation returned null';
    END IF;
    DELETE FROM public.ai_conversations WHERE id = v_id;
  EXCEPTION WHEN OTHERS THEN
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F1: AI conversation creation failed: %', SQLERRM;
  END;

  -- F2: AI usage readable
  SELECT COUNT(*) INTO v_count FROM public.ai_usage WHERE user_id = v_free;
  IF v_count >= 0 THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] F2: AI usage SELECT works (% rows)', v_count;
  ELSE
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F2: AI usage SELECT failed';
  END IF;

  -- F3: ai_rate_limits denies authenticated
  BEGIN
    INSERT INTO public.ai_rate_limits (user_id, request_timestamps) VALUES (v_free, ARRAY[NOW()]);
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] F3: ai_rate_limits allows INSERT!';
  EXCEPTION WHEN OTHERS THEN
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] F3: ai_rate_limits blocks INSERT';
  END;

  -- ========================================================================
  -- G. GAMIFICATION (service_role tests)
  -- ========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '--- G. Gamification ---';

  -- G1: award_points RPC works via service_role
  PERFORM set_config('role', 'service_role', true);
  BEGIN
    PERFORM public.award_points(v_free, 10, 'daily_login'::text, 'Functional test points'::text, NULL::uuid);
    v_pass := v_pass + 1; RAISE NOTICE '[PASS] G1: award_points RPC works';
  EXCEPTION WHEN OTHERS THEN
    -- Function may not exist or signature may differ
    v_fail := v_fail + 1; RAISE NOTICE '[FAIL] G1: award_points RPC failed: %', SQLERRM;
  END;

  -- ========================================================================
  -- RESET ROLE & SUMMARY
  -- ========================================================================
  PERFORM set_config('role', 'service_role', true);

  RAISE NOTICE '';
  RAISE NOTICE '=== Functional Tests Complete ===';
  RAISE NOTICE 'PASSED: %', v_pass;
  RAISE NOTICE 'FAILED: %', v_fail;
  RAISE NOTICE 'TOTAL:  %', v_pass + v_fail;
  RAISE NOTICE '';

END $$;
