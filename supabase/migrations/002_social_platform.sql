-- Human Design Social Platform Database Schema
-- Migration 002: Social features, gamification, learning, and messaging
-- Run this migration AFTER 001_initial_schema.sql

-- ==================== Profile Extensions ====================
-- Add social and HD-specific fields to profiles
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT TRUE;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS show_chart_publicly BOOLEAN DEFAULT FALSE;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS allow_messages TEXT DEFAULT 'followers' CHECK (allow_messages IN ('everyone', 'followers', 'nobody'));
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS hd_type TEXT CHECK (hd_type IN ('Manifestor', 'Generator', 'Manifesting Generator', 'Projector', 'Reflector'));
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS hd_profile TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS hd_authority TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS notification_settings JSONB DEFAULT '{"push_enabled": true, "email_enabled": false, "dm_notifications": true, "follow_notifications": true, "reaction_notifications": true}';
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMPTZ;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS follower_count INTEGER DEFAULT 0;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS following_count INTEGER DEFAULT 0;

-- ==================== User Follows (Twitter-style) ====================
CREATE TABLE public.user_follows (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  follower_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  following_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id)
);

CREATE INDEX idx_user_follows_follower ON public.user_follows(follower_id);
CREATE INDEX idx_user_follows_following ON public.user_follows(following_id);
CREATE INDEX idx_user_follows_created_at ON public.user_follows(created_at);

-- Update follower/following counts on follow/unfollow
CREATE OR REPLACE FUNCTION public.update_follow_counts()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_follow_change
  AFTER INSERT OR DELETE ON public.user_follows
  FOR EACH ROW EXECUTE FUNCTION public.update_follow_counts();

-- ==================== Posts (Content Feed) ====================
CREATE TABLE public.posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  post_type TEXT NOT NULL CHECK (post_type IN ('insight', 'reflection', 'transit_share', 'chart_share', 'question', 'achievement')),
  visibility TEXT DEFAULT 'public' CHECK (visibility IN ('public', 'followers', 'private')),
  media_urls TEXT[],
  chart_id UUID REFERENCES public.charts(id) ON DELETE SET NULL,
  gate_number INTEGER,
  channel_id TEXT,
  transit_data JSONB,
  badge_id UUID,
  is_pinned BOOLEAN DEFAULT FALSE,
  reaction_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  share_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_posts_user_id ON public.posts(user_id);
CREATE INDEX idx_posts_post_type ON public.posts(post_type);
CREATE INDEX idx_posts_visibility ON public.posts(visibility);
CREATE INDEX idx_posts_created_at ON public.posts(created_at DESC);
CREATE INDEX idx_posts_gate_number ON public.posts(gate_number) WHERE gate_number IS NOT NULL;

-- ==================== Post Comments ====================
CREATE TABLE public.post_comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  parent_id UUID REFERENCES public.post_comments(id) ON DELETE CASCADE,
  reaction_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_post_comments_post_id ON public.post_comments(post_id);
CREATE INDEX idx_post_comments_user_id ON public.post_comments(user_id);
CREATE INDEX idx_post_comments_parent_id ON public.post_comments(parent_id);

-- Update post comment count
CREATE OR REPLACE FUNCTION public.update_post_comment_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.posts SET comment_count = comment_count + 1 WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.posts SET comment_count = GREATEST(0, comment_count - 1) WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_post_comment_change
  AFTER INSERT OR DELETE ON public.post_comments
  FOR EACH ROW EXECUTE FUNCTION public.update_post_comment_count();

-- ==================== Reactions ====================
CREATE TABLE public.reactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES public.post_comments(id) ON DELETE CASCADE,
  reaction_type TEXT NOT NULL CHECK (reaction_type IN (
    'like', 'love', 'insight', 'resonate',
    'generator_sacral', 'projector_recognition', 'manifestor_peace', 'reflector_surprise', 'mg_satisfaction'
  )),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, post_id, reaction_type),
  CHECK ((post_id IS NOT NULL AND comment_id IS NULL) OR (post_id IS NULL AND comment_id IS NOT NULL))
);

CREATE INDEX idx_reactions_user_id ON public.reactions(user_id);
CREATE INDEX idx_reactions_post_id ON public.reactions(post_id);
CREATE INDEX idx_reactions_comment_id ON public.reactions(comment_id);
CREATE INDEX idx_reactions_type ON public.reactions(reaction_type);

