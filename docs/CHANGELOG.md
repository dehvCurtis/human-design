# Changelog

All notable changes to this project will be documented in this file.

## [0.2.18] - 2026-02-19

### Added

#### HD Study Circles (Groups Detail Screen)
- **Group Detail Screen** - Full 3-tab group experience (Members, Shared Charts, Feed)
  - Members tab: view members with HD type badges, role chips (admin/member)
  - Shared Charts tab: browse charts shared to the group, share your own charts via chart picker
  - Feed tab: inline post composer with group discussion, delete own posts
- **Admin Controls** - Group admins can promote/demote members, remove members, edit group name/description, delete group
- **Friends-Only Invite** - Invite system limited to followed users to prevent spam
  - Search with 400ms debounce, results show user name, avatar, HD type
- **Chart Sharing to Groups** - Share saved charts exclusively within a group via bottom sheet picker
- **Group Posts Table** - New `group_posts` database table with RLS policies
  - SELECT/INSERT gated by `get_user_group_ids()` security definer function
  - DELETE allows post author or group admin
  - CHECK constraint on content length (1-5000 chars)
- **Group Validation** - CHECK constraints on groups table (name 1-100 chars, description max 500 chars)

#### Apple Sign-In Fix
- **Cancellation Handling** - Apple Sign-In no longer flashes and disappears
  - Detects `AuthorizationErrorCode.canceled` and `ASAuthorizationError 1001`
  - Returns to unauthenticated state instead of showing error
  - Applied to both sign-in and sign-up screens

#### Unit Tests
- **Group Detail Tests** - 16 tests for GroupPost/UserSearchResult parsing, validation constants, Group/GroupMember models, InviteSearchParams equality
- Total test count: 183 (up from 167)

### Changed

#### Security (Defense-in-Depth)
- UI: admin actions conditionally rendered, maxLength on all inputs
- Repository: auth check, admin role check, input length validation on every method
- Database RLS: SECURITY DEFINER functions gate all operations
- DB Constraints: CHECK constraints on text lengths
- Error Display: ErrorHandler.getUserMessage() sanitizes all errors

### Technical Details

Database migration:
- `20260220100000_group_posts.sql` - group_posts table, RLS policies, CHECK constraints

New files:
- `lib/features/social/presentation/group_detail_screen.dart` - 3-tab group detail UI
- `test/group_detail_test.dart` - 16 unit tests

Files modified:
- `social_repository.dart` - 8 new methods (updateGroup, deleteGroup, updateMemberRole, getGroupPosts, createGroupPost, deleteGroupPost, getGroupSharedCharts, searchUsersForInvite) + GroupPost/UserSearchResult models
- `social_providers.dart` - 4 new providers + 8 notifier methods
- `app_router.dart` - New `/group/:id` route
- `social_screen.dart` - Fixed group navigation (was going to Penta)
- `auth_errors.dart` - Added isAppleSignInCancelled()
- `auth_providers.dart` - Catches Apple Sign-In cancellation
- `sign_in_screen.dart`, `sign_up_screen.dart` - Skip error display on cancellation
- 8 ARB files + generated l10n files - ~35 new group localization keys

---

## [0.2.17] - 2026-02-20

### Fixed

#### Social Group Creation
- **Group Creation RLS Fix** - Fixed PostgrestException when creating social groups
  - Root cause: SELECT policy on `groups` table only allowed viewing groups where user was already in `group_members`
  - The `.insert().select().single()` pattern failed because the creator couldn't SELECT the group they just created
  - Added `created_by = auth.uid()` to groups SELECT policy so creators can see their own groups immediately
  - Cleaned up orphan RLS policies from initial schema that were never dropped by subsequent migrations
  - Consolidated group_members INSERT policy with three cases: creator bootstrap, admin add, self-join

#### Chart Sharing in Posts
- **Chart ID Placeholder Fix** - Fixed "Unable to complete the operation" error when sharing chart in a post
  - The user's own chart uses placeholder ID `'user'` which is not a valid UUID
  - Now skips sending `chart_id` when it's the `'user'` placeholder

### Added

