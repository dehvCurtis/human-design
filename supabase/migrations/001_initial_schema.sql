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
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
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
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
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
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  avatar_url TEXT,
  created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.group_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
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
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
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
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
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
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  text TEXT NOT NULL,
  source TEXT NOT NULL,
  gate_number INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_saved_affirmations_user_id ON public.saved_affirmations(user_id);

-- ==================== Journal Entries ====================
CREATE TABLE public.journal_entries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
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
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
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
