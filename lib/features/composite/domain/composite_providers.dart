import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../chart/domain/chart_providers.dart';
import '../../chart/domain/models/human_design_chart.dart';
import 'composite_calculator.dart';

/// Provider for the Composite calculator
final compositeCalculatorProvider = Provider<CompositeCalculator>((ref) {
  return CompositeCalculator();
});

/// State notifier for managing Composite screen state
class CompositeNotifier extends Notifier<CompositeState> {
  @override
  CompositeState build() {
    return const CompositeState();
  }

  void toggleChartSelection(String chartId) {
    final newSelection = Set<String>.from(state.selectedChartIds);
    if (newSelection.contains(chartId)) {
      newSelection.remove(chartId);
    } else if (newSelection.length < 2) {
      // Composite requires exactly 2 charts
      newSelection.add(chartId);
    }
    state = state.copyWith(selectedChartIds: newSelection, result: null);
  }

  void clearSelection() {
    state = state.copyWith(selectedChartIds: const {}, result: null);
  }

  Future<void> calculateComposite() async {
    final selectedIds = state.selectedChartIds.toList();
    if (selectedIds.length != 2) {
      state = state.copyWith(
        errorMessage: 'Select exactly 2 charts for composite analysis',
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

      if (charts.length != 2) {
        state = state.copyWith(
          isCalculating: false,
          errorMessage: 'Could not load both charts for composite analysis',
        );
        return;
      }

      final calculator = ref.read(compositeCalculatorProvider);
      final result = calculator.calculate(charts[0], charts[1]);

      state = state.copyWith(
        isCalculating: false,
        result: result,
      );
    } catch (e) {
      state = state.copyWith(
        isCalculating: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearAnalysis() {
    state = const CompositeState();
  }
}

/// Provider for Composite state notifier
final compositeNotifierProvider = NotifierProvider<CompositeNotifier, CompositeState>(() {
  return CompositeNotifier();
});

/// State class for Composite feature
class CompositeState {
  const CompositeState({
    this.selectedChartIds = const {},
    this.result,
    this.isCalculating = false,
    this.errorMessage,
  });

  final Set<String> selectedChartIds;
  final CompositeResult? result;
  final bool isCalculating;
  final String? errorMessage;

  CompositeState copyWith({
    Set<String>? selectedChartIds,
    CompositeResult? result,
    bool? isCalculating,
    String? errorMessage,
  }) {
    return CompositeState(
      selectedChartIds: selectedChartIds ?? this.selectedChartIds,
      result: result ?? this.result,
      isCalculating: isCalculating ?? this.isCalculating,
      errorMessage: errorMessage,
    );
  }
}
