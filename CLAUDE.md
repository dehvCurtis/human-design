# Human Design App - Claude Agent Guide

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
│   ├── auth/                    # Authentication
│   │   ├── data/auth_repository.dart
│   │   └── domain/auth_providers.dart
│   ├── chart/                   # Chart calculation & display
│   │   ├── domain/models/human_design_chart.dart
│   │   ├── domain/usecases/calculate_chart.dart
│   │   └── presentation/widgets/bodygraph/
│   ├── ephemeris/               # Swiss Ephemeris integration
│   │   ├── data/ephemeris_service.dart
│   │   └── mappers/degree_to_gate_mapper.dart
│   ├── home/                    # Home screen
│   ├── lifestyle/               # Affirmations, transits
│   ├── penta/                   # Group chart calculations
│   ├── profile/                 # User profile
│   ├── social/                  # Friends, groups, sharing
│   ├── gamification/            # Points, badges, streaks (WIP)
│   └── subscription/            # Premium features (WIP)
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
1. Convert birth datetime to Julian Day
2. Calculate planetary positions (Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto, North Node, South Node)
3. Calculate **conscious activations** (at birth)
4. Find prenatal date (88° before birth Sun position)
5. Calculate **unconscious activations** (at prenatal)
6. Map degrees → gates → lines
7. Determine active channels (both gates defined)
8. Determine defined centers (from active channels)
9. Calculate Type, Authority, Profile, Definition

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

### Completed
- ✅ Supabase auth (email, Apple, Google)
- ✅ Swiss Ephemeris planetary calculations
- ✅ Bodygraph visualization widget
- ✅ Home screen with affirmations & transits
- ✅ Profile & social repositories
- ✅ Localization infrastructure

### In Progress / Placeholder
- ⚠️ Auth screens (SignIn, SignUp, BirthData)
- ⚠️ Chart screen with full interactivity
- ⚠️ Transits screen
- ⚠️ Profile screen
- ⚠️ Social screen
- ⚠️ Settings screen

### Not Started
- ❌ Gamification features
- ❌ Subscription/premium features
- ❌ Offline support (Drift)
- ❌ Push notifications

## Code Style Guidelines

1. **Use Riverpod** for all state management
2. **Clean Architecture**: Separate data/domain/presentation layers
3. **Feature-based** folder structure
4. **Prefer composition** over inheritance
5. **Use const** constructors where possible
6. **Document public APIs** with dartdoc comments
7. **Localize all user-facing strings**

## Testing Strategy

- **Unit tests**: Chart calculations, mappers, services
- **Widget tests**: Bodygraph rendering, form validation
- **Integration tests**: Auth flows, chart generation
- **Manual verification**: Chart accuracy against humdes.com

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
3. Review `calculate_chart.dart` for type/authority logic changes
4. Test against known charts for accuracy
