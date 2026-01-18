-- Human Design Social Platform RLS Policies
-- Migration 003: Row Level Security for all social platform tables
-- Run this migration AFTER 002_social_platform.sql

-- ==================== Helper Functions ====================

-- Check if user follows another user
CREATE OR REPLACE FUNCTION public.is_following(follower UUID, following UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_follows
    WHERE follower_id = follower AND following_id = following
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Check if user is blocked by another user
CREATE OR REPLACE FUNCTION public.is_blocked(blocker UUID, blocked UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.blocked_users
    WHERE blocker_id = blocker AND blocked_id = blocked
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Check if user is in conversation
CREATE OR REPLACE FUNCTION public.is_conversation_participant(conv_id UUID, user_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.conversations
    WHERE id = conv_id AND user_uuid = ANY(participant_ids)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Check if user can message another user
CREATE OR REPLACE FUNCTION public.can_message_user(sender UUID, recipient UUID)
RETURNS BOOLEAN AS $$
DECLARE
  recipient_setting TEXT;
BEGIN
  -- Check if blocked
  IF public.is_blocked(recipient, sender) THEN
    RETURN FALSE;
  END IF;

  -- Get recipient's message settings
  SELECT allow_messages INTO recipient_setting
  FROM public.profiles
  WHERE id = recipient;

  CASE recipient_setting
    WHEN 'everyone' THEN RETURN TRUE;
    WHEN 'followers' THEN RETURN public.is_following(recipient, sender);
    WHEN 'nobody' THEN RETURN FALSE;
    ELSE RETURN TRUE;
  END CASE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- ==================== Profile Policies (Updates) ====================

-- Allow viewing public profiles
CREATE POLICY "Anyone can view public profiles"
  ON public.profiles FOR SELECT
  USING (is_public = TRUE OR auth.uid() = id);

-- ==================== User Follows Policies ====================

CREATE POLICY "Users can view follow relationships"
  ON public.user_follows FOR SELECT
  USING (
    auth.uid() = follower_id OR
    auth.uid() = following_id OR
    -- Can see follows of public profiles
    EXISTS (SELECT 1 FROM public.profiles WHERE id = following_id AND is_public = TRUE)
  );

CREATE POLICY "Users can follow others"
  ON public.user_follows FOR INSERT
  WITH CHECK (
    auth.uid() = follower_id AND
    NOT public.is_blocked(following_id, auth.uid())
  );

CREATE POLICY "Users can unfollow"
  ON public.user_follows FOR DELETE
  USING (auth.uid() = follower_id);

-- ==================== Posts Policies ====================

CREATE POLICY "Users can view public posts"
  ON public.posts FOR SELECT
  USING (
    visibility = 'public' AND
    NOT public.is_blocked(user_id, auth.uid())
  );

CREATE POLICY "Users can view followers-only posts from followed users"
  ON public.posts FOR SELECT
  USING (
    visibility = 'followers' AND
    public.is_following(auth.uid(), user_id) AND
    NOT public.is_blocked(user_id, auth.uid())
  );

CREATE POLICY "Users can view their own posts"
  ON public.posts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create posts"
  ON public.posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own posts"
  ON public.posts FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own posts"
  ON public.posts FOR DELETE
  USING (auth.uid() = user_id);

-- ==================== Post Comments Policies ====================

CREATE POLICY "Users can view comments on accessible posts"
  ON public.post_comments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.posts p
      WHERE p.id = post_id AND (
        p.visibility = 'public' OR
        p.user_id = auth.uid() OR
        (p.visibility = 'followers' AND public.is_following(auth.uid(), p.user_id))
      )
    )
  );

CREATE POLICY "Users can create comments on accessible posts"
  ON public.post_comments FOR INSERT
  WITH CHECK (
    auth.uid() = user_id AND
    EXISTS (
      SELECT 1 FROM public.posts p
      WHERE p.id = post_id AND (
        p.visibility = 'public' OR
        p.user_id = auth.uid() OR
        (p.visibility = 'followers' AND public.is_following(auth.uid(), p.user_id))
      )
    )
  );

CREATE POLICY "Users can update their own comments"
  ON public.post_comments FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own comments"
  ON public.post_comments FOR DELETE
  USING (auth.uid() = user_id);

-- ==================== Reactions Policies ====================

CREATE POLICY "Users can view reactions"
  ON public.reactions FOR SELECT
  USING (TRUE);

CREATE POLICY "Users can add reactions"
  ON public.reactions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove their reactions"
  ON public.reactions FOR DELETE
  USING (auth.uid() = user_id);

-- ==================== Stories Policies ====================

CREATE POLICY "Users can view public non-expired stories"
  ON public.stories FOR SELECT
  USING (
    expires_at > NOW() AND (
      visibility = 'public' OR
      auth.uid() = user_id OR
      (visibility = 'followers' AND public.is_following(auth.uid(), user_id))
    ) AND
    NOT public.is_blocked(user_id, auth.uid())
  );

CREATE POLICY "Users can create stories"
  ON public.stories FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own stories"
  ON public.stories FOR DELETE
  USING (auth.uid() = user_id);

-- ==================== Story Views Policies ====================

CREATE POLICY "Story owners can see who viewed"
  ON public.story_views FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.stories
      WHERE id = story_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Users can view their own view history"
  ON public.story_views FOR SELECT
  USING (auth.uid() = viewer_id);

CREATE POLICY "Users can record story views"
  ON public.story_views FOR INSERT
  WITH CHECK (auth.uid() = viewer_id);

-- ==================== Conversations Policies ====================

CREATE POLICY "Users can view their conversations"
  ON public.conversations FOR SELECT
  USING (auth.uid() = ANY(participant_ids));

CREATE POLICY "Users can create conversations"
  ON public.conversations FOR INSERT
  WITH CHECK (auth.uid() = ANY(participant_ids));

CREATE POLICY "Participants can update conversation"
  ON public.conversations FOR UPDATE
  USING (auth.uid() = ANY(participant_ids));

-- ==================== Direct Messages Policies ====================

CREATE POLICY "Users can view messages in their conversations"
  ON public.direct_messages FOR SELECT
  USING (
    public.is_conversation_participant(conversation_id, auth.uid())
  );

CREATE POLICY "Users can send messages in their conversations"
  ON public.direct_messages FOR INSERT
  WITH CHECK (
    auth.uid() = sender_id AND
    public.is_conversation_participant(conversation_id, auth.uid())
  );

CREATE POLICY "Users can update their own messages (read status)"
  ON public.direct_messages FOR UPDATE
  USING (
    public.is_conversation_participant(conversation_id, auth.uid())
  );

-- ==================== User Points Policies ====================

CREATE POLICY "Users can view their own points"
  ON public.user_points FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view leaderboard (limited data)"
  ON public.user_points FOR SELECT
  USING (TRUE);  -- Will need to handle in app to show only necessary fields

CREATE POLICY "System can manage points"
  ON public.user_points FOR ALL
  USING (auth.uid() = user_id);

-- ==================== Point Transactions Policies ====================

CREATE POLICY "Users can view their own transactions"
  ON public.point_transactions FOR SELECT
  USING (auth.uid() = user_id);

-- Insert handled by award_points function

-- ==================== Badges Policies ====================

CREATE POLICY "Anyone can view badge definitions"
  ON public.badges FOR SELECT
  USING (NOT is_hidden);

-- Admin-only insert/update/delete (via service role)

-- ==================== User Badges Policies ====================

CREATE POLICY "Users can view earned badges"
  ON public.user_badges FOR SELECT
  USING (TRUE);  -- Public to show on profiles

CREATE POLICY "Users can update their featured badges"
  ON public.user_badges FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Insert handled by system

-- ==================== Challenges Policies ====================

CREATE POLICY "Users can view active challenges"
  ON public.challenges FOR SELECT
  USING (is_active = TRUE);

-- Admin-only insert/update/delete

-- ==================== User Challenges Policies ====================

CREATE POLICY "Users can view their challenges"
  ON public.user_challenges FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their challenge progress"
  ON public.user_challenges FOR UPDATE
  USING (auth.uid() = user_id);

-- Insert handled by system

-- ==================== Content Library Policies ====================

CREATE POLICY "Users can view published non-premium content"
  ON public.content_library FOR SELECT
  USING (
    is_published = TRUE AND (
      is_premium = FALSE OR
      EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_premium = TRUE)
    )
  );