#### Telegram Support
- **Telegram Support Channel** - Added Telegram support link in Settings > About section
  - Localized in all 8 languages (EN, RU, UK, DE, ES, PT, RO, BE)

#### Unit Tests
- **Auth Repository Tests** - 21 tests for nonce generation (length, charset, uniqueness) and SHA-256 hashing
- **Auth Notifier Tests** - 33 tests for auth state transitions, error messages, and clearError behavior
- **Chart ID Logic Tests** - 9 tests for chart ID sentinel value handling in post creation
- Total test count: 167 (up from 113)

### Changed

#### UI Consistency
- **Centered TabBars** - All tab bar sub-menus now use centered alignment across 14 screens
  - Applied `isScrollable: true` and `tabAlignment: TabAlignment.center` consistently

### Technical Details

Database migrations:
- `20260219200000_fix_group_creation_rls.sql` - Clean INSERT policies for groups and group_members
- `20260220000000_fix_groups_select_for_creator.sql` - Groups SELECT policy includes creator check

Files modified:
- `create_post_sheet.dart` - Skip chart_id for 'user' placeholder
- `settings_screen.dart` - Added Telegram support tile
- 14 screens - TabBar centering
- 8 ARB files - Telegram support localization keys
- 3 new test files in `test/`

---

## [0.2.16] - 2026-02-18

### Added

#### Microsoft Authentication
- **Microsoft Sign-In** - Added Azure AD OAuth provider for sign-in and sign-up
  - `signInWithMicrosoft()` method in auth repository using `OAuthProvider.azure`
  - `MicrosoftSignInButton` widget with custom Microsoft 4-square logo (`_MicrosoftLogo`)
  - Microsoft button added to both sign-in and sign-up screens
  - Loading state handling with `_isMicrosoftLoading`

### Changed

#### Title Screen
- **App Title Updated** - Changed onboarding welcome text from "Welcome to Inside Me" to "Inside Me: Human Design"

#### Localization
- Added `auth_signUpWithMicrosoft` key to all ARB files

### Technical Details

Files modified:
- `auth_repository.dart` - Added `signInWithMicrosoft()` method
- `auth_providers.dart` - Added `signInWithMicrosoft()` to AuthNotifier
- `oauth_button.dart` - Added `microsoft` to OAuthProvider enum, MicrosoftSignInButton, _MicrosoftLogo, _MicrosoftLogoPainter
- `sign_in_screen.dart` - Added Microsoft loading state and button
- `sign_up_screen.dart` - Added Microsoft loading state and button
- `app_en.arb` - Added auth_signUpWithMicrosoft, updated onboarding_welcome

---

## [0.2.15] - 2026-02-17

### Changed

#### Bundle ID Update
- **New Bundle ID** - Changed from `com.humandesign.app` to `com.insideme.humandesign`
  - Updated across iOS, macOS, and Android project configurations
  - Moved Android Kotlin source directory to match new package name
  - Updated proguard rules and settings screen references

#### iOS Signing Configuration
- **Manual Code Signing** - Configured Xcode project for App Store distribution
  - Distribution certificate: Apple Distribution (AFU44LJQW9)
  - Provisioning profile: Inside Me App Store Distribution
  - Manual signing applied to Debug, Release, and Profile build configurations

### Technical Details

Files modified:
- `ios/Runner.xcodeproj/project.pbxproj` - Bundle ID and manual signing config
- `macos/Runner.xcodeproj/project.pbxproj` - Bundle ID update
- `macos/Runner/Configs/AppInfo.xcconfig` - Bundle ID update
- `android/app/build.gradle.kts` - namespace and applicationId
- `android/app/src/main/kotlin/` - Moved to `com/insideme/humandesign/`
- `android/app/proguard-rules.pro` - Updated package reference
- `lib/features/settings/presentation/settings_screen.dart` - Updated bundle ID reference

---

## [0.2.14] - 2026-02-17

### Fixed

#### Security Audit
- **Social Media Feature Security** - Comprehensive security audit across social features
  - Fixed SQL injection vectors in feed, social, and messaging repositories
  - Added input validation and sanitization for user-generated content
  - Hardened RLS policies for posts, comments, reactions, stories, and messages
  - Fixed parameter name mismatches in database functions
  - Added rate limiting constraints and content length validation

