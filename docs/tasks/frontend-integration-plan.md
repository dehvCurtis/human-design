# Frontend Integration Plan - Social Platform Features

## Overview

Complete the frontend implementation for all backend features already created. The backend (data/domain layers) is 100% complete for all features. This plan focuses on:
1. Adding routes to the app router
2. Creating missing presentation screens
3. Integrating features into the navigation

---

## Current Status (Updated 2026-01-17)

| Feature | Backend | Frontend | Status |
|---------|:-------:|:--------:|--------|
| Discovery | ✅ | ✅ | Complete |
| Feed | ✅ | ✅ | Complete |
| Stories | ✅ | ✅ | Complete |
| Messaging | ✅ | ✅ | Complete |
| Gamification | ✅ | ✅ | Complete |
| Learning | ✅ | ✅ | Complete |
| Sharing | ✅ | ⚠️ | my_shares_screen pending |

**Overall Progress: 96% Complete**

---

## Phase 1: Add Routes for Ready Features

**File:** `lib/core/router/app_router.dart`

### 1.1 Add Route Constants
```dart
static const String discover = '/discover';
static const String feed = '/feed';
static const String achievements = '/achievements';
static const String challenges = '/challenges';
static const String leaderboard = '/leaderboard';
static const String messages = '/messages';
static const String messageDetail = '/messages/:id';
static const String stories = '/stories';
static const String learning = '/learning';
static const String contentDetail = '/learning/:id';
static const String mentorship = '/mentorship';
static const String sessions = '/sessions';
static const String share = '/share';
```

### 1.2 Add GoRoute Entries (within ShellRoute)
- `/discover` → DiscoveryScreen
- `/feed` → FeedScreen
- `/achievements` → AchievementsScreen
- `/challenges` → ChallengesScreen (to create)
- `/leaderboard` → LeaderboardScreen (to create)
- `/messages` → ConversationsScreen (to create)
- `/messages/:id` → MessageDetailScreen (to create)
- `/learning` → LearningScreen (to create)
- `/mentorship` → MentorshipScreen (to create)
- `/sessions` → LiveSessionsScreen (to create)
- `/share` → ShareScreen (to create)

### 1.3 Update Navigation
Add access points from existing screens:
- Home → Add "Discover" and "Feed" quick actions
- Profile → Add "Achievements", "Learning" action buttons
- Social → Add "Messages" button/FAB

---

## Phase 2: Stories Feature UI

**Directory:** `lib/features/stories/presentation/`

### 2.1 Stories Bar Widget
**File:** `widgets/stories_bar.dart`
- Horizontal scrollable row of story circles
- Shows followed users with active stories
- "Add story" button at start
- Unviewed indicator (colored ring)

### 2.2 Story Viewer Screen
**File:** `story_viewer_screen.dart`
- Full-screen story display
- Tap left/right to navigate
- Progress bar at top
- User info overlay
- Swipe down to dismiss

### 2.3 Create Story Sheet
**File:** `widgets/create_story_sheet.dart`
- Bottom sheet with options
- Text input with background color picker
- Transit gate auto-attach option
- Preview before posting

---

## Phase 3: Messaging Feature UI

**Directory:** `lib/features/messaging/presentation/`

### 3.1 Conversations Screen
**File:** `conversations_screen.dart`
- List of conversations with last message preview
- Unread badge indicator
- Pull-to-refresh
- FAB to start new conversation
- Search conversations

### 3.2 Message Detail Screen
**File:** `message_detail_screen.dart`
- Message thread with bubbles (sent/received styling)
- Real-time message updates
- Message input at bottom
- Timestamp grouping
- Read receipts

### 3.3 New Conversation Sheet
**File:** `widgets/new_conversation_sheet.dart`
- User search/selection
- Recent contacts list

---

## Phase 4: Gamification UI Completion

**Directory:** `lib/features/gamification/presentation/`

### 4.1 Challenges Screen
**File:** `challenges_screen.dart`
- Active challenges list with progress
- Daily/weekly/monthly tabs
- Challenge detail expansion
- Claim reward button

