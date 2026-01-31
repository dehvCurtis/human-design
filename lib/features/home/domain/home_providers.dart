import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../chart/domain/usecases/calculate_chart.dart';
import '../../ephemeris/data/ephemeris_service.dart';
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
