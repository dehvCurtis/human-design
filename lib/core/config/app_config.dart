/// Application configuration constants
class AppConfig {
  AppConfig._();

  /// App name
  static const String appName = 'Human Design';

  /// App version (should match pubspec.yaml)
  static const String appVersion = '1.0.0';

  /// Supabase configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// RevenueCat API keys
  static const String revenueCatAppleApiKey = String.fromEnvironment(
    'REVENUECAT_APPLE_API_KEY',
    defaultValue: '',
  );
  static const String revenueCatGoogleApiKey = String.fromEnvironment(
    'REVENUECAT_GOOGLE_API_KEY',
    defaultValue: '',
  );

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
