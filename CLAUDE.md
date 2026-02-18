# Inside Me: Human Design - Claude Agent Guide

This document provides context for Claude Code to work effectively with this Flutter Human Design application.

## Project Overview

This is a **Human Design charting app** built with Flutter. Human Design is a system that combines astrology, the I Ching, Kabbalah, and the chakra system to create a unique "bodygraph" chart based on birth data.

### Tech Stack
- **Framework**: Flutter 3.x with Dart
- **State Management**: Riverpod (flutter_riverpod)
- **Navigation**: GoRouter (go_router)
- **Backend**: Supabase (auth, database, realtime)
- **Calculations**: Swiss Ephemeris (sweph package)
- **Architecture**: Clean Architecture with feature-based organization

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core infrastructure
│   ├── config/app_config.dart   # Configuration constants
│   ├── constants/human_design_constants.dart  # HD data (gates, channels, centers)
│   ├── router/app_router.dart   # GoRouter navigation
│   └── theme/                   # Theming (app_theme.dart, app_colors.dart)
├── features/                    # Feature modules
│   ├── ai_assistant/             # AI chat assistant
│   │   ├── data/ai_repository.dart
│   │   ├── data/chart_context_builder.dart
│   │   ├── domain/ai_providers.dart
│   │   ├── domain/models/ai_conversation.dart
│   │   ├── domain/models/ai_message.dart
│   │   ├── domain/models/ai_usage.dart
│   │   └── presentation/ai_chat_screen.dart
│   ├── auth/                    # Authentication
│   │   ├── data/auth_repository.dart
│   │   └── domain/auth_providers.dart
│   ├── chart/                   # Chart calculation & display
│   │   ├── domain/models/human_design_chart.dart
│   │   ├── domain/usecases/calculate_chart.dart
│   │   └── presentation/widgets/bodygraph/
│   ├── discovery/               # User discovery & matching
│   ├── ephemeris/               # Swiss Ephemeris integration
│   │   ├── data/ephemeris_service.dart
│   │   └── mappers/degree_to_gate_mapper.dart
│   ├── feed/                    # Social content feed
│   ├── gamification/            # Points, badges, challenges, leaderboards
│   ├── home/                    # Home screen
│   ├── learning/                # Content library & mentorship
│   ├── lifestyle/               # Affirmations, transits
│   ├── messaging/               # Direct messages
│   ├── notifications/           # Push notifications (FCM)
│   ├── penta/                   # Group chart calculations
│   ├── profile/                 # User profile
│   ├── quiz/                    # HD knowledge quizzes
│   ├── sharing/                 # Chart export & sharing
│   ├── social/                  # Friends, groups
│   ├── stories/                 # 24h ephemeral content
│   └── subscription/            # Premium features (RevenueCat)
├── shared/
│   ├── providers/supabase_provider.dart
│   └── widgets/                 # Reusable UI components
└── l10n/                        # Localization (EN, RU, UK)
```

## Human Design Domain Concepts

### Core Components
- **9 Centers**: Head, Ajna, Throat, G (Self), Heart/Ego, Sacral, Solar Plexus, Spleen, Root
- **64 Gates**: Each maps to a specific degree of the zodiac
- **36 Channels**: Connect gates between centers
- **5 Types**: Manifestor, Generator, Manifesting Generator, Projector, Reflector
- **7 Authorities**: Emotional, Sacral, Splenic, Ego, Self-Projected, Environment, Lunar
- **12 Profiles**: 1/3, 1/4, 2/4, 2/5, 3/5, 3/6, 4/6, 4/1, 5/1, 5/2, 6/2, 6/3

### Chart Calculation Flow
1. Convert birth datetime to Julian Day (UTC)
2. Calculate planetary positions using Swiss Ephemeris (tropical zodiac longitude)
3. Calculate **conscious activations** (at birth)
4. Find prenatal date (88° before birth Sun position)
5. Calculate **unconscious activations** (at prenatal)
6. **Apply 58° HD wheel offset** to convert tropical longitude to HD gate position
7. Map HD wheel position → gates → lines (5.625° per gate, 0.9375° per line)
8. Determine active channels (both gates defined)
9. Determine defined centers (from active channels)
10. Calculate Type, Authority, Profile, Definition

### Critical: HD Wheel Offset
The Human Design mandala is offset from the tropical zodiac by **58°**:
- Gate 41 starts at 2° Aquarius (302° tropical), NOT 0° Aries
- 0° Aries (Spring Equinox) = Gate 25, not Gate 41
- Implementation: `hdWheelPosition = (tropicalLongitude + 58.0) % 360`
- Without this offset, all gates will be wrong by ~10 positions

### Key Files for Chart Logic
- `lib/features/ephemeris/data/ephemeris_service.dart` - Swiss Ephemeris calculations
- `lib/features/ephemeris/mappers/degree_to_gate_mapper.dart` - Degree to gate conversion
- `lib/features/chart/domain/usecases/calculate_chart.dart` - Type/Authority/Profile logic
- `lib/core/constants/human_design_constants.dart` - Gate/Channel/Center definitions

## State Management Patterns

### Riverpod Providers
```dart
// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

// Async data provider
final userChartProvider = FutureProvider<HumanDesignChart?>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  if (profile?.birthData == null) return null;
  return ref.read(calculateChartUseCaseProvider).execute(profile!.birthData!);
});

// Notifier for complex state
final authNotifierProvider = NotifierProvider<AuthNotifier, AppAuthState>(() {
  return AuthNotifier();
});
```

## Key Development Commands

```bash
# Run the app
flutter run

# Run with specific device
flutter run -d <device_id>

