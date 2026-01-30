-- ============================================================================
-- Transit Events Feature Migration
-- ============================================================================

-- Transit Events table
CREATE TABLE IF NOT EXISTS public.transit_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    event_type TEXT NOT NULL,
    gate_number INTEGER NOT NULL CHECK (gate_number >= 1 AND gate_number <= 64),
    channel_id TEXT,
    planet TEXT NOT NULL,
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    image_url TEXT,
    participant_count INTEGER NOT NULL DEFAULT 0,
    post_count INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_event_dates CHECK (ends_at > starts_at)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_transit_events_dates ON public.transit_events(starts_at, ends_at);
CREATE INDEX IF NOT EXISTS idx_transit_events_gate ON public.transit_events(gate_number);
CREATE INDEX IF NOT EXISTS idx_transit_events_type ON public.transit_events(event_type);
CREATE INDEX IF NOT EXISTS idx_transit_events_active ON public.transit_events(is_active);

-- Transit Event Participants table
CREATE TABLE IF NOT EXISTS public.transit_event_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    event_id UUID NOT NULL REFERENCES public.transit_events(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reflection TEXT,
    mood TEXT,
    UNIQUE(user_id, event_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_transit_event_participants_user ON public.transit_event_participants(user_id);
CREATE INDEX IF NOT EXISTS idx_transit_event_participants_event ON public.transit_event_participants(event_id);

-- Transit Event Posts table (links posts to events)
CREATE TABLE IF NOT EXISTS public.transit_event_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    event_id UUID NOT NULL REFERENCES public.transit_events(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(post_id, event_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_transit_event_posts_event ON public.transit_event_posts(event_id);
CREATE INDEX IF NOT EXISTS idx_transit_event_posts_post ON public.transit_event_posts(post_id);

-- Function to increment event participants
CREATE OR REPLACE FUNCTION public.increment_event_participants(event_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.transit_events
    SET participant_count = participant_count + 1
    WHERE id = event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrement event participants
CREATE OR REPLACE FUNCTION public.decrement_event_participants(event_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.transit_events
    SET participant_count = GREATEST(participant_count - 1, 0)
    WHERE id = event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to increment event posts
CREATE OR REPLACE FUNCTION public.increment_event_posts(event_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.transit_events
    SET post_count = post_count + 1
    WHERE id = event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get event insights
CREATE OR REPLACE FUNCTION public.get_event_insights(target_event_id UUID)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'event_id', target_event_id,
        'total_participants', (
            SELECT COUNT(*) FROM public.transit_event_participants
            WHERE event_id = target_event_id
        ),
        'total_posts', (
            SELECT COUNT(*) FROM public.transit_event_posts
            WHERE event_id = target_event_id
        ),
        'mood_distribution', (
            SELECT json_object_agg(mood, count)
            FROM (
                SELECT mood, COUNT(*) as count
                FROM public.transit_event_participants
                WHERE event_id = target_event_id AND mood IS NOT NULL
                GROUP BY mood
            ) m
        ),
        'type_distribution', (
            SELECT json_object_agg(hd_type, count)
            FROM (
                SELECT p.hd_type, COUNT(*) as count
                FROM public.transit_event_participants tep
                JOIN public.profiles p ON p.id = tep.user_id
                WHERE tep.event_id = target_event_id AND p.hd_type IS NOT NULL
                GROUP BY p.hd_type
            ) t
        )
    ) INTO result;

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Row Level Security
ALTER TABLE public.transit_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transit_event_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transit_event_posts ENABLE ROW LEVEL SECURITY;

-- Transit events are readable by everyone
CREATE POLICY "Transit events are viewable by everyone"
    ON public.transit_events FOR SELECT
    USING (true);

-- Service role can manage transit events (server-side administration)
-- Note: Transit events are managed via Supabase dashboard or Edge Functions
CREATE POLICY "Service role can manage transit events"
    ON public.transit_events FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- Participants can view all participants
CREATE POLICY "Participants are viewable by everyone"
    ON public.transit_event_participants FOR SELECT
    USING (true);

-- Users can manage their own participation
CREATE POLICY "Users can manage own participation"
    ON public.transit_event_participants FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own participation"
    ON public.transit_event_participants FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid());

CREATE POLICY "Users can delete own participation"
    ON public.transit_event_participants FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- Event posts are viewable by everyone
CREATE POLICY "Event posts are viewable by everyone"
    ON public.transit_event_posts FOR SELECT
    USING (true);

-- Post owners can link their posts to events
CREATE POLICY "Post owners can link posts to events"
    ON public.transit_event_posts FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.posts
            WHERE id = post_id AND user_id = auth.uid()
        )
    );

-- Grant execute permissions on functions
GRANT EXECUTE ON FUNCTION public.increment_event_participants(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.decrement_event_participants(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.increment_event_posts(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_event_insights(UUID) TO authenticated;
