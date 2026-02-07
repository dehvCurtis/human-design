# Add New Screen

Create a complete new screen following the app's Clean Architecture pattern — screen widget, providers, route, and localization — all wired up.

## Instructions

When the user provides: `$ARGUMENTS`

Parse the feature name, screen name, and any additional context (data source, model needs) from the arguments.

Format: `feature/screen_name [description]`

### Step 1: Read existing patterns

Before generating anything, read existing screens in the same feature to match conventions:
- `lib/features/<feature>/presentation/` — existing screen patterns
- `lib/features/<feature>/domain/` — existing providers and models
- `lib/features/<feature>/data/` — existing repositories
- `lib/core/router/app_router.dart` — route patterns
- `lib/core/theme/app_colors.dart` — color tokens

If the feature folder doesn't exist yet, read a similar feature (e.g., `events/`, `feed/`, `chart/`) for patterns.

### Step 2: Create the screen file

Create `lib/features/<feature>/presentation/<screen_name>_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class <ScreenName>Screen extends ConsumerStatefulWidget {
  const <ScreenName>Screen({super.key});

  @override
  ConsumerState<<ScreenName>Screen> createState() => _<ScreenName>ScreenState();
}

class _<ScreenName>ScreenState extends ConsumerState<<ScreenName>Screen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.<feature>_<screenName>Title),
      ),
      body: const Center(
        child: Text('TODO: Implement'),
      ),
    );
  }
}
```

### Step 3: Create providers if needed

If the screen needs data, create or update `lib/features/<feature>/domain/<feature>_providers.dart`:

```dart
final <name>Provider = FutureProvider<Type>((ref) async {
  final repo = ref.watch(<feature>RepositoryProvider);
  return repo.fetchData();
});
```

### Step 4: Create model if needed

If the arguments mention a data source or model, create `lib/features/<feature>/domain/models/<model_name>.dart` with:
- Immutable fields (final)
- `fromJson` factory constructor
- `toJson` method
- `copyWith` method

### Step 5: Create repository if data source specified

If the arguments mention Supabase or API data, create `lib/features/<feature>/data/<feature>_repository.dart`:

```dart
class <Feature>Repository {
  final SupabaseClient _client;

  <Feature>Repository(this._client);

  Future<List<Model>> fetchAll() async {
    final response = await _client
        .from('<table>')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((e) => Model.fromJson(e)).toList();
  }
}
```

### Step 6: Add route to app_router.dart

Read `lib/core/router/app_router.dart` and add a new `GoRoute`:

```dart
GoRoute(
  path: '/<feature>/<screen-name>',
  name: '<screenName>',
  builder: (context, state) => const <ScreenName>Screen(),
),
```

Place it in the appropriate location (inside `ShellRoute` for tab screens, at top level for full-screen routes).

### Step 7: Add localization keys

Add keys to all 3 ARB files:
- `lib/l10n/app_en.arb` — English strings
- `lib/l10n/app_ru.arb` — Russian translations
- `lib/l10n/app_uk.arb` — Ukrainian translations

Key naming: `<feature>_<descriptiveName>` (e.g., `events_detailTitle`, `events_noEventsFound`)

At minimum, add: title, empty state message, and any button labels.

### Step 8: Verify

Run these commands:
```bash
flutter gen-l10n
flutter analyze
```

Report what was created and flag any manual steps remaining.

Example usage:
- `/add-screen events/event_detail Event detail page showing event info and attendees`
- `/add-screen profile/edit_profile Edit profile form with birth data`
- `/add-screen chart/gate_detail Detail view for a specific gate`
