


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."award_points"("p_user_id" "uuid", "p_points" integer, "p_action_type" "text", "p_description" "text" DEFAULT NULL::"text", "p_reference_id" "uuid" DEFAULT NULL::"uuid") RETURNS integer
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  new_total INTEGER;
  current_date DATE := CURRENT_DATE;
  last_date DATE;
  new_streak INTEGER;
BEGIN
  -- Insert transaction
  INSERT INTO public.point_transactions (user_id, points, action_type, description, reference_id)
  VALUES (p_user_id, p_points, p_action_type, p_description, p_reference_id);

  -- Get or create user_points record
  INSERT INTO public.user_points (user_id, total_points, weekly_points, monthly_points, last_activity_date)
  VALUES (p_user_id, 0, 0, 0, NULL)
  ON CONFLICT (user_id) DO NOTHING;

  -- Get last activity date
  SELECT last_activity_date INTO last_date
  FROM public.user_points
  WHERE user_id = p_user_id;

  -- Calculate streak
  IF last_date IS NULL OR last_date < current_date - 1 THEN
    new_streak := 1;
  ELSIF last_date = current_date - 1 THEN
    SELECT current_streak + 1 INTO new_streak
    FROM public.user_points
    WHERE user_id = p_user_id;
  ELSE
    SELECT current_streak INTO new_streak
    FROM public.user_points
    WHERE user_id = p_user_id;
  END IF;

  -- Update points
  UPDATE public.user_points
  SET
    total_points = total_points + p_points,
    weekly_points = weekly_points + p_points,
    monthly_points = monthly_points + p_points,
    current_streak = new_streak,
    longest_streak = GREATEST(longest_streak, new_streak),
    last_activity_date = current_date,
    current_level = FLOOR(SQRT((total_points + p_points) / 100)) + 1,
    updated_at = NOW()
  WHERE user_id = p_user_id
  RETURNING total_points INTO new_total;

  RETURN new_total;
END;
$$;


