-- Create chart visibility enum type
DO $$ BEGIN
  CREATE TYPE chart_visibility AS ENUM ('private', 'friends', 'public');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Add chart_visibility column (keep show_chart_publicly for backward compat temporarily)
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS chart_visibility chart_visibility DEFAULT 'private';

-- Migrate existing data: show_chart_publicly TRUE -> 'public', FALSE -> 'private'
UPDATE public.profiles
SET chart_visibility = CASE
  WHEN show_chart_publicly = true THEN 'public'::chart_visibility
  ELSE 'private'::chart_visibility
END
WHERE chart_visibility IS NULL OR chart_visibility = 'private';

-- Index for popular charts query (users with public charts sorted by followers)
CREATE INDEX IF NOT EXISTS idx_profiles_chart_visibility
ON public.profiles(chart_visibility, follower_count DESC)
WHERE chart_visibility = 'public';

-- RLS policy to allow users to see chart_visibility for public profiles
-- (existing RLS policies should already handle profile access)
