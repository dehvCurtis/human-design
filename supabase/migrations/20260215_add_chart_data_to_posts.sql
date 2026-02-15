-- Add chart_data column to posts table for storing chart JSON data inline
-- This replaces the image upload approach for chart sharing in feed posts
ALTER TABLE posts ADD COLUMN IF NOT EXISTS chart_data jsonb;
