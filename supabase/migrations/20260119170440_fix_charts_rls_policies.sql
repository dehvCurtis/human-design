-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view own charts" ON charts;
DROP POLICY IF EXISTS "Users can insert own charts" ON charts;
DROP POLICY IF EXISTS "Users can update own charts" ON charts;
DROP POLICY IF EXISTS "Users can delete own charts" ON charts;

-- Ensure RLS is enabled
ALTER TABLE charts ENABLE ROW LEVEL SECURITY;

-- Recreate policies
CREATE POLICY "Users can view own charts" ON charts
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own charts" ON charts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own charts" ON charts
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own charts" ON charts
  FOR DELETE USING (auth.uid() = user_id);