-- Update reaction counts
CREATE OR REPLACE FUNCTION public.update_reaction_counts()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_reaction_change
  AFTER INSERT OR DELETE ON public.reactions
  FOR EACH ROW EXECUTE FUNCTION public.update_reaction_counts();

-- ==================== Stories (24h Ephemeral) ====================
CREATE TABLE public.stories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT,
  media_url TEXT,
  background_color TEXT,
  text_color TEXT,
  transit_gate INTEGER,
  affirmation_text TEXT,
  visibility TEXT DEFAULT 'followers' CHECK (visibility IN ('public', 'followers')),
  view_count INTEGER DEFAULT 0,
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '24 hours'),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_stories_user_id ON public.stories(user_id);
CREATE INDEX idx_stories_expires_at ON public.stories(expires_at);
CREATE INDEX idx_stories_created_at ON public.stories(created_at DESC);

-- Story views tracking
CREATE TABLE public.story_views (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  story_id UUID REFERENCES public.stories(id) ON DELETE CASCADE NOT NULL,
  viewer_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  viewed_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(story_id, viewer_id)
);

CREATE INDEX idx_story_views_story_id ON public.story_views(story_id);
CREATE INDEX idx_story_views_viewer_id ON public.story_views(viewer_id);

-- Update story view count
CREATE OR REPLACE FUNCTION public.update_story_view_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.stories SET view_count = view_count + 1 WHERE id = NEW.story_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_story_view
  AFTER INSERT ON public.story_views
  FOR EACH ROW EXECUTE FUNCTION public.update_story_view_count();

-- ==================== Direct Messaging ====================
CREATE TABLE public.conversations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  participant_ids UUID[] NOT NULL,
  last_message_at TIMESTAMPTZ DEFAULT NOW(),
  last_message_preview TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_conversations_participants ON public.conversations USING GIN (participant_ids);
CREATE INDEX idx_conversations_last_message ON public.conversations(last_message_at DESC);

CREATE TABLE public.direct_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE NOT NULL,
  sender_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'chart_share', 'transit_share', 'image')),
  shared_chart_id UUID REFERENCES public.charts(id) ON DELETE SET NULL,
  media_url TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_dm_conversation_id ON public.direct_messages(conversation_id);
CREATE INDEX idx_dm_sender_id ON public.direct_messages(sender_id);
CREATE INDEX idx_dm_created_at ON public.direct_messages(created_at DESC);
CREATE INDEX idx_dm_is_read ON public.direct_messages(is_read) WHERE is_read = FALSE;

-- Update conversation on new message
CREATE OR REPLACE FUNCTION public.update_conversation_on_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.conversations
  SET
    last_message_at = NEW.created_at,
    last_message_preview = LEFT(NEW.content, 100),
    updated_at = NOW()
  WHERE id = NEW.conversation_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_new_message
  AFTER INSERT ON public.direct_messages
  FOR EACH ROW EXECUTE FUNCTION public.update_conversation_on_message();