# Generate localization files
flutter gen-l10n

# Run tests
flutter test

# Build for iOS
flutter build ios

# Build for Android
flutter build apk
```

## Current Implementation Status

### Core Features ✅
- ✅ Supabase auth (email, Apple, Google)
- ✅ Swiss Ephemeris planetary calculations
- ✅ Bodygraph visualization widget with all 9 centers, gates, channels
- ✅ Chart screen with 6 tabs (Bodygraph, Planets, Properties, Gates, Channels, Chakras)
- ✅ Home screen with affirmations, transits, gamification progress
- ✅ Saved charts management (create, rename, delete)
- ✅ Profile screen with birth data editing
- ✅ Settings screen with theme and language selection
- ✅ Full localization (EN, RU, UK, DE, ES, PT, RO, BE)

### Social Platform ✅
- ✅ Discovery screen with HD compatibility matching
- ✅ Content feed with posts and reactions
- ✅ Stories (24h ephemeral content)
- ✅ Direct messaging with real-time delivery
- ✅ Chart sharing with friends/groups

### Gamification ✅
- ✅ Points system with level progression
- ✅ Daily login streaks with bonuses
- ✅ Badge system with 5 categories
- ✅ Daily/weekly/monthly challenges
- ✅ Leaderboards (weekly, monthly, all-time)
- ✅ Auto-assignment of daily challenges on login
- ✅ Home screen gamification summary card

### Learning & Quiz ✅
- ✅ Quiz system with 138+ HD questions
- ✅ Multiple quiz categories (Types, Centers, Authorities, etc.)
- ✅ Quiz progress tracking and scoring
- ✅ Content library for learning materials

### AI Assistant ✅
- ✅ AI chat with personalized chart context
- ✅ Multi-provider backend (Claude, Gemini, OpenAI)
- ✅ Conversation history and management
- ✅ Usage quota (5 free/month, unlimited premium)
- ✅ Hero CTA on home screen (first position)
- ✅ Supabase Edge Function backend

### Subscription/Premium ✅
- ✅ Subscription models and repository
- ✅ Premium screen with paywall UI
- ✅ Subscription providers with purchase/restore
- ✅ Share limit enforcement for free users
- ✅ RevenueCat SDK integration (requires App Store/Play Store product setup)

### Push Notifications ✅
- ✅ Firebase Cloud Messaging integration
- ✅ Notification service with local notifications
- ✅ Topic subscriptions (transits, affirmations, challenges)
- ✅ Notification preferences provider
- ✅ Gracefully optional Firebase (app runs without `flutterfire configure`)

### Store Readiness ✅
- ✅ iOS bundle identifier updated (`com.insideme.humandesign`)
- ✅ iOS PrivacyInfo.xcprivacy manifest (iOS 17+ requirement)
- ✅ Firebase gracefully optional via `firebaseConfigured` flag
- ✅ RevenueCat gracefully optional via `revenueCatConfigured` flag
- ✅ Removed unused `screenshot` package dependency
- ✅ Replaced deprecated `flutter_markdown` with `flutter_markdown_plus`
- ✅ Dismissable AI premium gate in chat screen
- ✅ Chart image rendering for post attachments (Canvas-based PNG export)
- ✅ Profile avatar button on home screen app bar
- ✅ Auto-dispose journal/dream entry providers for fresh data

### Not Started
- ❌ Offline support (Drift local database)
- ❌ App Store / Play Store submission (ready for submission)

## Code Style Guidelines

1. **Use Riverpod** for all state management
2. **Clean Architecture**: Separate data/domain/presentation layers
3. **Feature-based** folder structure
4. **Prefer composition** over inheritance
5. **Use const** constructors where possible
6. **Document public APIs** with dartdoc comments
7. **Localize all user-facing strings**

## Testing Strategy

- **Unit tests**: Chart calculations, mappers, services, models
  - `test/gate_wheel_offset_test.dart` - Verifies 58° HD wheel offset
  - `test/timezone_fix_test.dart` - Verifies timezone conversions
  - `test/calculate_chart_test.dart` - Type, Authority, Definition calculation logic (22 tests)
  - `test/ai_usage_test.dart` - AI quota, bonus messages, period reset (35 tests)
  - `test/feed_post_test.dart` - Post model, enums, content validation (40 tests)
- **Widget tests**: App smoke test, bodygraph rendering, form validation
  - `test/widget_test.dart` - App renders with mocked Firebase and providers
- **Integration tests**: Auth flows, chart generation
- **Manual verification**: Chart accuracy against humdes.com
  - Compare Conscious/Design Sun gates
  - Verify Type, Profile, Authority
  - Check Incarnation Cross (Sun/Earth gates)
- **Current coverage**: 113+ tests passing

## Common Tasks

### Adding a new screen
1. Create screen file in `features/<feature>/presentation/`
2. Add route in `core/router/app_router.dart`
3. Create any needed providers in `features/<feature>/domain/`
4. Add localization strings to `l10n/` ARB files

### Adding a new provider
1. Create in `features/<feature>/domain/<feature>_providers.dart`
2. Use appropriate provider type (Provider, FutureProvider, NotifierProvider)
3. Document dependencies and usage

### Modifying chart calculations
1. Review `ephemeris_service.dart` for planetary position changes
2. Review `degree_to_gate_mapper.dart` for gate mapping changes
   - **Important**: The 58° HD wheel offset is applied here
   - Do NOT remove `_hdWheelOffset` constant
3. Review `calculate_chart.dart` for type/authority logic changes
4. Run `flutter test test/gate_wheel_offset_test.dart` to verify accuracy
5. Test against humdes.com with known birth data
