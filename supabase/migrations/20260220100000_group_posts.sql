-- =============================================================================
-- Group Posts: discussion feed within HD Study Circles
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Create group_posts table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.group_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL CHECK (char_length(content) BETWEEN 1 AND 5000),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_group_posts_group_id ON public.group_posts(group_id, created_at DESC);
CREATE INDEX idx_group_posts_user_id ON public.group_posts(user_id);

ALTER TABLE public.group_posts ENABLE ROW LEVEL SECURITY;

-- -----------------------------------------------------------------------------
-- 2. RLS policies for group_posts
-- -----------------------------------------------------------------------------

-- SELECT: members can read posts in their groups
CREATE POLICY "group_posts_select"
  ON public.group_posts FOR SELECT
  USING (
    group_id IN (SELECT public.get_user_group_ids(auth.uid()))
  );

-- INSERT: members can post in their groups (must be themselves)
CREATE POLICY "group_posts_insert"
  ON public.group_posts FOR INSERT
  WITH CHECK (
    auth.uid() = user_id
    AND group_id IN (SELECT public.get_user_group_ids(auth.uid()))
  );

-- DELETE: authors can delete own posts, admins can delete any post in their group
CREATE POLICY "group_posts_delete"
  ON public.group_posts FOR DELETE
  USING (
    user_id = auth.uid()
    OR public.is_group_admin(auth.uid(), group_id)
  );

-- -----------------------------------------------------------------------------
-- 3. CHECK constraints on groups table (text lengths)
-- -----------------------------------------------------------------------------
DO $$
BEGIN
  -- Add name length constraint if not exists
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.groups'::regclass
    AND conname = 'groups_name_length'
  ) THEN
    ALTER TABLE public.groups
      ADD CONSTRAINT groups_name_length CHECK (char_length(name) BETWEEN 1 AND 100);
  END IF;

  -- Add description length constraint if not exists
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.groups'::regclass
    AND conname = 'groups_description_length'
  ) THEN
    ALTER TABLE public.groups
      ADD CONSTRAINT groups_description_length CHECK (description IS NULL OR char_length(description) <= 500);
  END IF;
END $$;

-- -----------------------------------------------------------------------------
-- 4. UPDATE policy on groups for admins (if not already present)
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Admins can update groups" ON public.groups;

CREATE POLICY "Admins can update groups"
  ON public.groups FOR UPDATE
  USING (public.is_group_admin(auth.uid(), id))
  WITH CHECK (public.is_group_admin(auth.uid(), id));

-- -----------------------------------------------------------------------------
-- 5. DELETE policy on groups for admins (if not already present)
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Admins can delete groups" ON public.groups;

CREATE POLICY "Admins can delete groups"
  ON public.groups FOR DELETE
  USING (public.is_group_admin(auth.uid(), id));