### Technical Details

Files modified:
- `feed_repository.dart` - Input validation, parameterized queries
- `social_repository.dart` - Input sanitization, SQL injection prevention
- `messaging_repository.dart` - Content validation, query hardening
- `stories_repository.dart` - Input validation, expiry checks
- `discovery_repository.dart` - Search input sanitization
- `create_post_sheet.dart` - Client-side content validation
- `create_story_sheet.dart` - Input length limits
- `message_detail_screen.dart` - Message content validation
- `feed_screen.dart` - Comment input validation
- `post.dart` - Model-level validation
- `supabase/migrations/20260217000000_security_audit_fixes.sql` - DB function fixes and RLS policy hardening

---

## [0.2.13] - 2026-02-07

### Added

#### AI Transit Insights
- **Personalized Transit Interpretation** - AI-generated daily insight based on chart + transits
  - Transit header showing current Sun gate and key transits
  - Generate button with cached results
  - "Ask follow-up" button to continue in AI chat
  - Integrated on home screen via AI Features card

#### AI Chart Reading
- **Comprehensive Chart Reading** - Multi-paragraph AI reading with section parsing
  - Covers Type & Strategy, Authority, Profile, Centers, Channels, Incarnation Cross
  - Expandable section cards parsed from AI markdown response
  - PDF export via `ChartExportService.exportReadingAsPdf()`
  - Share reading as text
  - Uses 4096 max tokens for long-form content

#### AI Compatibility Reading
- **Composite Chart Analysis** - AI-powered compatibility reading for two charts
  - Accessible from composite screen via AppBar action button
  - Covers electromagnetic channels, companionship, center bridging, profile harmonics
  - Uses 2048 max tokens
  - "Ask follow-up" button for continued conversation

#### AI Dream Interpretation
- **Dream Journal Feature** - New `dream_journal/` feature module
  - `JournalEntry` model with `JournalEntryType` enum (dream/journal)
  - `DreamRepository` with full CRUD (getEntries, getEntry, createEntry, updateInterpretation, deleteEntry)
  - Dream journal list screen with entry cards, date formatting, transit Sun gate badges
  - Dream entry screen with text input and "Interpret with AI" button
  - Bottom sheet detail view with AI interpretation display
  - Dreams interpreted through HD chart + current transits lens

#### AI Journaling Prompts
- **Daily Journal Prompts** - Personalized prompts based on chart + transits
  - 3-5 AI-generated prompts displayed as cards
  - Inline text areas for writing responses
  - Save entries to journal_entries table
  - Regenerate button for new prompts
  - Transit context summary header

#### Database
- `journal_entries` table with RLS policies
  - Columns: id, user_id, content, entry_type, ai_interpretation, transit_sun_gate, conversation_id, prompt, created_at
  - `entry_type` CHECK constraint: 'dream' or 'journal'
  - Index on (user_id, created_at DESC)

#### Navigation & UI
- 6 new routes: aiTransitInsight, aiChartReading, aiCompatibility, dreamJournal, dreamEntry, journalPrompts
- AI Features card on home screen (Transit Insight + Chart Reading shortcuts)
- Quick actions: Dreams (moon icon) and Journal (edit_note icon) added
- AI button on composite screen AppBar

### Changed
- `AiContextType` enum extended with 5 new values: transitInsight, chartReading, compatibility, dream, journal
- `ChartContextBuilder` extended with `buildTransitContext()`, `buildCompatibilityContext()`, `buildTransitContextSummary()`
- `AiRepository` extended with convenience methods for all 5 features + `maxTokens` parameter
- Edge Function updated with specialized system prompts per context type and per-context max_tokens
- `ChartExportService` extended with `exportReadingAsPdf()` for AI reading PDF export
- All 8 ARB files updated with 17 new localization keys

---

## [0.2.12] - 2026-02-07

### Added