ALTER FUNCTION "public"."award_points"("p_user_id" "uuid", "p_points" integer, "p_action_type" "text", "p_description" "text", "p_reference_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."can_message_user"("sender" "uuid", "recipient" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
DECLARE
  recipient_setting TEXT;
BEGIN
  -- Check if blocked
  IF public.is_blocked(recipient, sender) THEN
    RETURN FALSE;
  END IF;

  -- Get recipient's message settings
  SELECT allow_messages INTO recipient_setting
  FROM public.profiles
  WHERE id = recipient;

  CASE recipient_setting
    WHEN 'everyone' THEN RETURN TRUE;
    WHEN 'followers' THEN RETURN public.is_following(recipient, sender);
    WHEN 'nobody' THEN RETURN FALSE;
    ELSE RETURN TRUE;
  END CASE;
END;
$$;


ALTER FUNCTION "public"."can_message_user"("sender" "uuid", "recipient" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_share_limit"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  user_is_premium BOOLEAN;
  monthly_shares INTEGER;
BEGIN
  -- Get user premium status
  SELECT is_premium INTO user_is_premium
  FROM public.profiles
  WHERE id = NEW.shared_by;

  -- Premium users have no limit
  IF user_is_premium THEN
    RETURN NEW;
  END IF;

  -- Count shares this month
  SELECT COUNT(*) INTO monthly_shares
  FROM public.shares
  WHERE shared_by = NEW.shared_by
    AND created_at >= date_trunc('month', NOW());

  -- Free users limited to 3 shares per month
  IF monthly_shares >= 3 THEN
    RAISE EXCEPTION 'Share limit reached. Upgrade to premium for unlimited shares.';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."check_share_limit"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."complete_quiz_attempt"("p_attempt_id" "uuid", "p_answers" "jsonb", "p_score" integer, "p_correct_count" integer, "p_total_questions" integer, "p_points_awarded" integer) RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_user_id UUID;
  v_quiz_id UUID;
  v_quiz_category TEXT;
  v_is_new_best BOOLEAN := FALSE;
  v_old_best INT;
  v_progress_existed BOOLEAN;
  v_yesterday DATE;
  v_streak_updated BOOLEAN := FALSE;
  v_category_progress JSONB;
BEGIN
  -- Get attempt info
  SELECT user_id, quiz_id INTO v_user_id, v_quiz_id
  FROM quiz_attempts WHERE id = p_attempt_id;

  IF v_user_id IS NULL THEN
    RETURN jsonb_build_object('error', 'Attempt not found');
  END IF;

  -- Get quiz category
  SELECT category INTO v_quiz_category FROM quizzes WHERE id = v_quiz_id;

  -- Update the attempt
  UPDATE quiz_attempts
  SET
    answers = p_answers,
    score = p_score,
    correct_count = p_correct_count,
    total_questions = p_total_questions,
    points_awarded = p_points_awarded,
    completed_at = NOW()
  WHERE id = p_attempt_id;

  -- Check if this is a new best score
  SELECT best_score INTO v_old_best
  FROM quiz_best_scores
  WHERE user_id = v_user_id AND quiz_id = v_quiz_id;

  IF v_old_best IS NULL THEN
    -- First attempt at this quiz
    INSERT INTO quiz_best_scores (user_id, quiz_id, best_score, best_attempt_id, attempts_count, first_completed_at, last_completed_at)
    VALUES (v_user_id, v_quiz_id, p_score, p_attempt_id, 1, NOW(), NOW());
    v_is_new_best := TRUE;
  ELSE
    -- Update existing record
    IF p_score > v_old_best THEN
      v_is_new_best := TRUE;
      UPDATE quiz_best_scores
      SET best_score = p_score, best_attempt_id = p_attempt_id, attempts_count = attempts_count + 1, last_completed_at = NOW()
      WHERE user_id = v_user_id AND quiz_id = v_quiz_id;
    ELSE
      UPDATE quiz_best_scores
      SET attempts_count = attempts_count + 1, last_completed_at = NOW()
      WHERE user_id = v_user_id AND quiz_id = v_quiz_id;
    END IF;
  END IF;

  -- Calculate yesterday for streak check
  v_yesterday := CURRENT_DATE - INTERVAL '1 day';

  -- Update user progress
  SELECT EXISTS(SELECT 1 FROM quiz_progress WHERE user_id = v_user_id) INTO v_progress_existed;

  IF NOT v_progress_existed THEN
    -- Create new progress record
    INSERT INTO quiz_progress (user_id, total_quizzes_completed, total_questions_answered, total_correct_answers, current_streak, best_streak, total_points_earned, category_progress, last_quiz_date)
    VALUES (
      v_user_id,
      1,
      p_total_questions,
      p_correct_count,
      1,
      1,
      p_points_awarded,
      jsonb_build_object(v_quiz_category, jsonb_build_object(
        'category', v_quiz_category,
        'questions_answered', p_total_questions,
        'correct_answers', p_correct_count,
        'quizzes_completed', 1,
        'best_score', p_score
      )),
      CURRENT_DATE
    );
    v_streak_updated := TRUE;
  ELSE
    -- Get current progress
    SELECT category_progress INTO v_category_progress FROM quiz_progress WHERE user_id = v_user_id;

    -- Update category progress
    IF v_category_progress ? v_quiz_category THEN
      v_category_progress := jsonb_set(
        v_category_progress,
        ARRAY[v_quiz_category],
        jsonb_build_object(
          'category', v_quiz_category,
          'questions_answered', COALESCE((v_category_progress->v_quiz_category->>'questions_answered')::INT, 0) + p_total_questions,
          'correct_answers', COALESCE((v_category_progress->v_quiz_category->>'correct_answers')::INT, 0) + p_correct_count,
          'quizzes_completed', COALESCE((v_category_progress->v_quiz_category->>'quizzes_completed')::INT, 0) + 1,
          'best_score', GREATEST(COALESCE((v_category_progress->v_quiz_category->>'best_score')::INT, 0), p_score)
        )
      );
    ELSE
      v_category_progress := v_category_progress || jsonb_build_object(v_quiz_category, jsonb_build_object(
        'category', v_quiz_category,
        'questions_answered', p_total_questions,
        'correct_answers', p_correct_count,
        'quizzes_completed', 1,
        'best_score', p_score
      ));
    END IF;

    -- Update progress with streak logic
    UPDATE quiz_progress
    SET
      total_quizzes_completed = total_quizzes_completed + 1,
      total_questions_answered = total_questions_answered + p_total_questions,
      total_correct_answers = total_correct_answers + p_correct_count,
      current_streak = CASE
        WHEN last_quiz_date = CURRENT_DATE THEN current_streak
        WHEN last_quiz_date = v_yesterday THEN current_streak + 1
        ELSE 1
      END,
      best_streak = GREATEST(best_streak, CASE
        WHEN last_quiz_date = CURRENT_DATE THEN current_streak
        WHEN last_quiz_date = v_yesterday THEN current_streak + 1
        ELSE 1
      END),
      total_points_earned = total_points_earned + p_points_awarded,
      category_progress = v_category_progress,
      last_quiz_date = CURRENT_DATE,
      updated_at = NOW()
    WHERE user_id = v_user_id
    RETURNING (last_quiz_date IS NULL OR last_quiz_date != CURRENT_DATE) INTO v_streak_updated;
  END IF;

  RETURN jsonb_build_object(
    'success', TRUE,
    'is_new_best', v_is_new_best,
    'streak_updated', v_streak_updated,
    'points_awarded', p_points_awarded
  );
END;
$$;


ALTER FUNCTION "public"."complete_quiz_attempt"("p_attempt_id" "uuid", "p_answers" "jsonb", "p_score" integer, "p_correct_count" integer, "p_total_questions" integer, "p_points_awarded" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."decrement"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer DEFAULT 1) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $_$
BEGIN
  EXECUTE format(
    'UPDATE public.%I SET %I = GREATEST(COALESCE(%I, 0) - $1, 0) WHERE id = $2',
    table_name, column_name, column_name
  ) USING amount, row_id;
END;
$_$;


ALTER FUNCTION "public"."decrement"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."decrement_hashtag_count"("hashtag_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    UPDATE public.hashtags
    SET post_count = GREATEST(post_count - 1, 0)
    WHERE id = hashtag_id;
END;
$$;


ALTER FUNCTION "public"."decrement_hashtag_count"("hashtag_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_hashtag_usage_history"("target_hashtag_id" "uuid", "days_back" integer DEFAULT 7) RETURNS TABLE("date" "date", "post_count" bigint)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        DATE(ph.created_at) AS date,
        COUNT(*) AS post_count
    FROM public.post_hashtags ph
    WHERE ph.hashtag_id = target_hashtag_id
      AND ph.created_at > NOW() - (days_back || ' days')::INTERVAL
    GROUP BY DATE(ph.created_at)
    ORDER BY date ASC;
END;
$$;


ALTER FUNCTION "public"."get_hashtag_usage_history"("target_hashtag_id" "uuid", "days_back" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_quiz_with_questions"("p_quiz_id" "uuid") RETURNS TABLE("quiz" "jsonb", "question_ids" "uuid"[])
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    jsonb_build_object(
      'id', q.id,
      'title', q.title,
      'description', q.description,
      'category', q.category,
      'difficulty', q.difficulty,
      'points_reward', q.points_reward,
      'time_limit', q.time_limit,
      'is_premium', q.is_premium,
      'is_active', q.is_active,
      'created_at', q.created_at
    ) AS quiz,
    ARRAY_AGG(qm.question_id ORDER BY qm.sort_order) AS question_ids
  FROM quizzes q
  LEFT JOIN quiz_question_map qm ON q.id = qm.quiz_id
  WHERE q.id = p_quiz_id
  GROUP BY q.id;
END;
$$;


ALTER FUNCTION "public"."get_quiz_with_questions"("p_quiz_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_trending_hashtags"("limit_count" integer DEFAULT 10) RETURNS TABLE("id" "uuid", "name" "text", "post_count" integer, "created_at" timestamp with time zone, "last_used_at" timestamp with time zone, "recent_post_count" bigint, "trend_score" numeric, "percent_change" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    WITH recent_counts AS (
        SELECT
            ph.hashtag_id,
            COUNT(*) AS recent_count
        FROM public.post_hashtags ph
        WHERE ph.created_at > NOW() - INTERVAL '24 hours'
        GROUP BY ph.hashtag_id
    ),
    previous_counts AS (
        SELECT
            ph.hashtag_id,
            COUNT(*) AS prev_count
        FROM public.post_hashtags ph
        WHERE ph.created_at > NOW() - INTERVAL '48 hours'
          AND ph.created_at <= NOW() - INTERVAL '24 hours'
        GROUP BY ph.hashtag_id
    )
    SELECT
        h.id,
        h.name,
        h.post_count,
        h.created_at,
        h.last_used_at,
        COALESCE(rc.recent_count, 0) AS recent_post_count,
        -- Trend score: recent posts weighted by recency
        COALESCE(rc.recent_count * 1.0, 0) AS trend_score,
        -- Percent change vs previous period
        CASE
            WHEN COALESCE(pc.prev_count, 0) = 0 THEN 100.0
            ELSE ((COALESCE(rc.recent_count, 0) - COALESCE(pc.prev_count, 0))::NUMERIC / COALESCE(pc.prev_count, 1)::NUMERIC) * 100
        END AS percent_change
    FROM public.hashtags h
    LEFT JOIN recent_counts rc ON rc.hashtag_id = h.id
    LEFT JOIN previous_counts pc ON pc.hashtag_id = h.id
    WHERE COALESCE(rc.recent_count, 0) > 0
    ORDER BY trend_score DESC, h.post_count DESC
    LIMIT limit_count;
END;
$$;


ALTER FUNCTION "public"."get_trending_hashtags"("limit_count" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_group_ids"("user_uuid" "uuid") RETURNS SETOF "uuid"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT group_id FROM public.group_members WHERE user_id = user_uuid;
$$;


ALTER FUNCTION "public"."get_user_group_ids"("user_uuid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.profiles (id, email, name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."increment"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer DEFAULT 1) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $_$
BEGIN
  EXECUTE format(
    'UPDATE public.%I SET %I = COALESCE(%I, 0) + $1 WHERE id = $2',
    table_name, column_name, column_name
  ) USING amount, row_id;
END;
$_$;


ALTER FUNCTION "public"."increment"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."increment_hashtag_count"("hashtag_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    UPDATE public.hashtags
    SET post_count = post_count + 1,
        last_used_at = NOW()
    WHERE id = hashtag_id;
END;
$$;


ALTER FUNCTION "public"."increment_hashtag_count"("hashtag_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_blocked"("blocker" "uuid", "blocked" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.blocked_users
    WHERE blocker_id = blocker AND blocked_id = blocked
  );
END;
$$;


ALTER FUNCTION "public"."is_blocked"("blocker" "uuid", "blocked" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_conversation_participant"("conv_id" "uuid", "user_uuid" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.conversations
    WHERE id = conv_id AND user_uuid = ANY(participant_ids)
  );
END;
$$;


ALTER FUNCTION "public"."is_conversation_participant"("conv_id" "uuid", "user_uuid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_following"("follower" "uuid", "following" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_follows
    WHERE follower_id = follower AND following_id = following
  );
END;
$$;


ALTER FUNCTION "public"."is_following"("follower" "uuid", "following" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_group_admin"("user_uuid" "uuid", "check_group_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.group_members
    WHERE user_id = user_uuid AND group_id = check_group_id AND role = 'admin'
  );
$$;


ALTER FUNCTION "public"."is_group_admin"("user_uuid" "uuid", "check_group_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_conversation_on_message"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE public.conversations
  SET
    last_message_at = NEW.created_at,
    last_message_preview = LEFT(NEW.content, 100),
    updated_at = NOW()
  WHERE id = NEW.conversation_id;
  RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."update_conversation_on_message"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_follow_counts"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.profiles SET follower_count = follower_count + 1 WHERE id = NEW.following_id;
    UPDATE public.profiles SET following_count = following_count + 1 WHERE id = NEW.follower_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.profiles SET follower_count = GREATEST(0, follower_count - 1) WHERE id = OLD.following_id;
    UPDATE public.profiles SET following_count = GREATEST(0, following_count - 1) WHERE id = OLD.follower_id;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."update_follow_counts"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_post_comment_count"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.posts SET comment_count = comment_count + 1 WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.posts SET comment_count = GREATEST(0, comment_count - 1) WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."update_post_comment_count"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_reaction_counts"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.post_id IS NOT NULL THEN
      UPDATE public.posts SET reaction_count = reaction_count + 1 WHERE id = NEW.post_id;
    ELSIF NEW.comment_id IS NOT NULL THEN
      UPDATE public.post_comments SET reaction_count = reaction_count + 1 WHERE id = NEW.comment_id;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.post_id IS NOT NULL THEN
      UPDATE public.posts SET reaction_count = GREATEST(0, reaction_count - 1) WHERE id = OLD.post_id;
    ELSIF OLD.comment_id IS NOT NULL THEN
      UPDATE public.post_comments SET reaction_count = GREATEST(0, reaction_count - 1) WHERE id = OLD.comment_id;
    END IF;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."update_reaction_counts"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_story_view_count"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE public.stories SET view_count = view_count + 1 WHERE id = NEW.story_id;
  RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."update_story_view_count"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."badges" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" NOT NULL,
    "icon_name" "text" NOT NULL,
    "category" "text" NOT NULL,
    "requirement_type" "text" NOT NULL,
    "requirement_value" integer,
    "requirement_data" "jsonb",
    "points_awarded" integer DEFAULT 0,
    "is_hidden" boolean DEFAULT false,
    "sort_order" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "badges_category_check" CHECK (("category" = ANY (ARRAY['social'::"text", 'learning'::"text", 'engagement'::"text", 'transit'::"text", 'achievement'::"text"]))),
    CONSTRAINT "badges_requirement_type_check" CHECK (("requirement_type" = ANY (ARRAY['count'::"text", 'streak'::"text", 'special'::"text"])))
);


ALTER TABLE "public"."badges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."blocked_users" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "blocker_id" "uuid" NOT NULL,
    "blocked_id" "uuid" NOT NULL,
    "reason" "text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."blocked_users" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."challenges" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text" NOT NULL,
    "challenge_type" "text" NOT NULL,
    "action_type" "text" NOT NULL,
    "target_value" integer NOT NULL,
    "points_reward" integer NOT NULL,
    "hd_type_filter" "text"[],
    "gate_filter" integer[],
    "is_active" boolean DEFAULT true,
    "start_date" "date",
    "end_date" "date",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "challenges_challenge_type_check" CHECK (("challenge_type" = ANY (ARRAY['daily'::"text", 'weekly'::"text", 'monthly'::"text", 'special'::"text"])))
);


ALTER TABLE "public"."challenges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."charts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "birth_datetime" timestamp with time zone NOT NULL,
    "birth_location" "jsonb" NOT NULL,
    "timezone" "text" NOT NULL,
    "type" "text" NOT NULL,
    "authority" "text" NOT NULL,
    "profile" "text" NOT NULL,
    "definition" "text" NOT NULL,
    "defined_centers" "text"[] NOT NULL,
    "conscious_gates" integer[] NOT NULL,
    "unconscious_gates" integer[] NOT NULL,
    "visibility" "text" DEFAULT 'private'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "charts_visibility_check" CHECK (("visibility" = ANY (ARRAY['private'::"text", 'friends'::"text", 'public'::"text"])))
);


ALTER TABLE "public"."charts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."comments" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "chart_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "content" "text" NOT NULL,
    "element_type" "text",
    "element_id" "text",
    "parent_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "comments_element_type_check" CHECK (("element_type" = ANY (ARRAY['gate'::"text", 'channel'::"text", 'center'::"text"])))
);


ALTER TABLE "public"."comments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."content_library" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "title" "text" NOT NULL,
    "content" "text" NOT NULL,
    "content_type" "text" NOT NULL,
    "category" "text" NOT NULL,
    "subcategory" "text",
    "gate_number" integer,
    "channel_id" "text",
    "center_name" "text",
    "hd_type" "text",
    "author_id" "uuid",
    "is_official" boolean DEFAULT false,
    "is_premium" boolean DEFAULT false,
    "is_published" boolean DEFAULT false,
    "view_count" integer DEFAULT 0,
    "like_count" integer DEFAULT 0,
    "tags" "text"[],
    "media_url" "text",
    "estimated_read_time" integer,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "published_at" timestamp with time zone,
    CONSTRAINT "content_library_category_check" CHECK (("category" = ANY (ARRAY['type'::"text", 'authority'::"text", 'profile'::"text", 'gate'::"text", 'channel'::"text", 'center'::"text", 'transit'::"text", 'general'::"text"]))),
    CONSTRAINT "content_library_content_type_check" CHECK (("content_type" = ANY (ARRAY['article'::"text", 'guide'::"text", 'quiz'::"text", 'video'::"text", 'infographic'::"text"])))
);


ALTER TABLE "public"."content_library" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."content_progress" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "content_id" "uuid" NOT NULL,
    "is_completed" boolean DEFAULT false,
    "progress_percent" integer DEFAULT 0,
    "quiz_score" integer,
    "last_accessed_at" timestamp with time zone DEFAULT "now"(),
    "completed_at" timestamp with time zone
);


ALTER TABLE "public"."content_progress" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."content_reports" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "reporter_id" "uuid" NOT NULL,
    "content_type" "text" NOT NULL,
    "content_id" "uuid" NOT NULL,
    "reason" "text" NOT NULL,
    "description" "text",
    "status" "text" DEFAULT 'pending'::"text",
    "reviewed_by" "uuid",
    "reviewed_at" timestamp with time zone,
    "action_taken" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "content_reports_content_type_check" CHECK (("content_type" = ANY (ARRAY['post'::"text", 'comment'::"text", 'story'::"text", 'message'::"text", 'profile'::"text"]))),
    CONSTRAINT "content_reports_reason_check" CHECK (("reason" = ANY (ARRAY['spam'::"text", 'harassment'::"text", 'inappropriate'::"text", 'misinformation'::"text", 'other'::"text"]))),
    CONSTRAINT "content_reports_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'reviewed'::"text", 'action_taken'::"text", 'dismissed'::"text"])))
);


ALTER TABLE "public"."content_reports" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."conversations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "participant_ids" "uuid"[] NOT NULL,
    "last_message_at" timestamp with time zone DEFAULT "now"(),
    "last_message_preview" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."conversations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."direct_messages" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "conversation_id" "uuid" NOT NULL,
    "sender_id" "uuid" NOT NULL,
    "content" "text" NOT NULL,
    "message_type" "text" DEFAULT 'text'::"text",
    "shared_chart_id" "uuid",
    "media_url" "text",
    "is_read" boolean DEFAULT false,
    "read_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "direct_messages_message_type_check" CHECK (("message_type" = ANY (ARRAY['text'::"text", 'chart_share'::"text", 'transit_share'::"text", 'image'::"text"])))
);


ALTER TABLE "public"."direct_messages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."friendships" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "friend_id" "uuid" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "friendships_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'accepted'::"text", 'blocked'::"text"])))
);


