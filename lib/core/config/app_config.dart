import 'package:flutter/foundation.dart';

/// Application configuration constants
class AppConfig {
  AppConfig._();

  /// App name
  static const String appName = 'Human Design';

  /// App version (should match pubspec.yaml)
  static const String appVersion = '1.0.0';

  /// App URL for deep links and sharing
  static const String appUrl = 'https://app.humandesign.com';

  /// Supabase configuration
  static const String _supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String _supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Get Supabase URL with validation
  static String get supabaseUrl {
    if (_supabaseUrl.isEmpty && !kDebugMode) {
      throw StateError(
        'SUPABASE_URL environment variable is not set. '
        'Pass it with: --dart-define=SUPABASE_URL=your_url',
      );
    }
    return _supabaseUrl;
  }

  /// Get Supabase Anon Key with validation
  static String get supabaseAnonKey {
    if (_supabaseAnonKey.isEmpty && !kDebugMode) {
      throw StateError(
        'SUPABASE_ANON_KEY environment variable is not set. '
        'Pass it with: --dart-define=SUPABASE_ANON_KEY=your_key',
      );
    }
    return _supabaseAnonKey;
  }

  /// RevenueCat API keys
  static const String revenueCatAppleApiKey = String.fromEnvironment(
    'REVENUECAT_APPLE_API_KEY',
    defaultValue: '',
  );
  static const String revenueCatGoogleApiKey = String.fromEnvironment(
    'REVENUECAT_GOOGLE_API_KEY',
    defaultValue: '',
  );

  /// Validate all required environment variables for release builds
  /// Call this at app startup to fail fast if configuration is missing
  static void validateConfiguration() {
    if (kReleaseMode) {
      final errors = <String>[];
      if (_supabaseUrl.isEmpty) {
        errors.add('SUPABASE_URL is not set');
      }
      if (_supabaseAnonKey.isEmpty) {
        errors.add('SUPABASE_ANON_KEY is not set');
      }
      if (errors.isNotEmpty) {
        throw StateError(
          'Missing required environment variables:\n${errors.join('\n')}\n\n'
          'Pass them with: flutter build --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
        );
      }
    }
  }

  /// Free tier limits
  static const int freeSharesPerMonth = 3;
  static const int freeGroupLimit = 0;

  /// Premium entitlement ID
  static const String premiumEntitlementId = 'premium';

  /// Ephemeris files path (relative to assets)
  static const String ephemerisPath = 'assets/ephe';

  /// Default animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  /// Chart calculation constants
  static const double prenatalSunDegrees = 88.0;

  /// Cache durations
  static const Duration chartCacheDuration = Duration(days: 30);
  static const Duration transitCacheDuration = Duration(hours: 1);
}
