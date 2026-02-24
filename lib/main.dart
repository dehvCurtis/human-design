import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/config/app_config.dart';
import 'firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/ephemeris/data/ephemeris_service.dart';
import 'features/settings/domain/settings_providers.dart';
import 'l10n/generated/app_localizations.dart';
import 'shared/providers/supabase_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await AppConfig.load();

  // Validate required environment variables for release builds
  AppConfig.validateConfiguration();

  // Initialize timezone database for birth location timezone conversion
  tz.initializeTimeZones();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase (requires firebase_options.dart from flutterfire configure)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseConfigured = true;
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('Push notifications disabled. Run: flutterfire configure');
  }

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Supabase
  await initializeSupabase();

  // Validate and refresh session if needed
  await _validateSession();

  // Initialize RevenueCat
  await _initializeRevenueCat();

  // Initialize Swiss Ephemeris
  await EphemerisService.instance.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const HumanDesignApp(),
    ),
  );
}

/// Validate current session and refresh if expiring soon
///
/// Proactively refreshes tokens within 5 minutes of expiry to prevent
/// auth errors during app usage.
Future<void> _validateSession() async {
  try {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) return;

    final expiresAt = session.expiresAt;
    if (expiresAt == null) return;

    final expiryTime = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    final refreshThreshold = DateTime.now().add(const Duration(minutes: 5));

    // If session expires within 5 minutes, refresh proactively
    if (expiryTime.isBefore(refreshThreshold)) {
      debugPrint('Session expiring soon, refreshing...');
      await Supabase.instance.client.auth.refreshSession();
    }
  } catch (e) {
    // Log but don't fail app startup - user will be redirected to login if needed
    debugPrint('Session validation failed: $e');
  }
}

/// Whether Firebase was successfully initialized.
/// Guards all Firebase-dependent calls (FCM, analytics) to prevent errors
/// when firebase_options.dart doesn't exist (needs `flutterfire configure`).
bool firebaseConfigured = false;

/// Whether RevenueCat was successfully configured.
/// Guards all Purchases.* calls to prevent Swift-level fatal errors
/// when the SDK is not configured (e.g., missing API key).
bool revenueCatConfigured = false;

/// Initialize RevenueCat for in-app purchases
///
/// Configures RevenueCat with platform-specific API keys.
/// Links purchases to Supabase user ID when authenticated.
Future<void> _initializeRevenueCat() async {
  try {
    // Get platform-specific API key
    String? apiKey;
    if (Platform.isIOS || Platform.isMacOS) {
      apiKey = AppConfig.revenueCatAppleApiKey;
    } else if (Platform.isAndroid) {
      apiKey = AppConfig.revenueCatGoogleApiKey;
    }

    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('RevenueCat: No API key configured for this platform');
      return;
    }

    // Configure RevenueCat
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);

    final configuration = PurchasesConfiguration(apiKey);

    // Link to Supabase user ID if authenticated
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      configuration.appUserID = userId;
    }

    await Purchases.configure(configuration);
    revenueCatConfigured = true;
    debugPrint('RevenueCat: Initialized successfully');
  } catch (e) {
    debugPrint('RevenueCat initialization failed: $e');
    // Continue without RevenueCat - purchases will fail gracefully
  }
}

/// The main application widget
class HumanDesignApp extends ConsumerWidget {
  const HumanDesignApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Human Design',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Routing
      routerConfig: router,

      // Localization
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // Builder for responsive adjustments
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
