import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';
import '../../home/domain/home_providers.dart';
import 'models/human_design_chart.dart';

/// Model for a saved chart summary (for listing)
class ChartSummary {
  const ChartSummary({
    required this.id,
    required this.name,
    required this.type,
    required this.profile,
    required this.createdAt,
    this.isCurrentUser = false,
  });

  final String id;
  final String name;
  final HumanDesignType type;
  final String profile;
  final DateTime createdAt;
  final bool isCurrentUser;
}

/// Provider for the currently selected chart ID
final selectedChartIdProvider = StateProvider<String?>((ref) {
  return null;
});

/// Provider for user's saved charts
final userSavedChartsProvider = FutureProvider<List<ChartSummary>>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  if (profile == null) return [];

  // Get user's own chart first
  final userChart = await ref.watch(userChartProvider.future);
  final charts = <ChartSummary>[];

  if (userChart != null) {
    charts.add(ChartSummary(
      id: 'user',
      name: profile.name ?? 'My Chart',
      type: userChart.type,
      profile: userChart.profile.notation,
      createdAt: profile.createdAt ?? DateTime.now(),
      isCurrentUser: true,
    ));
  }

  // Fetch additional saved charts from repository
  final repository = ref.watch(profileRepositoryProvider);
  final savedCharts = await repository.getUserCharts();

  for (final savedChart in savedCharts) {
    // Parse the type from the string
    final type = HumanDesignType.values.firstWhere(
      (t) => t.name == savedChart.type,
      orElse: () => HumanDesignType.generator,
    );

    charts.add(ChartSummary(
      id: savedChart.id,
      name: savedChart.name,
      type: type,
      profile: '', // Not stored in summary
      createdAt: savedChart.createdAt,
      isCurrentUser: false,
    ));
  }

  return charts;
});

/// Provider for a chart by ID
final chartByIdProvider =
    FutureProvider.family<HumanDesignChart?, String>((ref, chartId) async {
  if (chartId == 'user') {
    return ref.watch(userChartProvider.future);
  }

  // Fetch chart from repository by ID
  final repository = ref.watch(profileRepositoryProvider);
  final chartData = await repository.getChartById(chartId);

  if (chartData == null) return null;

  // Parse the chart data into a HumanDesignChart
  return _parseChartFromJson(chartData);
});

/// Parse chart data from JSON
HumanDesignChart _parseChartFromJson(Map<String, dynamic> json) {
  final type = HumanDesignType.values.firstWhere(
    (t) => t.name == json['type'],
    orElse: () => HumanDesignType.generator,
  );

  final authority = Authority.values.firstWhere(
    (a) => a.name == json['authority'],
    orElse: () => Authority.sacral,
  );

  final definition = Definition.values.firstWhere(
    (d) => d.name == json['definition'],
    orElse: () => Definition.single,
  );

  final profileNotation = json['profile'] as String? ?? '1/3';
  final profile = Profile.values.firstWhere(
    (p) => p.notation == profileNotation,
    orElse: () => Profile.oneThree,
  );

  final definedCenterNames = (json['defined_centers'] as List?)?.cast<String>() ?? [];
  final definedCenters = definedCenterNames
      .map((name) => HumanDesignCenter.values.firstWhere(
            (c) => c.name == name,
            orElse: () => HumanDesignCenter.sacral,
          ))
      .toSet();

  final undefinedCenters = HumanDesignCenter.values.toSet().difference(definedCenters);

  return HumanDesignChart(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    name: json['name'] as String,
    birthDateTime: DateTime.parse(json['birth_datetime'] as String),
    birthLocation: BirthLocation.fromJson(json['birth_location'] as Map<String, dynamic>),
    timezone: json['timezone'] as String? ?? 'UTC',
    type: type,
    strategy: type.strategy,
    authority: authority,
    profile: profile,
    definition: definition,
    definedCenters: definedCenters,
    undefinedCenters: undefinedCenters,
    activeChannels: <ChannelActivation>[], // Would need to recalculate from gates
    consciousActivations: <HumanDesignPlanet, GateActivation>{},
    unconsciousActivations: <HumanDesignPlanet, GateActivation>{},
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

/// Notifier for managing saved charts
class SavedChartsNotifier extends Notifier<SavedChartsState> {
  @override
  SavedChartsState build() {
    return const SavedChartsState();
  }

  Future<bool> saveChart({
    required String name,
    required HumanDesignChart chart,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.saveChart(chart);
      ref.invalidate(userSavedChartsProvider);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> renameChart(String chartId, String newName) async {
    if (chartId == 'user') {
      // Can't rename user's own chart through this - they should update their profile
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final client = ref.read(supabaseClientProvider);
      await client.from('charts').update({'name': newName}).eq('id', chartId);
      ref.invalidate(userSavedChartsProvider);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteChart(String chartId) async {
    if (chartId == 'user') {
      // Can't delete user's own chart
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.deleteChart(chartId);
      ref.invalidate(userSavedChartsProvider);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

/// Provider for saved charts notifier
final savedChartsNotifierProvider =
    NotifierProvider<SavedChartsNotifier, SavedChartsState>(() {
  return SavedChartsNotifier();
});

/// State for saved charts management
class SavedChartsState {
  const SavedChartsState({
    this.isSaving = false,
    this.errorMessage,
  });

  final bool isSaving;
  final String? errorMessage;

  SavedChartsState copyWith({
    bool? isSaving,
    String? errorMessage,
  }) {
    return SavedChartsState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }
}