ALTER TABLE "public"."friendships" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group_members" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "group_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "role" "text" DEFAULT 'member'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "group_members_role_check" CHECK (("role" = ANY (ARRAY['admin'::"text", 'member'::"text"])))
);


ALTER TABLE "public"."group_members" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."groups" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "avatar_url" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."groups" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."hashtags" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "post_count" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "last_used_at" timestamp with time zone,
    CONSTRAINT "hashtag_name_format" CHECK (("name" ~ '^[a-z0-9]+$'::"text"))
);


ALTER TABLE "public"."hashtags" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."journal_entries" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "content" "text" NOT NULL,
    "mood" integer,
    "energy" integer,
    "transit_gate" integer,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "journal_entries_energy_check" CHECK ((("energy" >= 1) AND ("energy" <= 5))),
    CONSTRAINT "journal_entries_mood_check" CHECK ((("mood" >= 1) AND ("mood" <= 5)))
);


ALTER TABLE "public"."journal_entries" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."live_sessions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "host_id" "uuid" NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "session_type" "text" NOT NULL,
    "scheduled_at" timestamp with time zone NOT NULL,
    "duration_minutes" integer DEFAULT 60,
    "max_participants" integer,
    "current_participants" integer DEFAULT 0,
    "meeting_url" "text",
    "is_premium" boolean DEFAULT false,
    "is_recorded" boolean DEFAULT false,
    "recording_url" "text",
    "status" "text" DEFAULT 'scheduled'::"text",
    "tags" "text"[],
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "live_sessions_session_type_check" CHECK (("session_type" = ANY (ARRAY['workshop'::"text", 'q_and_a'::"text", 'group_reading'::"text", 'study_group'::"text", 'meditation'::"text"]))),
    CONSTRAINT "live_sessions_status_check" CHECK (("status" = ANY (ARRAY['scheduled'::"text", 'live'::"text", 'completed'::"text", 'cancelled'::"text"])))
);


ALTER TABLE "public"."live_sessions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."mentorship_profiles" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "is_mentor" boolean DEFAULT false,
    "is_mentee" boolean DEFAULT false,
    "expertise_areas" "text"[],
    "experience_years" integer,
    "bio" "text",
    "availability" "text",
    "max_mentees" integer DEFAULT 3,
    "current_mentee_count" integer DEFAULT 0,
    "session_rate" numeric(10,2),
    "is_verified" boolean DEFAULT false,
    "rating" numeric(3,2),
    "review_count" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."mentorship_profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."mentorship_requests" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "mentor_id" "uuid" NOT NULL,
    "mentee_id" "uuid" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text",
    "message" "text",
    "focus_areas" "text"[],
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "mentorship_requests_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'accepted'::"text", 'declined'::"text", 'completed'::"text", 'cancelled'::"text"])))
);


ALTER TABLE "public"."mentorship_requests" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "type" "text" NOT NULL,
    "title" "text" NOT NULL,
    "body" "text",
    "data" "jsonb",
    "is_read" boolean DEFAULT false,
    "read_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "notifications_type_check" CHECK (("type" = ANY (ARRAY['follow'::"text", 'reaction'::"text", 'comment'::"text", 'mention'::"text", 'message'::"text", 'badge_earned'::"text", 'challenge_completed'::"text", 'streak_milestone'::"text", 'session_reminder'::"text", 'mentorship_request'::"text", 'system'::"text"])))
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pentas" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "created_by" "uuid" NOT NULL,
    "member_ids" "uuid"[] NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."pentas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."point_transactions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "points" integer NOT NULL,
    "action_type" "text" NOT NULL,
    "description" "text",
    "reference_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "point_transactions_action_type_check" CHECK (("action_type" = ANY (ARRAY['daily_login'::"text", 'check_transit'::"text", 'save_affirmation'::"text", 'journal_entry'::"text", 'create_post'::"text", 'post_reaction'::"text", 'comment'::"text", 'friend_added'::"text", 'share_chart'::"text", 'complete_challenge'::"text", 'streak_bonus_7'::"text", 'streak_bonus_30'::"text", 'badge_earned'::"text", 'referral'::"text", 'first_chart'::"text", 'premium_bonus'::"text"])))
);


ALTER TABLE "public"."point_transactions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."post_comments" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "post_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "content" "text" NOT NULL,
    "parent_id" "uuid",
    "reaction_count" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."post_comments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."post_hashtags" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "post_id" "uuid" NOT NULL,
    "hashtag_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."post_hashtags" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."posts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "content" "text" NOT NULL,
    "post_type" "text" NOT NULL,
    "visibility" "text" DEFAULT 'public'::"text",
    "media_urls" "text"[],
    "chart_id" "uuid",
    "gate_number" integer,
    "channel_id" "text",
    "transit_data" "jsonb",
    "badge_id" "uuid",
    "is_pinned" boolean DEFAULT false,
    "reaction_count" integer DEFAULT 0,
    "comment_count" integer DEFAULT 0,
    "share_count" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "posts_post_type_check" CHECK (("post_type" = ANY (ARRAY['insight'::"text", 'reflection'::"text", 'transit_share'::"text", 'chart_share'::"text", 'question'::"text", 'achievement'::"text"]))),
    CONSTRAINT "posts_visibility_check" CHECK (("visibility" = ANY (ARRAY['public'::"text", 'followers'::"text", 'private'::"text"])))
);


ALTER TABLE "public"."posts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "email" "text" NOT NULL,
    "name" "text",
    "avatar_url" "text",
    "birth_date" timestamp with time zone,
    "birth_location" "jsonb",
    "timezone" "text",
    "is_premium" boolean DEFAULT false,
    "preferred_language" "text" DEFAULT 'en'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "bio" "text",
    "is_public" boolean DEFAULT true,
    "show_chart_publicly" boolean DEFAULT false,
    "allow_messages" "text" DEFAULT 'followers'::"text",
    "hd_type" "text",
    "hd_profile" "text",
    "hd_authority" "text",
    "notification_settings" "jsonb" DEFAULT '{"push_enabled": true, "email_enabled": false, "dm_notifications": true, "follow_notifications": true, "reaction_notifications": true}'::"jsonb",
    "last_seen_at" timestamp with time zone,
    "follower_count" integer DEFAULT 0,
    "following_count" integer DEFAULT 0,
    CONSTRAINT "profiles_allow_messages_check" CHECK (("allow_messages" = ANY (ARRAY['everyone'::"text", 'followers'::"text", 'nobody'::"text"]))),
    CONSTRAINT "profiles_hd_type_check" CHECK (("hd_type" = ANY (ARRAY['Manifestor'::"text", 'Generator'::"text", 'Manifesting Generator'::"text", 'Projector'::"text", 'Reflector'::"text"])))
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."quiz_attempts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "quiz_id" "uuid" NOT NULL,
    "score" integer DEFAULT 0,
    "correct_count" integer DEFAULT 0,
    "total_questions" integer DEFAULT 0,
    "answers" "jsonb" DEFAULT '[]'::"jsonb",
    "points_awarded" integer DEFAULT 0,
    "started_at" timestamp with time zone DEFAULT "now"(),
    "completed_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."quiz_attempts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."quiz_best_scores" (
    "user_id" "uuid" NOT NULL,
    "quiz_id" "uuid" NOT NULL,
    "best_score" integer DEFAULT 0,
    "best_attempt_id" "uuid",
    "attempts_count" integer DEFAULT 0,
    "first_completed_at" timestamp with time zone,
    "last_completed_at" timestamp with time zone
);


ALTER TABLE "public"."quiz_best_scores" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."quiz_progress" (
    "user_id" "uuid" NOT NULL,
    "total_quizzes_completed" integer DEFAULT 0,
    "total_questions_answered" integer DEFAULT 0,
    "total_correct_answers" integer DEFAULT 0,
    "current_streak" integer DEFAULT 0,
    "best_streak" integer DEFAULT 0,
    "total_points_earned" integer DEFAULT 0,
    "category_progress" "jsonb" DEFAULT '{}'::"jsonb",
    "last_quiz_date" "date",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."quiz_progress" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."quiz_question_map" (
    "quiz_id" "uuid" NOT NULL,
    "question_id" "uuid" NOT NULL,
    "sort_order" integer DEFAULT 0
);


ALTER TABLE "public"."quiz_question_map" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."quiz_questions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "question_type" "text" NOT NULL,
    "category" "text" NOT NULL,
    "difficulty" "text" NOT NULL,
    "question_text" "text" NOT NULL,
    "options" "jsonb" NOT NULL,
    "correct_answer" "text" NOT NULL,
    "explanation" "text" NOT NULL,
    "points" integer DEFAULT 10,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "quiz_questions_category_check" CHECK (("category" = ANY (ARRAY['types'::"text", 'centers'::"text", 'authorities'::"text", 'profiles'::"text", 'gates'::"text", 'channels'::"text", 'definitions'::"text", 'general'::"text"]))),
    CONSTRAINT "quiz_questions_difficulty_check" CHECK (("difficulty" = ANY (ARRAY['beginner'::"text", 'intermediate'::"text", 'advanced'::"text"]))),
    CONSTRAINT "quiz_questions_question_type_check" CHECK (("question_type" = ANY (ARRAY['multiple_choice'::"text", 'true_false'::"text"])))
);


ALTER TABLE "public"."quiz_questions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."quizzes" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "category" "text" NOT NULL,
    "difficulty" "text" NOT NULL,
    "points_reward" integer DEFAULT 25,
    "time_limit" integer,
    "is_premium" boolean DEFAULT false,
    "is_active" boolean DEFAULT true,
    "sort_order" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "quizzes_category_check" CHECK (("category" = ANY (ARRAY['types'::"text", 'centers'::"text", 'authorities'::"text", 'profiles'::"text", 'gates'::"text", 'channels'::"text", 'definitions'::"text", 'general'::"text"]))),
    CONSTRAINT "quizzes_difficulty_check" CHECK (("difficulty" = ANY (ARRAY['beginner'::"text", 'intermediate'::"text", 'advanced'::"text"])))
);


ALTER TABLE "public"."quizzes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."reactions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "post_id" "uuid",
    "comment_id" "uuid",
    "reaction_type" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "reactions_check" CHECK (((("post_id" IS NOT NULL) AND ("comment_id" IS NULL)) OR (("post_id" IS NULL) AND ("comment_id" IS NOT NULL)))),
    CONSTRAINT "reactions_reaction_type_check" CHECK (("reaction_type" = ANY (ARRAY['like'::"text", 'love'::"text", 'insight'::"text", 'resonate'::"text", 'generator_sacral'::"text", 'projector_recognition'::"text", 'manifestor_peace'::"text", 'reflector_surprise'::"text", 'mg_satisfaction'::"text"])))
);


ALTER TABLE "public"."reactions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."saved_affirmations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "text" "text" NOT NULL,
    "source" "text" NOT NULL,
    "gate_number" integer,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."saved_affirmations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."session_participants" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "session_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "rsvp_status" "text" DEFAULT 'registered'::"text",
    "registered_at" timestamp with time zone DEFAULT "now"(),
    "attended_at" timestamp with time zone,
    CONSTRAINT "session_participants_rsvp_status_check" CHECK (("rsvp_status" = ANY (ARRAY['registered'::"text", 'attended'::"text", 'no_show'::"text", 'cancelled'::"text"])))
);


