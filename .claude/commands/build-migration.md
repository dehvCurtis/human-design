# Build Supabase Migration

Generate a production-ready SQL migration for the Human Design app's Supabase database.

## Instructions

When the user describes the tables/changes needed: `$ARGUMENTS`

### Step 1: Study existing patterns

Read the latest migration for pattern reference:
- `supabase/migrations/20260206_ai_and_community.sql`

Note the established conventions:
- `UUID PRIMARY KEY DEFAULT gen_random_uuid()` for IDs
- `user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE` for user ownership
- `TIMESTAMPTZ NOT NULL DEFAULT now()` for timestamps
- `CHECK` constraints on text lengths and enum values
- Indexes on common query patterns (user_id + sort column)
- `SECURITY DEFINER` functions for atomic operations

### Step 2: Generate the migration file

Create the file at `supabase/migrations/YYYYMMDD_<descriptive_name>.sql` using today's date.

Follow this structure for EVERY table:

```sql
-- =============================================================================
-- <Section Description>
-- =============================================================================

-- <Table description>
CREATE TABLE IF NOT EXISTS <table_name> (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- columns with CHECK constraints on text: CHECK (char_length(column) <= N)
  -- columns with CHECK constraints on enums: CHECK (column IN ('a', 'b', 'c'))
  -- columns with CHECK constraints on numbers: CHECK (column >= 0)
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_<table>_<columns>
  ON <table_name>(<columns>);

-- =============================================================================
-- RLS Policies
-- =============================================================================

ALTER TABLE <table_name> ENABLE ROW LEVEL SECURITY;

-- SELECT: users see own data
CREATE POLICY "Users can view own <table>"
  ON <table_name> FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: users create own data
CREATE POLICY "Users can insert own <table>"
  ON <table_name> FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE: users update own data
CREATE POLICY "Users can update own <table>"
  ON <table_name> FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: users delete own data
CREATE POLICY "Users can delete own <table>"
  ON <table_name> FOR DELETE
  USING (auth.uid() = user_id);
```

### Step 3: Add SECURITY DEFINER functions if needed

For atomic operations (counters, upserts), create functions:

```sql
CREATE OR REPLACE FUNCTION <function_name>(
  p_user_id UUID,
  p_param TYPE
) RETURNS void AS $$
BEGIN
  -- Atomic operation here
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Step 4: Add triggers if needed

For `updated_at` auto-update:

```sql
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON <table_name>
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

### Step 5: Remind about deployment

After creating the migration file, remind the user:
```
Next steps:
1. Review the migration SQL
2. Run: supabase db push (for remote)
3. Or: supabase db reset (for local reset with all migrations)
```

### Checklist before finishing:
- [ ] Every table has RLS enabled
- [ ] Every table has SELECT/INSERT/UPDATE/DELETE policies
- [ ] Text columns have `char_length` CHECK constraints
- [ ] Enum-like columns have CHECK constraints with allowed values
- [ ] Foreign keys have ON DELETE CASCADE or appropriate action
- [ ] Indexes exist for user_id + common sort/filter columns
- [ ] Numeric counters have `CHECK (column >= 0)`
- [ ] Timestamps use TIMESTAMPTZ, not TIMESTAMP