-- ==================== Gamification: Points ====================
CREATE TABLE public.user_points (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL UNIQUE,
  total_points INTEGER DEFAULT 0,
  current_level INTEGER DEFAULT 1,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_activity_date DATE,
  weekly_points INTEGER DEFAULT 0,
  monthly_points INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_user_points_total ON public.user_points(total_points DESC);
CREATE INDEX idx_user_points_level ON public.user_points(current_level DESC);
CREATE INDEX idx_user_points_streak ON public.user_points(current_streak DESC);
CREATE INDEX idx_user_points_weekly ON public.user_points(weekly_points DESC);
CREATE INDEX idx_user_points_monthly ON public.user_points(monthly_points DESC);

CREATE TABLE public.point_transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  points INTEGER NOT NULL,
  action_type TEXT NOT NULL CHECK (action_type IN (
    'daily_login', 'check_transit', 'save_affirmation', 'journal_entry',
    'create_post', 'post_reaction', 'comment', 'friend_added', 'share_chart',
    'complete_challenge', 'streak_bonus_7', 'streak_bonus_30', 'badge_earned',
    'referral', 'first_chart', 'premium_bonus'
  )),
  description TEXT,
  reference_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_point_transactions_user_id ON public.point_transactions(user_id);
CREATE INDEX idx_point_transactions_action ON public.point_transactions(action_type);
CREATE INDEX idx_point_transactions_created_at ON public.point_transactions(created_at DESC);

-- Function to award points
CREATE OR REPLACE FUNCTION public.award_points(
  p_user_id UUID,
  p_points INTEGER,
  p_action_type TEXT,
  p_description TEXT DEFAULT NULL,
  p_reference_id UUID DEFAULT NULL
)
RETURNS INTEGER AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==================== Gamification: Badges ====================
CREATE TABLE public.badges (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  icon_name TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('social', 'learning', 'engagement', 'transit', 'achievement')),
  requirement_type TEXT NOT NULL CHECK (requirement_type IN ('count', 'streak', 'special')),
  requirement_value INTEGER,
  requirement_data JSONB,
  points_awarded INTEGER DEFAULT 0,
  is_hidden BOOLEAN DEFAULT FALSE,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_badges_category ON public.badges(category);

-- Insert default badges
INSERT INTO public.badges (name, description, icon_name, category, requirement_type, requirement_value, points_awarded, sort_order) VALUES
-- Social badges
('first_friend', 'Added your first friend', 'person_add', 'social', 'count', 1, 25, 1),
('social_butterfly', 'Connected with 10 people', 'groups', 'social', 'count', 10, 50, 2),
('community_builder', 'Connected with 50 people', 'diversity_3', 'social', 'count', 50, 100, 3),
('influencer', 'Gained 100 followers', 'trending_up', 'social', 'count', 100, 150, 4),
-- Learning badges
('chart_explorer', 'Explored all 64 gates', 'explore', 'learning', 'count', 64, 100, 10),
('transit_tracker', 'Tracked transits for 30 days', 'track_changes', 'learning', 'streak', 30, 75, 11),
('type_master', 'Read about all 5 types', 'school', 'learning', 'count', 5, 50, 12),
-- Engagement badges
('consistent', 'Logged in 7 days in a row', 'calendar_today', 'engagement', 'streak', 7, 50, 20),
('dedicated', 'Logged in 30 days in a row', 'event_available', 'engagement', 'streak', 30, 200, 21),
('journaler', 'Created 10 journal entries', 'edit_note', 'engagement', 'count', 10, 40, 22),
('prolific_writer', 'Created 50 posts', 'article', 'engagement', 'count', 50, 100, 23),
-- Transit badges
('full_wheel', 'Experienced all 64 gates in transit', 'autorenew', 'transit', 'count', 64, 200, 30),
('personal_year', 'Tracked transits for 12 months', 'calendar_month', 'transit', 'count', 12, 150, 31),
-- Achievement badges
('early_adopter', 'Joined during beta', 'star', 'achievement', 'special', NULL, 100, 40),
('premium_member', 'Became a premium member', 'workspace_premium', 'achievement', 'special', NULL, 50, 41),
('helper', 'Received 100 reactions on comments', 'volunteer_activism', 'achievement', 'count', 100, 75, 42);

CREATE TABLE public.user_badges (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  badge_id UUID REFERENCES public.badges(id) ON DELETE CASCADE NOT NULL,
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  progress INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT FALSE,
  UNIQUE(user_id, badge_id)
);

CREATE INDEX idx_user_badges_user_id ON public.user_badges(user_id);
CREATE INDEX idx_user_badges_badge_id ON public.user_badges(badge_id);
CREATE INDEX idx_user_badges_earned_at ON public.user_badges(earned_at);

-- ==================== Gamification: Challenges ====================
CREATE TABLE public.challenges (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  challenge_type TEXT NOT NULL CHECK (challenge_type IN ('daily', 'weekly', 'monthly', 'special')),
  action_type TEXT NOT NULL,
  target_value INTEGER NOT NULL,
  points_reward INTEGER NOT NULL,
  hd_type_filter TEXT[],
  gate_filter INTEGER[],
  is_active BOOLEAN DEFAULT TRUE,
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_challenges_type ON public.challenges(challenge_type);
CREATE INDEX idx_challenges_active ON public.challenges(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_challenges_dates ON public.challenges(start_date, end_date);

-- Insert default daily challenges
INSERT INTO public.challenges (title, description, challenge_type, action_type, target_value, points_reward) VALUES
('Daily Check-In', 'Log in and check your transits', 'daily', 'check_transit', 1, 10),
('Reflect', 'Write a journal entry', 'daily', 'journal_entry', 1, 15),
('Share Your Insight', 'Create a post sharing your HD insight', 'daily', 'create_post', 1, 10),
('Connect', 'React to 3 posts from others', 'daily', 'post_reaction', 3, 15),
('Engage', 'Leave a meaningful comment', 'daily', 'comment', 1, 10);

-- Weekly challenges
INSERT INTO public.challenges (title, description, challenge_type, action_type, target_value, points_reward) VALUES
('Weekly Warrior', 'Log in every day this week', 'weekly', 'daily_login', 7, 50),
('Thoughtful Writer', 'Create 5 posts this week', 'weekly', 'create_post', 5, 75),
('Social Star', 'Add 2 new connections', 'weekly', 'friend_added', 2, 40);

CREATE TABLE public.user_challenges (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE NOT NULL,
  progress INTEGER DEFAULT 0,
  is_completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  assigned_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_user_challenges_user_id ON public.user_challenges(user_id);
CREATE INDEX idx_user_challenges_challenge_id ON public.user_challenges(challenge_id);
CREATE INDEX idx_user_challenges_date ON public.user_challenges(assigned_date);
CREATE INDEX idx_user_challenges_completed ON public.user_challenges(is_completed);

-- ==================== Content Library ====================
CREATE TABLE public.content_library (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  content_type TEXT NOT NULL CHECK (content_type IN ('article', 'guide', 'quiz', 'video', 'infographic')),
  category TEXT NOT NULL CHECK (category IN ('type', 'authority', 'profile', 'gate', 'channel', 'center', 'transit', 'general')),
  subcategory TEXT,
  gate_number INTEGER,
  channel_id TEXT,
  center_name TEXT,
  hd_type TEXT,
  author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  is_official BOOLEAN DEFAULT FALSE,
  is_premium BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT FALSE,
  view_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  tags TEXT[],
  media_url TEXT,
  estimated_read_time INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  published_at TIMESTAMPTZ
);

CREATE INDEX idx_content_library_type ON public.content_library(content_type);
CREATE INDEX idx_content_library_category ON public.content_library(category);
CREATE INDEX idx_content_library_gate ON public.content_library(gate_number) WHERE gate_number IS NOT NULL;
CREATE INDEX idx_content_library_published ON public.content_library(is_published) WHERE is_published = TRUE;
CREATE INDEX idx_content_library_premium ON public.content_library(is_premium);

CREATE TABLE public.content_progress (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content_id UUID REFERENCES public.content_library(id) ON DELETE CASCADE NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  progress_percent INTEGER DEFAULT 0,
  quiz_score INTEGER,
  last_accessed_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, content_id)
);

CREATE INDEX idx_content_progress_user ON public.content_progress(user_id);

-- ==================== Mentorship ====================
CREATE TABLE public.mentorship_profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL UNIQUE,
  is_mentor BOOLEAN DEFAULT FALSE,
  is_mentee BOOLEAN DEFAULT FALSE,
  expertise_areas TEXT[],
  experience_years INTEGER,
  bio TEXT,
  availability TEXT,
  max_mentees INTEGER DEFAULT 3,
  current_mentee_count INTEGER DEFAULT 0,
  session_rate DECIMAL(10, 2),
  is_verified BOOLEAN DEFAULT FALSE,
  rating DECIMAL(3, 2),
  review_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_mentorship_profiles_mentor ON public.mentorship_profiles(is_mentor) WHERE is_mentor = TRUE;
CREATE INDEX idx_mentorship_profiles_verified ON public.mentorship_profiles(is_verified);
CREATE INDEX idx_mentorship_profiles_rating ON public.mentorship_profiles(rating DESC);

CREATE TABLE public.mentorship_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  mentor_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  mentee_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'completed', 'cancelled')),
  message TEXT,
  focus_areas TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(mentor_id, mentee_id)
);

