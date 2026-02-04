import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration constants
class AppConfig {
  AppConfig._();

  /// App name
  static const String appName = 'Human Design';

  /// App version (should match pubspec.yaml)
  static const String appVersion = '1.0.0';

  /// App URL for deep links and sharing
  static const String appUrl = 'https://app.humandesign.com';

  /// Load environment variables from .env file
  /// Call this before accessing any environment-dependent config
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      debugPrint('Warning: Could not load .env file: $e');
      // Continue without .env - will use defaults or fail on access
    }
  }

  /// Check if environment is loaded
  static bool get isLoaded => dotenv.isInitialized;

  /// Get Supabase URL from environment
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    if (url.isEmpty && !kDebugMode) {
      throw StateError(
        'SUPABASE_URL is not set in .env file',
      );
    }
    return url;
  }

  /// Get Supabase Anon Key from environment
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    if (key.isEmpty && !kDebugMode) {
      throw StateError(
        'SUPABASE_ANON_KEY is not set in .env file',
      );
    }
    return key;
  }

  /// RevenueCat API keys
  static String get revenueCatAppleApiKey {
    return dotenv.env['REVENUECAT_APPLE_API_KEY'] ?? '';
  }

  static String get revenueCatGoogleApiKey {
    return dotenv.env['REVENUECAT_GOOGLE_API_KEY'] ?? '';
  }

  /// Validate all required environment variables for release builds
  /// Call this at app startup to fail fast if configuration is missing
  static void validateConfiguration() {
    if (kReleaseMode) {
      final errors = <String>[];
      if (supabaseUrl.isEmpty) {
        errors.add('SUPABASE_URL is not set');
      }
      if (supabaseAnonKey.isEmpty) {
        errors.add('SUPABASE_ANON_KEY is not set');
      }
      if (errors.isNotEmpty) {
        throw StateError(
          'Missing required environment variables in .env:\n${errors.join('\n')}',
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
