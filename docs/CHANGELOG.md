# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

#### Quiz System
- **Comprehensive Question Generators** - 138+ factual Human Design questions
  - `TypesQuestionGenerator` - 25+ questions (strategies, auras, population stats)
  - `CentersQuestionGenerator` - 26+ questions (functions, biological correlations)
  - `AuthoritiesQuestionGenerator` - 17+ questions (7 authorities, hierarchy)
  - `ProfilesQuestionGenerator` - 26+ questions (12 profiles, 6 lines, harmonics)
  - `DefinitionsQuestionGenerator` - 14+ questions (5 definition types)
  - `GatesQuestionGenerator` - Dynamic questions from 64 gates
  - `ChannelsQuestionGenerator` - Dynamic questions from 36 channels

- **Pre-defined Quizzes** - 19 quizzes across all categories
  - Types Basics, Types & Auras
  - Centers Introduction, Centers Deep Dive
  - Authority Basics, Know Your Authority, Authority Mastery
  - Profile Introduction, Profile Mastery, Profile Deep Dive
  - Definition Types, Definition Dynamics
  - Gates Introduction, Gate Exploration
  - Channel Connections, Channel Mastery
  - Human Design Fundamentals, Intermediate, Advanced Synthesis

#### Bodygraph Improvements
- **Purple Color Scheme** - Style guide compliant colors
  - Defined centers: Light purple fill (#DDD6FE) with dark purple border (#7C3AED)
  - Undefined centers: White fill with light purple border (#C4B5FD)
  - Conscious activations: Dark indigo (#3730A3)
  - Unconscious activations: Pink/magenta (#DB2777)
  - Inactive elements: Light purple tint (#E9D5FF)
  - Transits: Cyan (#0891B2) for clear distinction

- **Gate Position Fixes**
  - Sacral bottom edge corrected: 42, 3, 9 (left to right)
  - Root top edge aligned: 53, 60, 52 (matching Sacral)

- **Planets Tab** - New tab showing Design and Personality planetary activations
  - Design panel (unconscious/88° prenatal) on left in pink
  - Personality panel (conscious/birth) on right in indigo
  - All 13 planets displayed in HD standard order: Sun, Earth, Moon, North Node, South Node, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto
  - Gate.Line notation (e.g., "41.3") for each planetary activation
  - Tappable rows to view gate details
  - Centered layout with responsive planet name display

#### Home Screen Improvements
- **Saved Charts Quick Action** - New "Saved" button on home screen for quick access
  - Three-row quick action layout: Charts, Social, Communication
  - Direct navigation to Saved Charts screen
- **Quick Actions Reorganization**
  - Row 1: My Chart, Saved, Composite, Penta
  - Row 2: Friends, Discover, Feed, Learning
  - Row 3: Messages

#### Social Platform Features
- **Discovery & Matching** - Find users by HD type, profile, authority with compatibility scoring
  - HD compatibility algorithm (type, profile, channels, centers)
  - Follow/unfollow system
  - User search with filters
  - Compatibility badges and scores

- **Content Feed** - Social feed for sharing HD insights
  - Post types: insight, reflection, transit_share, chart_share, question, achievement
  - HD-specific reactions (generator_sacral, projector_recognition, manifestor_peace, etc.)
  - Comments with nested replies
  - Visibility controls (public, followers, private)

- **Stories** - 24-hour ephemeral content
  - Text overlays with HD color themes
  - Current transit gate display
  - Auto-expiration cleanup
  - View tracking

- **Direct Messaging** - Private conversations
  - Real-time message delivery via Supabase Realtime
  - Chart/transit sharing in chat
  - Read receipts
  - Conversation management

- **Gamification System** - Points, badges, and challenges
  - Points for actions (login, posts, reactions, streaks)
  - Level progression system
  - Badge categories: Social, Learning, Engagement, Transit
  - Daily challenges (type-specific and transit-based)
  - Leaderboards (weekly, monthly, by type)
  - Streak tracking

- **Learning & Mentorship** - Educational content and guidance
  - Content library (articles, guides, quizzes)
  - Gate/channel/type-specific content
  - Mentorship profiles and matching
  - Mentorship request system
  - Live sessions with registration

- **Sharing & Export** - Chart sharing capabilities
  - Shareable chart cards (PNG export)
  - Compatibility reports
  - Transit share cards
  - Gate of the day sharing
  - Share link generation with expiration

#### Infrastructure
- **Database Schema** - 18+ new tables for social platform
  - SQL migrations in `supabase/migrations/002_social_platform.sql`
  - Profile extensions (bio, visibility, messaging preferences)

- **RLS Security Policies** - Row-level security for all tables
  - `supabase/migrations/003_rls_policies.sql`
  - Post visibility controls
  - DM participant restrictions
  - Premium content access

- **iOS Deep Linking** - Universal Links and URL schemes
  - `ios/Runner/Info.plist` configuration
  - `ios/Runner/Runner.entitlements` for associated domains
  - OAuth callback support

#### Presentation Layer (Screens)
- **Stories** - stories_screen.dart, story_viewer_screen.dart, stories_bar.dart, create_story_sheet.dart
- **Messaging** - conversations_screen.dart, message_detail_screen.dart, new_conversation_sheet.dart
- **Gamification** - achievements_screen.dart, challenges_screen.dart, leaderboard_screen.dart
- **Learning** - learning_screen.dart, content_detail_screen.dart, mentorship_screen.dart, live_sessions_screen.dart
- **Discovery** - discovery_screen.dart with user_card, compatibility_badge, type_filter_chips widgets
- **Feed** - feed_screen.dart with post_card, reaction_bar, create_post_sheet widgets
- **Sharing** - share_screen.dart with chart_share_card, compatibility_report_card, transit_share_card widgets

#### Routes Added
- All 13 new routes configured in app_router.dart
- /discover, /feed, /achievements, /challenges, /leaderboard
- /messages, /messages/:id, /stories
- /learning, /learning/:id, /mentorship, /sessions, /share

### Previous Changes

- **Language Selection on First Launch** - Users can choose English, Russian, or Ukrainian on the onboarding screen
- **Chart Management for Others** - New screen to create and save Human Design charts for other people
  - New route `/charts/add` with full birth data entry form
  - Charts saved to Supabase with user association
  - Rename and delete functionality for saved charts
- **Full Localization** - All UI strings now support EN/RU/UK localization
  - Home screen widgets (affirmation, transits, quick actions, chart preview)
  - Auth screens (sign in, sign up, birth data)
  - Penta analysis screen
  - Saved charts screen

### Fixed
- **Planets Tab Layout** - Fixed blank screen issue by adding explicit width constraints to panels
- **Saved Charts Loading** - Removed dependency on full chart calculation to prevent infinite loading spinner
- **Affirmation Card Overflow** - Action buttons now wrap to prevent overflow on smaller screens or with longer translations
- **Type Safety Issues** - Fixed dynamic type usage in chart_screen.dart and profile_screen.dart
- **Back Button Navigation** - Learning and other sub-screens now properly handle back navigation with canPop() check
- **Auth Bypass Disabled** - kBypassAuth flag set to false for production
- **Chart Creation Auth** - Calculate Chart button now prompts login when user is unauthenticated
- **Markdown Rendering** - Learning content now renders markdown properly using flutter_markdown
- **Navigation Stack** - Sub-routes now use push() instead of go() for proper back navigation

### Changed
- **Unified Chart Display** - All charts now use the same full-featured `ChartScreen` component
  - `/chart` (My Chart) and `/chart/:id` (saved charts) now display identically
  - Saved charts get full 6-tab view (Bodygraph, Planets, Properties, Gates, Channels, Chakras)
  - Removed redundant `ChartDetailScreen` class (was showing simplified 400px view)
  - `ChartScreen` now accepts optional `chartId` parameter for loading specific charts
  - Dynamic AppBar: back button for saved charts, composite/penta buttons for user's chart
- Onboarding screen now shows language selector before welcome content
- Saved charts FAB now navigates to new chart entry screen
- Chart providers now fetch saved charts from Supabase database

## [0.1.0] - 2026-01-17

### Added
- Initial app implementation
- Human Design chart calculation using Swiss Ephemeris
- Bodygraph visualization widget
- User authentication (Email, Apple, Google via Supabase)
- Profile management with birth data
- Daily affirmations based on chart type
- Transit tracking with personal impact
- Social features (friends, groups, sharing)
- Penta (group dynamics) analysis
- Multi-language support infrastructure (EN/RU/UK)
- Dark/Light/System theme support
