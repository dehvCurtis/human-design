-- Create charts table for storing saved Human Design charts
CREATE TABLE IF NOT EXISTS charts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  birth_datetime TIMESTAMPTZ NOT NULL,
  birth_location JSONB NOT NULL,
  timezone TEXT NOT NULL,
  type TEXT NOT NULL,
  authority TEXT NOT NULL,
  profile TEXT NOT NULL,
  definition TEXT NOT NULL,
  defined_centers TEXT[] DEFAULT '{}',
  conscious_gates INTEGER[] DEFAULT '{}',
  unconscious_gates INTEGER[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE charts ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own charts
CREATE POLICY "Users can view own charts" ON charts
  FOR SELECT USING (auth.uid() = user_id);

-- Policy: Users can insert their own charts
CREATE POLICY "Users can insert own charts" ON charts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own charts
CREATE POLICY "Users can update own charts" ON charts
  FOR UPDATE USING (auth.uid() = user_id);

-- Policy: Users can delete their own charts
CREATE POLICY "Users can delete own charts" ON charts
  FOR DELETE USING (auth.uid() = user_id);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_charts_user_id ON charts(user_id);
