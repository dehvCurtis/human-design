import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../chart/domain/chart_providers.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../home/domain/home_providers.dart';
import '../../profile/data/profile_repository.dart';
import '../../social/data/social_repository.dart';
import '../../social/domain/social_providers.dart';
import 'penta_calculator.dart';

/// Provider for the Penta calculator
final pentaCalculatorProvider = Provider<PentaCalculator>((ref) {
  return PentaCalculator();
});

/// Provider for the currently selected group ID for Penta analysis
final selectedPentaGroupIdProvider = StateProvider<String?>((ref) {
  return null;
});

/// Group member combined with their profile data
class GroupMemberWithProfile {
  const GroupMemberWithProfile({
    required this.member,
    this.profile,
  });

  final GroupMember member;
  final UserProfile? profile;

  bool get hasBirthData => profile?.hasBirthData ?? false;
}

/// Provider for group members with their profile data (for Penta)
final pentaGroupMembersProvider =
    FutureProvider.family<List<GroupMemberWithProfile>, String>((ref, groupId) async {
  final socialRepo = ref.watch(socialRepositoryProvider);
  final profileRepo = ref.watch(profileRepositoryProvider);

  // Get group members
  final members = await socialRepo.getGroupMembers(groupId);
  if (members.isEmpty) return [];

  // Get profiles for all members
  final userIds = members.map((m) => m.userId).toList();
  final profiles = await profileRepo.getProfilesByIds(userIds);

  // Map profiles to members
  final profileMap = {for (var p in profiles) p.id: p};

  return members.map((member) {
    return GroupMemberWithProfile(
      member: member,
      profile: profileMap[member.userId],
    );
  }).toList();
});

/// Provider for group members' charts
final pentaGroupChartsProvider =
    FutureProvider.family<List<HumanDesignChart>, String>((ref, groupId) async {
  final groups = await ref.watch(groupsProvider.future);
  // Find the group to validate it exists
  groups.firstWhere(
    (g) => g.id == groupId,
    orElse: () => throw Exception('Group not found'),
  );

  // Get group members with their profiles
  final membersWithProfiles = await ref.watch(pentaGroupMembersProvider(groupId).future);

  // Filter to members with birth data
  final membersWithBirthData = membersWithProfiles
      .where((m) => m.profile != null && m.profile!.hasBirthData)
      .toList();

  if (membersWithBirthData.isEmpty) {
    return <HumanDesignChart>[];
  }

  // Calculate charts for each member
  final calculateChart = ref.read(calculateChartUseCaseProvider);
  final charts = <HumanDesignChart>[];

  for (final memberWithProfile in membersWithBirthData) {
    final profile = memberWithProfile.profile!;
    try {
      final chart = await calculateChart.execute(
        userId: profile.id,
        name: profile.name ?? memberWithProfile.member.name,
        birthDateTime: profile.birthDate!,
        birthLocation: profile.birthLocation!,
        timezone: profile.timezone!,
      );
      charts.add(chart);
    } catch (e) {
      // Skip members whose charts cannot be calculated
      continue;
    }
  }

  return charts;
});

/// Provider for the Penta analysis of a selected group
final pentaAnalysisProvider = FutureProvider<Penta?>((ref) async {
  final selectedGroupId = ref.watch(selectedPentaGroupIdProvider);
  if (selectedGroupId == null) return null;

  final charts = await ref.watch(pentaGroupChartsProvider(selectedGroupId).future);
  if (charts.length < 2) return null;

  final calculator = ref.read(pentaCalculatorProvider);
  return calculator.calculate(charts);
});

/// State notifier for managing Penta screen state
class PentaNotifier extends Notifier<PentaState> {
  @override
  PentaState build() {
    return const PentaState();
  }

  void setUseIndividualCharts(bool value) {
    state = state.copyWith(
      useIndividualCharts: value,
      selectedGroupId: value ? null : state.selectedGroupId,
      selectedChartIds: value ? state.selectedChartIds : const {},
      penta: null,
    );
    if (!value) {
      ref.read(selectedPentaGroupIdProvider.notifier).state = null;
    }
  }

  void toggleChartSelection(String chartId) {
    final newSelection = Set<String>.from(state.selectedChartIds);
    if (newSelection.contains(chartId)) {
      newSelection.remove(chartId);
    } else if (newSelection.length < 5) {
      // Penta supports 3-5 members
      newSelection.add(chartId);
    }
    state = state.copyWith(selectedChartIds: newSelection, penta: null);
  }

  void selectGroup(String? groupId) {
    ref.read(selectedPentaGroupIdProvider.notifier).state = groupId;
    state = state.copyWith(selectedGroupId: groupId, isCalculating: false, penta: null);
  }

  Future<void> calculatePenta() async {
    final selectedIds = state.selectedChartIds;
    if (selectedIds.length < 2) {
      state = state.copyWith(
        errorMessage: 'Select at least 2 charts for Penta analysis',
      );
      return;
    }

    state = state.copyWith(isCalculating: true, errorMessage: null);

    try {
      final charts = <HumanDesignChart>[];

      for (final chartId in selectedIds) {
        final chart = await ref.read(chartByIdProvider(chartId).future);
        if (chart != null) {
          charts.add(chart);
        }
      }

      if (charts.length < 2) {
        state = state.copyWith(
          isCalculating: false,
          errorMessage: 'Could not load enough charts for Penta analysis',
        );
        return;
      }

      final calculator = ref.read(pentaCalculatorProvider);
      final penta = calculator.calculate(charts);

      state = state.copyWith(
        isCalculating: false,
        penta: penta,
      );
    } catch (e) {
      state = state.copyWith(
        isCalculating: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearAnalysis() {
    state = const PentaState();
    ref.read(selectedPentaGroupIdProvider.notifier).state = null;
  }
}

/// Provider for Penta state notifier
final pentaNotifierProvider = NotifierProvider<PentaNotifier, PentaState>(() {
  return PentaNotifier();
});

/// State class for Penta feature
class PentaState {
  const PentaState({
    this.selectedGroupId,
    this.selectedChartIds = const {},
    this.penta,
    this.isCalculating = false,
    this.errorMessage,
    this.useIndividualCharts = false,
  });

  final String? selectedGroupId;
  final Set<String> selectedChartIds;
  final Penta? penta;
  final bool isCalculating;
  final String? errorMessage;
  final bool useIndividualCharts;

  PentaState copyWith({
    String? selectedGroupId,
    Set<String>? selectedChartIds,
    Penta? penta,
    bool? isCalculating,
    String? errorMessage,
    bool? useIndividualCharts,
  }) {
    return PentaState(
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedChartIds: selectedChartIds ?? this.selectedChartIds,
      penta: penta ?? this.penta,
      isCalculating: isCalculating ?? this.isCalculating,
      errorMessage: errorMessage,
      useIndividualCharts: useIndividualCharts ?? this.useIndividualCharts,
    );
  }
}