ALTER TABLE "public"."session_participants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shares" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "chart_id" "uuid" NOT NULL,
    "shared_by" "uuid" NOT NULL,
    "shared_with" "uuid",
    "group_id" "uuid",
    "share_type" "text" NOT NULL,
    "share_token" "text",
    "expires_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "shares_check" CHECK (((("share_type" = 'friend'::"text") AND ("shared_with" IS NOT NULL)) OR (("share_type" = 'group'::"text") AND ("group_id" IS NOT NULL)) OR (("share_type" = 'link'::"text") AND ("share_token" IS NOT NULL)))),
    CONSTRAINT "shares_share_type_check" CHECK (("share_type" = ANY (ARRAY['friend'::"text", 'group'::"text", 'link'::"text"])))
);


ALTER TABLE "public"."shares" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."stories" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "content" "text",
    "media_url" "text",
    "background_color" "text",
    "text_color" "text",
    "transit_gate" integer,
    "affirmation_text" "text",
    "visibility" "text" DEFAULT 'followers'::"text",
    "view_count" integer DEFAULT 0,
    "expires_at" timestamp with time zone DEFAULT ("now"() + '24:00:00'::interval) NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "stories_visibility_check" CHECK (("visibility" = ANY (ARRAY['public'::"text", 'followers'::"text"])))
);


ALTER TABLE "public"."stories" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."story_views" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "story_id" "uuid" NOT NULL,
    "viewer_id" "uuid" NOT NULL,
    "viewed_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."story_views" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_badges" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "badge_id" "uuid" NOT NULL,
    "earned_at" timestamp with time zone DEFAULT "now"(),
    "progress" integer DEFAULT 0,
    "is_featured" boolean DEFAULT false
);


ALTER TABLE "public"."user_badges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_challenges" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "challenge_id" "uuid" NOT NULL,
    "progress" integer DEFAULT 0,
    "is_completed" boolean DEFAULT false,
    "completed_at" timestamp with time zone,
    "assigned_date" "date" DEFAULT CURRENT_DATE,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."user_challenges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_follows" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "follower_id" "uuid" NOT NULL,
    "following_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "user_follows_check" CHECK (("follower_id" <> "following_id"))
);


ALTER TABLE "public"."user_follows" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_points" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "total_points" integer DEFAULT 0,
    "current_level" integer DEFAULT 1,
    "current_streak" integer DEFAULT 0,
    "longest_streak" integer DEFAULT 0,
    "last_activity_date" "date",
    "weekly_points" integer DEFAULT 0,
    "monthly_points" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."user_points" OWNER TO "postgres";


ALTER TABLE ONLY "public"."badges"
    ADD CONSTRAINT "badges_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."badges"
    ADD CONSTRAINT "badges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."blocked_users"
    ADD CONSTRAINT "blocked_users_blocker_id_blocked_id_key" UNIQUE ("blocker_id", "blocked_id");



ALTER TABLE ONLY "public"."blocked_users"
    ADD CONSTRAINT "blocked_users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."challenges"
    ADD CONSTRAINT "challenges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."charts"
    ADD CONSTRAINT "charts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."comments"
    ADD CONSTRAINT "comments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."content_library"
    ADD CONSTRAINT "content_library_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."content_progress"
    ADD CONSTRAINT "content_progress_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."content_progress"
    ADD CONSTRAINT "content_progress_user_id_content_id_key" UNIQUE ("user_id", "content_id");



ALTER TABLE ONLY "public"."content_reports"
    ADD CONSTRAINT "content_reports_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."conversations"
    ADD CONSTRAINT "conversations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."direct_messages"
    ADD CONSTRAINT "direct_messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_user_id_friend_id_key" UNIQUE ("user_id", "friend_id");



ALTER TABLE ONLY "public"."group_members"
    ADD CONSTRAINT "group_members_group_id_user_id_key" UNIQUE ("group_id", "user_id");



ALTER TABLE ONLY "public"."group_members"
    ADD CONSTRAINT "group_members_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."hashtags"
    ADD CONSTRAINT "hashtags_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."hashtags"
    ADD CONSTRAINT "hashtags_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."journal_entries"
    ADD CONSTRAINT "journal_entries_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."live_sessions"
    ADD CONSTRAINT "live_sessions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."mentorship_profiles"
    ADD CONSTRAINT "mentorship_profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."mentorship_profiles"
    ADD CONSTRAINT "mentorship_profiles_user_id_key" UNIQUE ("user_id");



ALTER TABLE ONLY "public"."mentorship_requests"
    ADD CONSTRAINT "mentorship_requests_mentor_id_mentee_id_key" UNIQUE ("mentor_id", "mentee_id");



ALTER TABLE ONLY "public"."mentorship_requests"
    ADD CONSTRAINT "mentorship_requests_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pentas"
    ADD CONSTRAINT "pentas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."point_transactions"
    ADD CONSTRAINT "point_transactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."post_comments"
    ADD CONSTRAINT "post_comments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."post_hashtags"
    ADD CONSTRAINT "post_hashtags_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."post_hashtags"
    ADD CONSTRAINT "post_hashtags_post_id_hashtag_id_key" UNIQUE ("post_id", "hashtag_id");



ALTER TABLE ONLY "public"."posts"
    ADD CONSTRAINT "posts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."quiz_attempts"
    ADD CONSTRAINT "quiz_attempts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."quiz_best_scores"
    ADD CONSTRAINT "quiz_best_scores_pkey" PRIMARY KEY ("user_id", "quiz_id");



ALTER TABLE ONLY "public"."quiz_progress"
    ADD CONSTRAINT "quiz_progress_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."quiz_question_map"
    ADD CONSTRAINT "quiz_question_map_pkey" PRIMARY KEY ("quiz_id", "question_id");



ALTER TABLE ONLY "public"."quiz_questions"
    ADD CONSTRAINT "quiz_questions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."quizzes"
    ADD CONSTRAINT "quizzes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reactions"
    ADD CONSTRAINT "reactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reactions"
    ADD CONSTRAINT "reactions_user_id_post_id_reaction_type_key" UNIQUE ("user_id", "post_id", "reaction_type");



ALTER TABLE ONLY "public"."saved_affirmations"
    ADD CONSTRAINT "saved_affirmations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."session_participants"
    ADD CONSTRAINT "session_participants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."session_participants"
    ADD CONSTRAINT "session_participants_session_id_user_id_key" UNIQUE ("session_id", "user_id");



ALTER TABLE ONLY "public"."shares"
    ADD CONSTRAINT "shares_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shares"
    ADD CONSTRAINT "shares_share_token_key" UNIQUE ("share_token");



ALTER TABLE ONLY "public"."stories"
    ADD CONSTRAINT "stories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."story_views"
    ADD CONSTRAINT "story_views_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."story_views"
    ADD CONSTRAINT "story_views_story_id_viewer_id_key" UNIQUE ("story_id", "viewer_id");



ALTER TABLE ONLY "public"."user_badges"
    ADD CONSTRAINT "user_badges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_badges"
    ADD CONSTRAINT "user_badges_user_id_badge_id_key" UNIQUE ("user_id", "badge_id");



ALTER TABLE ONLY "public"."user_challenges"
    ADD CONSTRAINT "user_challenges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_follows"
    ADD CONSTRAINT "user_follows_follower_id_following_id_key" UNIQUE ("follower_id", "following_id");



ALTER TABLE ONLY "public"."user_follows"
    ADD CONSTRAINT "user_follows_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_points"
    ADD CONSTRAINT "user_points_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_points"
    ADD CONSTRAINT "user_points_user_id_key" UNIQUE ("user_id");



CREATE INDEX "idx_badges_category" ON "public"."badges" USING "btree" ("category");



CREATE INDEX "idx_blocked_users_blocked" ON "public"."blocked_users" USING "btree" ("blocked_id");



CREATE INDEX "idx_blocked_users_blocker" ON "public"."blocked_users" USING "btree" ("blocker_id");



CREATE INDEX "idx_challenges_active" ON "public"."challenges" USING "btree" ("is_active") WHERE ("is_active" = true);



CREATE INDEX "idx_challenges_dates" ON "public"."challenges" USING "btree" ("start_date", "end_date");



CREATE INDEX "idx_challenges_type" ON "public"."challenges" USING "btree" ("challenge_type");



CREATE INDEX "idx_charts_user_id" ON "public"."charts" USING "btree" ("user_id");



CREATE INDEX "idx_charts_visibility" ON "public"."charts" USING "btree" ("visibility");



CREATE INDEX "idx_comments_chart_id" ON "public"."comments" USING "btree" ("chart_id");



CREATE INDEX "idx_comments_parent_id" ON "public"."comments" USING "btree" ("parent_id");



CREATE INDEX "idx_comments_user_id" ON "public"."comments" USING "btree" ("user_id");



CREATE INDEX "idx_content_library_category" ON "public"."content_library" USING "btree" ("category");



CREATE INDEX "idx_content_library_gate" ON "public"."content_library" USING "btree" ("gate_number") WHERE ("gate_number" IS NOT NULL);



CREATE INDEX "idx_content_library_premium" ON "public"."content_library" USING "btree" ("is_premium");



CREATE INDEX "idx_content_library_published" ON "public"."content_library" USING "btree" ("is_published") WHERE ("is_published" = true);



CREATE INDEX "idx_content_library_type" ON "public"."content_library" USING "btree" ("content_type");



CREATE INDEX "idx_content_progress_user" ON "public"."content_progress" USING "btree" ("user_id");



CREATE INDEX "idx_content_reports_content" ON "public"."content_reports" USING "btree" ("content_type", "content_id");



CREATE INDEX "idx_content_reports_status" ON "public"."content_reports" USING "btree" ("status");



CREATE INDEX "idx_conversations_last_message" ON "public"."conversations" USING "btree" ("last_message_at" DESC);



CREATE INDEX "idx_conversations_participants" ON "public"."conversations" USING "gin" ("participant_ids");



CREATE INDEX "idx_dm_conversation_id" ON "public"."direct_messages" USING "btree" ("conversation_id");



CREATE INDEX "idx_dm_created_at" ON "public"."direct_messages" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_dm_is_read" ON "public"."direct_messages" USING "btree" ("is_read") WHERE ("is_read" = false);



CREATE INDEX "idx_dm_sender_id" ON "public"."direct_messages" USING "btree" ("sender_id");



CREATE INDEX "idx_friendships_friend_id" ON "public"."friendships" USING "btree" ("friend_id");



CREATE INDEX "idx_friendships_status" ON "public"."friendships" USING "btree" ("status");



CREATE INDEX "idx_friendships_user_id" ON "public"."friendships" USING "btree" ("user_id");



CREATE INDEX "idx_group_members_group_id" ON "public"."group_members" USING "btree" ("group_id");



CREATE INDEX "idx_group_members_user_id" ON "public"."group_members" USING "btree" ("user_id");



CREATE INDEX "idx_hashtags_name" ON "public"."hashtags" USING "btree" ("name");



CREATE INDEX "idx_hashtags_post_count" ON "public"."hashtags" USING "btree" ("post_count" DESC);



CREATE INDEX "idx_journal_entries_created_at" ON "public"."journal_entries" USING "btree" ("created_at");



CREATE INDEX "idx_journal_entries_user_id" ON "public"."journal_entries" USING "btree" ("user_id");



CREATE INDEX "idx_live_sessions_host" ON "public"."live_sessions" USING "btree" ("host_id");



CREATE INDEX "idx_live_sessions_scheduled" ON "public"."live_sessions" USING "btree" ("scheduled_at");



