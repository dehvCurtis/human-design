# Human Design Social Platform - Comprehensive Implementation Plan

## Overview

Transform the Human Design app into a full social media platform with community features, gamification, learning tools, and content sharing.

---

## Phase 1: Foundation & Infrastructure

### 1.1 Database Schema (Supabase SQL)

**New Tables to Create:**

| Table | Purpose |
|-------|---------|
| `user_follows` | Twitter-style follow system |
| `posts` | Content feed (insights, reflections, transit shares) |
| `reactions` | Type-specific emoji reactions |
| `stories` | 24h ephemeral content |
| `story_views` | Track story views |
| `conversations` | DM conversation threads |
| `direct_messages` | Individual messages |
| `user_points` | Gamification points & levels |
| `point_transactions` | Point earning history |
| `badges` | Achievement definitions |
| `user_badges` | Earned badges |
| `challenges` | Daily challenge definitions |
| `user_challenges` | Challenge progress |
| `content_library` | Learning content (articles, guides, quizzes) |
| `mentorship_profiles` | Mentor/mentee profiles |
| `mentorship_requests` | Mentorship connections |
| `live_sessions` | Scheduled group sessions |

**Profile Extensions:**
```sql
ALTER TABLE profiles ADD COLUMN bio TEXT;
ALTER TABLE profiles ADD COLUMN is_public BOOLEAN DEFAULT TRUE;
ALTER TABLE profiles ADD COLUMN show_chart_publicly BOOLEAN DEFAULT FALSE;
ALTER TABLE profiles ADD COLUMN allow_messages TEXT DEFAULT 'followers';
ALTER TABLE profiles ADD COLUMN hd_type TEXT;
ALTER TABLE profiles ADD COLUMN hd_profile TEXT;
ALTER TABLE profiles ADD COLUMN hd_authority TEXT;
```

### 1.2 RLS Security Policies

**Key Policies:**
- Posts: Public visible to all, followers-only to followers, private to owner
- DMs: Only conversation participants can read/write
- Stories: Expire after 24h, visibility based on follower status
- Premium content: Restricted to `is_premium = TRUE` users
- Gamification: Users can only view/modify their own data

### 1.3 iOS Deep Linking

**File: `ios/Runner/Info.plist`**
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>io.humandesign.app</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>io.humandesign.app</string>
      <string>humandesign</string>
    </array>
  </dict>
</array>
<key>FlutterDeepLinkingEnabled</key>
<true/>
```

**File: `ios/Runner/Runner.entitlements`**
```xml
<key>com.apple.developer.associated-domains</key>
<array>
  <string>applinks:humandesign.app</string>
</array>
```

**Bundle Identifier:** `io.humandesign.app`

### 1.4 Apple App Store Security

**Privacy Policy Requirements:**
- Data collection: Birth data, location, chart data, social content
- Automated profanity filtering
- Admin moderation dashboard

---

## Phase 2: Community & Discovery

### 2.1 Follow System
- Follow suggestions based on HD compatibility

### 2.2 User Discovery
- Search by name, HD type, profile, authority
- Type/profile matching algorithm
- Compatibility scoring:
  - Type compatibility (0-25 pts)
  - Profile harmonics (0-25 pts)
  - Channel complementarity (0-25 pts)
  - Definition bridging (0-25 pts)

### 2.3 Discovery Feed
- Public charts and insights
- Filter by type, profile, authority
- "People like you" recommendations

**Files to Create:**
```
lib/features/discovery/
├── data/discovery_repository.dart
├── domain/
│   ├── models/user_discovery.dart
│   ├── matching_service.dart
│   └── discovery_providers.dart
└── presentation/
    ├── discovery_screen.dart
    └── widgets/
        ├── user_card.dart
        ├── type_filter.dart
        └── compatibility_badge.dart
```

---

## Phase 3: Engagement Features

### 3.1 Content Feed

**Post Types:**
- `insight` - Personal HD insights
- `reflection` - Daily reflections
- `transit_share` - Transit observations
- `chart_share` - Chart element sharing
- `question` - Community questions
- `achievement` - Badge announcements

**Feed Algorithm:**
1. Recency weighting
2. Following relationship
3. Engagement rate
4. Same HD type affinity

### 3.2 Type-Specific Reactions
- `like`, `love`, `insight`, `resonate`
- `generator_sacral` - Satisfaction
- `projector_recognition` - "I see you"
- `manifestor_peace` - Alignment
- `reflector_surprise` - Delight
- `mg_satisfaction` - MG satisfaction

### 3.3 Stories (24h Ephemeral)
- Text overlays with HD color themes
- Current transit gate display
- Daily affirmation sharing
- Auto-expire with cleanup job

### 3.4 Direct Messaging
- Real-time via Supabase Realtime
- Chart/transit sharing in chat
- Read receipts
- Privacy controls per user

**Files to Create:**
```
lib/features/feed/
lib/features/stories/
lib/features/messaging/
```

---

## Phase 4: Gamification

### 4.1 Points System

| Action | Points |
|--------|--------|
| Daily login | 10 |
| Check transit | 5 |
| Save affirmation | 5 |
| Journal entry | 15 |
| Create post | 10 |
| Post gets reaction | 2 |
| Comment | 5 |
| Friend added | 20 |
| Share chart | 10 |
| Complete challenge | 25-100 |
| 7-day streak | 50 |
| 30-day streak | 200 |

### 4.2 Badges

**Categories:**
- **Social**: First Friend, Social Butterfly (10), Community Builder
- **Learning**: Chart Explorer (64 gates), Transit Tracker (30 days)
- **Engagement**: Consistent (7-day), Dedicated (30-day), Journaler
- **Transit**: Full Wheel (all gates), Personal Year (12 months)

### 4.3 Daily Challenges

**Transit-based:**
- "Gate 41 transits today. Reflect on a new beginning."
- "Moon in your Sacral. Note what energizes you."

**Type-specific:**
- Generators: Track 3 satisfaction moments
- Projectors: Practice waiting for invitation
- Manifestors: Inform someone of plans
- Reflectors: Note environmental feelings

### 4.4 Leaderboards
- Weekly/monthly points
- Longest streak
- Most helpful (reactions on comments)
- By HD type

**Files to Create:**
```
lib/features/gamification/
├── data/gamification_repository.dart
├── domain/
│   ├── models/badge.dart, challenge.dart, user_stats.dart
│   └── gamification_providers.dart
└── presentation/
    ├── achievements_screen.dart
    ├── challenges_screen.dart
    ├── leaderboard_screen.dart
    └── widgets/
