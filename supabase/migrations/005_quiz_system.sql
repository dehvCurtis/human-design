-- Quiz System Migration
-- Creates tables for quizzes, questions, progress tracking, and attempts

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- Quiz Questions Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS quiz_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  question_type TEXT NOT NULL CHECK (question_type IN ('multiple_choice', 'true_false')),
  category TEXT NOT NULL CHECK (category IN ('types', 'centers', 'authorities', 'profiles', 'gates', 'channels', 'definitions', 'general')),
  difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  question_text TEXT NOT NULL,
  options JSONB NOT NULL,
  correct_answer TEXT NOT NULL,
  explanation TEXT NOT NULL,
  points INT DEFAULT 10,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for efficient querying
CREATE INDEX idx_quiz_questions_category ON quiz_questions(category);
CREATE INDEX idx_quiz_questions_difficulty ON quiz_questions(difficulty);
CREATE INDEX idx_quiz_questions_active ON quiz_questions(is_active) WHERE is_active = TRUE;

-- ============================================================================
-- Quizzes Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS quizzes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL CHECK (category IN ('types', 'centers', 'authorities', 'profiles', 'gates', 'channels', 'definitions', 'general')),
  difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  points_reward INT DEFAULT 25,
  time_limit INT, -- seconds, NULL means no time limit
  is_premium BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for efficient querying
CREATE INDEX idx_quizzes_category ON quizzes(category);
CREATE INDEX idx_quizzes_difficulty ON quizzes(difficulty);
CREATE INDEX idx_quizzes_active ON quizzes(is_active) WHERE is_active = TRUE;

-- ============================================================================
-- Quiz to Questions Mapping Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS quiz_question_map (
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE,
  question_id UUID REFERENCES quiz_questions(id) ON DELETE CASCADE,
  sort_order INT DEFAULT 0,
  PRIMARY KEY (quiz_id, question_id)
);

CREATE INDEX idx_quiz_question_map_quiz ON quiz_question_map(quiz_id);

-- ============================================================================
-- User Quiz Progress Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS quiz_progress (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  total_quizzes_completed INT DEFAULT 0,
  total_questions_answered INT DEFAULT 0,
  total_correct_answers INT DEFAULT 0,
  current_streak INT DEFAULT 0,
  best_streak INT DEFAULT 0,
  total_points_earned INT DEFAULT 0,
  category_progress JSONB DEFAULT '{}',
  last_quiz_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- Quiz Attempts Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS quiz_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  quiz_id UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  score INT DEFAULT 0, -- percentage 0-100
  correct_count INT DEFAULT 0,
  total_questions INT DEFAULT 0,
  answers JSONB DEFAULT '[]',
  points_awarded INT DEFAULT 0,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_quiz_attempts_user ON quiz_attempts(user_id);
CREATE INDEX idx_quiz_attempts_quiz ON quiz_attempts(quiz_id);
CREATE INDEX idx_quiz_attempts_completed ON quiz_attempts(completed_at);
CREATE INDEX idx_quiz_attempts_user_quiz ON quiz_attempts(user_id, quiz_id);

-- ============================================================================
-- User Quiz Best Scores (for leaderboards and tracking)
-- ============================================================================
CREATE TABLE IF NOT EXISTS quiz_best_scores (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE,
  best_score INT DEFAULT 0,
  best_attempt_id UUID REFERENCES quiz_attempts(id) ON DELETE SET NULL,
  attempts_count INT DEFAULT 0,
  first_completed_at TIMESTAMPTZ,
  last_completed_at TIMESTAMPTZ,
  PRIMARY KEY (user_id, quiz_id)
);

CREATE INDEX idx_quiz_best_scores_quiz ON quiz_best_scores(quiz_id);
CREATE INDEX idx_quiz_best_scores_score ON quiz_best_scores(best_score DESC);

-- ============================================================================
-- Functions
-- ============================================================================

-- Function to get quiz with question IDs
CREATE OR REPLACE FUNCTION get_quiz_with_questions(p_quiz_id UUID)
RETURNS TABLE (
  quiz JSONB,
  question_ids UUID[]
) AS $$
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
$$ LANGUAGE plpgsql;

-- Function to complete a quiz attempt and update progress
CREATE OR REPLACE FUNCTION complete_quiz_attempt(
  p_attempt_id UUID,
  p_answers JSONB,
  p_score INT,
  p_correct_count INT,
  p_total_questions INT,
  p_points_awarded INT
)
RETURNS JSONB AS $$
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
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Row Level Security (RLS)
-- ============================================================================

-- Quiz questions - public read for active questions
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Quiz questions are viewable by all authenticated users"
  ON quiz_questions FOR SELECT
  TO authenticated
  USING (is_active = TRUE);

-- Quizzes - public read for active quizzes
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Quizzes are viewable by all authenticated users"
  ON quizzes FOR SELECT
  TO authenticated
  USING (is_active = TRUE);

-- Quiz question map - public read
ALTER TABLE quiz_question_map ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Quiz question map is viewable by all authenticated users"
  ON quiz_question_map FOR SELECT
  TO authenticated
  USING (TRUE);

-- Quiz progress - users can only see their own progress
ALTER TABLE quiz_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own quiz progress"
  ON quiz_progress FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own quiz progress"
  ON quiz_progress FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own quiz progress"
  ON quiz_progress FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Quiz attempts - users can see their own attempts
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own quiz attempts"
  ON quiz_attempts FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own quiz attempts"
  ON quiz_attempts FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own quiz attempts"
  ON quiz_attempts FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Quiz best scores - users can see their own scores
ALTER TABLE quiz_best_scores ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own quiz best scores"
  ON quiz_best_scores FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own quiz best scores"
  ON quiz_best_scores FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own quiz best scores"
  ON quiz_best_scores FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================================================
-- Triggers
-- ============================================================================

-- Update timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_quiz_questions_updated_at
  BEFORE UPDATE ON quiz_questions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quizzes_updated_at
  BEFORE UPDATE ON quizzes
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quiz_progress_updated_at
  BEFORE UPDATE ON quiz_progress
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