CREATE INDEX "idx_live_sessions_status" ON "public"."live_sessions" USING "btree" ("status");



CREATE INDEX "idx_mentorship_profiles_mentor" ON "public"."mentorship_profiles" USING "btree" ("is_mentor") WHERE ("is_mentor" = true);



CREATE INDEX "idx_mentorship_profiles_rating" ON "public"."mentorship_profiles" USING "btree" ("rating" DESC);



CREATE INDEX "idx_mentorship_profiles_verified" ON "public"."mentorship_profiles" USING "btree" ("is_verified");



CREATE INDEX "idx_mentorship_requests_mentee" ON "public"."mentorship_requests" USING "btree" ("mentee_id");



CREATE INDEX "idx_mentorship_requests_mentor" ON "public"."mentorship_requests" USING "btree" ("mentor_id");



CREATE INDEX "idx_mentorship_requests_status" ON "public"."mentorship_requests" USING "btree" ("status");



CREATE INDEX "idx_notifications_created" ON "public"."notifications" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_notifications_unread" ON "public"."notifications" USING "btree" ("user_id", "is_read") WHERE ("is_read" = false);



CREATE INDEX "idx_notifications_user" ON "public"."notifications" USING "btree" ("user_id");



CREATE INDEX "idx_pentas_created_by" ON "public"."pentas" USING "btree" ("created_by");



CREATE INDEX "idx_point_transactions_action" ON "public"."point_transactions" USING "btree" ("action_type");



CREATE INDEX "idx_point_transactions_created_at" ON "public"."point_transactions" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_point_transactions_user_id" ON "public"."point_transactions" USING "btree" ("user_id");



CREATE INDEX "idx_post_comments_parent_id" ON "public"."post_comments" USING "btree" ("parent_id");



CREATE INDEX "idx_post_comments_post_id" ON "public"."post_comments" USING "btree" ("post_id");



CREATE INDEX "idx_post_comments_user_id" ON "public"."post_comments" USING "btree" ("user_id");



CREATE INDEX "idx_post_hashtags_created_at" ON "public"."post_hashtags" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_post_hashtags_hashtag_id" ON "public"."post_hashtags" USING "btree" ("hashtag_id");



CREATE INDEX "idx_post_hashtags_post_id" ON "public"."post_hashtags" USING "btree" ("post_id");



CREATE INDEX "idx_posts_created_at" ON "public"."posts" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_posts_gate_number" ON "public"."posts" USING "btree" ("gate_number") WHERE ("gate_number" IS NOT NULL);



CREATE INDEX "idx_posts_post_type" ON "public"."posts" USING "btree" ("post_type");



CREATE INDEX "idx_posts_user_id" ON "public"."posts" USING "btree" ("user_id");



CREATE INDEX "idx_posts_visibility" ON "public"."posts" USING "btree" ("visibility");



CREATE INDEX "idx_quiz_attempts_completed" ON "public"."quiz_attempts" USING "btree" ("completed_at");



CREATE INDEX "idx_quiz_attempts_quiz" ON "public"."quiz_attempts" USING "btree" ("quiz_id");



CREATE INDEX "idx_quiz_attempts_user" ON "public"."quiz_attempts" USING "btree" ("user_id");



CREATE INDEX "idx_quiz_attempts_user_quiz" ON "public"."quiz_attempts" USING "btree" ("user_id", "quiz_id");



CREATE INDEX "idx_quiz_best_scores_quiz" ON "public"."quiz_best_scores" USING "btree" ("quiz_id");



CREATE INDEX "idx_quiz_best_scores_score" ON "public"."quiz_best_scores" USING "btree" ("best_score" DESC);



CREATE INDEX "idx_quiz_question_map_quiz" ON "public"."quiz_question_map" USING "btree" ("quiz_id");



CREATE INDEX "idx_quiz_questions_active" ON "public"."quiz_questions" USING "btree" ("is_active") WHERE ("is_active" = true);



CREATE INDEX "idx_quiz_questions_category" ON "public"."quiz_questions" USING "btree" ("category");



CREATE INDEX "idx_quiz_questions_difficulty" ON "public"."quiz_questions" USING "btree" ("difficulty");



CREATE INDEX "idx_quizzes_active" ON "public"."quizzes" USING "btree" ("is_active") WHERE ("is_active" = true);



CREATE INDEX "idx_quizzes_category" ON "public"."quizzes" USING "btree" ("category");



CREATE INDEX "idx_quizzes_difficulty" ON "public"."quizzes" USING "btree" ("difficulty");



CREATE INDEX "idx_reactions_comment_id" ON "public"."reactions" USING "btree" ("comment_id");



CREATE INDEX "idx_reactions_post_id" ON "public"."reactions" USING "btree" ("post_id");



CREATE INDEX "idx_reactions_type" ON "public"."reactions" USING "btree" ("reaction_type");



CREATE INDEX "idx_reactions_user_id" ON "public"."reactions" USING "btree" ("user_id");



CREATE INDEX "idx_saved_affirmations_user_id" ON "public"."saved_affirmations" USING "btree" ("user_id");



CREATE INDEX "idx_session_participants_session" ON "public"."session_participants" USING "btree" ("session_id");



CREATE INDEX "idx_session_participants_user" ON "public"."session_participants" USING "btree" ("user_id");



CREATE INDEX "idx_shares_chart_id" ON "public"."shares" USING "btree" ("chart_id");



CREATE INDEX "idx_shares_group_id" ON "public"."shares" USING "btree" ("group_id");



CREATE INDEX "idx_shares_shared_by" ON "public"."shares" USING "btree" ("shared_by");



CREATE INDEX "idx_shares_shared_with" ON "public"."shares" USING "btree" ("shared_with");



CREATE INDEX "idx_stories_created_at" ON "public"."stories" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_stories_expires_at" ON "public"."stories" USING "btree" ("expires_at");



CREATE INDEX "idx_stories_user_id" ON "public"."stories" USING "btree" ("user_id");



CREATE INDEX "idx_story_views_story_id" ON "public"."story_views" USING "btree" ("story_id");



CREATE INDEX "idx_story_views_viewer_id" ON "public"."story_views" USING "btree" ("viewer_id");



CREATE INDEX "idx_user_badges_badge_id" ON "public"."user_badges" USING "btree" ("badge_id");



CREATE INDEX "idx_user_badges_earned_at" ON "public"."user_badges" USING "btree" ("earned_at");



CREATE INDEX "idx_user_badges_user_id" ON "public"."user_badges" USING "btree" ("user_id");



CREATE INDEX "idx_user_challenges_challenge_id" ON "public"."user_challenges" USING "btree" ("challenge_id");



CREATE INDEX "idx_user_challenges_completed" ON "public"."user_challenges" USING "btree" ("is_completed");



CREATE INDEX "idx_user_challenges_date" ON "public"."user_challenges" USING "btree" ("assigned_date");



CREATE INDEX "idx_user_challenges_user_id" ON "public"."user_challenges" USING "btree" ("user_id");



CREATE INDEX "idx_user_follows_created_at" ON "public"."user_follows" USING "btree" ("created_at");



CREATE INDEX "idx_user_follows_follower" ON "public"."user_follows" USING "btree" ("follower_id");



CREATE INDEX "idx_user_follows_following" ON "public"."user_follows" USING "btree" ("following_id");



CREATE INDEX "idx_user_points_level" ON "public"."user_points" USING "btree" ("current_level" DESC);



CREATE INDEX "idx_user_points_monthly" ON "public"."user_points" USING "btree" ("monthly_points" DESC);



CREATE INDEX "idx_user_points_streak" ON "public"."user_points" USING "btree" ("current_streak" DESC);



CREATE INDEX "idx_user_points_total" ON "public"."user_points" USING "btree" ("total_points" DESC);



CREATE INDEX "idx_user_points_weekly" ON "public"."user_points" USING "btree" ("weekly_points" DESC);



CREATE OR REPLACE TRIGGER "check_share_limit_trigger" BEFORE INSERT ON "public"."shares" FOR EACH ROW EXECUTE FUNCTION "public"."check_share_limit"();



CREATE OR REPLACE TRIGGER "on_follow_change" AFTER INSERT OR DELETE ON "public"."user_follows" FOR EACH ROW EXECUTE FUNCTION "public"."update_follow_counts"();



CREATE OR REPLACE TRIGGER "on_new_message" AFTER INSERT ON "public"."direct_messages" FOR EACH ROW EXECUTE FUNCTION "public"."update_conversation_on_message"();



CREATE OR REPLACE TRIGGER "on_post_comment_change" AFTER INSERT OR DELETE ON "public"."post_comments" FOR EACH ROW EXECUTE FUNCTION "public"."update_post_comment_count"();



CREATE OR REPLACE TRIGGER "on_reaction_change" AFTER INSERT OR DELETE ON "public"."reactions" FOR EACH ROW EXECUTE FUNCTION "public"."update_reaction_counts"();



CREATE OR REPLACE TRIGGER "on_story_view" AFTER INSERT ON "public"."story_views" FOR EACH ROW EXECUTE FUNCTION "public"."update_story_view_count"();



CREATE OR REPLACE TRIGGER "update_charts_updated_at" BEFORE UPDATE ON "public"."charts" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_comments_updated_at" BEFORE UPDATE ON "public"."comments" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_content_library_updated_at" BEFORE UPDATE ON "public"."content_library" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_conversations_updated_at" BEFORE UPDATE ON "public"."conversations" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_journal_entries_updated_at" BEFORE UPDATE ON "public"."journal_entries" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_live_sessions_updated_at" BEFORE UPDATE ON "public"."live_sessions" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_mentorship_profiles_updated_at" BEFORE UPDATE ON "public"."mentorship_profiles" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_mentorship_requests_updated_at" BEFORE UPDATE ON "public"."mentorship_requests" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_post_comments_updated_at" BEFORE UPDATE ON "public"."post_comments" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_posts_updated_at" BEFORE UPDATE ON "public"."posts" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_profiles_updated_at" BEFORE UPDATE ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



CREATE OR REPLACE TRIGGER "update_quiz_progress_updated_at" BEFORE UPDATE ON "public"."quiz_progress" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_quiz_questions_updated_at" BEFORE UPDATE ON "public"."quiz_questions" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_quizzes_updated_at" BEFORE UPDATE ON "public"."quizzes" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_user_points_updated_at" BEFORE UPDATE ON "public"."user_points" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at"();