#### AI Message Packs
- **One-Time Message Packs** - Purchasable message credits for free users
  - 3 packs: 3 messages ($1.99), 5 messages ($2.99), 10 messages ($4.99)
  - Per-message pricing incentivizes subscription over packs
  - RevenueCat consumable product integration with default fallback
  - Purchase audit trail in `ai_purchases` table
- **Redesigned AI Paywall** - New `AiPremiumGate` with pack options + subscription CTA
  - Row of 3 message pack cards with price and per-message cost
  - "or subscribe for unlimited" divider
  - "Best value" badge on subscription button
  - Replaces old single "Upgrade" button
- **Home Screen Exhausted State** - AI hero CTA updates when quota is used
  - "Get more messages" label replaces "Start chatting"
  - "From $1.99" badge replaces "0 remaining"
  - Colors stay consistent with primary indigo palette

#### Database
- `bonus_messages` column on `ai_usage` table
- `add_ai_bonus_messages` RPC function (upsert with increment)
- `ai_purchases` audit table with RLS policies

### Changed
- `AiUsage` model now tracks `bonusMessages` with `effectiveLimit` getter
- Edge Function quota check factors in `bonus_messages`
- `AiPremiumGate` upgraded from `StatelessWidget` to `ConsumerWidget`

### Fixed
- **Chart Share via Post** - Fixed validation that blocked chart-only posts
  - `create_post_sheet.dart` validation now allows posts with just a chart attached
  - Previously required text or images even when chart was selected

---

## [0.2.11] - 2026-02-07

### Added

#### AI Assistant
- **AI Chat Feature** - Personalized AI assistant for Human Design questions
  - Supabase Edge Function backend with multi-provider support (Claude, Gemini, OpenAI)
  - Chart-aware system prompt with sanitized chart context (type, centers, gates, channels)
  - Conversation history with save/resume functionality
  - Usage quota enforcement (5 free messages/month, unlimited for premium)
  - Defense-in-depth: client-side and server-side quota checks
  - Input validation (2000 char limit, 20 message history cap)
  - Suggested questions based on user's chart data

#### AI Hero CTA on Home Screen
- **Prominent AI Card** - Redesigned AiMiniWidget as a large hero CTA
  - Vertical layout with 64x64 gradient icon, bold title, description
  - "Start chatting" action label with arrow
  - Stronger gradient background (15-20% alpha)
  - Moved to first position on home screen (before transit summary)
  - Usage badge for free users showing remaining messages

#### Expanded Localization
- **5 New Languages** - Added German, Spanish, Portuguese, Romanian, Belarusian
  - Total supported locales: EN, RU, UK, DE, ES, PT, RO, BE
  - All AI assistant strings localized across all 8 languages

### Fixed

#### Onboarding Screen Overflow
- **Flag Row Overflow** - Fixed RenderFlex overflow (4px on right) on onboarding screen
  - Replaced `Row` with `Wrap` widget for locale flag selector
  - Flags now wrap to second line on narrow screens instead of overflowing

#### Security
- Database security fixes (see `supabase/migrations/20260207_security_fixes.sql`)

---

## [0.2.10] - 2026-02-06

### Added

#### RevenueCat Integration
- **In-App Purchases** - Full RevenueCat SDK integration for subscriptions
  - Platform-specific initialization (iOS/macOS, Android)
  - Automatic user linking with Supabase auth
  - Monthly and yearly subscription packages
  - Free trial detection and display
  - Purchase flow with error handling
  - Restore purchases functionality
  - Supabase `is_premium` sync as fallback

### Technical Details

Files modified:
- `main.dart` - Added `_initializeRevenueCat()` for SDK initialization on app startup
- `subscription_repository.dart` - Complete rewrite from mock to RevenueCat SDK
  - `getSubscription()` - Fetches entitlements from RevenueCat
  - `getOffers()` - Fetches packages with pricing from RevenueCat offerings
  - `purchaseSubscription()` - Uses `PurchaseParams.package()` API
  - `restorePurchases()` - Restores previous purchases
  - `loginToRevenueCat()` / `logoutFromRevenueCat()` - Auth sync helpers

SDK version: purchases_flutter ^9.10.x

---

## [0.2.9] - 2026-02-05

### Changed

