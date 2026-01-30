-- Migration: Add regenerate (repost) support to posts table
-- Implements "Thoughts" feature with Facebook-like regenerate functionality

-- Add regenerate support columns to posts table
ALTER TABLE public.posts
  ADD COLUMN IF NOT EXISTS original_post_id UUID REFERENCES public.posts(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS is_regenerate BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS regenerate_count INTEGER DEFAULT 0;

-- Index for efficient queries on regenerated posts
CREATE INDEX IF NOT EXISTS idx_posts_original_post_id
  ON public.posts(original_post_id) WHERE original_post_id IS NOT NULL;

-- Index for fetching a user's regenerated posts
CREATE INDEX IF NOT EXISTS idx_posts_user_regenerates
  ON public.posts(user_id, is_regenerate) WHERE is_regenerate = TRUE;

-- Trigger function to update regenerate_count on the original post
CREATE OR REPLACE FUNCTION public.update_regenerate_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' AND NEW.original_post_id IS NOT NULL THEN
    UPDATE public.posts SET regenerate_count = regenerate_count + 1
    WHERE id = NEW.original_post_id;
  ELSIF TG_OP = 'DELETE' AND OLD.original_post_id IS NOT NULL THEN
    UPDATE public.posts SET regenerate_count = GREATEST(0, regenerate_count - 1)
    WHERE id = OLD.original_post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically update regenerate_count
DROP TRIGGER IF EXISTS on_regenerate_change ON public.posts;
CREATE TRIGGER on_regenerate_change
  AFTER INSERT OR DELETE ON public.posts
  FOR EACH ROW EXECUTE FUNCTION public.update_regenerate_count();

-- Update post_type constraint to include 'regenerate' type
-- First drop existing constraint if it exists
DO $$
BEGIN
  ALTER TABLE public.posts DROP CONSTRAINT IF EXISTS posts_post_type_check;
EXCEPTION
  WHEN undefined_object THEN NULL;
END $$;

-- Add updated constraint with regenerate type
ALTER TABLE public.posts ADD CONSTRAINT posts_post_type_check
  CHECK (post_type IN ('insight', 'reflection', 'transit_share', 'chart_share',
                       'question', 'achievement', 'regenerate'));

-- Add comment for documentation
COMMENT ON COLUMN public.posts.original_post_id IS 'Reference to the original post if this is a regenerate';
COMMENT ON COLUMN public.posts.is_regenerate IS 'True if this post is a regenerate of another post';
COMMENT ON COLUMN public.posts.regenerate_count IS 'Number of times this post has been regenerated';
