-- Learning Paths Migration
-- Tables for curated learning journeys with progress tracking

-- ============================================================================
-- Learning Paths Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS learning_paths (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon_emoji TEXT,
  cover_image_url TEXT,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  estimated_minutes INTEGER NOT NULL DEFAULT 0,
  step_count INTEGER NOT NULL DEFAULT 0,
  enrollment_count INTEGER NOT NULL DEFAULT 0,
  completion_count INTEGER NOT NULL DEFAULT 0,
  author_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  is_published BOOLEAN NOT NULL DEFAULT false,
  is_featured BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for learning_paths
CREATE INDEX IF NOT EXISTS idx_learning_paths_published ON learning_paths(is_published);
CREATE INDEX IF NOT EXISTS idx_learning_paths_featured ON learning_paths(is_featured);
CREATE INDEX IF NOT EXISTS idx_learning_paths_difficulty ON learning_paths(difficulty);
CREATE INDEX IF NOT EXISTS idx_learning_paths_author ON learning_paths(author_id);

-- ============================================================================
-- Learning Path Steps Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS learning_path_steps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  path_id UUID NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  step_type TEXT NOT NULL CHECK (step_type IN ('article', 'video', 'quiz', 'challenge', 'exercise', 'reflection')),
  content_id TEXT NOT NULL,
  content_title TEXT,
  estimated_minutes INTEGER,
  is_required BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE(path_id, order_index)
);

-- Indexes for learning_path_steps
CREATE INDEX IF NOT EXISTS idx_learning_path_steps_path ON learning_path_steps(path_id);
CREATE INDEX IF NOT EXISTS idx_learning_path_steps_order ON learning_path_steps(path_id, order_index);

-- ============================================================================
-- Learning Path Progress Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS learning_path_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  path_id UUID NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
  steps_completed INTEGER NOT NULL DEFAULT 0,
  total_steps INTEGER NOT NULL DEFAULT 0,
  is_completed BOOLEAN NOT NULL DEFAULT false,
  completed_at TIMESTAMPTZ,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_activity_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  current_step_id UUID REFERENCES learning_path_steps(id) ON DELETE SET NULL,
  completed_step_ids UUID[] NOT NULL DEFAULT '{}',

  UNIQUE(user_id, path_id)
);

-- Indexes for learning_path_progress
CREATE INDEX IF NOT EXISTS idx_learning_path_progress_user ON learning_path_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_learning_path_progress_path ON learning_path_progress(path_id);
CREATE INDEX IF NOT EXISTS idx_learning_path_progress_completed ON learning_path_progress(is_completed);

-- ============================================================================
-- Step Completions Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS step_completions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  progress_id UUID NOT NULL REFERENCES learning_path_progress(id) ON DELETE CASCADE,
  step_id UUID NOT NULL REFERENCES learning_path_steps(id) ON DELETE CASCADE,
  completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  notes TEXT,
  score INTEGER,

  UNIQUE(progress_id, step_id)
);

-- Indexes for step_completions
CREATE INDEX IF NOT EXISTS idx_step_completions_progress ON step_completions(progress_id);
CREATE INDEX IF NOT EXISTS idx_step_completions_step ON step_completions(step_id);

-- ============================================================================
-- RPC Functions
-- ============================================================================

-- Function to increment path enrollment count
CREATE OR REPLACE FUNCTION increment_path_enrollment_count(target_path_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE learning_paths
  SET enrollment_count = enrollment_count + 1,
      updated_at = NOW()
  WHERE id = target_path_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to increment path completion count
CREATE OR REPLACE FUNCTION increment_path_completion_count(target_path_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE learning_paths
  SET completion_count = completion_count + 1,
      updated_at = NOW()
  WHERE id = target_path_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update step count when steps change
CREATE OR REPLACE FUNCTION update_path_step_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE learning_paths
    SET step_count = (
      SELECT COUNT(*) FROM learning_path_steps WHERE path_id = NEW.path_id
    ),
    updated_at = NOW()
    WHERE id = NEW.path_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE learning_paths
    SET step_count = (
      SELECT COUNT(*) FROM learning_path_steps WHERE path_id = OLD.path_id
    ),
    updated_at = NOW()
    WHERE id = OLD.path_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to keep step count in sync
DROP TRIGGER IF EXISTS trigger_update_path_step_count ON learning_path_steps;
CREATE TRIGGER trigger_update_path_step_count
  AFTER INSERT OR DELETE ON learning_path_steps
  FOR EACH ROW EXECUTE FUNCTION update_path_step_count();

-- ============================================================================
-- Row Level Security
-- ============================================================================

-- Enable RLS
ALTER TABLE learning_paths ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_path_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_path_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE step_completions ENABLE ROW LEVEL SECURITY;

-- Learning Paths policies
CREATE POLICY "Published paths are viewable by everyone"
  ON learning_paths FOR SELECT
  USING (is_published = true);

CREATE POLICY "Authors can manage their paths"
  ON learning_paths FOR ALL
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());

-- Learning Path Steps policies
CREATE POLICY "Steps of published paths are viewable by everyone"
  ON learning_path_steps FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM learning_paths
      WHERE id = path_id AND is_published = true
    )
  );

