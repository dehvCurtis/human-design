-- Fix journal_entries table to match application code expectations
-- The table was created with different columns than the migration specified

-- Add missing columns
ALTER TABLE journal_entries
  ADD COLUMN IF NOT EXISTS entry_type TEXT NOT NULL DEFAULT 'dream'
    CHECK (entry_type IN ('dream', 'journal'));

ALTER TABLE journal_entries
  ADD COLUMN IF NOT EXISTS ai_interpretation TEXT;

ALTER TABLE journal_entries
  ADD COLUMN IF NOT EXISTS transit_sun_gate INTEGER;

ALTER TABLE journal_entries
  ADD COLUMN IF NOT EXISTS conversation_id UUID REFERENCES ai_conversations(id) ON DELETE SET NULL;

ALTER TABLE journal_entries
  ADD COLUMN IF NOT EXISTS prompt TEXT;

-- Copy data from old columns if they exist, then drop them
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'journal_entries' AND column_name = 'transit_gate') THEN
    UPDATE journal_entries SET transit_sun_gate = transit_gate WHERE transit_gate IS NOT NULL;
    ALTER TABLE journal_entries DROP COLUMN transit_gate;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'journal_entries' AND column_name = 'mood') THEN
    ALTER TABLE journal_entries DROP COLUMN mood;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'journal_entries' AND column_name = 'energy') THEN
    ALTER TABLE journal_entries DROP COLUMN energy;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'journal_entries' AND column_name = 'updated_at') THEN
    ALTER TABLE journal_entries DROP COLUMN updated_at;
  END IF;
END $$;

-- Create indexes if they don't exist
CREATE INDEX IF NOT EXISTS idx_journal_entries_user ON journal_entries(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_journal_entries_type ON journal_entries(user_id, entry_type, created_at DESC);
