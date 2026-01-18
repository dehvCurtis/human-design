-- Human Design App Database Schema
-- Run this migration in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==================== Profiles ====================
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT,
  avatar_url TEXT,
  birth_date TIMESTAMPTZ,
  birth_location JSONB,
  timezone TEXT,
  is_premium BOOLEAN DEFAULT FALSE,
  preferred_language TEXT DEFAULT 'en',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ==================== Charts ====================
CREATE TABLE public.charts (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  birth_datetime TIMESTAMPTZ NOT NULL,
  birth_location JSONB NOT NULL,
  timezone TEXT NOT NULL,
  type TEXT NOT NULL,
  authority TEXT NOT NULL,
  profile TEXT NOT NULL,
  definition TEXT NOT NULL,
  defined_centers TEXT[] NOT NULL,
  conscious_gates INTEGER[] NOT NULL,
  unconscious_gates INTEGER[] NOT NULL,
  visibility TEXT DEFAULT 'private' CHECK (visibility IN ('private', 'friends', 'public')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_charts_user_id ON public.charts(user_id);
CREATE INDEX idx_charts_visibility ON public.charts(visibility);

-- ==================== Friendships ====================
CREATE TABLE public.friendships (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  friend_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'blocked')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, friend_id)
);

CREATE INDEX idx_friendships_user_id ON public.friendships(user_id);
CREATE INDEX idx_friendships_friend_id ON public.friendships(friend_id);
CREATE INDEX idx_friendships_status ON public.friendships(status);