#### Social System Redesign
- **Removed Friends System** - Replaced mutual friends with Twitter-style following
  - Social screen now has 3 tabs: Thoughts, Discover, Groups (was 4 tabs)
  - Removed Friends tab and all friend request functionality
  - Users can now follow anyone without approval required
  - Simplified social interactions for better user experience

#### Comment Reactions
- **Comment Liking** - Fully implemented comment like functionality
  - Heart icon for liking comments (was showing "Coming Soon")
  - Toggle like on/off with visual feedback
  - Reaction count updates in real-time
  - Uses existing `reactions` table with `comment_id` field

#### Reaction Icons
- **Heart Icons** - Consistent heart icons for all like actions
  - Posts: Filled heart when liked, outline when not
  - Comments: Filled heart when liked, outline when not
  - Removed thumbs up icons throughout the app
  - Updated ReactionBar widget to use heart icons

#### Share Chart Dialog
- **Share Link First** - Create Share Link is now the primary option
  - Prominent "Create Share Link" button at top of dialog
  - Link auto-copies to clipboard on creation
  - "Manage Links" option to view existing shares
  - Groups moved to secondary section below

### Fixed

#### Code Quality
- **Deprecated API Usage** - Fixed `Share.share()` deprecation
  - Updated to `SharePlus.instance.share(ShareParams(...))` in social_screen.dart
- **Print Statements** - Replaced `print()` with `debugPrint()` in feed_providers.dart
- **Unused Code** - Removed unused `_ActionButtonCompact` widget from post_card.dart
- **Static Analysis** - All flutter analyze issues resolved (0 errors, 0 warnings)

### Removed

#### Friends System (Complete Removal)
- `Friend` and `FriendRequest` model classes from social_repository.dart
- `friendsProvider` and `pendingRequestsProvider` from social_providers.dart
- `getFriends()`, `sendFriendRequest()`, `acceptFriendRequest()`, `declineFriendRequest()`, `getPendingRequests()` methods
- `_FriendsTab` and `_FriendCard` widgets from social_screen.dart
- Pending requests badge and dialog from social screen
- Friends tab from ShareChartDialog (now Groups only + Share Link)
- ~17 friend-related localization keys from EN, RU, UK ARB files

### Technical Details

Files modified:
- `social_screen.dart` - Reduced from 4 to 3 tabs, removed all friend-related code
- `social_repository.dart` - Removed Friend/FriendRequest models and methods
- `social_providers.dart` - Removed friendsProvider and friend-related notifier methods
- `share_chart_dialog.dart` - Added Share Link section, removed Friends tab
- `new_conversation_sheet.dart` - Changed from friendsProvider to followingListProvider
- `feed_screen.dart` - Implemented comment liking with heart icons
- `feed_providers.dart` - Added reactToComment, removeCommentReaction, toggleCommentReaction methods
- `feed_repository.dart` - Added addCommentReaction, removeCommentReaction, _getUserCommentReactions methods
- `post.dart` - Added userReaction field to PostComment model
- `post_card.dart` - Changed reaction button to heart icon, removed unused widget
- `reaction_bar.dart` - Changed from thumb icon to heart icon
- `app_en.arb`, `app_ru.arb`, `app_uk.arb` - Removed friend-related localization keys

---

## [0.2.8] - 2026-02-05

### Added

#### Navigation Redesign
- **More Tab** - Replaced Profile tab in bottom navigation with "More" tab
  - Opens bottom sheet with quick access to Profile, Learn, and Settings
  - Provides cleaner navigation while accommodating new features
  - All three routes (Profile, Learning, Settings) now map to More tab index

#### Social Screen Redesign
- **Thoughts Tab** - New main tab showing feed of all thoughts/posts
  - Shows posts from all users with reactions, comments, shares
  - Floating action button to create new posts
- **Discover Tab** - Browse and discover new users to follow
  - Shows compatibility percentages with Human Design types
  - Empty state with appropriate messaging
- **Friends Tab** - View and manage friends list
  - Add Friend button at top for quick access
- **Groups Tab** - View and manage groups

