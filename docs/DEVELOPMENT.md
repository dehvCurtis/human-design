# Development Guide

## Setup

```bash
flutter pub get
```

## Run

```bash
# iOS Simulator
flutter run -d <simulator-id>

# List devices
flutter devices

# Run with verbose logging
flutter run -v
```

## Auth Bypass

For development, auth can be bypassed. To toggle:

```dart
// lib/features/auth/domain/auth_providers.dart:8
const bool kBypassAuth = true;  // Set to false for production
```

## Testing

```bash
flutter test
flutter analyze
```

## Key Files

### Core
| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/core/router/app_router.dart` | All routes |
| `lib/core/constants/human_design_constants.dart` | HD data |

### Auth & Profile
| File | Purpose |
|------|---------|
| `lib/features/auth/domain/auth_providers.dart` | Auth logic |
| `lib/features/profile/data/profile_repository.dart` | Profile CRUD |

### Chart & Calculations
| File | Purpose |
|------|---------|
| `lib/features/home/domain/home_providers.dart` | Core providers |
| `lib/features/ephemeris/data/ephemeris_service.dart` | Planetary calculations |
| `lib/features/chart/domain/usecases/calculate_chart.dart` | Chart calculation |

### Social Platform
| File | Purpose |
|------|---------|
| `lib/features/discovery/data/discovery_repository.dart` | User discovery |
| `lib/features/discovery/domain/matching_service.dart` | HD compatibility |
| `lib/features/feed/data/feed_repository.dart` | Posts & reactions |
| `lib/features/feed/domain/feed_providers.dart` | Feed state |
| `lib/features/stories/data/stories_repository.dart` | Ephemeral stories |
| `lib/features/messaging/data/messaging_repository.dart` | Direct messages |
| `lib/features/gamification/data/gamification_repository.dart` | Points & badges |
| `lib/features/learning/data/learning_repository.dart` | Content & mentorship |
| `lib/features/sharing/data/sharing_repository.dart` | Chart sharing |

### Database Migrations
| File | Purpose |
|------|---------|
| `supabase/migrations/002_social_platform.sql` | Social tables schema |
| `supabase/migrations/003_rls_policies.sql` | RLS security policies |

### iOS Configuration
| File | Purpose |
|------|---------|
| `ios/Runner/Info.plist` | Deep linking, privacy |
| `ios/Runner/Runner.entitlements` | Associated domains |

## Adding a Screen

1. Create `lib/features/{feature}/presentation/{name}_screen.dart`
2. Add route in `app_router.dart`
3. Create providers in `domain/{feature}_providers.dart`

## Adding a Provider

```dart
// Simple provider
final myProvider = Provider<Type>((ref) => value);

// Async provider
final myAsyncProvider = FutureProvider<Type>((ref) async => value);

// Parameterized provider
final myFamilyProvider = FutureProvider.family<Type, Param>((ref, param) async => value);

// Notifier (for mutable state)
final myNotifier = NotifierProvider<MyNotifier, State>(MyNotifier.new);
```

## Adding a Repository

1. Create `lib/features/{feature}/data/{feature}_repository.dart`
2. Inject `SupabaseClient` via constructor
3. Create provider in `{feature}_providers.dart`:

```dart
final myRepositoryProvider = Provider<MyRepository>((ref) {
  return MyRepository(supabaseClient: ref.watch(supabaseClientProvider));
});
```

## Database Migrations

Apply migrations to Supabase:

```bash
# Push all migrations
supabase db push

# View diff
supabase db diff

# Reset database (destructive)
supabase db reset
```

## Feature Module Template

```
lib/features/{feature}/
├── data/
│   └── {feature}_repository.dart
├── domain/
│   ├── models/
│   │   └── {feature}.dart
│   └── {feature}_providers.dart
└── presentation/
    ├── {feature}_screen.dart
    └── widgets/
        └── {feature}_widget.dart
```

## Debugging

### Riverpod
```dart
// Enable provider logging
ProviderScope(
  observers: [ProviderLogger()],
  child: MyApp(),
)
```

### Supabase
```dart
// Enable Supabase logging
Supabase.initialize(
  debug: true,
  ...
)
```

## Code Style

- Use `const` constructors where possible
- Prefer `final` over `var`
- Use named parameters for clarity
- Document public APIs with dartdoc
- Localize all user-facing strings