CREATE INDEX idx_mentorship_requests_mentor ON public.mentorship_requests(mentor_id);
CREATE INDEX idx_mentorship_requests_mentee ON public.mentorship_requests(mentee_id);
CREATE INDEX idx_mentorship_requests_status ON public.mentorship_requests(status);

-- ==================== Live Sessions ====================
CREATE TABLE public.live_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  host_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  session_type TEXT NOT NULL CHECK (session_type IN ('workshop', 'q_and_a', 'group_reading', 'study_group', 'meditation')),
  scheduled_at TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER DEFAULT 60,
  max_participants INTEGER,
  current_participants INTEGER DEFAULT 0,
  meeting_url TEXT,
  is_premium BOOLEAN DEFAULT FALSE,
  is_recorded BOOLEAN DEFAULT FALSE,
  recording_url TEXT,
  status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'live', 'completed', 'cancelled')),
  tags TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_live_sessions_host ON public.live_sessions(host_id);
CREATE INDEX idx_live_sessions_scheduled ON public.live_sessions(scheduled_at);
CREATE INDEX idx_live_sessions_status ON public.live_sessions(status);

CREATE TABLE public.session_participants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id UUID REFERENCES public.live_sessions(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  rsvp_status TEXT DEFAULT 'registered' CHECK (rsvp_status IN ('registered', 'attended', 'no_show', 'cancelled')),
  registered_at TIMESTAMPTZ DEFAULT NOW(),
  attended_at TIMESTAMPTZ,
  UNIQUE(session_id, user_id)
);

