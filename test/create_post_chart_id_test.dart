import 'package:flutter_test/flutter_test.dart';

/// Logic extracted from the chart sharing flow in the feed feature.
///
/// When a user creates a post and selects a chart to attach, the special
/// sentinel value `'user'` means "use the user's own current chart" (i.e. no
/// explicit saved-chart ID).  The DB column `chart_id` must receive `null` in
/// that case, not the literal string `'user'`.
///
/// The production logic (from CreatePostScreen) is:
///   final chartIdForDb =
///       selectedChartId != null && selectedChartId != 'user'
///           ? selectedChartId
///           : null;
///
/// This test file exercises that exact conditional without importing any
/// Flutter or Supabase dependencies.
String? resolveChartIdForDb(String? selectedChartId) {
  return selectedChartId != null && selectedChartId != 'user'
      ? selectedChartId
      : null;
}

void main() {
  group('resolveChartIdForDb – chart_id mapping for DB insert', () {
    group("Sentinel value 'user' → null", () {
      test("'user' maps to null (own profile chart, no saved chart ID)", () {
        expect(resolveChartIdForDb('user'), isNull);
      });
    });

    group('null input → null', () {
      test('null (no chart selected) maps to null', () {
        expect(resolveChartIdForDb(null), isNull);
      });
    });

    group('Valid UUID → passed through unchanged', () {
      test('standard UUID v4 is returned as-is', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        expect(resolveChartIdForDb(uuid), equals(uuid));
      });

      test('another valid UUID is returned unchanged', () {
        const uuid = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
        expect(resolveChartIdForDb(uuid), equals(uuid));
      });

      test('UUID with all uppercase hex characters is returned unchanged', () {
        const uuid = 'A1B2C3D4-E5F6-7890-ABCD-EF1234567890';
        expect(resolveChartIdForDb(uuid), equals(uuid));
      });
    });

    group('Edge cases – non-sentinel non-null strings pass through', () {
      test("arbitrary non-empty string (not 'user') is returned as-is", () {
        expect(resolveChartIdForDb('some-other-id'), equals('some-other-id'));
      });

      test("empty string (not 'user') is returned as-is", () {
        // An empty string is not the sentinel 'user', so it passes through.
        expect(resolveChartIdForDb(''), equals(''));
      });

      test("case-sensitive: 'User' (capital U) is NOT the sentinel", () {
        // Only exact lowercase 'user' is the sentinel.
        expect(resolveChartIdForDb('User'), equals('User'));
      });

      test("case-sensitive: 'USER' is NOT the sentinel", () {
        expect(resolveChartIdForDb('USER'), equals('USER'));
      });
    });

    group('Return type', () {
      test('returns null (nullable String) when sentinel is provided', () {
        final result = resolveChartIdForDb('user');
        expect(result, isNull);
        // Compiler-level: the function signature returns String?, so this
        // double-checks the runtime type.
        expect(result, isA<String?>());
      });

      test('returns a non-null String when a real UUID is provided', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        final result = resolveChartIdForDb(uuid);
        expect(result, isNotNull);
        expect(result, isA<String>());
      });
    });
  });
}
