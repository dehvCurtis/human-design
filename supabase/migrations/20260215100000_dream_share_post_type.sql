ALTER TABLE public.posts DROP CONSTRAINT IF EXISTS posts_post_type_check;
ALTER TABLE public.posts ADD CONSTRAINT posts_post_type_check
  CHECK (post_type IN ('insight', 'reflection', 'transit_share', 'chart_share',
                       'question', 'achievement', 'regenerate', 'dream_share'));
