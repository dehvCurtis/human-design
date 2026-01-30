# Add New Provider

Create a new Riverpod provider for the Human Design app.

## Instructions

When the user provides: `$ARGUMENTS`

Parse the arguments to determine:
1. Feature name
2. Provider name
3. Provider type (Provider, FutureProvider, StreamProvider, NotifierProvider)

Create the provider following these patterns:

### Simple Provider
```dart
final <name>Provider = Provider<Type>((ref) {
  return Type();
});
```

### FutureProvider (for async data)
```dart
final <name>Provider = FutureProvider<Type>((ref) async {
  // Fetch data
  return data;
});
```

### FutureProvider.family (for parameterized queries)
```dart
final <name>Provider = FutureProvider.family<Type, ParamType>((ref, param) async {
  // Fetch data based on param
  return data;
});
```

### NotifierProvider (for complex state)
```dart
class <Name>Notifier extends Notifier<State> {
  @override
  State build() {
    return initialState;
  }

  void someAction() {
    state = newState;
  }
}

final <name>NotifierProvider = NotifierProvider<<Name>Notifier, State>(() {
  return <Name>Notifier();
});
```

Add to the appropriate providers file in `lib/features/<feature>/domain/<feature>_providers.dart`.

Example usage:
- `/add-provider chart/selectedGate FutureProvider.family` - Adds a gate detail provider
- `/add-provider social/friends FutureProvider` - Adds a friends list provider
- `/add-provider settings/settings NotifierProvider` - Adds a settings notifier
