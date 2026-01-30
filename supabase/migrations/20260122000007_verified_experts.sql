-- ============================================================================
-- Verified Expert System Migration
-- ============================================================================

-- Experts table
CREATE TABLE IF NOT EXISTS public.experts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    bio TEXT,
    specializations TEXT[] NOT NULL DEFAULT '{}',
    credentials TEXT[],
    years_of_experience INTEGER,
    website_url TEXT,
    social_links JSONB,
    verification_status TEXT NOT NULL DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'rejected')),
    verified_at TIMESTAMPTZ,
    follower_count INTEGER NOT NULL DEFAULT 0,
    content_count INTEGER NOT NULL DEFAULT 0,
    average_rating DECIMAL(2,1),
    review_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_experts_user ON public.experts(user_id);
CREATE INDEX IF NOT EXISTS idx_experts_status ON public.experts(verification_status);
CREATE INDEX IF NOT EXISTS idx_experts_specializations ON public.experts USING GIN(specializations);
CREATE INDEX IF NOT EXISTS idx_experts_followers ON public.experts(follower_count DESC);
CREATE INDEX IF NOT EXISTS idx_experts_rating ON public.experts(average_rating DESC);

-- Expert Applications table
CREATE TABLE IF NOT EXISTS public.expert_applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    bio TEXT NOT NULL,
    specializations TEXT[] NOT NULL,
    credentials TEXT[] NOT NULL,
    years_of_experience INTEGER,
    website_url TEXT,
    portfolio_urls TEXT[],
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'verified', 'rejected')),
    reviewed_at TIMESTAMPTZ,
    review_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_expert_applications_user ON public.expert_applications(user_id);
CREATE INDEX IF NOT EXISTS idx_expert_applications_status ON public.expert_applications(status);

-- Expert Follows table
CREATE TABLE IF NOT EXISTS public.expert_follows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expert_id UUID NOT NULL REFERENCES public.experts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(expert_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_expert_follows_expert ON public.expert_follows(expert_id);
CREATE INDEX IF NOT EXISTS idx_expert_follows_user ON public.expert_follows(user_id);

-- Expert Reviews table
CREATE TABLE IF NOT EXISTS public.expert_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expert_id UUID NOT NULL REFERENCES public.experts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    content TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(expert_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_expert_reviews_expert ON public.expert_reviews(expert_id);
CREATE INDEX IF NOT EXISTS idx_expert_reviews_user ON public.expert_reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_expert_reviews_rating ON public.expert_reviews(rating);

-- ============================================================================
-- Functions
-- ============================================================================

-- Function to increment expert follower count
CREATE OR REPLACE FUNCTION public.increment_expert_follower_count(target_expert_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.experts
    SET follower_count = follower_count + 1,
        updated_at = NOW()
    WHERE id = target_expert_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrement expert follower count
CREATE OR REPLACE FUNCTION public.decrement_expert_follower_count(target_expert_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.experts
    SET follower_count = GREATEST(0, follower_count - 1),
        updated_at = NOW()
    WHERE id = target_expert_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update expert rating
CREATE OR REPLACE FUNCTION public.update_expert_rating(target_expert_id UUID)
RETURNS VOID AS $$
DECLARE
    avg_rating DECIMAL(2,1);
    review_cnt INTEGER;
BEGIN
    SELECT AVG(rating)::DECIMAL(2,1), COUNT(*)
    INTO avg_rating, review_cnt
    FROM public.expert_reviews
    WHERE expert_id = target_expert_id;

    UPDATE public.experts
    SET average_rating = avg_rating,
        review_count = review_cnt,
        updated_at = NOW()
    WHERE id = target_expert_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- Row Level Security
-- ============================================================================

ALTER TABLE public.experts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expert_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expert_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expert_reviews ENABLE ROW LEVEL SECURITY;

-- Experts policies
CREATE POLICY "Verified experts are viewable by everyone"
    ON public.experts FOR SELECT
    USING (verification_status = 'verified' OR user_id = auth.uid());

CREATE POLICY "Users can update their own expert profile"
    ON public.experts FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid());

-- Expert applications policies
CREATE POLICY "Users can view their own applications"
    ON public.expert_applications FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "Authenticated users can create applications"
    ON public.expert_applications FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

-- Expert follows policies
CREATE POLICY "Expert follows are viewable by everyone"
    ON public.expert_follows FOR SELECT
    USING (true);

CREATE POLICY "Users can follow experts"
    ON public.expert_follows FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can unfollow experts"
    ON public.expert_follows FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- Expert reviews policies
CREATE POLICY "Expert reviews are viewable by everyone"
    ON public.expert_reviews FOR SELECT
    USING (true);

CREATE POLICY "Users can create reviews"
    ON public.expert_reviews FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own reviews"
    ON public.expert_reviews FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- Grant Permissions
-- ============================================================================

GRANT EXECUTE ON FUNCTION public.increment_expert_follower_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.decrement_expert_follower_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_expert_rating(UUID) TO authenticated;
