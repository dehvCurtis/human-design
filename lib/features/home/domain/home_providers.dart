import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../auth/domain/auth_providers.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../chart/domain/usecases/calculate_chart.dart';
import '../../ephemeris/data/ephemeris_service.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';
import '../../lifestyle/domain/affirmation_service.dart';
import '../../lifestyle/domain/transit_service.dart';
import '../../profile/data/profile_repository.dart';

/// Provider for the ephemeris service
final ephemerisServiceProvider = Provider<EphemerisService>((ref) {
  return EphemerisService.instance;
});

/// Provider for the transit service
final transitServiceProvider = Provider<TransitService>((ref) {
  final ephemeris = ref.watch(ephemerisServiceProvider);
  return TransitService(ephemerisService: ephemeris);
});

/// Provider for the affirmation service
final affirmationServiceProvider = Provider<AffirmationService>((ref) {
  final transitService = ref.watch(transitServiceProvider);
  return AffirmationService(transitService: transitService);
});

/// Provider for the chart calculation use case
final calculateChartUseCaseProvider = Provider<CalculateChartUseCase>((ref) {
  final ephemeris = ref.watch(ephemerisServiceProvider);
  return CalculateChartUseCase(ephemerisService: ephemeris);
});

/// Provider for the profile repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepository(supabaseClient: client);
});

/// Provider for the current user's profile
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getCurrentProfile();
});

/// Provider for the user's personal chart
final userChartProvider = FutureProvider<HumanDesignChart?>((ref) async {
  // Use mock data when auth is bypassed for testing
  if (kBypassAuth) {
    return _createMockChart();
  }

  final profile = await ref.watch(userProfileProvider.future);
  if (profile == null || !profile.hasBirthData) return null;

  final calculateChart = ref.watch(calculateChartUseCaseProvider);

  return calculateChart.execute(
    userId: profile.id,
    name: profile.name ?? 'My Chart',
    birthDateTime: profile.birthDate!,
    birthLocation: profile.birthLocation!,
    timezone: profile.timezone!,
  );
});

/// Create a mock chart for testing
HumanDesignChart _createMockChart() {
  return HumanDesignChart(
    id: 'mock-chart-001',
    userId: 'mock-user-001',
    name: 'Test User',
    birthDateTime: DateTime(1990, 6, 15, 14, 30),
    birthLocation: const BirthLocation(
      city: 'New York',
      country: 'USA',
      latitude: 40.7128,
      longitude: -74.0060,
    ),
    timezone: 'America/New_York',
    type: HumanDesignType.generator,
    strategy: 'To Respond',
    authority: Authority.sacral,
    profile: Profile.threeFive,
    definition: Definition.single,
    definedCenters: {
      HumanDesignCenter.sacral,
      HumanDesignCenter.root,
      HumanDesignCenter.spleen,
      HumanDesignCenter.g,
      HumanDesignCenter.throat,
    },
    undefinedCenters: {
      HumanDesignCenter.head,
      HumanDesignCenter.ajna,
      HumanDesignCenter.heart,
      HumanDesignCenter.solarPlexus,
    },
    activeChannels: [
      ChannelActivation(
        channel: channels.firstWhere((c) => c.id == '34-57'),
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: false,
        gate2Unconscious: true,
      ),
      ChannelActivation(
        channel: channels.firstWhere((c) => c.id == '10-57'),
        gate1Conscious: true,
        gate1Unconscious: true,
        gate2Conscious: true,
        gate2Unconscious: true,
      ),
    ],
    consciousActivations: {
      HumanDesignPlanet.sun: const GateActivation(gate: 10, line: 3, color: 1, tone: 1, base: 1, degree: 83.5),
      HumanDesignPlanet.earth: const GateActivation(gate: 15, line: 3, color: 1, tone: 1, base: 1, degree: 263.5),
      HumanDesignPlanet.moon: const GateActivation(gate: 34, line: 5, color: 2, tone: 3, base: 2, degree: 180.2),
      HumanDesignPlanet.northNode: const GateActivation(gate: 57, line: 1, color: 3, tone: 2, base: 1, degree: 300.1),
      HumanDesignPlanet.southNode: const GateActivation(gate: 51, line: 1, color: 3, tone: 2, base: 1, degree: 120.1),
      HumanDesignPlanet.mercury: const GateActivation(gate: 20, line: 2, color: 4, tone: 1, base: 3, degree: 95.3),
      HumanDesignPlanet.venus: const GateActivation(gate: 31, line: 4, color: 2, tone: 4, base: 2, degree: 150.7),
      HumanDesignPlanet.mars: const GateActivation(gate: 45, line: 6, color: 1, tone: 5, base: 1, degree: 230.9),
      HumanDesignPlanet.jupiter: const GateActivation(gate: 7, line: 1, color: 5, tone: 3, base: 4, degree: 55.2),
      HumanDesignPlanet.saturn: const GateActivation(gate: 62, line: 3, color: 3, tone: 6, base: 5, degree: 340.1),
      HumanDesignPlanet.uranus: const GateActivation(gate: 23, line: 5, color: 6, tone: 2, base: 3, degree: 110.8),
      HumanDesignPlanet.neptune: const GateActivation(gate: 36, line: 2, color: 4, tone: 4, base: 2, degree: 185.4),
      HumanDesignPlanet.pluto: const GateActivation(gate: 35, line: 4, color: 2, tone: 1, base: 6, degree: 175.6),
    },
    unconsciousActivations: {
      HumanDesignPlanet.sun: const GateActivation(gate: 57, line: 5, color: 1, tone: 1, base: 1, degree: 295.5),
      HumanDesignPlanet.earth: const GateActivation(gate: 51, line: 5, color: 1, tone: 1, base: 1, degree: 115.5),
      HumanDesignPlanet.moon: const GateActivation(gate: 9, line: 2, color: 2, tone: 3, base: 2, degree: 68.2),
      HumanDesignPlanet.northNode: const GateActivation(gate: 44, line: 4, color: 3, tone: 2, base: 1, degree: 225.1),
      HumanDesignPlanet.southNode: const GateActivation(gate: 24, line: 4, color: 3, tone: 2, base: 1, degree: 45.1),
      HumanDesignPlanet.mercury: const GateActivation(gate: 10, line: 6, color: 4, tone: 1, base: 3, degree: 85.3),
      HumanDesignPlanet.venus: const GateActivation(gate: 58, line: 1, color: 2, tone: 4, base: 2, degree: 310.7),
      HumanDesignPlanet.mars: const GateActivation(gate: 18, line: 3, color: 1, tone: 5, base: 1, degree: 90.9),
      HumanDesignPlanet.jupiter: const GateActivation(gate: 48, line: 2, color: 5, tone: 3, base: 4, degree: 245.2),
      HumanDesignPlanet.saturn: const GateActivation(gate: 21, line: 6, color: 3, tone: 6, base: 5, degree: 100.1),
      HumanDesignPlanet.uranus: const GateActivation(gate: 2, line: 1, color: 6, tone: 2, base: 3, degree: 10.8),
      HumanDesignPlanet.neptune: const GateActivation(gate: 22, line: 5, color: 4, tone: 4, base: 2, degree: 105.4),
      HumanDesignPlanet.pluto: const GateActivation(gate: 47, line: 3, color: 2, tone: 1, base: 6, degree: 240.6),
    },
    createdAt: DateTime.now(),
  );
}

