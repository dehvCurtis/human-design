-- ============================================================================
-- Hashtags Feature Migration
-- ============================================================================

-- Hashtags table
CREATE TABLE IF NOT EXISTS public.hashtags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    post_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_used_at TIMESTAMPTZ,
    CONSTRAINT hashtag_name_format CHECK (name ~ '^[a-z0-9]+$')
);

-- Create index for hashtag name lookups
CREATE INDEX IF NOT EXISTS idx_hashtags_name ON public.hashtags(name);
CREATE INDEX IF NOT EXISTS idx_hashtags_post_count ON public.hashtags(post_count DESC);

-- Post-Hashtag association table
CREATE TABLE IF NOT EXISTS public.post_hashtags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    hashtag_id UUID NOT NULL REFERENCES public.hashtags(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(post_id, hashtag_id)
);

-- Create indexes for efficient lookups
CREATE INDEX IF NOT EXISTS idx_post_hashtags_post_id ON public.post_hashtags(post_id);
CREATE INDEX IF NOT EXISTS idx_post_hashtags_hashtag_id ON public.post_hashtags(hashtag_id);
CREATE INDEX IF NOT EXISTS idx_post_hashtags_created_at ON public.post_hashtags(created_at DESC);

-- Function to increment hashtag count
CREATE OR REPLACE FUNCTION public.increment_hashtag_count(hashtag_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.hashtags
    SET post_count = post_count + 1,
        last_used_at = NOW()
    WHERE id = hashtag_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrement hashtag count
CREATE OR REPLACE FUNCTION public.decrement_hashtag_count(hashtag_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.hashtags
    SET post_count = GREATEST(post_count - 1, 0)
    WHERE id = hashtag_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get trending hashtags (most used in last 24 hours)
CREATE OR REPLACE FUNCTION public.get_trending_hashtags(limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
    id UUID,
    name TEXT,
    post_count INTEGER,
    created_at TIMESTAMPTZ,
    last_used_at TIMESTAMPTZ,
    recent_post_count BIGINT,
    trend_score NUMERIC,
    percent_change NUMERIC
) AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get hashtag usage history
CREATE OR REPLACE FUNCTION public.get_hashtag_usage_history(
    target_hashtag_id UUID,
    days_back INTEGER DEFAULT 7
)
RETURNS TABLE (
    date DATE,
    post_count BIGINT
) AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Row Level Security
ALTER TABLE public.hashtags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_hashtags ENABLE ROW LEVEL SECURITY;

-- Hashtags are readable by everyone
CREATE POLICY "Hashtags are viewable by everyone"
    ON public.hashtags FOR SELECT
    USING (true);

-- Hashtags can be created by authenticated users
CREATE POLICY "Authenticated users can create hashtags"
    ON public.hashtags FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Post hashtags are viewable by everyone
CREATE POLICY "Post hashtags are viewable by everyone"
    ON public.post_hashtags FOR SELECT
    USING (true);

-- Post hashtags can be created by the post owner
CREATE POLICY "Post owners can add hashtags"
    ON public.post_hashtags FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.posts
            WHERE id = post_id AND user_id = auth.uid()
        )
    );

-- Post hashtags can be deleted by the post owner
CREATE POLICY "Post owners can remove hashtags"
    ON public.post_hashtags FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.posts
            WHERE id = post_id AND user_id = auth.uid()
        )
    );

-- Grant execute permissions on functions
GRANT EXECUTE ON FUNCTION public.increment_hashtag_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.decrement_hashtag_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_trending_hashtags(INTEGER) TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.get_hashtag_usage_history(UUID, INTEGER) TO authenticated;
