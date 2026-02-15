-- Re-add updated_at column that was dropped in 20260214_fix_journal_entries.sql
-- The update_journal_entries_updated_at trigger (from 001_initial_schema.sql)
-- fires update_updated_at() on every UPDATE, which fails without this column.
ALTER TABLE journal_entries
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();
