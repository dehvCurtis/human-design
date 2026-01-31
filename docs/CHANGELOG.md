# Changelog

All notable changes to this project will be documented in this file.

## [0.2.5] - 2026-01-30

### Added

#### Bodygraph Zoom & Pan
- **Pinch-to-Zoom** - Use two fingers to zoom in/out on the bodygraph
- **Zoom Controls** - +/- buttons on chart screen for zoom control
  - Plus button to zoom in
  - Minus button to zoom out
  - Reset button to restore default view
- **Pan/Drag** - Click and drag to pan around when zoomed
- Zoom range: 0.5x to 4.0x scale
- New widget parameters: `enableZoom`, `showZoomControls`

### Changed

#### Bodygraph Display Improvements
- **Chart Scale** - Added 1.05x scale multiplier for better fit
  - Compensates for internal padding in the 400x600 canvas
  - Prevents chart from overflowing under app bar
- **Ego/Heart Center Shape** - Changed from triangle to circle
  - Ego center now renders as a circle instead of an upward-pointing triangle
  - Added `circle` to `CenterShape` enum
  - Added `_drawCircleCenter()` method in bodygraph painter
- **Ego Gate Positions** - Repositioned gates in grid pattern
  - Gates 51 & 21: top row, horizontally aligned
  - Gates 26 & 40: bottom row, horizontally aligned
  - Gates 51 & 26: left column, vertically aligned
  - Gates 21 & 40: right column, vertically aligned

### Fixed

#### User Flow Issues
- **Sign In/Up Back Button** - Fixed navigation loop where back button went to home (which requires auth)
  - Now uses `context.pop()` if possible, otherwise goes to onboarding
- **Chart Share Button** - Implemented share button to navigate to share screen
- **Social Routes Bottom Nav** - Added feed, discover, messages, stories, circles routes to social tab mapping
- **Auth Validation on Create Post** - Added auth check before opening create post sheet with sign-in prompt
- **Auth Validation on Share Screen** - Added auth check with sign-in prompt for unauthenticated users
- **Auth Validation on New Message** - Added auth check before opening new conversation sheet

### Technical Details

Files modified:
- `bodygraph_widget.dart` - Added InteractiveViewer for zoom/pan, zoom control buttons
- `bodygraph_painter.dart` - Added 1.05x scale multiplier, added circle drawing method
- `bodygraph_layout.dart` - Added `circle` to CenterShape enum
- `bodygraph_layout_standard.dart` - Changed heart center shape to circle, repositioned ego gates
- `chart_screen.dart` - Enabled zoom controls on bodygraph tab, implemented share button
- `sign_in_screen.dart` - Fixed back button navigation
- `sign_up_screen.dart` - Fixed back button navigation
- `app_router.dart` - Added social routes to bottom nav mapping
- `feed_screen.dart` - Added auth check for create post
- `share_screen.dart` - Added auth check and sign-in prompt
- `conversations_screen.dart` - Added auth check for new message

---

## [0.2.4] - 2026-01-29

### Added

#### Hanging Gates (Half-Channel) Visualization
- **Bodygraph Painter** - Gates that don't form complete channels now display as half-lines
  - Full channel (both gates active) = Full line between centers
  - Hanging gate (one gate active) = Half line from center to midpoint
  - Matches humdes.com and standard Human Design chart rendering
  - Colors indicate activation type: black (conscious), red (unconscious), striped (both)

### Technical Details

Added `_drawHangingGates()` method in `bodygraph_painter.dart`:
- Identifies activated gates not part of complete channels
- Calculates path from gate position to channel midpoint using path interpolation
- Renders with appropriate color based on conscious/unconscious activation
- New rendering layer inserted between inactive channels and active channels

---

## [0.2.3] - 2026-01-29

### Fixed

#### Critical Chart Calculation Bug
- **HD Wheel Offset** - Fixed missing 58° offset in gate mapping
  - The Human Design wheel is offset from the tropical zodiac by 58°
  - Gate 41 starts at 2° Aquarius (302° tropical), not 0° Aries
  - Previously all gate calculations were off by ~10 gates
  - Charts now match reference sites (humdes.com, Jovian Archive)
  - Affects: Type, Profile, Authority, Definition, Channels, Gates - everything!

