-- ============================================================================
-- Friend Activity Feed Feature Migration
-- ============================================================================

-- Activities table
CREATE TABLE IF NOT EXISTS public.activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    target_id TEXT,
    target_name TEXT,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_activities_user ON public.activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_type ON public.activities(activity_type);
CREATE INDEX IF NOT EXISTS idx_activities_created ON public.activities(created_at DESC);

-- Activity Reactions table
CREATE TABLE IF NOT EXISTS public.activity_reactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    reaction_type TEXT NOT NULL DEFAULT 'celebrate',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(activity_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_activity_reactions_activity ON public.activity_reactions(activity_id);
CREATE INDEX IF NOT EXISTS idx_activity_reactions_user ON public.activity_reactions(user_id);

-- Function to get friend activities
CREATE OR REPLACE FUNCTION public.get_friend_activities(
    current_user_id UUID,
    limit_count INTEGER DEFAULT 50,
    offset_count INTEGER DEFAULT 0
)
RETURNS SETOF JSON AS $$
BEGIN
    RETURN QUERY
    SELECT json_build_object(
        'id', a.id,
        'user_id', a.user_id,
        'activity_type', a.activity_type,
        'target_id', a.target_id,
        'target_name', a.target_name,
        'metadata', a.metadata,
        'created_at', a.created_at,
        'user', json_build_object(
            'id', p.id,
            'name', p.name,
            'avatar_url', p.avatar_url,
            'hd_type', p.hd_type
        )
    )
    FROM public.activities a
    JOIN public.profiles p ON p.id = a.user_id
    WHERE a.user_id IN (
        SELECT following_id
        FROM public.user_follows
        WHERE follower_id = current_user_id
    )
    ORDER BY a.created_at DESC
    LIMIT limit_count
    OFFSET offset_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get following IDs for a user
CREATE OR REPLACE FUNCTION public.get_following_ids(user_id UUID)
RETURNS UUID[] AS $$
BEGIN
    RETURN ARRAY(
        SELECT following_id
        FROM public.user_follows
        WHERE follower_id = user_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger function to create activity on various events
CREATE OR REPLACE FUNCTION public.create_activity_on_event()
RETURNS TRIGGER AS $$
BEGIN
    -- This is a placeholder for trigger logic
    -- Different tables would call this with appropriate activity types
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Row Level Security
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_reactions ENABLE ROW LEVEL SECURITY;

-- Activities are viewable by everyone (for friend feed filtering)
CREATE POLICY "Activities are viewable by everyone"
    ON public.activities FOR SELECT
    USING (true);

-- Users can create their own activities
CREATE POLICY "Users can create own activities"
    ON public.activities FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

-- Activity reactions are viewable by everyone
CREATE POLICY "Activity reactions are viewable by everyone"
    ON public.activity_reactions FOR SELECT
    USING (true);

-- Users can manage their own reactions
CREATE POLICY "Users can create own reactions"
    ON public.activity_reactions FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own reactions"
    ON public.activity_reactions FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION public.get_friend_activities(UUID, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_following_ids(UUID) TO authenticated;
