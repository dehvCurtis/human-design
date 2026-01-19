# Frontend Integration - Task Checklist

**Last Updated:** 2026-01-18

## Phase 1: Add Routes for Ready Features
- [x] Add route constants to `app_router.dart`
- [x] Add GoRoute for `/discover` → DiscoveryScreen
- [x] Add GoRoute for `/feed` → FeedScreen
- [x] Add GoRoute for `/achievements` → AchievementsScreen
- [x] Add GoRoute for `/challenges` → ChallengesScreen
- [x] Add GoRoute for `/leaderboard` → LeaderboardScreen
- [x] Add GoRoute for `/messages` → ConversationsScreen
- [x] Add GoRoute for `/messages/:id` → MessageDetailScreen
- [x] Add GoRoute for `/learning` → LearningScreen
- [x] Add GoRoute for `/learning/:id` → ContentDetailScreen
- [x] Add GoRoute for `/mentorship` → MentorshipScreen
- [x] Add GoRoute for `/sessions` → LiveSessionsScreen
- [x] Add GoRoute for `/share` → ShareScreen

## Phase 2: Stories Feature UI
- [x] Create `stories/presentation/widgets/stories_bar.dart`
- [x] Create `stories/presentation/story_viewer_screen.dart`
- [x] Create `stories/presentation/widgets/create_story_sheet.dart`

## Phase 3: Messaging Feature UI
- [x] Create `messaging/presentation/conversations_screen.dart`
- [x] Create `messaging/presentation/message_detail_screen.dart`
- [x] Create `messaging/presentation/widgets/new_conversation_sheet.dart`

## Phase 4: Gamification UI Completion
- [x] Create `gamification/presentation/challenges_screen.dart`
- [x] Create `gamification/presentation/leaderboard_screen.dart`

## Phase 5: Learning Feature UI
- [x] Create `learning/presentation/learning_screen.dart`
- [x] Create `learning/presentation/content_detail_screen.dart`
- [x] Create `learning/presentation/mentorship_screen.dart`
- [x] Create `learning/presentation/live_sessions_screen.dart`

## Phase 6: Sharing Feature UI
- [x] Create `sharing/presentation/share_screen.dart`
- [ ] Create `sharing/presentation/my_shares_screen.dart`

## Phase 7: Navigation Integration
- [x] Update `quick_actions_row.dart` - Add Discover/Feed buttons
- [x] Update `profile_screen.dart` - Add Achievements, Learning, Share buttons
- [x] Update `social_screen.dart` - Add Messages access

## Phase 8: Bodygraph Chart Improvements
- [x] Show all 36 channels (active and inactive)
- [x] Style inactive channels with faded/gray appearance
- [x] Style active channels with proper coloring (conscious/unconscious/both)
- [x] Create or obtain human silhouette asset (SVG preferred)
- [x] Add silhouette as background layer in bodygraph widget
- [x] Ensure silhouette scales correctly with chart
- [x] Test on various screen sizes

## Localization
- [x] Add translation keys to `app_en.arb`
- [x] Add translation keys to `app_ru.arb`
- [x] Add translation keys to `app_uk.arb`

## Verification
- [x] Test Discovery navigation and functionality
- [x] Test Feed navigation and functionality
- [x] Test Messages navigation and functionality
- [x] Test Stories navigation and functionality
- [x] Test Gamification navigation and functionality
- [x] Test Learning navigation and functionality
- [ ] Test Sharing navigation and functionality

---

## Progress Summary

| Phase | Tasks | Completed | Status |
|-------|-------|-----------|--------|
| Phase 1: Routes | 13 | 13 | Complete |
| Phase 2: Stories | 3 | 3 | Complete |
| Phase 3: Messaging | 3 | 3 | Complete |
| Phase 4: Gamification | 2 | 2 | Complete |
| Phase 5: Learning | 4 | 4 | Complete |
| Phase 6: Sharing | 2 | 1 | In Progress |
| Phase 7: Navigation | 3 | 3 | Complete |
| Phase 8: Bodygraph | 7 | 7 | Complete |
| Phase 9: Planets Tab | 5 | 5 | Complete |
| Phase 10: Quiz System | 5 | 5 | Complete |
| Phase 11: Home Screen | 3 | 3 | Complete |
| Localization | 3 | 3 | Complete |
| Verification | 7 | 6 | In Progress |
| **Total** | **60** | **58** | **97%** |

---

## Phase 9: Planets Tab
- [x] Create `planetary_panel.dart` widget
- [x] Create `planet_activation_row.dart` widget
- [x] Add Planets tab to chart_screen.dart
- [x] Fix blank screen (add explicit width constraints)
- [x] Add localization strings

## Phase 10: Quiz System
- [x] Create quiz feature module structure
- [x] Add question generators for all categories
- [x] Create quiz list, detail, taking, and results screens
- [x] Add database migrations
- [x] Seed factual quizzes

## Phase 11: Home Screen Improvements
- [x] Add "Saved" quick action button
- [x] Reorganize quick actions into 3 rows
- [x] Fix Saved Charts loading (remove chart calculation dependency)

---

## Remaining Work

### Pending Items
1. `my_shares_screen.dart` - Share history/management screen
2. Full sharing flow verification
3. Auth configuration (email confirmation settings)

### Known Issues Fixed (2026-01-18)
- Planets Tab blank screen (added width constraints)
- Saved Charts infinite loading (removed chart calculation dependency)

### Known Issues Fixed (2026-01-17)
- Back button navigation in Learn/other screens
- Chart creation button when logged out (now prompts login)
- Auth bypass flag disabled (`kBypassAuth = false`)
- Markdown rendering in learning content
- Navigation using `push()` instead of `go()` for sub-routes

### Database Setup Complete
- All migrations applied (001-004)
- RLS policies configured
- Seed data inserted (badges, challenges, learning content)
- Test user created: test@humandesign.app