ALTER TABLE ONLY "public"."blocked_users"
    ADD CONSTRAINT "blocked_users_blocked_id_fkey" FOREIGN KEY ("blocked_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."blocked_users"
    ADD CONSTRAINT "blocked_users_blocker_id_fkey" FOREIGN KEY ("blocker_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."charts"
    ADD CONSTRAINT "charts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comments"
    ADD CONSTRAINT "comments_chart_id_fkey" FOREIGN KEY ("chart_id") REFERENCES "public"."charts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comments"
    ADD CONSTRAINT "comments_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."comments"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comments"
    ADD CONSTRAINT "comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."content_library"
    ADD CONSTRAINT "content_library_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "public"."profiles"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."content_progress"
    ADD CONSTRAINT "content_progress_content_id_fkey" FOREIGN KEY ("content_id") REFERENCES "public"."content_library"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."content_progress"
    ADD CONSTRAINT "content_progress_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."content_reports"
    ADD CONSTRAINT "content_reports_reporter_id_fkey" FOREIGN KEY ("reporter_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."content_reports"
    ADD CONSTRAINT "content_reports_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."direct_messages"
    ADD CONSTRAINT "direct_messages_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "public"."conversations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."direct_messages"
    ADD CONSTRAINT "direct_messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."direct_messages"
    ADD CONSTRAINT "direct_messages_shared_chart_id_fkey" FOREIGN KEY ("shared_chart_id") REFERENCES "public"."charts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_friend_id_fkey" FOREIGN KEY ("friend_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_members"
    ADD CONSTRAINT "group_members_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_members"
    ADD CONSTRAINT "group_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."journal_entries"
    ADD CONSTRAINT "journal_entries_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."live_sessions"
    ADD CONSTRAINT "live_sessions_host_id_fkey" FOREIGN KEY ("host_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."mentorship_profiles"
    ADD CONSTRAINT "mentorship_profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."mentorship_requests"
    ADD CONSTRAINT "mentorship_requests_mentee_id_fkey" FOREIGN KEY ("mentee_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."mentorship_requests"
    ADD CONSTRAINT "mentorship_requests_mentor_id_fkey" FOREIGN KEY ("mentor_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pentas"
    ADD CONSTRAINT "pentas_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."point_transactions"
    ADD CONSTRAINT "point_transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."post_comments"
    ADD CONSTRAINT "post_comments_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."post_comments"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."post_comments"
    ADD CONSTRAINT "post_comments_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."post_comments"
    ADD CONSTRAINT "post_comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."post_hashtags"
    ADD CONSTRAINT "post_hashtags_hashtag_id_fkey" FOREIGN KEY ("hashtag_id") REFERENCES "public"."hashtags"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."post_hashtags"
    ADD CONSTRAINT "post_hashtags_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."posts"
    ADD CONSTRAINT "posts_chart_id_fkey" FOREIGN KEY ("chart_id") REFERENCES "public"."charts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."posts"
    ADD CONSTRAINT "posts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."quiz_attempts"
    ADD CONSTRAINT "quiz_attempts_quiz_id_fkey" FOREIGN KEY ("quiz_id") REFERENCES "public"."quizzes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."quiz_attempts"
    ADD CONSTRAINT "quiz_attempts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."quiz_best_scores"
    ADD CONSTRAINT "quiz_best_scores_best_attempt_id_fkey" FOREIGN KEY ("best_attempt_id") REFERENCES "public"."quiz_attempts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."quiz_best_scores"
    ADD CONSTRAINT "quiz_best_scores_quiz_id_fkey" FOREIGN KEY ("quiz_id") REFERENCES "public"."quizzes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."quiz_best_scores"
    ADD CONSTRAINT "quiz_best_scores_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."quiz_progress"
    ADD CONSTRAINT "quiz_progress_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."quiz_question_map"
    ADD CONSTRAINT "quiz_question_map_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."quiz_questions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."quiz_question_map"
    ADD CONSTRAINT "quiz_question_map_quiz_id_fkey" FOREIGN KEY ("quiz_id") REFERENCES "public"."quizzes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reactions"
    ADD CONSTRAINT "reactions_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "public"."post_comments"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reactions"
    ADD CONSTRAINT "reactions_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reactions"
    ADD CONSTRAINT "reactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."saved_affirmations"
    ADD CONSTRAINT "saved_affirmations_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."session_participants"
    ADD CONSTRAINT "session_participants_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "public"."live_sessions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."session_participants"
    ADD CONSTRAINT "session_participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."shares"
    ADD CONSTRAINT "shares_chart_id_fkey" FOREIGN KEY ("chart_id") REFERENCES "public"."charts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."shares"
    ADD CONSTRAINT "shares_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."shares"
    ADD CONSTRAINT "shares_shared_by_fkey" FOREIGN KEY ("shared_by") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."shares"
    ADD CONSTRAINT "shares_shared_with_fkey" FOREIGN KEY ("shared_with") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stories"
    ADD CONSTRAINT "stories_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."story_views"
    ADD CONSTRAINT "story_views_story_id_fkey" FOREIGN KEY ("story_id") REFERENCES "public"."stories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."story_views"
    ADD CONSTRAINT "story_views_viewer_id_fkey" FOREIGN KEY ("viewer_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_badges"
    ADD CONSTRAINT "user_badges_badge_id_fkey" FOREIGN KEY ("badge_id") REFERENCES "public"."badges"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_badges"
    ADD CONSTRAINT "user_badges_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_challenges"
    ADD CONSTRAINT "user_challenges_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "public"."challenges"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_challenges"
    ADD CONSTRAINT "user_challenges_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_follows"
    ADD CONSTRAINT "user_follows_follower_id_fkey" FOREIGN KEY ("follower_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_follows"
    ADD CONSTRAINT "user_follows_following_id_fkey" FOREIGN KEY ("following_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_points"
    ADD CONSTRAINT "user_points_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



CREATE POLICY "Admins can manage group members" ON "public"."group_members" USING ("public"."is_group_admin"("auth"."uid"(), "group_id"));



CREATE POLICY "Admins can manage groups" ON "public"."groups" USING ("public"."is_group_admin"("auth"."uid"(), "id"));



CREATE POLICY "Admins can update their groups" ON "public"."groups" FOR UPDATE USING (("id" IN ( SELECT "group_members"."group_id"
   FROM "public"."group_members"
  WHERE (("group_members"."user_id" = "auth"."uid"()) AND ("group_members"."role" = 'admin'::"text")))));



CREATE POLICY "Anyone can view badge definitions" ON "public"."badges" FOR SELECT USING ((NOT "is_hidden"));



CREATE POLICY "Anyone can view public profiles" ON "public"."profiles" FOR SELECT USING ((("is_public" = true) OR ("auth"."uid"() = "id")));



CREATE POLICY "Authenticated users can create hashtags" ON "public"."hashtags" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Authors can delete their content" ON "public"."content_library" FOR DELETE USING ((("auth"."uid"() = "author_id") AND ("is_official" = false)));



CREATE POLICY "Authors can update their content" ON "public"."content_library" FOR UPDATE USING (("auth"."uid"() = "author_id"));



CREATE POLICY "Authors can view their own content" ON "public"."content_library" FOR SELECT USING (("auth"."uid"() = "author_id"));



CREATE POLICY "Both parties can delete requests" ON "public"."mentorship_requests" FOR DELETE USING ((("auth"."uid"() = "mentor_id") OR ("auth"."uid"() = "mentee_id")));



CREATE POLICY "Both parties can update request status" ON "public"."mentorship_requests" FOR UPDATE USING ((("auth"."uid"() = "mentor_id") OR ("auth"."uid"() = "mentee_id")));



CREATE POLICY "Hashtags are viewable by everyone" ON "public"."hashtags" FOR SELECT USING (true);



CREATE POLICY "Hosts and participants can view participants" ON "public"."session_participants" FOR SELECT USING ((("auth"."uid"() = "user_id") OR (EXISTS ( SELECT 1
   FROM "public"."live_sessions"
  WHERE (("live_sessions"."id" = "session_participants"."session_id") AND ("live_sessions"."host_id" = "auth"."uid"()))))));



CREATE POLICY "Hosts can delete their sessions" ON "public"."live_sessions" FOR DELETE USING (("auth"."uid"() = "host_id"));



CREATE POLICY "Hosts can update their sessions" ON "public"."live_sessions" FOR UPDATE USING (("auth"."uid"() = "host_id"));



CREATE POLICY "Mentees can create requests" ON "public"."mentorship_requests" FOR INSERT WITH CHECK (("auth"."uid"() = "mentee_id"));



CREATE POLICY "Mentors and mentees can view their requests" ON "public"."mentorship_requests" FOR SELECT USING ((("auth"."uid"() = "mentor_id") OR ("auth"."uid"() = "mentee_id")));



CREATE POLICY "Participants can update conversation" ON "public"."conversations" FOR UPDATE USING (("auth"."uid"() = ANY ("participant_ids")));



CREATE POLICY "Post hashtags are viewable by everyone" ON "public"."post_hashtags" FOR SELECT USING (true);



CREATE POLICY "Post owners can add hashtags" ON "public"."post_hashtags" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."posts"
  WHERE (("posts"."id" = "post_hashtags"."post_id") AND ("posts"."user_id" = "auth"."uid"())))));



CREATE POLICY "Post owners can remove hashtags" ON "public"."post_hashtags" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."posts"
  WHERE (("posts"."id" = "post_hashtags"."post_id") AND ("posts"."user_id" = "auth"."uid"())))));



CREATE POLICY "Premium content requires premium" ON "public"."live_sessions" FOR SELECT USING ((("is_premium" = false) OR (EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."id" = "auth"."uid"()) AND ("profiles"."is_premium" = true)))) OR ("auth"."uid"() = "host_id")));



CREATE POLICY "Quiz question map is viewable by all authenticated users" ON "public"."quiz_question_map" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Quiz questions are viewable by all authenticated users" ON "public"."quiz_questions" FOR SELECT TO "authenticated" USING (("is_active" = true));



CREATE POLICY "Quizzes are viewable by all authenticated users" ON "public"."quizzes" FOR SELECT TO "authenticated" USING (("is_active" = true));



CREATE POLICY "Story owners can see who viewed" ON "public"."story_views" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."stories"
  WHERE (("stories"."id" = "story_views"."story_id") AND ("stories"."user_id" = "auth"."uid"())))));



CREATE POLICY "System can manage points" ON "public"."user_points" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users and hosts can remove registration" ON "public"."session_participants" FOR DELETE USING ((("auth"."uid"() = "user_id") OR (EXISTS ( SELECT 1
   FROM "public"."live_sessions"
  WHERE (("live_sessions"."id" = "session_participants"."session_id") AND ("live_sessions"."host_id" = "auth"."uid"()))))));



CREATE POLICY "Users can add reactions" ON "public"."reactions" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can block others" ON "public"."blocked_users" FOR INSERT WITH CHECK (("auth"."uid"() = "blocker_id"));



CREATE POLICY "Users can create comments on accessible charts" ON "public"."comments" FOR INSERT WITH CHECK ((("auth"."uid"() = "user_id") AND (("chart_id" IN ( SELECT "charts"."id"
   FROM "public"."charts"
  WHERE (("charts"."user_id" = "auth"."uid"()) OR ("charts"."visibility" = 'public'::"text")))) OR ("chart_id" IN ( SELECT "shares"."chart_id"
   FROM "public"."shares"
  WHERE ("shares"."shared_with" = "auth"."uid"()))))));



CREATE POLICY "Users can create comments on accessible posts" ON "public"."post_comments" FOR INSERT WITH CHECK ((("auth"."uid"() = "user_id") AND (EXISTS ( SELECT 1
   FROM "public"."posts" "p"
  WHERE (("p"."id" = "post_comments"."post_id") AND (("p"."visibility" = 'public'::"text") OR ("p"."user_id" = "auth"."uid"()) OR (("p"."visibility" = 'followers'::"text") AND "public"."is_following"("auth"."uid"(), "p"."user_id"))))))));



CREATE POLICY "Users can create community content" ON "public"."content_library" FOR INSERT WITH CHECK ((("auth"."uid"() = "author_id") AND ("is_official" = false)));



CREATE POLICY "Users can create conversations" ON "public"."conversations" FOR INSERT WITH CHECK (("auth"."uid"() = ANY ("participant_ids")));



CREATE POLICY "Users can create friend requests" ON "public"."friendships" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can create groups" ON "public"."groups" FOR INSERT WITH CHECK (("auth"."uid"() = "created_by"));



CREATE POLICY "Users can create posts" ON "public"."posts" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can create reports" ON "public"."content_reports" FOR INSERT WITH CHECK (("auth"."uid"() = "reporter_id"));