CREATE POLICY "Authors can view their own content"
  ON public.content_library FOR SELECT
  USING (auth.uid() = author_id);

CREATE POLICY "Users can create community content"
  ON public.content_library FOR INSERT
  WITH CHECK (auth.uid() = author_id AND is_official = FALSE);

CREATE POLICY "Authors can update their content"
  ON public.content_library FOR UPDATE
  USING (auth.uid() = author_id);

CREATE POLICY "Authors can delete their content"
  ON public.content_library FOR DELETE
  USING (auth.uid() = author_id AND is_official = FALSE);

-- ==================== Content Progress Policies ====================

CREATE POLICY "Users can manage their content progress"
  ON public.content_progress FOR ALL
  USING (auth.uid() = user_id);

-- ==================== Mentorship Profiles Policies ====================

CREATE POLICY "Users can view mentor profiles"
  ON public.mentorship_profiles FOR SELECT
  USING (is_mentor = TRUE OR auth.uid() = user_id);

CREATE POLICY "Users can manage their mentorship profile"
  ON public.mentorship_profiles FOR ALL
  USING (auth.uid() = user_id);

-- ==================== Mentorship Requests Policies ====================

CREATE POLICY "Mentors and mentees can view their requests"
  ON public.mentorship_requests FOR SELECT
  USING (auth.uid() = mentor_id OR auth.uid() = mentee_id);

