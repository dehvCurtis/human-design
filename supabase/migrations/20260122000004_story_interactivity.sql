-- ============================================================================
-- Story Interactivity Feature Migration
-- ============================================================================

-- Story Reactions table
CREATE TABLE IF NOT EXISTS public.story_reactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    story_id UUID NOT NULL REFERENCES public.stories(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    reaction_type TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(story_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_story_reactions_story ON public.story_reactions(story_id);
CREATE INDEX IF NOT EXISTS idx_story_reactions_user ON public.story_reactions(user_id);

-- Story Replies table
CREATE TABLE IF NOT EXISTS public.story_replies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    story_id UUID NOT NULL REFERENCES public.stories(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_story_replies_story ON public.story_replies(story_id);
CREATE INDEX IF NOT EXISTS idx_story_replies_user ON public.story_replies(user_id);

-- Story Polls table
CREATE TABLE IF NOT EXISTS public.story_polls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    story_id UUID NOT NULL REFERENCES public.stories(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(story_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_story_polls_story ON public.story_polls(story_id);

-- Poll Options table
CREATE TABLE IF NOT EXISTS public.poll_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES public.story_polls(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    vote_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_poll_options_poll ON public.poll_options(poll_id);

-- Poll Votes table
CREATE TABLE IF NOT EXISTS public.poll_votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES public.story_polls(id) ON DELETE CASCADE,
    option_id UUID NOT NULL REFERENCES public.poll_options(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(poll_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_poll_votes_poll ON public.poll_votes(poll_id);
CREATE INDEX IF NOT EXISTS idx_poll_votes_option ON public.poll_votes(option_id);
CREATE INDEX IF NOT EXISTS idx_poll_votes_user ON public.poll_votes(user_id);

-- Function to increment poll option vote count
CREATE OR REPLACE FUNCTION public.increment_poll_option_count(option_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.poll_options
    SET vote_count = vote_count + 1
    WHERE id = option_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Row Level Security
ALTER TABLE public.story_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.story_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.story_polls ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poll_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poll_votes ENABLE ROW LEVEL SECURITY;

-- Story reactions policies
CREATE POLICY "Story reactions are viewable by story owner and reactor"
    ON public.story_reactions FOR SELECT
    USING (
        user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.stories
            WHERE id = story_id AND user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create own reactions"
    ON public.story_reactions FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own reactions"
    ON public.story_reactions FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- Story replies policies
CREATE POLICY "Story replies are viewable by story owner and replier"
    ON public.story_replies FOR SELECT
    USING (
        user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.stories
            WHERE id = story_id AND user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create replies"
    ON public.story_replies FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

-- Story polls policies
CREATE POLICY "Story polls are viewable by everyone"
    ON public.story_polls FOR SELECT
    USING (true);

CREATE POLICY "Story owners can create polls"
    ON public.story_polls FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.stories
            WHERE id = story_id AND user_id = auth.uid()
        )
    );

-- Poll options policies
CREATE POLICY "Poll options are viewable by everyone"
    ON public.poll_options FOR SELECT
    USING (true);

CREATE POLICY "Poll creators can add options"
    ON public.poll_options FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.story_polls sp
            JOIN public.stories s ON s.id = sp.story_id
            WHERE sp.id = poll_id AND s.user_id = auth.uid()
        )
    );

-- Poll votes policies
CREATE POLICY "Poll votes are viewable by voter and poll creator"
    ON public.poll_votes FOR SELECT
    USING (
        user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.story_polls sp
            JOIN public.stories s ON s.id = sp.story_id
            WHERE sp.id = poll_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create own votes"
    ON public.poll_votes FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION public.increment_poll_option_count(UUID) TO authenticated;