```

---

## Phase 5: Learning & Collaboration

### 5.1 Content Library
- Official curated content
- Community contributions (moderated)
- Gate/channel/type guides
- Transit interpretations

### 5.2 Study Groups
- Topic-focused groups
- Shared chart analysis
- Discussion threads
- Penta analysis integration

### 5.3 Mentorship
- Mentor/mentee matching
- Expertise areas
- Experience verification
- Session scheduling

### 5.4 Live Sessions
- Calendar integration
- Zoom/Meet links
- Reminders
- Premium recordings

**Files to Create:**
```
lib/features/learning/
lib/features/mentorship/
```

---

## Phase 6: Sharing & Export

### 6.1 Chart Cards
- PNG export for social media
- PDF detailed reports
- Variants: bodygraph, summary, transit overlay

### 6.2 Compatibility Reports
- Side-by-side charts
- Electromagnetic connections
- Relationship dynamics
- Pairing advice

### 6.3 Transit Alerts
- Personal transit notifications
- Shareable transit cards
- "Gate of the day" sharing

**Files to Create:**
```
lib/features/sharing/
├── data/sharing_repository.dart
└── presentation/widgets/
    ├── chart_share_card.dart
    ├── compatibility_report.dart
    └── transit_share_card.dart
```

---

## File Structure Summary

```
lib/features/
├── discovery/          # User search & matching
├── feed/               # Content feed & posts
├── stories/            # 24h ephemeral content
├── messaging/          # Direct messages
├── gamification/       # Points, badges, challenges
├── learning/           # Content library, quizzes
├── mentorship/         # Mentor/mentee system
├── sharing/            # Chart cards, reports
└── subscription/       # Premium features
```

---

## Implementation Priority

### MVP (Weeks 1-4)
1. Database schema migration
2. iOS deep linking configuration
3. RLS security policies
4. Follow system
5. Basic discovery

### V1.0 (Weeks 5-10)
6. Content feed
7. Reactions
8. Stories
9. Direct messaging

### V1.5 (Weeks 11-15)
10. Points system
11. Badges & challenges
12. Streaks & leaderboards

### V2.0 (Weeks 16-22)
13. Content library
14. Study groups
15. Mentorship
16. Chart export & reports

---

## Current Implementation Status

### Completed
- [x] Database schema (migrations 001-004)
- [x] RLS security policies (migration 003)
- [x] Follow system (discovery_repository.dart)
- [x] User discovery (discovery_screen.dart)
- [x] Content feed (feed_screen.dart)
- [x] Stories (stories_screen.dart)
- [x] Direct messaging (conversations_screen.dart, message_detail_screen.dart)
- [x] Gamification (achievements_screen.dart, challenges_screen.dart, leaderboard_screen.dart)
- [x] Learning content (learning_screen.dart, content_detail_screen.dart)
- [x] Mentorship (mentorship_screen.dart)
- [x] Live sessions (live_sessions_screen.dart)
- [x] Sharing (share_screen.dart)
- [x] Routes configured in app_router.dart
- [x] Seed data for badges, challenges, learning content

### Pending
- [ ] iOS deep linking configuration
- [ ] Apple App Store privacy policy
- [ ] Content moderation system
- [ ] Push notifications for social features
- [ ] Chart export (PNG/PDF)
- [ ] Compatibility reports
- [ ] Study groups
- [ ] Premium subscription gating

---

## Verification Plan

### Database
```bash
# Apply migrations
supabase db push

# Verify tables created
supabase db diff
```

### iOS Deep Linking
1. Build iOS app
2. Test URL scheme: `io.humandesign.app://auth/callback`
3. Verify OAuth flow completes

### Features
1. Create post → appears in feed
2. Follow user → see their posts
3. Send DM → realtime delivery
4. Complete challenge → earn points
5. Earn badge → notification shown

### App Store
1. Submit privacy policy URL
2. Complete App Privacy questionnaire
3. Verify content moderation works
4. Test age-appropriate content flow
