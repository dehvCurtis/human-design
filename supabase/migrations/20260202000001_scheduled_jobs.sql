-- ============================================================================
-- Scheduled Jobs Migration
-- Uses pg_cron extension to automate cleanup and maintenance tasks
-- ============================================================================
--
-- IMPORTANT: Before running this migration, you must enable pg_cron in Supabase:
-- 1. Go to Supabase Dashboard → Database → Extensions
-- 2. Search for "pg_cron"
-- 3. Enable the extension
--
-- After enabling, run: supabase db push
-- ============================================================================

-- Enable pg_cron extension (requires prior enablement in Supabase dashboard)
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Grant usage to postgres role
GRANT USAGE ON SCHEMA cron TO postgres;

-- ============================================================================
-- Job 1: Delete expired stories (every 2 hours)
-- Stories auto-expire 24 hours after creation but remain in database
-- This job cleans them up. Cascade deletes: story_views, story_reactions,
-- story_replies, story_polls, poll_options, poll_votes
-- ============================================================================
SELECT cron.schedule(
  'delete-expired-stories',
  '0 */2 * * *',  -- Every 2 hours at minute 0
  $$DELETE FROM public.stories WHERE expires_at < NOW()$$
);

-- ============================================================================
-- Job 2: Reset user weekly points (every Monday at 00:00 UTC)
-- Resets weekly_points for weekly leaderboard
-- ============================================================================
SELECT cron.schedule(
  'reset-user-weekly-points',
  '0 0 * * 1',  -- Monday at 00:00 UTC
  $$UPDATE public.user_points SET weekly_points = 0, updated_at = NOW()$$
);

-- ============================================================================
-- Job 3: Reset user monthly points (1st of month at 00:00 UTC)
-- Resets monthly_points for monthly leaderboard
-- ============================================================================
SELECT cron.schedule(
  'reset-user-monthly-points',
  '0 0 1 * *',  -- 1st of month at 00:00 UTC
  $$UPDATE public.user_points SET monthly_points = 0, updated_at = NOW()$$
);

-- ============================================================================
-- Job 4: Reset team weekly points (every Monday at 00:00 UTC)
-- Uses existing function from 20260122000005_group_challenges.sql
-- ============================================================================
SELECT cron.schedule(
  'reset-team-weekly-points',
  '0 0 * * 1',  -- Monday at 00:00 UTC
  $$SELECT public.reset_weekly_team_points()$$
);

-- ============================================================================
-- Job 5: Reset team monthly points (1st of month at 00:00 UTC)
-- Uses existing function from 20260122000005_group_challenges.sql
-- ============================================================================
SELECT cron.schedule(
  'reset-team-monthly-points',
  '0 0 1 * *',  -- 1st of month at 00:00 UTC
  $$SELECT public.reset_monthly_team_points()$$
);

-- ============================================================================
-- Verification Queries (run manually to verify setup)
-- ============================================================================
-- View all scheduled jobs:
--   SELECT * FROM cron.job;
--
-- View job execution history:
--   SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 20;
--
-- Manually trigger a job for testing:
--   SELECT cron.run(job_id) FROM cron.job WHERE jobname = 'delete-expired-stories';
--
-- Remove a job if needed:
--   SELECT cron.unschedule('job-name');
-- ============================================================================
