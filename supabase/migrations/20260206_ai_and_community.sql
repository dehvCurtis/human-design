-- =============================================================================
-- AI Chat Tables
-- =============================================================================

-- AI conversations
CREATE TABLE IF NOT EXISTS ai_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT,
  context_type TEXT NOT NULL DEFAULT 'chart'
    CHECK (context_type IN ('chart', 'transit', 'general')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_message_at TIMESTAMPTZ,
  message_count INTEGER NOT NULL DEFAULT 0
    CHECK (message_count >= 0)
);

-- Index for user's conversations sorted by recent activity
CREATE INDEX IF NOT EXISTS idx_ai_conversations_user_recent
  ON ai_conversations(user_id, last_message_at DESC);

-- AI messages
CREATE TABLE IF NOT EXISTS ai_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES ai_conversations(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL
    CHECK (char_length(content) <= 10000), -- Limit stored content size
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for loading conversation messages in order
CREATE INDEX IF NOT EXISTS idx_ai_messages_conversation
  ON ai_messages(conversation_id, created_at ASC);

-- AI usage tracking (per month)
CREATE TABLE IF NOT EXISTS ai_usage (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  period_start DATE NOT NULL,
  messages_count INTEGER NOT NULL DEFAULT 0
    CHECK (messages_count >= 0),
  UNIQUE(user_id, period_start)
);

CREATE INDEX IF NOT EXISTS idx_ai_usage_user_period
  ON ai_usage(user_id, period_start);

-- Function to atomically increment AI usage counter (prevents race conditions)
CREATE OR REPLACE FUNCTION increment_ai_usage(
  p_user_id UUID,
  p_period_start DATE
) RETURNS void AS $$
BEGIN
  INSERT INTO ai_usage (user_id, period_start, messages_count)
  VALUES (p_user_id, p_period_start, 1)
  ON CONFLICT (user_id, period_start)
  DO UPDATE SET messages_count = ai_usage.messages_count + 1;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================================================
-- RLS Policies: AI Tables
-- Users can only access their own data
-- =============================================================================

ALTER TABLE ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_usage ENABLE ROW LEVEL SECURITY;

-- ai_conversations: users see only their own
CREATE POLICY "Users can view own conversations"
  ON ai_conversations FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own conversations"
  ON ai_conversations FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own conversations"
  ON ai_conversations FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own conversations"
  ON ai_conversations FOR DELETE
  USING (auth.uid() = user_id);

-- ai_messages: users see only messages in their conversations
CREATE POLICY "Users can view messages in own conversations"
  ON ai_messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM ai_conversations
      WHERE ai_conversations.id = ai_messages.conversation_id
        AND ai_conversations.user_id = auth.uid()
    )
  );

-- Only the Edge Function (service role) inserts messages directly
-- No client INSERT policy needed — messages created via Edge Function

-- ai_usage: users can view their own usage
CREATE POLICY "Users can view own usage"
  ON ai_usage FOR SELECT
  USING (auth.uid() = user_id);

-- No client INSERT/UPDATE policy — managed by Edge Function via service role

-- =============================================================================
-- Community Events Tables
-- =============================================================================

CREATE TABLE IF NOT EXISTS community_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL
    CHECK (char_length(title) BETWEEN 1 AND 200),
  description TEXT NOT NULL
    CHECK (char_length(description) <= 5000),
  event_type TEXT NOT NULL DEFAULT 'online'
    CHECK (event_type IN ('online', 'in_person', 'hybrid')),
  starts_at TIMESTAMPTZ NOT NULL,
  ends_at TIMESTAMPTZ NOT NULL,
  location TEXT CHECK (char_length(location) <= 500),
  virtual_link TEXT CHECK (char_length(virtual_link) <= 500),
  hd_type_filter TEXT CHECK (
    hd_type_filter IS NULL OR
    hd_type_filter IN ('Manifestor', 'Generator', 'Manifesting Generator', 'Projector', 'Reflector')
  ),
  gate_themes INTEGER[],
  max_participants INTEGER CHECK (max_participants IS NULL OR max_participants > 0),
  current_participants INTEGER NOT NULL DEFAULT 0
    CHECK (current_participants >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (ends_at > starts_at)
);

CREATE INDEX IF NOT EXISTS idx_community_events_starts
  ON community_events(starts_at ASC);

CREATE INDEX IF NOT EXISTS idx_community_events_creator
  ON community_events(creator_id);

CREATE TABLE IF NOT EXISTS event_participants (
  event_id UUID NOT NULL REFERENCES community_events(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'registered'
    CHECK (status IN ('registered', 'cancelled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (event_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_event_participants_user
  ON event_participants(user_id);

-- Function to safely update participant count
CREATE OR REPLACE FUNCTION update_event_participant_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.status = 'registered') THEN
    UPDATE community_events
    SET current_participants = (
      SELECT count(*) FROM event_participants
      WHERE event_id = NEW.event_id AND status = 'registered'
    )
    WHERE id = NEW.event_id;
  ELSIF TG_OP = 'DELETE' OR (TG_OP = 'UPDATE' AND NEW.status = 'cancelled') THEN
    UPDATE community_events
    SET current_participants = (
      SELECT count(*) FROM event_participants
      WHERE event_id = COALESCE(NEW.event_id, OLD.event_id) AND status = 'registered'
    )
    WHERE id = COALESCE(NEW.event_id, OLD.event_id);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER trg_event_participants_count
  AFTER INSERT OR UPDATE OR DELETE ON event_participants
  FOR EACH ROW
  EXECUTE FUNCTION update_event_participant_count();

-- =============================================================================
-- RLS Policies: Community Events
-- =============================================================================

ALTER TABLE community_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_participants ENABLE ROW LEVEL SECURITY;

-- Events are publicly viewable by authenticated users
CREATE POLICY "Authenticated users can view events"
  ON community_events FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Only authenticated users can create events
CREATE POLICY "Authenticated users can create events"
  ON community_events FOR INSERT
  WITH CHECK (auth.uid() = creator_id);

-- Creators can update their own events
CREATE POLICY "Creators can update own events"
  ON community_events FOR UPDATE
  USING (auth.uid() = creator_id)
  WITH CHECK (auth.uid() = creator_id);

-- Creators can delete their own events
CREATE POLICY "Creators can delete own events"
  ON community_events FOR DELETE
  USING (auth.uid() = creator_id);

-- Event participants
CREATE POLICY "Authenticated users can view participants"
  ON event_participants FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "Users can register themselves"
  ON event_participants FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own registration"
  ON event_participants FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove own registration"
  ON event_participants FOR DELETE
  USING (auth.uid() = user_id);

-- =============================================================================
-- Chart of the Day
-- =============================================================================

CREATE TABLE IF NOT EXISTS chart_of_day (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  featured_date DATE NOT NULL UNIQUE,
  reason TEXT CHECK (char_length(reason) <= 500),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_chart_of_day_date
  ON chart_of_day(featured_date DESC);

ALTER TABLE chart_of_day ENABLE ROW LEVEL SECURITY;

-- Anyone authenticated can view chart of the day
CREATE POLICY "Authenticated users can view chart of day"
  ON chart_of_day FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Only service role (cron function) can insert — no client policy needed
