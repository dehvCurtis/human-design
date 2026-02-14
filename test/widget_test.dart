// Human Design App Widget Tests
//
// These tests verify that the app builds and renders correctly.
// Native services (Swiss Ephemeris) are mocked for test environment.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:human_design/main.dart';
import 'package:human_design/core/config/app_config.dart';
import 'package:human_design/core/constants/human_design_constants.dart';
import 'package:human_design/shared/providers/supabase_provider.dart';
import 'package:human_design/features/ephemeris/mappers/degree_to_gate_mapper.dart';
import 'package:human_design/features/home/domain/home_providers.dart';
import 'package:human_design/features/lifestyle/domain/transit_service.dart';
import 'package:human_design/features/lifestyle/domain/affirmation_service.dart';
import 'package:human_design/features/settings/domain/settings_providers.dart';

/// Creates a mock TransitChart for testing
TransitChart _createMockTransitChart() {
  return TransitChart(
    dateTime: DateTime.now(),
    activations: {
      HumanDesignPlanet.sun: const GateActivation(
        gate: 1,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 0.0,
      ),
      HumanDesignPlanet.earth: const GateActivation(
        gate: 2,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 180.0,
      ),
      HumanDesignPlanet.moon: const GateActivation(
        gate: 3,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 90.0,
      ),
      HumanDesignPlanet.northNode: const GateActivation(
        gate: 4,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 45.0,
      ),
      HumanDesignPlanet.southNode: const GateActivation(
        gate: 5,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 225.0,
      ),
      HumanDesignPlanet.mercury: const GateActivation(
        gate: 6,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 30.0,
      ),
      HumanDesignPlanet.venus: const GateActivation(
        gate: 7,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 60.0,
      ),
      HumanDesignPlanet.mars: const GateActivation(
        gate: 8,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 120.0,
      ),
      HumanDesignPlanet.jupiter: const GateActivation(
        gate: 9,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 150.0,
      ),
      HumanDesignPlanet.saturn: const GateActivation(
        gate: 10,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 210.0,
      ),
      HumanDesignPlanet.uranus: const GateActivation(
        gate: 11,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 240.0,
      ),
      HumanDesignPlanet.neptune: const GateActivation(
        gate: 12,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 270.0,
      ),
      HumanDesignPlanet.pluto: const GateActivation(
        gate: 13,
        line: 1,
        color: 1,
        tone: 1,
        base: 1,
        degree: 300.0,
      ),
    },
    activeGates: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13},
    activeChannels: [],
    definedCenters: {HumanDesignCenter.g},
  );
}

/// Creates a mock DailyAffirmation for testing
DailyAffirmation _createMockAffirmation() {
  return DailyAffirmation(
    text: 'This is a test affirmation for unit testing.',
    source: AffirmationSource.type,
    date: DateTime.now(),
    gateNumber: 1,
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Set up mock SharedPreferences before any initialization
    SharedPreferences.setMockInitialValues({});

    // Mock Firebase platform channel so Firebase.initializeApp() doesn't crash
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_core'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'Firebase#initializeCore') {
          return [
            {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'fake-api-key',
                'appId': 'fake-app-id',
                'messagingSenderId': 'fake-sender-id',
                'projectId': 'fake-project-id',
              },
              'pluginConstants': {},
            }
          ];
        }
        if (methodCall.method == 'Firebase#initializeApp') {
          return {
            'name': methodCall.arguments['appName'] ?? '[DEFAULT]',
            'options': methodCall.arguments['options'] ?? {},
            'pluginConstants': {},
          };
        }
        return null;
      },
    );

    // Load environment variables from .env file
    await AppConfig.load();

    // Initialize Supabase with loaded config
    await initializeSupabase();
  });

  testWidgets('HumanDesignApp smoke test', (WidgetTester tester) async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app with mocked providers
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override SharedPreferences
          sharedPreferencesProvider.overrideWithValue(prefs),
          // Override transit provider with mock data (avoids native ephemeris)
          todayTransitsProvider.overrideWithValue(_createMockTransitChart()),
          // Override transit impact to avoid native calls
          transitImpactProvider.overrideWith((ref) async => null),
          // Override daily affirmation to avoid native calls
          dailyAffirmationProvider.overrideWith((ref) async => _createMockAffirmation()),
        ],
        child: const HumanDesignApp(),
      ),
    );

    // Pump frames to let the app render
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify the app renders (MaterialApp is present)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App shows home screen when authenticated', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          todayTransitsProvider.overrideWithValue(_createMockTransitChart()),
          transitImpactProvider.overrideWith((ref) async => null),
          dailyAffirmationProvider.overrideWith((ref) async => _createMockAffirmation()),
        ],
        child: const HumanDesignApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // With kBypassAuth = true, we should land on home screen
    // Look for typical home screen elements
    expect(find.byType(Scaffold), findsWidgets);
  });
}
