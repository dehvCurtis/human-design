-- Seed Factual Human Design Quizzes
-- This migration adds comprehensive quizzes covering all Human Design categories
-- Questions are generated dynamically by the app using question generators

-- ============================================================================
-- Types Quizzes
-- ============================================================================
INSERT INTO quizzes (id, title, description, category, difficulty, points_reward, sort_order, is_active)
VALUES
  ('f47ac10b-58cc-4372-a567-0e02b2c3d479', 'Types Basics', 'Learn the fundamentals of the 5 Human Design types including strategy, signature, and not-self themes.', 'types', 'beginner', 25, 1, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d480', 'Types & Auras', 'Intermediate exploration of Human Design types, aura mechanics, and population statistics.', 'types', 'intermediate', 50, 2, TRUE)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- Centers Quizzes
-- ============================================================================
INSERT INTO quizzes (id, title, description, category, difficulty, points_reward, sort_order, is_active)
VALUES
  ('f47ac10b-58cc-4372-a567-0e02b2c3d481', 'Centers Introduction', 'Discover the 9 energy centers of the bodygraph and their functions.', 'centers', 'beginner', 25, 3, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d482', 'Centers Deep Dive', 'Explore center conditioning, biological correlations, and defined vs undefined dynamics.', 'centers', 'intermediate', 50, 4, TRUE)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- Authorities Quizzes
-- ============================================================================
INSERT INTO quizzes (id, title, description, category, difficulty, points_reward, sort_order, is_active)
VALUES
  ('f47ac10b-58cc-4372-a567-0e02b2c3d483', 'Authority Basics', 'Learn the fundamentals of the 7 decision-making authorities in Human Design.', 'authorities', 'beginner', 25, 5, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d484', 'Know Your Authority', 'Deepen your understanding of how each authority works and the authority hierarchy.', 'authorities', 'intermediate', 50, 6, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d485', 'Authority Mastery', 'Advanced scenarios combining authority with type and center configurations.', 'authorities', 'advanced', 75, 7, TRUE)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- Profiles Quizzes
-- ============================================================================
INSERT INTO quizzes (id, title, description, category, difficulty, points_reward, sort_order, is_active)
VALUES
  ('f47ac10b-58cc-4372-a567-0e02b2c3d486', 'Profile Introduction', 'Discover the 12 profile combinations and the 6 line themes.', 'profiles', 'beginner', 25, 8, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d487', 'Profile Mastery', 'Master the intricacies of profiles, line harmonics, and geometry types.', 'profiles', 'intermediate', 50, 9, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d488', 'Profile Deep Dive', 'Advanced profile concepts including trigram structure and life phases.', 'profiles', 'advanced', 75, 10, TRUE)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- Definitions Quizzes
-- ============================================================================
INSERT INTO quizzes (id, title, description, category, difficulty, points_reward, sort_order, is_active)
VALUES
  ('f47ac10b-58cc-4372-a567-0e02b2c3d489', 'Definition Types', 'Learn how centers connect in the 5 definition types: None, Single, Split, Triple, and Quadruple.', 'definitions', 'beginner', 25, 11, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d490', 'Definition Dynamics', 'Explore how definition affects relationships, decision-making, and energy processing.', 'definitions', 'intermediate', 50, 12, TRUE)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- Gates Quizzes
-- ============================================================================
INSERT INTO quizzes (id, title, description, category, difficulty, points_reward, sort_order, is_active)
VALUES
  ('f47ac10b-58cc-4372-a567-0e02b2c3d491', 'Gates Introduction', 'Begin exploring the 64 gates and their centers.', 'gates', 'beginner', 25, 13, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d492', 'Gate Exploration', 'Deepen your understanding of gate keynotes and meanings.', 'gates', 'intermediate', 50, 14, TRUE)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- Channels Quizzes
-- ============================================================================
INSERT INTO quizzes (id, title, description, category, difficulty, points_reward, sort_order, is_active)
VALUES
  ('f47ac10b-58cc-4372-a567-0e02b2c3d498', 'Channel Basics', 'Learn the fundamentals of how gates form channels and connect centers.', 'channels', 'beginner', 25, 15, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d493', 'Channel Connections', 'Explore how gates form the 36 channels connecting centers.', 'channels', 'intermediate', 50, 16, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d494', 'Channel Mastery', 'Test your knowledge of channel circuit types and center connections.', 'channels', 'advanced', 75, 17, TRUE)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- General/Mixed Quizzes
-- ============================================================================
INSERT INTO quizzes (id, title, description, category, difficulty, points_reward, sort_order, is_active)
VALUES
  ('f47ac10b-58cc-4372-a567-0e02b2c3d495', 'Human Design Fundamentals', 'A comprehensive beginner quiz covering types, centers, authorities, and profiles.', 'general', 'beginner', 25, 18, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d496', 'Human Design Intermediate', 'Mixed intermediate questions across all Human Design categories.', 'general', 'intermediate', 50, 19, TRUE),
  ('f47ac10b-58cc-4372-a567-0e02b2c3d497', 'Advanced Synthesis', 'Advanced cross-category questions requiring deep Human Design knowledge.', 'general', 'advanced', 75, 20, TRUE)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- Note on Question Generation
-- ============================================================================
-- Questions are generated dynamically by the app's question generator classes:
-- - TypesQuestionGenerator: 25+ questions about types, strategies, auras
-- - CentersQuestionGenerator: 26+ questions about centers and biology
-- - AuthoritiesQuestionGenerator: 26+ questions about the 7 authorities (expanded beginner coverage)
-- - ProfilesQuestionGenerator: 26+ questions about profiles and lines
-- - DefinitionsQuestionGenerator: 14+ questions about definition types
-- - GatesQuestionGenerator: 42+ questions from 64 gates data (expanded beginner conceptual questions)
-- - ChannelsQuestionGenerator: 30+ questions from 36 channels data
--
-- Total dynamically generated questions: ~190+
--
-- Beginner Quiz Coverage:
-- - Types Basics, Centers Introduction, Authority Basics, Profile Introduction
-- - Definition Types, Gates Introduction, Channel Basics
-- - Human Design Fundamentals (mixed)
--
-- The quiz_question_map table is not populated here because questions
-- are generated fresh each time with unique IDs. The app uses the
-- CombinedQuestionGenerator to create questions for each quiz session.