CREATE POLICY "Users can create sessions" ON "public"."live_sessions" FOR INSERT WITH CHECK (("auth"."uid"() = "host_id"));



CREATE POLICY "Users can create shares for their charts" ON "public"."shares" FOR INSERT WITH CHECK ((("auth"."uid"() = "shared_by") AND ("chart_id" IN ( SELECT "charts"."id"
   FROM "public"."charts"
  WHERE ("charts"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can create stories" ON "public"."stories" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete own charts" ON "public"."charts" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete their friendships" ON "public"."friendships" FOR DELETE USING ((("auth"."uid"() = "user_id") OR ("auth"."uid"() = "friend_id")));



CREATE POLICY "Users can delete their notifications" ON "public"."notifications" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete their own comments" ON "public"."comments" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete their own comments" ON "public"."post_comments" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete their own posts" ON "public"."posts" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete their own stories" ON "public"."stories" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete their shares" ON "public"."shares" FOR DELETE USING (("auth"."uid"() = "shared_by"));



CREATE POLICY "Users can follow others" ON "public"."user_follows" FOR INSERT WITH CHECK ((("auth"."uid"() = "follower_id") AND (NOT "public"."is_blocked"("following_id", "auth"."uid"()))));



CREATE POLICY "Users can insert own charts" ON "public"."charts" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can insert their own quiz attempts" ON "public"."quiz_attempts" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can insert their own quiz best scores" ON "public"."quiz_best_scores" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can insert their own quiz progress" ON "public"."quiz_progress" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage their content progress" ON "public"."content_progress" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage their journal entries" ON "public"."journal_entries" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage their mentorship profile" ON "public"."mentorship_profiles" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage their own charts" ON "public"."charts" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage their pentas" ON "public"."pentas" USING (("auth"."uid"() = "created_by"));



CREATE POLICY "Users can manage their saved affirmations" ON "public"."saved_affirmations" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can mark their notifications as read" ON "public"."notifications" FOR UPDATE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can record story views" ON "public"."story_views" FOR INSERT WITH CHECK (("auth"."uid"() = "viewer_id"));



CREATE POLICY "Users can register for sessions" ON "public"."session_participants" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can remove their reactions" ON "public"."reactions" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can send messages in their conversations" ON "public"."direct_messages" FOR INSERT WITH CHECK ((("auth"."uid"() = "sender_id") AND "public"."is_conversation_participant"("conversation_id", "auth"."uid"())));



CREATE POLICY "Users can unblock others" ON "public"."blocked_users" FOR DELETE USING (("auth"."uid"() = "blocker_id"));



CREATE POLICY "Users can unfollow" ON "public"."user_follows" FOR DELETE USING (("auth"."uid"() = "follower_id"));



CREATE POLICY "Users can update friendships they're part of" ON "public"."friendships" FOR UPDATE USING (("auth"."uid"() = "friend_id"));



CREATE POLICY "Users can update own charts" ON "public"."charts" FOR UPDATE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their challenge progress" ON "public"."user_challenges" FOR UPDATE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their featured badges" ON "public"."user_badges" FOR UPDATE USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their own comments" ON "public"."comments" FOR UPDATE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their own comments" ON "public"."post_comments" FOR UPDATE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their own messages (read status)" ON "public"."direct_messages" FOR UPDATE USING ("public"."is_conversation_participant"("conversation_id", "auth"."uid"()));



CREATE POLICY "Users can update their own posts" ON "public"."posts" FOR UPDATE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their own profile" ON "public"."profiles" FOR UPDATE USING (("auth"."uid"() = "id"));



CREATE POLICY "Users can update their own quiz attempts" ON "public"."quiz_attempts" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their own quiz best scores" ON "public"."quiz_best_scores" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their own quiz progress" ON "public"."quiz_progress" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can update their registration" ON "public"."session_participants" FOR UPDATE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view active challenges" ON "public"."challenges" FOR SELECT USING (("is_active" = true));



CREATE POLICY "Users can view comments on accessible charts" ON "public"."comments" FOR SELECT USING ((("chart_id" IN ( SELECT "charts"."id"
   FROM "public"."charts"
  WHERE (("charts"."user_id" = "auth"."uid"()) OR ("charts"."visibility" = 'public'::"text")))) OR ("chart_id" IN ( SELECT "shares"."chart_id"
   FROM "public"."shares"
  WHERE ("shares"."shared_with" = "auth"."uid"())))));



CREATE POLICY "Users can view comments on accessible posts" ON "public"."post_comments" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."posts" "p"
  WHERE (("p"."id" = "post_comments"."post_id") AND (("p"."visibility" = 'public'::"text") OR ("p"."user_id" = "auth"."uid"()) OR (("p"."visibility" = 'followers'::"text") AND "public"."is_following"("auth"."uid"(), "p"."user_id")))))));



CREATE POLICY "Users can view earned badges" ON "public"."user_badges" FOR SELECT USING (true);



CREATE POLICY "Users can view follow relationships" ON "public"."user_follows" FOR SELECT USING ((("auth"."uid"() = "follower_id") OR ("auth"."uid"() = "following_id") OR (EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."id" = "user_follows"."following_id") AND ("profiles"."is_public" = true))))));



CREATE POLICY "Users can view followers-only posts from followed users" ON "public"."posts" FOR SELECT USING ((("visibility" = 'followers'::"text") AND "public"."is_following"("auth"."uid"(), "user_id") AND (NOT "public"."is_blocked"("user_id", "auth"."uid"()))));



CREATE POLICY "Users can view friends' profiles" ON "public"."profiles" FOR SELECT USING (("id" IN ( SELECT "friendships"."friend_id"
   FROM "public"."friendships"
  WHERE (("friendships"."user_id" = "auth"."uid"()) AND ("friendships"."status" = 'accepted'::"text")))));



CREATE POLICY "Users can view groups they're members of" ON "public"."groups" FOR SELECT USING (("id" IN ( SELECT "group_members"."group_id"
   FROM "public"."group_members"
  WHERE ("group_members"."user_id" = "auth"."uid"()))));



CREATE POLICY "Users can view leaderboard (limited data)" ON "public"."user_points" FOR SELECT USING (true);



CREATE POLICY "Users can view members of their groups" ON "public"."group_members" FOR SELECT USING ((("user_id" = "auth"."uid"()) OR ("group_id" IN ( SELECT "public"."get_user_group_ids"("auth"."uid"()) AS "get_user_group_ids"))));



CREATE POLICY "Users can view mentor profiles" ON "public"."mentorship_profiles" FOR SELECT USING ((("is_mentor" = true) OR ("auth"."uid"() = "user_id")));



CREATE POLICY "Users can view messages in their conversations" ON "public"."direct_messages" FOR SELECT USING ("public"."is_conversation_participant"("conversation_id", "auth"."uid"()));



CREATE POLICY "Users can view own charts" ON "public"."charts" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view public non-expired stories" ON "public"."stories" FOR SELECT USING ((("expires_at" > "now"()) AND (("visibility" = 'public'::"text") OR ("auth"."uid"() = "user_id") OR (("visibility" = 'followers'::"text") AND "public"."is_following"("auth"."uid"(), "user_id"))) AND (NOT "public"."is_blocked"("user_id", "auth"."uid"()))));



CREATE POLICY "Users can view public posts" ON "public"."posts" FOR SELECT USING ((("visibility" = 'public'::"text") AND (NOT "public"."is_blocked"("user_id", "auth"."uid"()))));



CREATE POLICY "Users can view published non-premium content" ON "public"."content_library" FOR SELECT USING ((("is_published" = true) AND (("is_premium" = false) OR (EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."id" = "auth"."uid"()) AND ("profiles"."is_premium" = true)))))));



CREATE POLICY "Users can view reactions" ON "public"."reactions" FOR SELECT USING (true);



CREATE POLICY "Users can view scheduled and live sessions" ON "public"."live_sessions" FOR SELECT USING ((("status" = ANY (ARRAY['scheduled'::"text", 'live'::"text"])) OR ("auth"."uid"() = "host_id") OR (EXISTS ( SELECT 1
   FROM "public"."session_participants"
  WHERE (("session_participants"."session_id" = "session_participants"."id") AND ("session_participants"."user_id" = "auth"."uid"()))))));



CREATE POLICY "Users can view shared charts" ON "public"."charts" FOR SELECT USING ((("visibility" = 'public'::"text") OR (("visibility" = 'friends'::"text") AND ("user_id" IN ( SELECT "friendships"."friend_id"
   FROM "public"."friendships"
  WHERE (("friendships"."user_id" = "auth"."uid"()) AND ("friendships"."status" = 'accepted'::"text"))))) OR ("id" IN ( SELECT "shares"."chart_id"
   FROM "public"."shares"
  WHERE ("shares"."shared_with" = "auth"."uid"())))));



CREATE POLICY "Users can view shares involving them" ON "public"."shares" FOR SELECT USING ((("auth"."uid"() = "shared_by") OR ("auth"."uid"() = "shared_with") OR ("group_id" IN ( SELECT "public"."get_user_group_ids"("auth"."uid"()) AS "get_user_group_ids"))));



CREATE POLICY "Users can view their block list" ON "public"."blocked_users" FOR SELECT USING (("auth"."uid"() = "blocker_id"));



CREATE POLICY "Users can view their challenges" ON "public"."user_challenges" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their conversations" ON "public"."conversations" FOR SELECT USING (("auth"."uid"() = ANY ("participant_ids")));



CREATE POLICY "Users can view their friendships" ON "public"."friendships" FOR SELECT USING ((("auth"."uid"() = "user_id") OR ("auth"."uid"() = "friend_id")));



CREATE POLICY "Users can view their groups" ON "public"."groups" FOR SELECT USING (("id" IN ( SELECT "public"."get_user_group_ids"("auth"."uid"()) AS "get_user_group_ids")));



CREATE POLICY "Users can view their notifications" ON "public"."notifications" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own points" ON "public"."user_points" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own posts" ON "public"."posts" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own profile" ON "public"."profiles" FOR SELECT USING (("auth"."uid"() = "id"));



CREATE POLICY "Users can view their own quiz attempts" ON "public"."quiz_attempts" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own quiz best scores" ON "public"."quiz_best_scores" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own quiz progress" ON "public"."quiz_progress" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own reports" ON "public"."content_reports" FOR SELECT USING (("auth"."uid"() = "reporter_id"));



CREATE POLICY "Users can view their own transactions" ON "public"."point_transactions" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own view history" ON "public"."story_views" FOR SELECT USING (("auth"."uid"() = "viewer_id"));



ALTER TABLE "public"."badges" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."blocked_users" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."challenges" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."charts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."comments" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."content_library" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."content_progress" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."content_reports" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."conversations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."direct_messages" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."friendships" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group_members" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."groups" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."hashtags" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."journal_entries" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."live_sessions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."mentorship_profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."mentorship_requests" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."notifications" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pentas" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."point_transactions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."post_comments" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."post_hashtags" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."posts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."quiz_attempts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."quiz_best_scores" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."quiz_progress" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."quiz_question_map" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."quiz_questions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."quizzes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."reactions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."saved_affirmations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."session_participants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."shares" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."story_views" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_badges" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_challenges" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_follows" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_points" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."direct_messages";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."notifications";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."posts";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."reactions";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."stories";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

























































































































































