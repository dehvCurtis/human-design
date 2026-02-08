# API Reference

## Supabase Tables

### Core Tables

#### profiles
```sql
id, user_id, name, email, avatar_url,
birth_date, birth_time, birth_city, birth_country,
birth_lat, birth_lng, timezone,
-- Social platform extensions
bio, is_public, show_chart_publicly, allow_messages,
hd_type, hd_profile, hd_authority, follower_count, following_count,
created_at, updated_at
```

#### charts
```sql
id, user_id, name, birth_datetime, birth_location,
type, authority, profile, definition,
defined_centers, active_channels, activations,
created_at
```

### Social Platform Tables

#### user_follows
```sql
id, follower_id, following_id, created_at
-- Unique constraint on (follower_id, following_id)
```

#### posts
```sql
id, author_id, content, post_type,
visibility (public|followers|private),
attached_chart_id, attached_transit_data,
reaction_count, comment_count, share_count,
is_pinned, created_at, updated_at
```

#### reactions
```sql
id, user_id, post_id, reaction_type, created_at
-- reaction_type: like, love, insight, resonate,
--   generator_sacral, projector_recognition, manifestor_peace,
--   reflector_surprise, mg_satisfaction
```

#### comments
```sql
id, user_id, post_id, parent_id, content,
reaction_count, created_at, updated_at
```

#### stories
```sql
id, author_id, media_type, media_url,
text_content, background_color, transit_gate,
view_count, expires_at, created_at
```

#### story_views
```sql
id, story_id, viewer_id, viewed_at
```

#### conversations
```sql
id, participant_ids, last_message_at, created_at
```

#### direct_messages
```sql
id, conversation_id, sender_id, content,
message_type, attached_data,
read_at, created_at
```

#### shares
```sql
id, chart_id, shared_by, share_type,
share_token, view_count, expires_at, created_at
```

### Gamification Tables

#### user_points
```sql
id, user_id, total_points, level,
current_streak, longest_streak, last_activity_date,
created_at, updated_at
```

#### point_transactions
```sql
id, user_id, points, action_type,
reference_id, description, created_at
```

#### badges
```sql
id, name, description, icon_name, category,
requirement_type, requirement_value, points_reward,
is_active, created_at
```

#### user_badges
```sql
id, user_id, badge_id, earned_at, notified
```

#### challenges
```sql
id, title, description, challenge_type,
target_type, target_value, points_reward,
start_date, end_date, is_active, created_at
```

#### user_challenges
```sql
id, user_id, challenge_id, progress,
is_completed, completed_at, created_at
```

### Learning Tables

#### content_library
```sql
id, title, content, category, content_type,
gate_number, hd_type, author_id,
is_premium, is_published,
view_count, reading_time_minutes,
created_at, updated_at
```

#### content_progress
```sql
id, user_id, content_id, progress_percent,
is_completed, completed_at, quiz_score, last_accessed_at
```

#### mentorship_profiles
```sql
id, user_id, is_mentor, is_mentee,
expertise_areas, experience_years, bio,
availability, max_mentees, session_rate,
rating, review_count, is_verified, created_at
```

#### mentorship_requests
```sql
id, mentor_id, mentee_id, message,
focus_areas, status (pending|accepted|declined|cancelled),
created_at, responded_at
```

#### live_sessions
```sql
id, host_id, title, description,
session_type (workshop|qa|reading|meditation),
scheduled_at, duration_minutes, timezone,
meeting_url, max_participants, current_participants,
is_premium, status (scheduled|live|completed|cancelled),
created_at
```

#### session_participants
```sql
id, session_id, user_id, registered_at,
attended, attended_at
```

### AI Tables

#### ai_conversations
```sql
id, user_id, title, context_type, last_message_at, created_at
-- context_type: chart, transit, general, transit_insight, chart_reading, compatibility, dream, journal
```

#### ai_messages
```sql
id, conversation_id, role, content, created_at
-- role: user, assistant
```

#### ai_usage
```sql
id, user_id, period_start, message_count, bonus_messages, created_at
```

#### ai_purchases
```sql
id, user_id, product_id, message_count, purchased_at
```

### Journal Tables

#### journal_entries
```sql
id, user_id, content, entry_type, ai_interpretation,
transit_sun_gate, conversation_id, prompt, created_at
-- entry_type: 'dream' or 'journal'
-- RLS: Users can manage own entries (auth.uid() = user_id)
-- Index: (user_id, created_at DESC)
```

## Environment Variables

```
SUPABASE_URL=your-project-url
SUPABASE_ANON_KEY=your-anon-key
```

Config: `lib/core/config/supabase_config.dart`

## Swiss Ephemeris

- Package: `sweph`
- Data files: `assets/ephe/sepl_18.se1`, `semo_18.se1`
- Initialize: `EphemerisService.instance.initialize()`

## Key Services

### Core Services

| Service | File | Purpose |
|---------|------|---------|
| EphemerisService | `ephemeris/data/` | Planetary calculations |
| TransitService | `lifestyle/domain/` | Daily transits |
| AffirmationService | `lifestyle/domain/` | Daily affirmations |
| AuthRepository | `auth/data/` | Supabase auth |
| ProfileRepository | `profile/data/` | User profiles |

### Social Platform Services

| Service | File | Purpose |
|---------|------|---------|
| DiscoveryRepository | `discovery/data/` | User search & matching |
| MatchingService | `discovery/domain/` | HD compatibility scoring |
| FeedRepository | `feed/data/` | Posts, comments, reactions |
| StoriesRepository | `stories/data/` | Ephemeral content |
| MessagingRepository | `messaging/data/` | Direct messages |
| GamificationRepository | `gamification/data/` | Points, badges, challenges |
| LearningRepository | `learning/data/` | Content & mentorship |
| SharingRepository | `sharing/data/` | Chart export & sharing |
| AiRepository | `ai_assistant/data/` | AI chat, transit insights, chart reading, compatibility, dream, journal |
| ChartContextBuilder | `ai_assistant/data/` | Sanitized chart/transit/compatibility context for AI prompts |
| DreamRepository | `dream_journal/data/` | Dream journal & journaling CRUD |
| ChartExportService | `sharing/services/` | Chart PNG/PDF export including AI readings |

## RPC Functions

### Gamification
```sql
award_points(user_uuid, points_amount, action, reference_uuid, desc)
check_and_award_badges(user_uuid)
update_streak(user_uuid)
```

### AI
```sql
add_ai_bonus_messages(p_user_id, p_period_start, p_count)
```

### Counters
```sql
increment(table_name, row_id, column_name)
decrement(table_name, row_id, column_name)
increment_share_view(share_token)
```

## Realtime Subscriptions

| Channel | Table | Events | Purpose |
|---------|-------|--------|---------|
| feed | posts | INSERT, UPDATE, DELETE | Live feed updates |
| messages | direct_messages | INSERT | New message notifications |
| stories | stories | INSERT | New story notifications |
| comments | comments | INSERT | New comment notifications |

## iOS Deep Linking

### URL Schemes
- `io.humandesign.app://`
- `humandesign://`

### Universal Links
- `https://humandesign.app/share/{token}`
- `https://humandesign.app/profile/{userId}`
- `https://humandesign.app/post/{postId}`

### OAuth Callback
- `io.humandesign.app://auth/callback`