#### Birth Time Display Bug
- **Profile Screen** - Birth time now displays in local timezone instead of UTC
  - Previously showed UTC time (e.g., "5:24 PM" instead of "10:24 AM")
  - Added timezone conversion using stored IANA timezone string
  - Fixed in both ProfileScreen and EditProfileScreen

### Added

#### Diagnostic Logging
- **Chart Calculation Debug Output** - Enhanced logging for chart verification
  - Displays Julian Day values, planetary longitudes, and gate mappings
  - Shows key values (Sun, Earth gates) for easy comparison with reference charts
  - Helps verify chart accuracy against humdes.com

#### Test Coverage
- **Gate Wheel Offset Tests** - New test file `test/gate_wheel_offset_test.dart`
  - Verifies 0° Aries maps to Gate 25 (not Gate 41)
  - Confirms all 64 gates are reachable
  - Validates Incarnation Cross calculation
  - Tests gate↔degree round-trip conversion

### Technical Details

The fix adds a constant offset in `DegreeToGateMapper`:
```dart
/// HD wheel offset from tropical zodiac.
/// Gate 41 starts at 302° tropical (2° Aquarius), so we add 58° to align.
static const double _hdWheelOffset = 58.0;
```

## [0.2.2] - 2026-01-22

### Added

#### Chart Screen Enhancements
- **Sun Gate Quick Access** - Sun gate.line notation displayed in top-left of Chart screen app bar
  - Tappable chip linking directly to Today's Transits screen
  - Shows user's conscious Sun activation (e.g., "14.2")
  - Styled with conscious (indigo) theme color

#### Transit Screen Improvements
- **Gate Keynotes in Planet Cards** - Each planet position now displays the gate keynote
  - Colored box below planet info showing the I Ching keynote
  - Planet-themed background colors for visual distinction
  - Provides immediate insight into transit meanings

### Changed

#### Chart Screen App Bar Reorganization
- **Left side**: Sun gate chip, Composite button, Penta button
- **Right side**: Saved Charts, Add Chart, Share buttons
- Improved leadingWidth to accommodate additional buttons

## [0.2.1] - 2026-01-20

### Fixed

#### Integration Channel Layout
- **Redesigned Integration channels (10-20-34-57)** - Fixed visual layout to match standard Human Design bodygraph
  - Channel 20-57 now forms the diagonal backbone from Throat to Spleen
  - Gate 10 connects to the diagonal at junction J1 (140, 265)
  - Gate 34 connects to the diagonal at junction J2 (105, 330)
  - Channels now form proper perpendicular intersections
  - All 6 Integration channels (10-20, 10-34, 10-57, 20-34, 20-57, 34-57) properly routed

#### Heart/Ego Center Adjustments
- **Repositioned Heart/Ego center** - Moved up 10px (y: 355→345) for better visual balance
- **Resized Heart/Ego center** - Made 10% larger (37x29 → 41x32)
- **Gate 51 repositioned** - Now on LEFT side middle of triangle (was at top tip)
- **Gate 21 repositioned** - Now on RIGHT side middle of triangle
- **Gates 26 & 40** - Adjusted to new bottom corners
- **Channel paths updated** - 25-51, 21-45, 26-44, 37-40 routes recalculated

#### Saved Charts Screen
- **Gate numbers now visible** - Changed `showGateNumbers: false` to `true` in BodygraphWidget

### Changed
- Updated bodygraph layout documentation and comments
- Integration channel comments now document junction points and routing logic

## [0.2.0] - 2026-01-19

### Added

#### Sharing Feature
- **My Shares Screen** - Dedicated screen for managing share history
  - View all active and expired share links
  - Statistics dashboard (total links, active, views)
  - Copy, revoke, and clear expired links
  - Full localization support (EN, RU, UK)

#### Semantic Versioning
- Implemented semantic versioning (MAJOR.MINOR.PATCH+BUILD)
- Added versioning documentation to `docs/STANDARDS.md`
- Version history tracking

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
