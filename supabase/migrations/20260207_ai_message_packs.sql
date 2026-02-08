-- Add bonus_messages column to ai_usage table
ALTER TABLE ai_usage
  ADD COLUMN IF NOT EXISTS bonus_messages integer NOT NULL DEFAULT 0;

-- RPC function to add bonus messages from a purchased pack
CREATE OR REPLACE FUNCTION add_ai_bonus_messages(
  p_user_id uuid,
  p_period_start date,
  p_count integer
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO ai_usage (user_id, period_start, messages_count, bonus_messages)
  VALUES (p_user_id, p_period_start, 0, p_count)
  ON CONFLICT (user_id, period_start)
  DO UPDATE SET bonus_messages = ai_usage.bonus_messages + p_count;
END;
$$;

-- Table to log message pack purchases for auditing
CREATE TABLE IF NOT EXISTS ai_purchases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message_count integer NOT NULL,
  product_id text NOT NULL DEFAULT '',
  price numeric(10, 2) NOT NULL DEFAULT 0,
  currency text NOT NULL DEFAULT 'USD',
  created_at timestamptz NOT NULL DEFAULT now()
);

-- RLS policies for ai_purchases
ALTER TABLE ai_purchases ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own purchases"
  ON ai_purchases FOR SELECT
  USING (auth.uid() = user_id);

-- Index for lookup by user
CREATE INDEX IF NOT EXISTS idx_ai_purchases_user_id ON ai_purchases(user_id);
