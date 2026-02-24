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

## Authentication

### Apple Sign-In (Native)
Uses `sign_in_with_apple` package — shows the native iOS sheet, passes ID token to Supabase via `signInWithIdToken`. No browser redirect needed.

### Google Sign-In (OAuth)
Opens external Safari with PKCE flow. After auth, redirects to `io.humandesign.app://auth/callback`. Supabase Flutter's built-in `app_links` listener handles the callback automatically.

### Environment
Supabase credentials are loaded from `.env` via `flutter_dotenv`.

## Testing

### Unit & Widget Tests

```bash
# Run all tests (183 passing)
flutter test

# Run specific suites
flutter test test/calculate_chart_test.dart       # Chart calculation (22 tests)
flutter test test/gate_wheel_offset_test.dart     # HD wheel offset
flutter test test/feed_post_test.dart             # Post model (40 tests)
flutter test test/ai_usage_test.dart              # AI quota (35 tests)
flutter test test/auth_repository_test.dart       # Nonce & SHA-256 (21 tests)
flutter test test/auth_notifier_test.dart         # Auth state (33 tests)
flutter test test/create_post_chart_id_test.dart  # Chart ID logic (9 tests)

# Static analysis
flutter analyze
```

### RLS & Database Tests (77 tests)

SQL-based test suite that verifies Row Level Security policies and social platform functionality against the live Supabase database.

```bash
# Run full suite (setup → RLS tests → functional tests → cleanup)
cd supabase/tests
psql $DATABASE_URL -f run_all_tests.sql

# Or run individual phases:
psql $DATABASE_URL -f 00_setup_test_users.sql    # Create 5 test users + data
psql $DATABASE_URL -f 01_rls_privacy_tests.sql   # 54 RLS privacy tests
psql $DATABASE_URL -f 02_functional_tests.sql    # 23 functional smoke tests
```

**Test users** (fixed UUIDs for reproducibility):

| User | UUID Suffix | Tier | Profile | Purpose |
|------|-------------|------|---------|---------|
| `user_free` | `...0001` | Free | Public | Free user limits |
| `user_premium` | `...0002` | Premium | Public | Premium access |
| `user_private` | `...0003` | Free | Private | Privacy enforcement |
| `user_blocked` | `...0004` | Free | Public | Block list enforcement |
| `user_stranger` | `...0005` | Free | Public | Zero-relationship access |

**RLS test coverage** (54 tests):
- A. Profile Privacy (5) - public/private visibility, premium escalation, cross-user update
- B. Posts & Feed (8) - public/followers-only, block filter, create/delete auth
- C. Stories (6) - visibility, expiry, block filter
- D. Direct Messages (6) - participant access, sender spoofing, read marking
- E. Groups (7) - member/non-member access, admin-only updates
- F. Circles (5) - private circle isolation, creator-only delete
- G. AI & Usage (5) - conversation/usage isolation
- H. Gamification (4) - points/challenges isolation
- I. Cross-User Isolation (5) - charts, transactions, journal, notifications
- J. Block List (3) - follow blocking, block list visibility

**Functional test coverage** (23 tests):
- Social graph CRUD, posts/comments/reactions, groups, stories, messaging, AI, gamification

### Security Migrations

| Migration | Purpose |
|-----------|---------|
| `20260208_security_hardening.sql` | Team/circle function auth checks, AI usage lockdown |
| `20260217000000_security_audit_fixes.sql` | LLM rate limiting, contribute_points_to_team fix |
| `20260222100000_fix_critical_audit_issues.sql` | RLS policy fixes (circles, points, pentas, DMs) |
| `20260223100000_llm_security_hardening.sql` | AI purchase redemption tracking, rate limit table |
| `20260224000000_fix_team_functions.sql` | Fix team functions to reference `challenge_teams` |

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