### 4.2 Leaderboard Screen
**File:** `leaderboard_screen.dart`
- Top 3 podium display
- Scrollable rankings list
- Filter tabs: All Time, Weekly, Monthly
- Current user highlight
- Filter by HD type option

---

## Phase 5: Learning Feature UI

**Directory:** `lib/features/learning/presentation/`

### 5.1 Learning Hub Screen
**File:** `learning_screen.dart`
- Content categories grid
- Featured content carousel
- Search bar
- Filter by type/gate/premium

### 5.2 Content Detail Screen
**File:** `content_detail_screen.dart`
- Article/video content display
- Progress tracking
- Related content suggestions
- Bookmark/save option

### 5.3 Mentorship Screen
**File:** `mentorship_screen.dart`
- Mentor directory with filters
- Mentor profile cards
- Request mentorship flow
- My mentorship status (as mentor/mentee)

### 5.4 Live Sessions Screen
**File:** `live_sessions_screen.dart`
- Upcoming sessions list
- Session detail with registration
- My registered sessions tab
- Calendar view option

---

## Phase 6: Sharing Feature UI

**Directory:** `lib/features/sharing/presentation/`

### 6.1 Share Screen
**File:** `share_screen.dart`
- Share options: Link, Image, PDF
- Preview of share card
- Copy link button
- Share to external apps
- Expiration settings

### 6.2 My Shares Screen
**File:** `my_shares_screen.dart`
- List of created share links
- View count stats
- Revoke/delete options

---

## Phase 7: Navigation Integration

### 7.1 Update Home Screen Quick Actions
**File:** `lib/features/home/presentation/widgets/quick_actions_row.dart`
- Replace or add: Discover, Feed buttons
- Consider 2-row grid for more actions

### 7.2 Add Messages FAB or Icon
**File:** `lib/core/router/app_router.dart` (MainShell)
- Add message icon to AppBar with unread badge
- Or floating action button

### 7.3 Update Profile Screen
**File:** `lib/features/profile/presentation/profile_screen.dart`
- Add Achievements action button
- Add Learning action button
- Add Share Chart button

### 7.4 Update Social Screen
**File:** `lib/features/social/presentation/social_screen.dart`
- Add Messages tab or icon
- Link to Discovery from Friends tab

---

## Phase 8: Bodygraph Chart Improvements

