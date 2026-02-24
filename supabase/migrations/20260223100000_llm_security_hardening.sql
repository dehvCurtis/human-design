-- LLM Security Hardening Migration
-- Fixes: ai_purchases redeemed column (CRITICAL), DB-backed rate limiting (HIGH)

-- ============================================================================
-- 1. CRITICAL: Add missing redeemed/redeemed_at columns to ai_purchases
-- The grant-bonus-messages Edge Function reads/writes these columns but they
-- were never created. Without them, any purchase_id can be redeemed unlimited
-- times for free AI messages.
-- ============================================================================

ALTER TABLE ai_purchases
  ADD COLUMN IF NOT EXISTS redeemed boolean NOT NULL DEFAULT false;

ALTER TABLE ai_purchases
  ADD COLUMN IF NOT EXISTS redeemed_at timestamptz;

-- Index for quick lookup of unredeemed purchases
CREATE INDEX IF NOT EXISTS idx_ai_purchases_unredeemed
  ON ai_purchases(user_id, redeemed) WHERE NOT redeemed;

-- ============================================================================
-- 2. HIGH: DB-backed rate limiting table
-- The in-memory rate limiter in the Edge Function is per-instance and resets
-- on cold start. This table provides a persistent, cross-instance rate limit.
-- ============================================================================

CREATE TABLE IF NOT EXISTS ai_rate_limits (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  request_timestamps timestamptz[] NOT NULL DEFAULT '{}'
);

ALTER TABLE ai_rate_limits ENABLE ROW LEVEL SECURITY;

-- No client access — only service_role (Edge Function) can read/write
-- RLS is enabled with no policies = deny all for anon/authenticated

-- Atomic rate limit check + record function
-- Returns TRUE if allowed, FALSE if rate limited
CREATE OR REPLACE FUNCTION check_ai_rate_limit(
  p_user_id uuid,
  p_window_seconds int DEFAULT 60,
  p_max_requests int DEFAULT 10
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cutoff timestamptz;
  v_recent timestamptz[];
  v_count int;
BEGIN
  v_cutoff := now() - (p_window_seconds || ' seconds')::interval;

  -- Upsert: create row if not exists
  INSERT INTO ai_rate_limits (user_id, request_timestamps)
  VALUES (p_user_id, ARRAY[now()])
  ON CONFLICT (user_id) DO UPDATE
    SET request_timestamps = (
      -- Filter to only recent timestamps, then append current
      SELECT array_append(
        array_agg(ts ORDER BY ts)
          FILTER (WHERE ts > v_cutoff),
        now()
      )
      FROM unnest(ai_rate_limits.request_timestamps) AS ts
    );

  -- Read back the count of recent timestamps
  SELECT coalesce(array_length(request_timestamps, 1), 0)
  INTO v_count
  FROM ai_rate_limits
  WHERE user_id = p_user_id;

  -- If we exceed the limit (count includes the one we just added), deny
  IF v_count > p_max_requests THEN
    -- Remove the timestamp we just added (rollback the record)
    UPDATE ai_rate_limits
    SET request_timestamps = (
      SELECT coalesce(
        array_agg(ts ORDER BY ts),
        '{}'::timestamptz[]
      )
      FROM (
        SELECT ts, row_number() OVER (ORDER BY ts DESC) AS rn
        FROM unnest(request_timestamps) AS ts
      ) sub
      WHERE rn > 1  -- remove the most recent (the one we just added)
    )
    WHERE user_id = p_user_id;

    RETURN false;
  END IF;

  RETURN true;
END;
$$;

-- Only service_role can call this
REVOKE EXECUTE ON FUNCTION check_ai_rate_limit(uuid, int, int) FROM authenticated;
REVOKE EXECUTE ON FUNCTION check_ai_rate_limit(uuid, int, int) FROM anon;
REVOKE EXECUTE ON FUNCTION check_ai_rate_limit(uuid, int, int) FROM public;

-- ============================================================================
-- 3. HIGH: Decrement AI usage function (for rollback on failed AI calls)
-- Used when usage is pre-incremented but the AI provider call fails.
-- ============================================================================

CREATE OR REPLACE FUNCTION decrement_ai_usage(
  p_user_id uuid,
  p_period_start date
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE ai_usage
  SET messages_count = GREATEST(messages_count - 1, 0)
  WHERE user_id = p_user_id
    AND period_start = p_period_start;
END;
$$;

-- Only service_role can call this
REVOKE EXECUTE ON FUNCTION decrement_ai_usage(uuid, date) FROM authenticated;
REVOKE EXECUTE ON FUNCTION decrement_ai_usage(uuid, date) FROM anon;
REVOKE EXECUTE ON FUNCTION decrement_ai_usage(uuid, date) FROM public;
