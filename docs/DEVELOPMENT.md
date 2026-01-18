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
```

## Auth Bypass

For development, auth is bypassed. To toggle:

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

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/core/router/app_router.dart` | All routes |
| `lib/features/auth/domain/auth_providers.dart` | Auth logic |
| `lib/features/home/domain/home_providers.dart` | Core providers |
| `lib/core/constants/human_design_constants.dart` | HD data |

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

// Notifier (for mutable state)
final myNotifier = NotifierProvider<MyNotifier, State>(MyNotifier.new);
```