GRANT ALL ON FUNCTION "public"."award_points"("p_user_id" "uuid", "p_points" integer, "p_action_type" "text", "p_description" "text", "p_reference_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."award_points"("p_user_id" "uuid", "p_points" integer, "p_action_type" "text", "p_description" "text", "p_reference_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."award_points"("p_user_id" "uuid", "p_points" integer, "p_action_type" "text", "p_description" "text", "p_reference_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."can_message_user"("sender" "uuid", "recipient" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."can_message_user"("sender" "uuid", "recipient" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."can_message_user"("sender" "uuid", "recipient" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."check_share_limit"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_share_limit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_share_limit"() TO "service_role";



GRANT ALL ON FUNCTION "public"."complete_quiz_attempt"("p_attempt_id" "uuid", "p_answers" "jsonb", "p_score" integer, "p_correct_count" integer, "p_total_questions" integer, "p_points_awarded" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."complete_quiz_attempt"("p_attempt_id" "uuid", "p_answers" "jsonb", "p_score" integer, "p_correct_count" integer, "p_total_questions" integer, "p_points_awarded" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."complete_quiz_attempt"("p_attempt_id" "uuid", "p_answers" "jsonb", "p_score" integer, "p_correct_count" integer, "p_total_questions" integer, "p_points_awarded" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."decrement"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."decrement"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."decrement"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."decrement_hashtag_count"("hashtag_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."decrement_hashtag_count"("hashtag_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."decrement_hashtag_count"("hashtag_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_hashtag_usage_history"("target_hashtag_id" "uuid", "days_back" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_hashtag_usage_history"("target_hashtag_id" "uuid", "days_back" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_hashtag_usage_history"("target_hashtag_id" "uuid", "days_back" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_quiz_with_questions"("p_quiz_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_quiz_with_questions"("p_quiz_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_quiz_with_questions"("p_quiz_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_trending_hashtags"("limit_count" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_trending_hashtags"("limit_count" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_trending_hashtags"("limit_count" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_group_ids"("user_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_group_ids"("user_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_group_ids"("user_uuid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."increment"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."increment"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."increment"("table_name" "text", "row_id" "uuid", "column_name" "text", "amount" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."increment_hashtag_count"("hashtag_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."increment_hashtag_count"("hashtag_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."increment_hashtag_count"("hashtag_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_blocked"("blocker" "uuid", "blocked" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_blocked"("blocker" "uuid", "blocked" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_blocked"("blocker" "uuid", "blocked" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_conversation_participant"("conv_id" "uuid", "user_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_conversation_participant"("conv_id" "uuid", "user_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_conversation_participant"("conv_id" "uuid", "user_uuid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_following"("follower" "uuid", "following" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_following"("follower" "uuid", "following" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_following"("follower" "uuid", "following" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_group_admin"("user_uuid" "uuid", "check_group_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_group_admin"("user_uuid" "uuid", "check_group_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_group_admin"("user_uuid" "uuid", "check_group_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_conversation_on_message"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_conversation_on_message"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_conversation_on_message"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_follow_counts"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_follow_counts"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_follow_counts"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_post_comment_count"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_post_comment_count"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_post_comment_count"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_reaction_counts"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_reaction_counts"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_reaction_counts"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_story_view_count"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_story_view_count"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_story_view_count"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";


















GRANT ALL ON TABLE "public"."badges" TO "anon";
GRANT ALL ON TABLE "public"."badges" TO "authenticated";
GRANT ALL ON TABLE "public"."badges" TO "service_role";



GRANT ALL ON TABLE "public"."blocked_users" TO "anon";
GRANT ALL ON TABLE "public"."blocked_users" TO "authenticated";
GRANT ALL ON TABLE "public"."blocked_users" TO "service_role";



GRANT ALL ON TABLE "public"."challenges" TO "anon";
GRANT ALL ON TABLE "public"."challenges" TO "authenticated";
GRANT ALL ON TABLE "public"."challenges" TO "service_role";



GRANT ALL ON TABLE "public"."charts" TO "anon";
GRANT ALL ON TABLE "public"."charts" TO "authenticated";
GRANT ALL ON TABLE "public"."charts" TO "service_role";



GRANT ALL ON TABLE "public"."comments" TO "anon";
GRANT ALL ON TABLE "public"."comments" TO "authenticated";
GRANT ALL ON TABLE "public"."comments" TO "service_role";



GRANT ALL ON TABLE "public"."content_library" TO "anon";
GRANT ALL ON TABLE "public"."content_library" TO "authenticated";
GRANT ALL ON TABLE "public"."content_library" TO "service_role";



GRANT ALL ON TABLE "public"."content_progress" TO "anon";
GRANT ALL ON TABLE "public"."content_progress" TO "authenticated";
GRANT ALL ON TABLE "public"."content_progress" TO "service_role";



GRANT ALL ON TABLE "public"."content_reports" TO "anon";
GRANT ALL ON TABLE "public"."content_reports" TO "authenticated";
GRANT ALL ON TABLE "public"."content_reports" TO "service_role";



GRANT ALL ON TABLE "public"."conversations" TO "anon";
GRANT ALL ON TABLE "public"."conversations" TO "authenticated";
GRANT ALL ON TABLE "public"."conversations" TO "service_role";



GRANT ALL ON TABLE "public"."direct_messages" TO "anon";
GRANT ALL ON TABLE "public"."direct_messages" TO "authenticated";
GRANT ALL ON TABLE "public"."direct_messages" TO "service_role";



GRANT ALL ON TABLE "public"."friendships" TO "anon";
GRANT ALL ON TABLE "public"."friendships" TO "authenticated";
GRANT ALL ON TABLE "public"."friendships" TO "service_role";



GRANT ALL ON TABLE "public"."group_members" TO "anon";
GRANT ALL ON TABLE "public"."group_members" TO "authenticated";
GRANT ALL ON TABLE "public"."group_members" TO "service_role";



GRANT ALL ON TABLE "public"."groups" TO "anon";
GRANT ALL ON TABLE "public"."groups" TO "authenticated";
GRANT ALL ON TABLE "public"."groups" TO "service_role";



GRANT ALL ON TABLE "public"."hashtags" TO "anon";
GRANT ALL ON TABLE "public"."hashtags" TO "authenticated";
GRANT ALL ON TABLE "public"."hashtags" TO "service_role";



GRANT ALL ON TABLE "public"."journal_entries" TO "anon";
GRANT ALL ON TABLE "public"."journal_entries" TO "authenticated";
GRANT ALL ON TABLE "public"."journal_entries" TO "service_role";



GRANT ALL ON TABLE "public"."live_sessions" TO "anon";
GRANT ALL ON TABLE "public"."live_sessions" TO "authenticated";
GRANT ALL ON TABLE "public"."live_sessions" TO "service_role";



GRANT ALL ON TABLE "public"."mentorship_profiles" TO "anon";
GRANT ALL ON TABLE "public"."mentorship_profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."mentorship_profiles" TO "service_role";



GRANT ALL ON TABLE "public"."mentorship_requests" TO "anon";
GRANT ALL ON TABLE "public"."mentorship_requests" TO "authenticated";
GRANT ALL ON TABLE "public"."mentorship_requests" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON TABLE "public"."pentas" TO "anon";
GRANT ALL ON TABLE "public"."pentas" TO "authenticated";
GRANT ALL ON TABLE "public"."pentas" TO "service_role";



GRANT ALL ON TABLE "public"."point_transactions" TO "anon";
GRANT ALL ON TABLE "public"."point_transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."point_transactions" TO "service_role";



GRANT ALL ON TABLE "public"."post_comments" TO "anon";
GRANT ALL ON TABLE "public"."post_comments" TO "authenticated";
GRANT ALL ON TABLE "public"."post_comments" TO "service_role";



GRANT ALL ON TABLE "public"."post_hashtags" TO "anon";
GRANT ALL ON TABLE "public"."post_hashtags" TO "authenticated";
GRANT ALL ON TABLE "public"."post_hashtags" TO "service_role";



GRANT ALL ON TABLE "public"."posts" TO "anon";
GRANT ALL ON TABLE "public"."posts" TO "authenticated";
GRANT ALL ON TABLE "public"."posts" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."quiz_attempts" TO "anon";
GRANT ALL ON TABLE "public"."quiz_attempts" TO "authenticated";
GRANT ALL ON TABLE "public"."quiz_attempts" TO "service_role";



GRANT ALL ON TABLE "public"."quiz_best_scores" TO "anon";
GRANT ALL ON TABLE "public"."quiz_best_scores" TO "authenticated";
GRANT ALL ON TABLE "public"."quiz_best_scores" TO "service_role";



GRANT ALL ON TABLE "public"."quiz_progress" TO "anon";
GRANT ALL ON TABLE "public"."quiz_progress" TO "authenticated";
GRANT ALL ON TABLE "public"."quiz_progress" TO "service_role";



GRANT ALL ON TABLE "public"."quiz_question_map" TO "anon";
GRANT ALL ON TABLE "public"."quiz_question_map" TO "authenticated";
GRANT ALL ON TABLE "public"."quiz_question_map" TO "service_role";



GRANT ALL ON TABLE "public"."quiz_questions" TO "anon";
GRANT ALL ON TABLE "public"."quiz_questions" TO "authenticated";
GRANT ALL ON TABLE "public"."quiz_questions" TO "service_role";



GRANT ALL ON TABLE "public"."quizzes" TO "anon";
GRANT ALL ON TABLE "public"."quizzes" TO "authenticated";
GRANT ALL ON TABLE "public"."quizzes" TO "service_role";



GRANT ALL ON TABLE "public"."reactions" TO "anon";
GRANT ALL ON TABLE "public"."reactions" TO "authenticated";
GRANT ALL ON TABLE "public"."reactions" TO "service_role";



GRANT ALL ON TABLE "public"."saved_affirmations" TO "anon";
GRANT ALL ON TABLE "public"."saved_affirmations" TO "authenticated";
GRANT ALL ON TABLE "public"."saved_affirmations" TO "service_role";



GRANT ALL ON TABLE "public"."session_participants" TO "anon";
GRANT ALL ON TABLE "public"."session_participants" TO "authenticated";
GRANT ALL ON TABLE "public"."session_participants" TO "service_role";



GRANT ALL ON TABLE "public"."shares" TO "anon";
GRANT ALL ON TABLE "public"."shares" TO "authenticated";
GRANT ALL ON TABLE "public"."shares" TO "service_role";



GRANT ALL ON TABLE "public"."stories" TO "anon";
GRANT ALL ON TABLE "public"."stories" TO "authenticated";
GRANT ALL ON TABLE "public"."stories" TO "service_role";



GRANT ALL ON TABLE "public"."story_views" TO "anon";
GRANT ALL ON TABLE "public"."story_views" TO "authenticated";
GRANT ALL ON TABLE "public"."story_views" TO "service_role";



GRANT ALL ON TABLE "public"."user_badges" TO "anon";
GRANT ALL ON TABLE "public"."user_badges" TO "authenticated";
GRANT ALL ON TABLE "public"."user_badges" TO "service_role";



GRANT ALL ON TABLE "public"."user_challenges" TO "anon";
GRANT ALL ON TABLE "public"."user_challenges" TO "authenticated";
GRANT ALL ON TABLE "public"."user_challenges" TO "service_role";



GRANT ALL ON TABLE "public"."user_follows" TO "anon";
GRANT ALL ON TABLE "public"."user_follows" TO "authenticated";
GRANT ALL ON TABLE "public"."user_follows" TO "service_role";



GRANT ALL ON TABLE "public"."user_points" TO "anon";
GRANT ALL ON TABLE "public"."user_points" TO "authenticated";
GRANT ALL ON TABLE "public"."user_points" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































