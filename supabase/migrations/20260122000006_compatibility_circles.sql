-- ============================================================================
-- Compatibility Circles Migration
-- ============================================================================

-- Compatibility Circles table
CREATE TABLE IF NOT EXISTS public.compatibility_circles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    icon_emoji TEXT DEFAULT '\u2B50',
    creator_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    member_count INTEGER NOT NULL DEFAULT 0,
    is_private BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_compatibility_circles_creator ON public.compatibility_circles(creator_id);

-- Circle Members table
CREATE TABLE IF NOT EXISTS public.circle_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID NOT NULL REFERENCES public.compatibility_circles(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('creator', 'admin', 'member')),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(circle_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_circle_members_circle ON public.circle_members(circle_id);
CREATE INDEX IF NOT EXISTS idx_circle_members_user ON public.circle_members(user_id);

-- Circle Invitations table
CREATE TABLE IF NOT EXISTS public.circle_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID NOT NULL REFERENCES public.compatibility_circles(id) ON DELETE CASCADE,
    inviter_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    invitee_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(circle_id, invitee_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_circle_invitations_invitee ON public.circle_invitations(invitee_id);

-- Circle Posts table (private feed for circle members)
CREATE TABLE IF NOT EXISTS public.circle_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID NOT NULL REFERENCES public.compatibility_circles(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    media_url TEXT,
    reaction_count INTEGER NOT NULL DEFAULT 0,
    comment_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_circle_posts_circle ON public.circle_posts(circle_id);
CREATE INDEX IF NOT EXISTS idx_circle_posts_user ON public.circle_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_circle_posts_created ON public.circle_posts(created_at DESC);

-- Circle Compatibility Analyses table (cached analysis results)
CREATE TABLE IF NOT EXISTS public.circle_compatibility_analyses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID NOT NULL REFERENCES public.compatibility_circles(id) ON DELETE CASCADE,
    members JSONB NOT NULL,
    type_distribution JSONB NOT NULL,
    electromagnetic_connections JSONB NOT NULL DEFAULT '[]',
    companionship_connections JSONB NOT NULL DEFAULT '[]',
    dominance_connections JSONB NOT NULL DEFAULT '[]',
    compromise_connections JSONB NOT NULL DEFAULT '[]',
    defined_centers JSONB NOT NULL DEFAULT '[]',
    group_strengths JSONB NOT NULL DEFAULT '[]',
    areas_for_growth JSONB NOT NULL DEFAULT '[]',
    overall_harmony_score DECIMAL(3,2) NOT NULL DEFAULT 0.5,
    analyzed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_circle_analyses_circle ON public.circle_compatibility_analyses(circle_id);
CREATE INDEX IF NOT EXISTS idx_circle_analyses_date ON public.circle_compatibility_analyses(analyzed_at DESC);

-- ============================================================================
-- Functions
-- ============================================================================

-- Function to increment circle member count
CREATE OR REPLACE FUNCTION public.increment_circle_member_count(target_circle_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.compatibility_circles
    SET member_count = member_count + 1,
        updated_at = NOW()
    WHERE id = target_circle_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrement circle member count
CREATE OR REPLACE FUNCTION public.decrement_circle_member_count(target_circle_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.compatibility_circles
    SET member_count = GREATEST(0, member_count - 1),
        updated_at = NOW()
    WHERE id = target_circle_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Placeholder function for circle compatibility analysis
-- In production, this would be replaced with actual HD calculation logic
CREATE OR REPLACE FUNCTION public.analyze_circle_compatibility(target_circle_id UUID)
RETURNS VOID AS $$
DECLARE
    member_data JSONB;
    type_dist JSONB;
BEGIN
    -- Get member data
    SELECT jsonb_agg(jsonb_build_object(
        'user_id', cm.user_id,
        'user_name', p.name,
        'hd_type', p.hd_type,
        'hd_authority', p.hd_authority,
        'hd_profile', p.hd_profile,
        'role_in_group', 'Participant',
        'unique_contributions', '["Contributing to group energy"]'::jsonb
    ))
    INTO member_data
    FROM public.circle_members cm
    JOIN public.profiles p ON p.id = cm.user_id
    WHERE cm.circle_id = target_circle_id;

    -- Calculate type distribution
    SELECT jsonb_object_agg(hd_type, type_count)
    INTO type_dist
    FROM (
        SELECT p.hd_type, COUNT(*) as type_count
        FROM public.circle_members cm
        JOIN public.profiles p ON p.id = cm.user_id
        WHERE cm.circle_id = target_circle_id AND p.hd_type IS NOT NULL
        GROUP BY p.hd_type
    ) type_counts;

    -- Insert analysis result
    INSERT INTO public.circle_compatibility_analyses (
        circle_id,
        members,
        type_distribution,
        electromagnetic_connections,
        companionship_connections,
        dominance_connections,
        compromise_connections,
        defined_centers,
        group_strengths,
        areas_for_growth,
        overall_harmony_score,
        analyzed_at
    ) VALUES (
        target_circle_id,
        COALESCE(member_data, '[]'::jsonb),
        COALESCE(type_dist, '{}'::jsonb),
        '[]'::jsonb,
        '[]'::jsonb,
        '[]'::jsonb,
        '[]'::jsonb,
        '[]'::jsonb,
        '["Diverse perspectives", "Complementary energies"]'::jsonb,
        '["Communication styles may differ", "Practice patience with different rhythms"]'::jsonb,
        0.75,
        NOW()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- Row Level Security
-- ============================================================================

ALTER TABLE public.compatibility_circles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.circle_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.circle_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.circle_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.circle_compatibility_analyses ENABLE ROW LEVEL SECURITY;

-- Compatibility circles policies
CREATE POLICY "Circles are viewable by members"
    ON public.compatibility_circles FOR SELECT
    USING (
        NOT is_private OR
        creator_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.circle_members
            WHERE circle_id = id AND user_id = auth.uid()
        )
    );

CREATE POLICY "Authenticated users can create circles"
    ON public.compatibility_circles FOR INSERT
    TO authenticated
    WITH CHECK (creator_id = auth.uid());

CREATE POLICY "Circle creators can update their circles"
    ON public.compatibility_circles FOR UPDATE
    TO authenticated
    USING (creator_id = auth.uid());

CREATE POLICY "Circle creators can delete their circles"
    ON public.compatibility_circles FOR DELETE
    TO authenticated
    USING (creator_id = auth.uid());

-- Circle members policies
CREATE POLICY "Circle members are viewable by circle members"
    ON public.circle_members FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.circle_members cm
            WHERE cm.circle_id = circle_members.circle_id AND cm.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can join circles"
    ON public.circle_members FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can leave circles"
    ON public.circle_members FOR DELETE
    TO authenticated
    USING (
        user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.circle_members
            WHERE circle_id = circle_members.circle_id
            AND user_id = auth.uid()
            AND role IN ('creator', 'admin')
        )
    );

-- Circle invitations policies
CREATE POLICY "Invitations are viewable by invitee"
    ON public.circle_invitations FOR SELECT
    USING (invitee_id = auth.uid());

CREATE POLICY "Circle members can create invitations"
    ON public.circle_invitations FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.circle_members
            WHERE circle_id = circle_invitations.circle_id AND user_id = auth.uid()
        )
    );

CREATE POLICY "Invitees can delete invitations"
    ON public.circle_invitations FOR DELETE
    TO authenticated
    USING (invitee_id = auth.uid());

-- Circle posts policies
CREATE POLICY "Circle posts are viewable by circle members"
    ON public.circle_posts FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.circle_members
            WHERE circle_id = circle_posts.circle_id AND user_id = auth.uid()
        )
    );

CREATE POLICY "Circle members can create posts"
    ON public.circle_posts FOR INSERT
    TO authenticated
    WITH CHECK (
        user_id = auth.uid() AND
        EXISTS (
            SELECT 1 FROM public.circle_members
            WHERE circle_id = circle_posts.circle_id AND user_id = auth.uid()
        )
    );

CREATE POLICY "Post authors can delete their posts"
    ON public.circle_posts FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- Circle analyses policies
CREATE POLICY "Circle analyses are viewable by circle members"
    ON public.circle_compatibility_analyses FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.circle_members
            WHERE circle_id = circle_compatibility_analyses.circle_id AND user_id = auth.uid()
        )
    );

-- ============================================================================
-- Grant Permissions
-- ============================================================================

GRANT EXECUTE ON FUNCTION public.increment_circle_member_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.decrement_circle_member_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.analyze_circle_compatibility(UUID) TO authenticated;
