-- Journal entries table for dream journal and journaling prompts features
CREATE TABLE IF NOT EXISTS journal_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  entry_type TEXT NOT NULL DEFAULT 'dream' CHECK (entry_type IN ('dream', 'journal')),
  ai_interpretation TEXT,
  transit_sun_gate INTEGER,
  conversation_id UUID REFERENCES ai_conversations(id) ON DELETE SET NULL,
  prompt TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE journal_entries ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'journal_entries' AND policyname = 'Users can manage own journal entries') THEN
    CREATE POLICY "Users can manage own journal entries" ON journal_entries
      FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_journal_entries_user ON journal_entries(user_id, created_at DESC);