CREATE POLICY "Mentees can create requests"
  ON public.mentorship_requests FOR INSERT
  WITH CHECK (auth.uid() = mentee_id);

CREATE POLICY "Both parties can update request status"
  ON public.mentorship_requests FOR UPDATE
  USING (auth.uid() = mentor_id OR auth.uid() = mentee_id);

CREATE POLICY "Both parties can delete requests"
  ON public.mentorship_requests FOR DELETE
  USING (auth.uid() = mentor_id OR auth.uid() = mentee_id);

-- ==================== Live Sessions Policies ====================

CREATE POLICY "Users can view scheduled and live sessions"
  ON public.live_sessions FOR SELECT
  USING (
    status IN ('scheduled', 'live') OR
    auth.uid() = host_id OR
    EXISTS (
      SELECT 1 FROM public.session_participants
      WHERE session_id = id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Premium content requires premium"
  ON public.live_sessions FOR SELECT
  USING (
    is_premium = FALSE OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_premium = TRUE) OR
    auth.uid() = host_id
  );

CREATE POLICY "Users can create sessions"
  ON public.live_sessions FOR INSERT
  WITH CHECK (auth.uid() = host_id);

CREATE POLICY "Hosts can update their sessions"
  ON public.live_sessions FOR UPDATE
  USING (auth.uid() = host_id);

CREATE POLICY "Hosts can delete their sessions"
  ON public.live_sessions FOR DELETE
  USING (auth.uid() = host_id);

-- ==================== Session Participants Policies ====================

CREATE POLICY "Hosts and participants can view participants"
  ON public.session_participants FOR SELECT
  USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM public.live_sessions
      WHERE id = session_id AND host_id = auth.uid()
    )
  );

CREATE POLICY "Users can register for sessions"
  ON public.session_participants FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their registration"
  ON public.session_participants FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users and hosts can remove registration"
  ON public.session_participants FOR DELETE
  USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM public.live_sessions
      WHERE id = session_id AND host_id = auth.uid()
    )
  );

-- ==================== Blocked Users Policies ====================

CREATE POLICY "Users can view their block list"
  ON public.blocked_users FOR SELECT
  USING (auth.uid() = blocker_id);

CREATE POLICY "Users can block others"
  ON public.blocked_users FOR INSERT
  WITH CHECK (auth.uid() = blocker_id);

CREATE POLICY "Users can unblock others"
  ON public.blocked_users FOR DELETE
  USING (auth.uid() = blocker_id);

-- ==================== Content Reports Policies ====================

CREATE POLICY "Users can view their own reports"
  ON public.content_reports FOR SELECT
  USING (auth.uid() = reporter_id);

CREATE POLICY "Users can create reports"
  ON public.content_reports FOR INSERT
  WITH CHECK (auth.uid() = reporter_id);

-- Admin-only update/delete (via service role)

-- ==================== Notifications Policies ====================

CREATE POLICY "Users can view their notifications"
  ON public.notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can mark their notifications as read"
  ON public.notifications FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their notifications"
  ON public.notifications FOR DELETE
  USING (auth.uid() = user_id);

-- System inserts via service role

-- ==================== Realtime Subscriptions ====================
-- Enable realtime for specific tables

ALTER PUBLICATION supabase_realtime ADD TABLE public.direct_messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE public.stories;
ALTER PUBLICATION supabase_realtime ADD TABLE public.posts;
ALTER PUBLICATION supabase_realtime ADD TABLE public.reactions;
