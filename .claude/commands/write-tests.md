# Write Tests

Generate unit and widget tests for a given source file or feature.

## Instructions

When the user specifies what to test: `$ARGUMENTS`

### Step 1: Read the source file

Read the file or feature specified in the arguments. Understand:
- What classes/functions exist
- What dependencies they have
- What behavior should be tested
- What edge cases exist

### Step 2: Read existing test patterns

Read these files for reference patterns:
- `test/gate_wheel_offset_test.dart` — unit test pattern for calculations
- `test/timezone_fix_test.dart` — unit test pattern for conversions

Note the conventions:
- `group()` for organizing related tests
- `test()` with descriptive names
- `expect()` with appropriate matchers
- Setup/teardown patterns

### Step 3: Determine test type

Based on the source file:

**Unit tests** (for models, services, mappers, use cases):
- Test constructors and factory methods
- Test serialization (toJson/fromJson, toMap/fromMap)
- Test equality and hashCode
- Test computed properties
- Test business logic methods
- Test error cases and edge cases
- Mock external dependencies (Supabase client, services)

**Widget tests** (for screens, widgets):
- Use `WidgetTester` and `pumpWidget`
- Wrap in `MaterialApp` and `ProviderScope`
- Test that key widgets render
- Test user interactions (tap, scroll, input)
- Test loading/error states
- Override providers with mock data

### Step 4: Create the test file

Place the test file at a path that mirrors the source:
- Source: `lib/features/chart/domain/models/human_design_chart.dart`
- Test: `test/features/chart/domain/models/human_design_chart_test.dart`

Follow this template:

```dart
import 'package:flutter_test/flutter_test.dart';
// Import the source file
// Import any needed mocks

void main() {
  group('<ClassName>', () {
    // Setup if needed
    late ClassName instance;

    setUp(() {
      instance = ClassName(/* params */);
    });

    group('constructor', () {
      test('creates instance with valid parameters', () {
        expect(instance, isNotNull);
        expect(instance.field, equals(expectedValue));
      });
    });

    group('<methodName>', () {
      test('returns expected result for normal input', () {
        final result = instance.methodName(input);
        expect(result, equals(expected));
      });

      test('handles edge case', () {
        final result = instance.methodName(edgeInput);
        expect(result, equals(edgeExpected));
      });

      test('throws on invalid input', () {
        expect(
          () => instance.methodName(invalidInput),
          throwsA(isA<ExpectedError>()),
        );
      });
    });
  });
}
```

For widget tests:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('<WidgetName>', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override providers with test data
          ],
          child: const MaterialApp(
            home: WidgetName(),
          ),
        ),
      );

      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

### Step 5: Run the tests

After writing the test file, run it to verify it passes:

```bash
flutter test <test_file_path>
```

If tests fail, read the error output and fix the issues. Common problems:
- Missing imports
- Wrong provider overrides
- Async timing (need `pumpAndSettle`)
- Missing `MaterialApp` wrapper

### Guidelines
- Aim for meaningful coverage, not 100% line coverage
- Test behavior, not implementation details
- Each test should test one thing
- Use descriptive test names that explain the expected behavior
- Don't mock what you don't own — mock the boundary (repository, not Supabase internals)