#### User Profile Enhancements
- **Privacy Badge** - Shows profile visibility status (Public/Private/Friends Only)
- **Clickable Followers/Following** - Tap counts to view full lists in bottom sheet
- **Thoughts Section** - View recent posts from user profile
  - "Show All" button to see complete post history

#### Comments System
- **Reply to Comments** - Reply to specific comments with visual indicator
  - Reply button on comments (top-level only)
  - "Replying to @username" indicator above input
  - Cancel button to stop replying
- **Like Comments** - Coming soon feature with placeholder
- **Delete Own Comments** - Remove comments you've posted
  - Confirmation dialog before deletion

### Changed

#### Navigation Labels
- **Daily Tab** - Renamed "Today" tab to "Daily" in all languages
  - English: "Daily"
  - Russian: "День"
  - Ukrainian: "День"

#### Penta Analysis
- **Minimum Charts Reduced** - Penta analysis now requires only 2 charts (was 3)
  - Changed from "Select 3-5 Charts" to "Select 2-5 Charts"
  - Allows couple/pair analysis in addition to group analysis

### Fixed

#### Chart Screen
- **Sun Gate Button Removed** - Removed redundant Sun gate decimal display from chart app bar
  - Sun gate information is already visible in Planets tab

#### Quiz System
- **Answer Selection Bug** - Users can now change their answer before submitting
  - Previously, selecting an answer immediately locked the choice
  - Now answers can be changed until the user submits

#### Settings Screen
- **Rate App Button** - Fixed iOS App Store URL format
  - Now uses `itms-apps://` scheme for native app store opening
  - Includes direct link to write-review action

#### Social Groups
- **Group Creation Error Handling** - Improved error feedback when creating groups
  - Shows loading state during creation
  - Displays error message if creation fails
  - Added localized error messages (EN, RU, UK)

#### Saved Charts
- **Rename Option Hidden for Own Chart** - Users can no longer see rename option for their own chart
  - Rename option now only appears for saved charts of other people

### Technical Details

Files modified:
- `app_router.dart` - Added More tab with bottom sheet, updated route mapping
- `app_en.arb`, `app_ru.arb`, `app_uk.arb` - Added nav_more, nav_learn, updated nav_today to Daily, added comment/reply strings
- `chart_screen.dart` - Removed Sun gate button from app bar
- `penta_providers.dart` - Changed minimum from 3 to 2 charts
- `penta_screen.dart` - Updated UI text for 2-5 charts
- `question_card.dart` - Fixed answer selection to allow changes before submit
- `settings_screen.dart` - Fixed Rate App URL format for iOS
- `social_screen.dart` - Redesigned with 4 tabs (Thoughts, Discover, Friends, Groups), added FAB for posts
- `saved_charts_screen.dart` - Hidden rename for user's own chart
- `home_providers.dart` - Added SavedAffirmation model and provider
- `user_profile_screen.dart` - Added privacy badge, clickable followers/following, thoughts section
- `discovery_providers.dart` - Added userFollowersProvider and userFollowingProvider
- `discovery_repository.dart` - Added getUserFollowers() and getUserFollowing() methods
- `feed_screen.dart` - Enhanced PostDetailScreen with reply functionality, added comment actions (reply, like, delete)

---

## [0.2.7] - 2026-02-05

### Added

#### Profile Features
- **Avatar Upload** - Users can now change their profile photo
  - Camera and gallery options via bottom sheet picker
  - Images resized to 512x512 with 85% quality optimization
  - Uploads to Supabase storage with automatic URL update
  - Loading indicator during upload

#### Mentorship System
- **Mentorship Profile Setup** - Full setup flow for mentors and mentees
  - Role selection (Mentor, Mentee, or both)
  - Bio/about section (up to 500 characters)
  - Expertise areas selection (10 predefined HD topics)
  - Experience years configuration for mentors
  - Maximum mentees setting (1-10) for mentors
  - Form validation and error handling

#### Content Interaction
- **Bookmark Feature** - Save content for later reading
  - Toggle bookmark from content detail screen
  - Visual feedback with filled/outline icon states
  - Bookmarked content list provider