-- ==================== Groups ====================
CREATE TABLE public.groups (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  avatar_url TEXT,
  created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.group_members (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  role TEXT DEFAULT 'member' CHECK (role IN ('admin', 'member')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(group_id, user_id)
);

CREATE INDEX idx_group_members_group_id ON public.group_members(group_id);
CREATE INDEX idx_group_members_user_id ON public.group_members(user_id);

-- ==================== Shares ====================
CREATE TABLE public.shares (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  chart_id UUID REFERENCES public.charts(id) ON DELETE CASCADE NOT NULL,
  shared_by UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  shared_with UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  share_type TEXT NOT NULL CHECK (share_type IN ('friend', 'group', 'link')),
  share_token TEXT UNIQUE,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (
    (share_type = 'friend' AND shared_with IS NOT NULL) OR
    (share_type = 'group' AND group_id IS NOT NULL) OR
    (share_type = 'link' AND share_token IS NOT NULL)
  )
);

CREATE INDEX idx_shares_chart_id ON public.shares(chart_id);
CREATE INDEX idx_shares_shared_by ON public.shares(shared_by);
CREATE INDEX idx_shares_shared_with ON public.shares(shared_with);
CREATE INDEX idx_shares_group_id ON public.shares(group_id);

-- ==================== Comments ====================
CREATE TABLE public.comments (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  chart_id UUID REFERENCES public.charts(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  element_type TEXT CHECK (element_type IN ('gate', 'channel', 'center')),
  element_id TEXT,
  parent_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_comments_chart_id ON public.comments(chart_id);
CREATE INDEX idx_comments_user_id ON public.comments(user_id);
CREATE INDEX idx_comments_parent_id ON public.comments(parent_id);

-- ==================== Saved Affirmations ====================
CREATE TABLE public.saved_affirmations (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  text TEXT NOT NULL,
  source TEXT NOT NULL,
  gate_number INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_saved_affirmations_user_id ON public.saved_affirmations(user_id);

-- ==================== Journal Entries ====================
CREATE TABLE public.journal_entries (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  mood INTEGER CHECK (mood >= 1 AND mood <= 5),
  energy INTEGER CHECK (energy >= 1 AND energy <= 5),
  transit_gate INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_journal_entries_user_id ON public.journal_entries(user_id);
CREATE INDEX idx_journal_entries_created_at ON public.journal_entries(created_at);

-- ==================== Pentas ====================
CREATE TABLE public.pentas (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  created_by UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  member_ids UUID[] NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_pentas_created_by ON public.pentas(created_by);

-- ==================== Row Level Security ====================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.charts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shares ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_affirmations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.journal_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pentas ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view their own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can view friends' profiles"
  ON public.profiles FOR SELECT
  USING (
    id IN (
      SELECT friend_id FROM public.friendships
      WHERE user_id = auth.uid() AND status = 'accepted'
    )
  );

-- Charts policies
CREATE POLICY "Users can manage their own charts"
  ON public.charts FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view shared charts"
  ON public.charts FOR SELECT
  USING (
    visibility = 'public' OR
    (visibility = 'friends' AND user_id IN (
      SELECT friend_id FROM public.friendships
      WHERE user_id = auth.uid() AND status = 'accepted'
    )) OR
    id IN (
      SELECT chart_id FROM public.shares
      WHERE shared_with = auth.uid()
    )
  );

-- Friendships policies
CREATE POLICY "Users can view their friendships"
  ON public.friendships FOR SELECT
  USING (auth.uid() = user_id OR auth.uid() = friend_id);

CREATE POLICY "Users can create friend requests"
  ON public.friendships FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update friendships they're part of"
  ON public.friendships FOR UPDATE
  USING (auth.uid() = friend_id);

CREATE POLICY "Users can delete their friendships"
  ON public.friendships FOR DELETE
  USING (auth.uid() = user_id OR auth.uid() = friend_id);

-- Groups policies
CREATE POLICY "Users can view groups they're members of"
  ON public.groups FOR SELECT
  USING (
    id IN (
      SELECT group_id FROM public.group_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create groups"
  ON public.groups FOR INSERT
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Admins can update their groups"
  ON public.groups FOR UPDATE
  USING (
    id IN (
      SELECT group_id FROM public.group_members
      WHERE user_id = auth.uid() AND role = 'admin'
    )
  );

-- Group members policies
CREATE POLICY "Users can view members of their groups"
  ON public.group_members FOR SELECT
  USING (
    group_id IN (
      SELECT group_id FROM public.group_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can manage group members"
  ON public.group_members FOR ALL
  USING (
    group_id IN (
      SELECT group_id FROM public.group_members
      WHERE user_id = auth.uid() AND role = 'admin'
    )
  );

-- Shares policies
CREATE POLICY "Users can view shares involving them"
  ON public.shares FOR SELECT
  USING (
    auth.uid() = shared_by OR
    auth.uid() = shared_with OR
    group_id IN (
      SELECT group_id FROM public.group_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create shares for their charts"
  ON public.shares FOR INSERT
  WITH CHECK (
    auth.uid() = shared_by AND
    chart_id IN (SELECT id FROM public.charts WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can delete their shares"
  ON public.shares FOR DELETE
  USING (auth.uid() = shared_by);

-- Comments policies
CREATE POLICY "Users can view comments on accessible charts"
  ON public.comments FOR SELECT
  USING (
    chart_id IN (
      SELECT id FROM public.charts
      WHERE user_id = auth.uid() OR visibility = 'public'
    ) OR
    chart_id IN (
      SELECT chart_id FROM public.shares
      WHERE shared_with = auth.uid()
    )
  );

CREATE POLICY "Users can create comments on accessible charts"
  ON public.comments FOR INSERT
  WITH CHECK (
    auth.uid() = user_id AND (
      chart_id IN (
        SELECT id FROM public.charts
        WHERE user_id = auth.uid() OR visibility = 'public'
      ) OR
      chart_id IN (
        SELECT chart_id FROM public.shares
        WHERE shared_with = auth.uid()
      )
    )
  );

CREATE POLICY "Users can update their own comments"
  ON public.comments FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own comments"
  ON public.comments FOR DELETE
  USING (auth.uid() = user_id);

-- Saved affirmations policies
CREATE POLICY "Users can manage their saved affirmations"
  ON public.saved_affirmations FOR ALL
  USING (auth.uid() = user_id);

-- Journal entries policies
CREATE POLICY "Users can manage their journal entries"
  ON public.journal_entries FOR ALL
  USING (auth.uid() = user_id);

-- Pentas policies
CREATE POLICY "Users can manage their pentas"
  ON public.pentas FOR ALL
  USING (auth.uid() = created_by);

-- ==================== Functions ====================

-- Function to check share limits for free users
CREATE OR REPLACE FUNCTION public.check_share_limit()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER check_share_limit_trigger
  BEFORE INSERT ON public.shares
  FOR EACH ROW EXECUTE FUNCTION public.check_share_limit();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to relevant tables
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_charts_updated_at
  BEFORE UPDATE ON public.charts
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_comments_updated_at
  BEFORE UPDATE ON public.comments
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_journal_entries_updated_at
  BEFORE UPDATE ON public.journal_entries
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  participant_ids UUID[] NOT NULL,
  last_message_at TIMESTAMPTZ DEFAULT NOW(),
  last_message_preview TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_conversations_participants ON public.conversations USING GIN (participant_ids);
CREATE INDEX idx_conversations_last_message ON public.conversations(last_message_at DESC);

CREATE TABLE public.direct_messages (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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
-- Human Design Social Platform RLS Policies
-- Migration 003: Row Level Security for all social platform tables
-- Run this migration AFTER 002_social_platform.sql

-- ==================== Helper Functions ====================

-- Check if user follows another user
CREATE OR REPLACE FUNCTION public.is_following(follower UUID, following UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_follows
    WHERE follower_id = follower AND following_id = following
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Check if user is blocked by another user
CREATE OR REPLACE FUNCTION public.is_blocked(blocker UUID, blocked UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.blocked_users
    WHERE blocker_id = blocker AND blocked_id = blocked
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Check if user is in conversation
CREATE OR REPLACE FUNCTION public.is_conversation_participant(conv_id UUID, user_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.conversations
    WHERE id = conv_id AND user_uuid = ANY(participant_ids)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Check if user can message another user
CREATE OR REPLACE FUNCTION public.can_message_user(sender UUID, recipient UUID)
RETURNS BOOLEAN AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- ==================== Profile Policies (Updates) ====================

-- Allow viewing public profiles
CREATE POLICY "Anyone can view public profiles"
  ON public.profiles FOR SELECT
  USING (is_public = TRUE OR auth.uid() = id);

-- ==================== User Follows Policies ====================

CREATE POLICY "Users can view follow relationships"
  ON public.user_follows FOR SELECT
  USING (
    auth.uid() = follower_id OR
    auth.uid() = following_id OR
    -- Can see follows of public profiles
    EXISTS (SELECT 1 FROM public.profiles WHERE id = following_id AND is_public = TRUE)
  );

CREATE POLICY "Users can follow others"
  ON public.user_follows FOR INSERT
  WITH CHECK (
    auth.uid() = follower_id AND
    NOT public.is_blocked(following_id, auth.uid())
  );

CREATE POLICY "Users can unfollow"
  ON public.user_follows FOR DELETE
  USING (auth.uid() = follower_id);

-- ==================== Posts Policies ====================

CREATE POLICY "Users can view public posts"
  ON public.posts FOR SELECT
  USING (
    visibility = 'public' AND
    NOT public.is_blocked(user_id, auth.uid())
  );

CREATE POLICY "Users can view followers-only posts from followed users"
  ON public.posts FOR SELECT
  USING (
    visibility = 'followers' AND
    public.is_following(auth.uid(), user_id) AND
    NOT public.is_blocked(user_id, auth.uid())
  );

CREATE POLICY "Users can view their own posts"
  ON public.posts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create posts"
  ON public.posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own posts"
  ON public.posts FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own posts"
  ON public.posts FOR DELETE
  USING (auth.uid() = user_id);

-- ==================== Post Comments Policies ====================

CREATE POLICY "Users can view comments on accessible posts"
  ON public.post_comments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.posts p
      WHERE p.id = post_id AND (
        p.visibility = 'public' OR
        p.user_id = auth.uid() OR
        (p.visibility = 'followers' AND public.is_following(auth.uid(), p.user_id))
      )
    )
  );

CREATE POLICY "Users can create comments on accessible posts"
  ON public.post_comments FOR INSERT
  WITH CHECK (
    auth.uid() = user_id AND
    EXISTS (
      SELECT 1 FROM public.posts p
      WHERE p.id = post_id AND (
        p.visibility = 'public' OR
        p.user_id = auth.uid() OR
        (p.visibility = 'followers' AND public.is_following(auth.uid(), p.user_id))
      )
    )
  );

CREATE POLICY "Users can update their own comments"
  ON public.post_comments FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own comments"
  ON public.post_comments FOR DELETE
  USING (auth.uid() = user_id);

-- ==================== Reactions Policies ====================

CREATE POLICY "Users can view reactions"
  ON public.reactions FOR SELECT
  USING (TRUE);

CREATE POLICY "Users can add reactions"
  ON public.reactions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove their reactions"
  ON public.reactions FOR DELETE
  USING (auth.uid() = user_id);

-- ==================== Stories Policies ====================

CREATE POLICY "Users can view public non-expired stories"
  ON public.stories FOR SELECT
  USING (
    expires_at > NOW() AND (
      visibility = 'public' OR
      auth.uid() = user_id OR
      (visibility = 'followers' AND public.is_following(auth.uid(), user_id))
    ) AND
    NOT public.is_blocked(user_id, auth.uid())
  );

CREATE POLICY "Users can create stories"
  ON public.stories FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own stories"
  ON public.stories FOR DELETE
  USING (auth.uid() = user_id);

-- ==================== Story Views Policies ====================

CREATE POLICY "Story owners can see who viewed"
  ON public.story_views FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.stories
      WHERE id = story_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Users can view their own view history"
  ON public.story_views FOR SELECT
  USING (auth.uid() = viewer_id);

CREATE POLICY "Users can record story views"
  ON public.story_views FOR INSERT
  WITH CHECK (auth.uid() = viewer_id);

-- ==================== Conversations Policies ====================

CREATE POLICY "Users can view their conversations"
  ON public.conversations FOR SELECT
  USING (auth.uid() = ANY(participant_ids));

CREATE POLICY "Users can create conversations"
  ON public.conversations FOR INSERT
  WITH CHECK (auth.uid() = ANY(participant_ids));

CREATE POLICY "Participants can update conversation"
  ON public.conversations FOR UPDATE
  USING (auth.uid() = ANY(participant_ids));

-- ==================== Direct Messages Policies ====================

CREATE POLICY "Users can view messages in their conversations"
  ON public.direct_messages FOR SELECT
  USING (
    public.is_conversation_participant(conversation_id, auth.uid())
  );

CREATE POLICY "Users can send messages in their conversations"
  ON public.direct_messages FOR INSERT
  WITH CHECK (
    auth.uid() = sender_id AND
    public.is_conversation_participant(conversation_id, auth.uid())
  );

CREATE POLICY "Users can update their own messages (read status)"
  ON public.direct_messages FOR UPDATE
  USING (
    public.is_conversation_participant(conversation_id, auth.uid())
  );

-- ==================== User Points Policies ====================

CREATE POLICY "Users can view their own points"
  ON public.user_points FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view leaderboard (limited data)"
  ON public.user_points FOR SELECT
  USING (TRUE);  -- Will need to handle in app to show only necessary fields

CREATE POLICY "System can manage points"
  ON public.user_points FOR ALL
  USING (auth.uid() = user_id);

-- ==================== Point Transactions Policies ====================

CREATE POLICY "Users can view their own transactions"
  ON public.point_transactions FOR SELECT
  USING (auth.uid() = user_id);

-- Insert handled by award_points function

-- ==================== Badges Policies ====================

CREATE POLICY "Anyone can view badge definitions"
  ON public.badges FOR SELECT
  USING (NOT is_hidden);

-- Admin-only insert/update/delete (via service role)

-- ==================== User Badges Policies ====================

CREATE POLICY "Users can view earned badges"
  ON public.user_badges FOR SELECT
  USING (TRUE);  -- Public to show on profiles

CREATE POLICY "Users can update their featured badges"
  ON public.user_badges FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Insert handled by system

-- ==================== Challenges Policies ====================

CREATE POLICY "Users can view active challenges"
  ON public.challenges FOR SELECT
  USING (is_active = TRUE);

-- Admin-only insert/update/delete

-- ==================== User Challenges Policies ====================

CREATE POLICY "Users can view their challenges"
  ON public.user_challenges FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their challenge progress"
  ON public.user_challenges FOR UPDATE
  USING (auth.uid() = user_id);

-- Insert handled by system

-- ==================== Content Library Policies ====================

CREATE POLICY "Users can view published non-premium content"
  ON public.content_library FOR SELECT
  USING (
    is_published = TRUE AND (
      is_premium = FALSE OR
      EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_premium = TRUE)
    )
  );

CREATE POLICY "Authors can view their own content"
  ON public.content_library FOR SELECT
  USING (auth.uid() = author_id);

CREATE POLICY "Users can create community content"
  ON public.content_library FOR INSERT
  WITH CHECK (auth.uid() = author_id AND is_official = FALSE);

CREATE POLICY "Authors can update their content"
  ON public.content_library FOR UPDATE
  USING (auth.uid() = author_id);

CREATE POLICY "Authors can delete their content"
  ON public.content_library FOR DELETE
  USING (auth.uid() = author_id AND is_official = FALSE);

-- ==================== Content Progress Policies ====================

CREATE POLICY "Users can manage their content progress"
  ON public.content_progress FOR ALL
  USING (auth.uid() = user_id);

-- ==================== Mentorship Profiles Policies ====================

CREATE POLICY "Users can view mentor profiles"
  ON public.mentorship_profiles FOR SELECT
  USING (is_mentor = TRUE OR auth.uid() = user_id);

CREATE POLICY "Users can manage their mentorship profile"
  ON public.mentorship_profiles FOR ALL
  USING (auth.uid() = user_id);

-- ==================== Mentorship Requests Policies ====================

CREATE POLICY "Mentors and mentees can view their requests"
  ON public.mentorship_requests FOR SELECT
  USING (auth.uid() = mentor_id OR auth.uid() = mentee_id);

CREATE POLICY "Mentees can create requests"
  ON public.mentorship_requests FOR INSERT
  WITH CHECK (auth.uid() = mentee_id);

CREATE POLICY "Both parties can update request status"
  ON public.mentorship_requests FOR UPDATE
  USING (auth.uid() = mentor_id OR auth.uid() = mentee_id);

CREATE POLICY "Both parties can delete requests"
  ON public.mentorship_requests FOR DELETE
  USING (auth.uid() = mentor_id OR auth.uid() = mentee_id);

-- ==================== Live Sessions Policies ====================

CREATE POLICY "Users can view scheduled and live sessions"
  ON public.live_sessions FOR SELECT
  USING (
    status IN ('scheduled', 'live') OR
    auth.uid() = host_id OR
    EXISTS (
      SELECT 1 FROM public.session_participants
      WHERE session_id = id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Premium content requires premium"
  ON public.live_sessions FOR SELECT
  USING (
    is_premium = FALSE OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_premium = TRUE) OR
    auth.uid() = host_id
  );

CREATE POLICY "Users can create sessions"
  ON public.live_sessions FOR INSERT
  WITH CHECK (auth.uid() = host_id);

CREATE POLICY "Hosts can update their sessions"
  ON public.live_sessions FOR UPDATE
  USING (auth.uid() = host_id);

CREATE POLICY "Hosts can delete their sessions"
  ON public.live_sessions FOR DELETE
  USING (auth.uid() = host_id);

-- ==================== Session Participants Policies ====================

CREATE POLICY "Hosts and participants can view participants"
  ON public.session_participants FOR SELECT
  USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM public.live_sessions
      WHERE id = session_id AND host_id = auth.uid()
    )
  );

CREATE POLICY "Users can register for sessions"
  ON public.session_participants FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their registration"
  ON public.session_participants FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users and hosts can remove registration"
  ON public.session_participants FOR DELETE
  USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM public.live_sessions
      WHERE id = session_id AND host_id = auth.uid()
    )
  );

-- ==================== Blocked Users Policies ====================

CREATE POLICY "Users can view their block list"
  ON public.blocked_users FOR SELECT
  USING (auth.uid() = blocker_id);

CREATE POLICY "Users can block others"
  ON public.blocked_users FOR INSERT
  WITH CHECK (auth.uid() = blocker_id);

CREATE POLICY "Users can unblock others"
  ON public.blocked_users FOR DELETE
  USING (auth.uid() = blocker_id);

-- ==================== Content Reports Policies ====================

CREATE POLICY "Users can view their own reports"
  ON public.content_reports FOR SELECT
  USING (auth.uid() = reporter_id);

CREATE POLICY "Users can create reports"
  ON public.content_reports FOR INSERT
  WITH CHECK (auth.uid() = reporter_id);

-- Admin-only update/delete (via service role)

-- ==================== Notifications Policies ====================

CREATE POLICY "Users can view their notifications"
  ON public.notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can mark their notifications as read"
  ON public.notifications FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their notifications"
  ON public.notifications FOR DELETE
  USING (auth.uid() = user_id);

-- System inserts via service role

-- ==================== Realtime Subscriptions ====================
-- Enable realtime for specific tables

ALTER PUBLICATION supabase_realtime ADD TABLE public.direct_messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE public.stories;
ALTER PUBLICATION supabase_realtime ADD TABLE public.posts;
ALTER PUBLICATION supabase_realtime ADD TABLE public.reactions;
-- ==================== Utility Functions ====================
-- Generic increment/decrement functions used by various features

-- Increment a counter column on any table
CREATE OR REPLACE FUNCTION public.increment(
  table_name TEXT,
  row_id UUID,
  column_name TEXT,
  amount INTEGER DEFAULT 1
)
RETURNS VOID AS $$
BEGIN
  EXECUTE format(
    'UPDATE public.%I SET %I = COALESCE(%I, 0) + $1 WHERE id = $2',
    table_name, column_name, column_name
  ) USING amount, row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Decrement a counter column on any table (with floor at 0)
CREATE OR REPLACE FUNCTION public.decrement(
  table_name TEXT,
  row_id UUID,
  column_name TEXT,
  amount INTEGER DEFAULT 1
)
RETURNS VOID AS $$
BEGIN
  EXECUTE format(
    'UPDATE public.%I SET %I = GREATEST(COALESCE(%I, 0) - $1, 0) WHERE id = $2',
    table_name, column_name, column_name
  ) USING amount, row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION public.increment TO authenticated;
GRANT EXECUTE ON FUNCTION public.decrement TO authenticated;
