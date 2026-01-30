-- ============================================================================
-- Group Challenges & Team Leaderboards Migration
-- ============================================================================

-- Challenge Teams table
CREATE TABLE IF NOT EXISTS public.challenge_teams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    avatar_url TEXT,
    creator_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    total_points INTEGER NOT NULL DEFAULT 0,
    weekly_points INTEGER NOT NULL DEFAULT 0,
    monthly_points INTEGER NOT NULL DEFAULT 0,
    member_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_challenge_teams_creator ON public.challenge_teams(creator_id);
CREATE INDEX IF NOT EXISTS idx_challenge_teams_total_points ON public.challenge_teams(total_points DESC);
CREATE INDEX IF NOT EXISTS idx_challenge_teams_weekly_points ON public.challenge_teams(weekly_points DESC);
CREATE INDEX IF NOT EXISTS idx_challenge_teams_monthly_points ON public.challenge_teams(monthly_points DESC);

-- Team Members table
CREATE TABLE IF NOT EXISTS public.team_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id UUID NOT NULL REFERENCES public.challenge_teams(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('admin', 'member')),
    points_contributed INTEGER NOT NULL DEFAULT 0,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(team_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_team_members_team ON public.team_members(team_id);
CREATE INDEX IF NOT EXISTS idx_team_members_user ON public.team_members(user_id);
CREATE INDEX IF NOT EXISTS idx_team_members_points ON public.team_members(points_contributed DESC);

-- Group Challenges table
CREATE TABLE IF NOT EXISTS public.group_challenges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    challenge_type TEXT NOT NULL CHECK (challenge_type IN ('team_posts', 'team_reactions', 'team_comments', 'team_quizzes', 'team_streaks')),
    hd_type_filter TEXT[],
    target_value INTEGER NOT NULL,
    points_reward INTEGER NOT NULL DEFAULT 100,
    is_active BOOLEAN NOT NULL DEFAULT true,
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    team_count INTEGER NOT NULL DEFAULT 0,
    total_participants INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_group_challenges_active ON public.group_challenges(is_active);
CREATE INDEX IF NOT EXISTS idx_group_challenges_end_date ON public.group_challenges(end_date);

-- Team Challenge Progress table
CREATE TABLE IF NOT EXISTS public.team_challenge_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id UUID NOT NULL REFERENCES public.challenge_teams(id) ON DELETE CASCADE,
    challenge_id UUID NOT NULL REFERENCES public.group_challenges(id) ON DELETE CASCADE,
    progress INTEGER NOT NULL DEFAULT 0,
    is_completed BOOLEAN NOT NULL DEFAULT false,
    completed_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(team_id, challenge_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_team_challenge_progress_team ON public.team_challenge_progress(team_id);
CREATE INDEX IF NOT EXISTS idx_team_challenge_progress_challenge ON public.team_challenge_progress(challenge_id);
CREATE INDEX IF NOT EXISTS idx_team_challenge_progress_progress ON public.team_challenge_progress(progress DESC);

-- ============================================================================
-- Functions
-- ============================================================================

-- Function to increment team member count
CREATE OR REPLACE FUNCTION public.increment_team_member_count(target_team_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.challenge_teams
    SET member_count = member_count + 1,
        updated_at = NOW()
    WHERE id = target_team_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrement team member count
CREATE OR REPLACE FUNCTION public.decrement_team_member_count(target_team_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.challenge_teams
    SET member_count = GREATEST(0, member_count - 1),
        updated_at = NOW()
    WHERE id = target_team_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to increment team challenge progress
CREATE OR REPLACE FUNCTION public.increment_team_challenge_progress(
    target_team_id UUID,
    target_challenge_id UUID,
    increment INTEGER
)
RETURNS VOID AS $$
DECLARE
    target_value INTEGER;
    current_progress INTEGER;
BEGIN
    -- Get target value for the challenge
    SELECT gc.target_value INTO target_value
    FROM public.group_challenges gc
    WHERE gc.id = target_challenge_id;

    -- Update progress
    UPDATE public.team_challenge_progress
    SET progress = progress + increment,
        updated_at = NOW(),
        is_completed = CASE
            WHEN progress + increment >= target_value THEN true
            ELSE is_completed
        END,
        completed_at = CASE
            WHEN progress + increment >= target_value AND completed_at IS NULL THEN NOW()
            ELSE completed_at
        END
    WHERE team_id = target_team_id AND challenge_id = target_challenge_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to contribute points to team
CREATE OR REPLACE FUNCTION public.contribute_points_to_team(
    target_team_id UUID,
    contributor_id UUID,
    points INTEGER
)
RETURNS VOID AS $$
BEGIN
    -- Update member's contribution
    UPDATE public.team_members
    SET points_contributed = points_contributed + points
    WHERE team_id = target_team_id AND user_id = contributor_id;

    -- Update team's total points
    UPDATE public.challenge_teams
    SET total_points = total_points + points,
        weekly_points = weekly_points + points,
        monthly_points = monthly_points + points,
        updated_at = NOW()
    WHERE id = target_team_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to reset weekly points (should be called by a cron job)
CREATE OR REPLACE FUNCTION public.reset_weekly_team_points()
RETURNS VOID AS $$
BEGIN
    UPDATE public.challenge_teams
    SET weekly_points = 0,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to reset monthly points (should be called by a cron job)
CREATE OR REPLACE FUNCTION public.reset_monthly_team_points()
RETURNS VOID AS $$
BEGIN
    UPDATE public.challenge_teams
    SET monthly_points = 0,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- Row Level Security
-- ============================================================================

ALTER TABLE public.challenge_teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_challenge_progress ENABLE ROW LEVEL SECURITY;

-- Challenge teams policies
CREATE POLICY "Challenge teams are viewable by everyone"
    ON public.challenge_teams FOR SELECT
    USING (true);

CREATE POLICY "Authenticated users can create teams"
    ON public.challenge_teams FOR INSERT
    TO authenticated
    WITH CHECK (creator_id = auth.uid());

CREATE POLICY "Team creators can update their teams"
    ON public.challenge_teams FOR UPDATE
    TO authenticated
    USING (creator_id = auth.uid());

-- Team members policies
CREATE POLICY "Team members are viewable by everyone"
    ON public.team_members FOR SELECT
    USING (true);

CREATE POLICY "Users can join teams"
    ON public.team_members FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can leave teams"
    ON public.team_members FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());

-- Group challenges policies
CREATE POLICY "Group challenges are viewable by everyone"
    ON public.group_challenges FOR SELECT
    USING (true);

-- Team challenge progress policies
CREATE POLICY "Team challenge progress is viewable by everyone"
    ON public.team_challenge_progress FOR SELECT
    USING (true);

CREATE POLICY "Team members can enroll their team"
    ON public.team_challenge_progress FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.team_members
            WHERE team_id = team_challenge_progress.team_id
            AND user_id = auth.uid()
            AND role = 'admin'
        )
    );

-- ============================================================================
-- Grant Permissions
-- ============================================================================

GRANT EXECUTE ON FUNCTION public.increment_team_member_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.decrement_team_member_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.increment_team_challenge_progress(UUID, UUID, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.contribute_points_to_team(UUID, UUID, INTEGER) TO authenticated;

-- ============================================================================
-- Seed Data: Sample Group Challenges
-- ============================================================================

INSERT INTO public.group_challenges (title, description, challenge_type, target_value, points_reward, is_active, start_date, end_date) VALUES
    ('Team Post Sprint', 'Your team creates 50 posts together this week', 'team_posts', 50, 500, true, NOW(), NOW() + INTERVAL '7 days'),
    ('Reaction Rally', 'Your team gives 100 reactions to posts', 'team_reactions', 100, 300, true, NOW(), NOW() + INTERVAL '7 days'),
    ('Comment Champions', 'Your team leaves 75 thoughtful comments', 'team_comments', 75, 400, true, NOW(), NOW() + INTERVAL '14 days'),
    ('Quiz Masters', 'Your team completes 30 quizzes together', 'team_quizzes', 30, 600, true, NOW(), NOW() + INTERVAL '30 days'),
    ('Streak Keepers', 'Team members maintain 7-day login streaks', 'team_streaks', 7, 350, true, NOW(), NOW() + INTERVAL '10 days');