- **Like Feature** - Show appreciation for content
  - Toggle like with optimistic UI updates
  - Like count automatically increments/decrements
  - Visual feedback with filled/outline icon states
- **Share Feature** - Share content externally
  - Native share sheet integration via share_plus
  - Shares content title and promotional text

### Fixed

#### Code Quality
- **Lint Warnings** - Fixed null-aware operator warnings
  - `edit_profile_screen.dart` - Changed `if (action != null) action!` to `?action`
  - `detail_bottom_sheet.dart` - Changed `if (trailing != null) trailing!` to `?trailing`

#### Share Screen
- **Chart ID Placeholder** - Share links now use actual user chart ID
  - Previously used hardcoded `'current-user-chart'` placeholder
  - Now fetches from `userChartProvider` with validation
  - Shows error message if user hasn't completed birth data

### Technical Details

New repository methods added:
- `ProfileRepository.uploadAvatar(filePath)` - Upload avatar to Supabase storage
- `LearningRepository.toggleBookmark(contentId)` - Toggle bookmark state
- `LearningRepository.isBookmarked(contentId)` - Check bookmark status
- `LearningRepository.getBookmarkedContent()` - Fetch bookmarked content list
- `LearningRepository.toggleLike(contentId)` - Toggle like state
- `LearningRepository.isLiked(contentId)` - Check like status

New providers added:
- `bookmarkedContentProvider` - List of bookmarked content
- `isBookmarkedProvider(contentId)` - Check if content is bookmarked
- `isLikedProvider(contentId)` - Check if content is liked

New notifier methods:
- `LearningNotifier.toggleBookmark(contentId)` - Toggle with cache invalidation
- `LearningNotifier.toggleLike(contentId)` - Toggle with cache invalidation

Files modified:
- `profile_repository.dart` - Added avatar upload method
- `edit_profile_screen.dart` - Added image picker and upload flow
- `learning_repository.dart` - Added bookmark/like methods
- `learning_providers.dart` - Added bookmark/like providers and notifier methods
- `content_detail_screen.dart` - Added bookmark, like, and share UI components
- `mentorship_screen.dart` - Added mentorship setup bottom sheet
- `share_screen.dart` - Fixed chart ID to use actual user chart
- `detail_bottom_sheet.dart` - Fixed lint warning

---

## [0.2.6] - 2026-02-02

### Fixed

#### Heart/Ego Center Position
- Moved Heart center down and to the right for better visual balance
- Updated all Heart gate positions (51, 21, 26, 40) to match new center location
- Adjusted channel path waypoints for Heart connections

#### Gate 10 Hanging Line Direction
- Fixed Gate 10 hanging line to point downward toward Gate 57 (backbone direction)
- Integration gates (10, 20, 34) now consistently draw toward Gate 57 when hanging
- Improves visual consistency with the integration channel backbone

#### Integration Channel Backbone Rendering
- **Duplicate Lines Fixed** - Integration channels (10-20, 10-34, 10-57, 20-34, 20-57, 34-57) no longer show duplicate/bent lines when multiple channels share the same backbone segments
- **Straight Backbone** - The 20-57 diagonal backbone now renders as a clean straight line from Gate 20 (Throat) to Gate 57 (Spleen)
- **Parallel Branch Connections** - Gate 10→J1 and Gate 34→J2 branches now connect at parallel angles for visual symmetry
- **Hanging Gates Fix** - Gates belonging to multiple channels now draw only one half-line instead of overlapping lines

### Technical Details

The integration channels form a complex network where Gates 10, 20, 34, and 57 connect through shared junction points:
- **Backbone**: Gate 20 (Throat) → J1 (136, 274) → J2 (102, 337) → Gate 57 (Spleen)
- **Branches**: Gate 10 connects at J1, Gate 34 connects at J2

**Problem solved**: Previously each channel was drawn independently, causing overlapping segments to appear doubled or bent. Now shared segments are drawn once with merged color information.

Files modified:
- `bodygraph_painter.dart` - Added `_drawIntegrationChannels()` method with segment-based rendering, fixed hanging gates to use first channel only
- `bodygraph_layout_standard.dart` - Updated junction coordinates for straight backbone and parallel branches

---

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