**Reference:** [Human Design Chart Example](https://images.squarespace-cdn.com/content/v1/618f2fcb56b4c6279895259b/e66c2f2f-902b-4c53-8625-a0fbeb9a528e/human+design+chart+black+and+red+conscious+and+unconscious)

**Directory:** `lib/features/chart/presentation/widgets/bodygraph/`

### 8.1 Show All Channels
**Current:** Only active/defined channels are displayed.
**Desired:** All 36 channels visible at all times.
- Inactive channels: Light gray or faded stroke
- Active channels: Full color (red for unconscious, black for conscious, striped for both)

### 8.2 Human Silhouette Background
**Current:** Centers and channels float without body context.
**Desired:** Human figure silhouette behind the chart elements.
- Subtle/faded so it doesn't compete with chart data
- Anatomically positions centers correctly

**Implementation:** SVG asset recommended for scalability.
- Create `assets/images/bodygraph_silhouette.svg`
- Render as background layer in bodygraph widget

### 8.3 Channel Styling Guide

| State | Description | Color/Style |
|-------|-------------|-------------|
| Inactive | Neither gate defined | Light gray, thin stroke |
| Conscious only | Both gates from personality | Black/dark solid |
| Unconscious only | Both gates from design | Red solid |
| Mixed | One conscious, one unconscious | Striped or split color |

### 8.4 Visual Hierarchy
1. Background layer: Human silhouette (~10-20% opacity)
2. Channel layer: All 36 channels (inactive gray, active colored)
3. Center layer: 9 centers (undefined open, defined colored)
4. Gate layer: Gate numbers/indicators
5. Interaction layer: Touch targets

**See:** `docs/tasks/bodygraph-improvements.md` for full details.

---

## File Summary

### New Files to Create (14 files)

| File | Description |
|------|-------------|
| `stories/presentation/widgets/stories_bar.dart` | Story circles bar |
| `stories/presentation/story_viewer_screen.dart` | Full-screen viewer |
| `stories/presentation/widgets/create_story_sheet.dart` | Create story UI |
| `messaging/presentation/conversations_screen.dart` | Conversation list |
| `messaging/presentation/message_detail_screen.dart` | Message thread |
| `messaging/presentation/widgets/new_conversation_sheet.dart` | Start conversation |
| `gamification/presentation/challenges_screen.dart` | Challenges list |
| `gamification/presentation/leaderboard_screen.dart` | Rankings display |
| `learning/presentation/learning_screen.dart` | Learning hub |
| `learning/presentation/content_detail_screen.dart` | Content viewer |
| `learning/presentation/mentorship_screen.dart` | Mentor directory |
| `learning/presentation/live_sessions_screen.dart` | Sessions list |
| `sharing/presentation/share_screen.dart` | Share options |
| `sharing/presentation/my_shares_screen.dart` | Share history |

### Files to Modify (4 files)

| File | Changes |
|------|---------|
| `lib/core/router/app_router.dart` | Add all new routes |
| `lib/features/home/presentation/widgets/quick_actions_row.dart` | Add Discover/Feed |
| `lib/features/profile/presentation/profile_screen.dart` | Add action buttons |
| `lib/features/social/presentation/social_screen.dart` | Add messages access |

---

## Implementation Order

1. **Phase 1**: Routes (unblocks everything)
2. **Phase 7**: Navigation integration (makes features accessible)
3. **Phase 4**: Gamification (smallest scope, existing patterns)
4. **Phase 3**: Messaging (high value, moderate scope)
5. **Phase 2**: Stories (moderate scope)
6. **Phase 5**: Learning (largest scope)
7. **Phase 6**: Sharing (builds on existing widgets)
8. **Phase 8**: Bodygraph improvements (can be done in parallel)

---

## Verification

After implementation:
1. Navigate to each new screen from home/profile/social
2. Test Discovery: search users, follow/unfollow
3. Test Feed: create post, react, comment
4. Test Messages: send message, real-time delivery
5. Test Stories: create, view, expiration
6. Test Gamification: view badges, challenges, leaderboard
7. Test Learning: browse content, register for session
8. Test Sharing: generate share link, export image

---

## Localization

Add translation keys to `lib/l10n/app_en.arb` (and RU, UK):
- `nav_discover`, `nav_feed`, `nav_messages`
- `stories_*`, `messages_*`, `challenges_*`
- `learning_*`, `mentorship_*`, `sharing_*`

---

## Implementation Complete (2026-01-17)

### All Phases Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 1: Routes | ✅ Complete | All 13 routes added |
| Phase 2: Stories | ✅ Complete | stories_bar, story_viewer, create_story_sheet |
| Phase 3: Messaging | ✅ Complete | conversations, message_detail, new_conversation_sheet |
| Phase 4: Gamification | ✅ Complete | challenges_screen, leaderboard_screen |
| Phase 5: Learning | ✅ Complete | learning, content_detail, mentorship, live_sessions |
| Phase 6: Sharing | ⚠️ 50% | share_screen done, my_shares_screen pending |
| Phase 7: Navigation | ✅ Complete | quick_actions, profile buttons, social messages |
| Phase 8: Bodygraph | ✅ Complete | All channels, silhouette, proper coloring |
| Localization | ✅ Complete | EN, RU, UK all updated |

### Files Created (13 of 14)

All planned screens and widgets have been created except `my_shares_screen.dart`.

### Bugs Fixed During Implementation
- Back button navigation (canPop check)
- Auth bypass disabled
- Markdown rendering in learning content
- Chart creation prompts login when unauthenticated
- Navigation uses push() for proper back stack

### Database Setup
- Supabase migrations applied (001-004)
- RLS security policies active
- Seed data: badges, challenges, learning content
- Test user: test@humandesign.app
