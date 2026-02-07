# Add New Provider

Create a Riverpod provider following the app's conventions — with correct dependency chains, error handling, and cache invalidation.

## Instructions

When the user provides: `$ARGUMENTS`

Parse the arguments to determine:
1. Feature name
2. Provider name and purpose
3. Provider type (Provider, FutureProvider, StreamProvider, NotifierProvider)
4. Data source (repository, service, other provider)

### Step 1: Read existing patterns

Before writing, read existing providers in the target feature:
- `lib/features/<feature>/domain/<feature>_providers.dart` — existing provider patterns
- `lib/features/<feature>/data/<feature>_repository.dart` — repository if exists
- `lib/shared/providers/supabase_provider.dart` — Supabase client provider

Match the conventions found (naming, dependency patterns, error handling).

### Step 2: Choose the right provider type

**Provider** — synchronous, single instance:
```dart
final <name>RepositoryProvider = Provider<Repository>((ref) {
  return Repository(ref.watch(supabaseClientProvider));
});
```

**FutureProvider** — async data, auto-caches:
```dart
final <name>Provider = FutureProvider<Type>((ref) async {
  final repo = ref.watch(<feature>RepositoryProvider);
  try {
    return await repo.fetchData();
  } catch (e) {
    // Log error, rethrow for AsyncValue.error state
    rethrow;
  }
});
```

**FutureProvider.family** — parameterized (use record for multiple params):
```dart
final <name>Provider = FutureProvider.family<Type, ({String id, bool includeDetails})>(
  (ref, params) async {
    final repo = ref.watch(<feature>RepositoryProvider);
    return repo.fetchById(params.id, includeDetails: params.includeDetails);
  },
);
```

**StreamProvider** — realtime data:
```dart
final <name>StreamProvider = StreamProvider<Type>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('<table>')
      .stream(primaryKey: ['id'])
      .eq('user_id', client.auth.currentUser!.id)
      .map((data) => data.map((e) => Type.fromJson(e)).toList());
});
```

**NotifierProvider** — complex mutable state:
```dart
class <Name>Notifier extends Notifier<State> {
  @override
  State build() {
    return State.initial();
  }

  Future<void> doAction(params) async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(<feature>RepositoryProvider);
      final result = await repo.action(params);
      state = state.copyWith(data: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final <name>NotifierProvider = NotifierProvider<<Name>Notifier, State>(
  () => <Name>Notifier(),
);
```

**AsyncNotifierProvider** — async initialization + mutations:
```dart
class <Name>Notifier extends AsyncNotifier<Type> {
  @override
  Future<Type> build() async {
    final repo = ref.watch(<feature>RepositoryProvider);
    return repo.fetchData();
  }

  Future<void> update(params) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(<feature>RepositoryProvider);
      return repo.update(params);
    });
  }
}

final <name>NotifierProvider = AsyncNotifierProvider<<Name>Notifier, Type>(
  () => <Name>Notifier(),
);
```

### Step 3: Wire up dependencies

- Use `ref.watch()` for providers the data depends on (auto-refreshes when dependency changes)
- Use `ref.read()` inside methods that are triggered by user actions (one-time reads)
- Add repository provider if it doesn't exist

### Step 4: Add invalidation patterns

For providers that should refresh after mutations:
```dart
// In the notifier that performs the mutation:
Future<void> create(params) async {
  await repo.create(params);
  // Invalidate the list provider so it refetches
  ref.invalidate(<name>ListProvider);
}
```

### Step 5: Add to providers file

Add the new provider to `lib/features/<feature>/domain/<feature>_providers.dart`. Create the file if it doesn't exist with proper imports.

### Step 6: Show consumer example

Provide a usage example:
```dart
// In a ConsumerWidget:
final dataAsync = ref.watch(<name>Provider);
return dataAsync.when(
  data: (data) => /* build UI */,
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
);
```

Example usage:
- `/add-provider chart/gateDetail FutureProvider.family` — Gate detail by ID
- `/add-provider social/friendsList FutureProvider` — Friends list
- `/add-provider events/eventForm NotifierProvider` — Event creation form state
- `/add-provider feed/posts StreamProvider` — Realtime post feed