CREATE POLICY "Path authors can manage steps"
  ON learning_path_steps FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM learning_paths
      WHERE id = path_id AND author_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM learning_paths
      WHERE id = path_id AND author_id = auth.uid()
    )
  );

-- Learning Path Progress policies
CREATE POLICY "Users can view their own progress"
  ON learning_path_progress FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can manage their own progress"
  ON learning_path_progress FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Step Completions policies
CREATE POLICY "Users can view their own step completions"
  ON step_completions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM learning_path_progress
      WHERE id = progress_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage their own step completions"
  ON step_completions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM learning_path_progress
      WHERE id = progress_id AND user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM learning_path_progress
      WHERE id = progress_id AND user_id = auth.uid()
    )
  );

-- ============================================================================
-- Seed Data: Sample Learning Paths
-- ============================================================================
INSERT INTO learning_paths (id, title, description, icon_emoji, difficulty, estimated_minutes, is_published, is_featured)
VALUES
  ('11111111-1111-1111-1111-111111111101', 'Understanding Your Type', 'Discover what it means to be your Human Design type and how to live in alignment with your natural energy.', E'\u2728', 'beginner', 45, true, true),
  ('11111111-1111-1111-1111-111111111102', 'Mastering Your Authority', 'Learn to make decisions that are correct for you using your inner authority.', E'\U0001F9ED', 'beginner', 60, true, true),
  ('11111111-1111-1111-1111-111111111103', 'Living Your Profile', 'Understand your profile and how it shapes your life purpose and interactions with others.', E'\U0001F465', 'intermediate', 90, true, false),
  ('11111111-1111-1111-1111-111111111104', 'Center Wisdom', 'Deep dive into your defined and undefined centers for greater self-understanding.', E'\U0001F4A0', 'intermediate', 120, true, false),
  ('11111111-1111-1111-1111-111111111105', 'Gates & Channels Mastery', 'Explore your gates and channels to unlock your unique gifts and potential.', E'\U0001F511', 'advanced', 180, true, true);

-- Sample steps for "Understanding Your Type" path
INSERT INTO learning_path_steps (path_id, order_index, title, description, step_type, content_id, estimated_minutes)
VALUES
  ('11111111-1111-1111-1111-111111111101', 0, 'Introduction to Human Design Types', 'Learn about the 5 types in Human Design and their unique roles.', 'article', 'hd-types-intro', 10),
  ('11111111-1111-1111-1111-111111111101', 1, 'Your Type Deep Dive', 'Explore the characteristics, strategy, and signature of your specific type.', 'article', 'type-deep-dive', 15),
  ('11111111-1111-1111-1111-111111111101', 2, 'Strategy & Signature', 'Understand how to use your strategy and recognize your signature.', 'video', 'strategy-signature-video', 10),
  ('11111111-1111-1111-1111-111111111101', 3, 'Type Knowledge Check', 'Test your understanding of Human Design types.', 'quiz', 'types-quiz', 5),
  ('11111111-1111-1111-1111-111111111101', 4, 'Living Your Type', 'Practical exercise to apply your type knowledge in daily life.', 'exercise', 'type-exercise', 5);

-- Sample steps for "Mastering Your Authority" path
INSERT INTO learning_path_steps (path_id, order_index, title, description, step_type, content_id, estimated_minutes)
VALUES
  ('11111111-1111-1111-1111-111111111102', 0, 'What is Authority?', 'Introduction to the concept of inner authority in Human Design.', 'article', 'authority-intro', 10),
  ('11111111-1111-1111-1111-111111111102', 1, 'The 7 Authorities', 'Overview of all authority types and how they work.', 'article', 'seven-authorities', 15),
  ('11111111-1111-1111-1111-111111111102', 2, 'Your Authority in Action', 'How to recognize and use your specific authority.', 'video', 'authority-in-action', 15),
  ('11111111-1111-1111-1111-111111111102', 3, 'Decision Making Challenge', 'Practice using your authority in a real decision.', 'challenge', 'authority-challenge', 10),
  ('11111111-1111-1111-1111-111111111102', 4, 'Authority Quiz', 'Test your knowledge of Human Design authorities.', 'quiz', 'authority-quiz', 5),
  ('11111111-1111-1111-1111-111111111102', 5, 'Reflection: Your Authority Journey', 'Reflect on your experiences with your authority.', 'reflection', 'authority-reflection', 5);

-- Update step counts
UPDATE learning_paths SET step_count = 5 WHERE id = '11111111-1111-1111-1111-111111111101';
UPDATE learning_paths SET step_count = 6 WHERE id = '11111111-1111-1111-1111-111111111102';