CREATE INDEX idx_session_participants_session ON public.session_participants(session_id);
CREATE INDEX idx_session_participants_user ON public.session_participants(user_id);

-- ==================== Blocked Users ====================
CREATE TABLE public.blocked_users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  blocker_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  blocked_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(blocker_id, blocked_id)
);

CREATE INDEX idx_blocked_users_blocker ON public.blocked_users(blocker_id);
CREATE INDEX idx_blocked_users_blocked ON public.blocked_users(blocked_id);

-- ==================== Content Reports ====================
CREATE TABLE public.content_reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  reporter_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content_type TEXT NOT NULL CHECK (content_type IN ('post', 'comment', 'story', 'message', 'profile')),
  content_id UUID NOT NULL,
  reason TEXT NOT NULL CHECK (reason IN ('spam', 'harassment', 'inappropriate', 'misinformation', 'other')),
  description TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'action_taken', 'dismissed')),
  reviewed_by UUID REFERENCES public.profiles(id),
  reviewed_at TIMESTAMPTZ,
  action_taken TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_content_reports_status ON public.content_reports(status);
CREATE INDEX idx_content_reports_content ON public.content_reports(content_type, content_id);

-- ==================== Notifications ====================
CREATE TABLE public.notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  type TEXT NOT NULL CHECK (type IN (
    'follow', 'reaction', 'comment', 'mention', 'message',
    'badge_earned', 'challenge_completed', 'streak_milestone',
    'session_reminder', 'mentorship_request', 'system'
  )),
  title TEXT NOT NULL,
  body TEXT,
  data JSONB,
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON public.notifications(user_id);
CREATE INDEX idx_notifications_unread ON public.notifications(user_id, is_read) WHERE is_read = FALSE;
CREATE INDEX idx_notifications_created ON public.notifications(created_at DESC);

-- ==================== Enable RLS ====================
ALTER TABLE public.user_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.story_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.direct_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.point_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_library ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentorship_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentorship_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.live_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blocked_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- ==================== Apply updated_at triggers ====================
CREATE TRIGGER update_posts_updated_at
  BEFORE UPDATE ON public.posts
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_post_comments_updated_at
  BEFORE UPDATE ON public.post_comments
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_conversations_updated_at
  BEFORE UPDATE ON public.conversations
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_user_points_updated_at
  BEFORE UPDATE ON public.user_points
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_content_library_updated_at
  BEFORE UPDATE ON public.content_library
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_mentorship_profiles_updated_at
  BEFORE UPDATE ON public.mentorship_profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_mentorship_requests_updated_at
  BEFORE UPDATE ON public.mentorship_requests
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_live_sessions_updated_at
  BEFORE UPDATE ON public.live_sessions
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- ==================== Scheduled Jobs (to be run via Supabase Edge Functions or cron) ====================
-- These are placeholder comments for jobs that need to be set up separately:
-- 1. Delete expired stories: DELETE FROM public.stories WHERE expires_at < NOW();
-- 2. Reset weekly points: UPDATE public.user_points SET weekly_points = 0 WHERE EXTRACT(DOW FROM NOW()) = 1;
-- 3. Reset monthly points: UPDATE public.user_points SET monthly_points = 0 WHERE EXTRACT(DAY FROM NOW()) = 1;
-- 4. Assign daily challenges: Call a function to assign new daily challenges to users
-- 5. Send streak reminders: Notify users who haven't logged in but have active streaks