/// Provider for today's transits
final todayTransitsProvider = Provider<TransitChart>((ref) {
  final transitService = ref.watch(transitServiceProvider);
  return transitService.calculateCurrentTransits();
});

/// Provider for transit impact on user's chart
final transitImpactProvider = FutureProvider<TransitImpact?>((ref) async {
  final chart = await ref.watch(userChartProvider.future);
  if (chart == null) return null;

  final transitService = ref.watch(transitServiceProvider);
  final transits = ref.watch(todayTransitsProvider);

  return transitService.analyzeTransitImpact(chart, transits);
});

/// Provider for daily affirmation
final dailyAffirmationProvider = FutureProvider<DailyAffirmation?>((ref) async {
  final chart = await ref.watch(userChartProvider.future);
  if (chart == null) return null;

  final affirmationService = ref.watch(affirmationServiceProvider);
  return affirmationService.getDailyAffirmation(chart);
});

/// State to track affirmation refresh requests
/// Each increment triggers a new random affirmation
final _affirmationRefreshCounterProvider = StateProvider.family<int, String>((ref, chartId) => 0);

/// Enum for affirmation type selection
enum AffirmationType { daily, random, transit }

/// State to track which type of affirmation to show
final _affirmationTypeProvider = StateProvider.family<AffirmationType, String>(
  (ref, chartId) => AffirmationType.daily,
);

/// Provider for affirmation with refresh capability
final affirmationNotifierProvider = Provider.family<AsyncValue<DailyAffirmation?>, HumanDesignChart?>(
  (ref, chart) {
    if (chart == null) {
      return const AsyncValue.data(null);
    }

    final affirmationService = ref.watch(affirmationServiceProvider);
    final affirmationType = ref.watch(_affirmationTypeProvider(chart.id));
    // Watch refresh counter to rebuild when refresh is called
    ref.watch(_affirmationRefreshCounterProvider(chart.id));

    final DailyAffirmation affirmation = switch (affirmationType) {
      AffirmationType.daily => affirmationService.getDailyAffirmation(chart),
      AffirmationType.random => affirmationService.getRandomAffirmation(chart),
      AffirmationType.transit => affirmationService.getTransitAffirmation(chart),
    };

    return AsyncValue.data(affirmation);
  },
);

/// Extension to provide refresh methods
extension AffirmationRefreshExtension on WidgetRef {
  void refreshAffirmation(String chartId) {
    read(_affirmationTypeProvider(chartId).notifier).state = AffirmationType.random;
    read(_affirmationRefreshCounterProvider(chartId).notifier).state++;
  }

  void getTransitAffirmation(String chartId) {
    read(_affirmationTypeProvider(chartId).notifier).state = AffirmationType.transit;
    read(_affirmationRefreshCounterProvider(chartId).notifier).state++;
  }
}
