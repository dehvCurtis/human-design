import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../chart/domain/chart_providers.dart';
import '../domain/penta_calculator.dart';
import '../domain/penta_providers.dart';
import 'widgets/connection_card.dart';
import 'widgets/health_score_meter.dart';
import 'widgets/penta_role_card.dart';

/// Screen for Penta (small group dynamics) analysis
class PentaScreen extends ConsumerWidget {
  const PentaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pentaState = ref.watch(pentaNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.penta_analysis),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push(AppRoutes.addChart);
            },
            tooltip: l10n.chart_addChart,
          ),
          if (pentaState.penta != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(pentaNotifierProvider.notifier).clearAnalysis();
              },
              tooltip: l10n.penta_clearAnalysis,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            _buildInfoCard(context),
            const SizedBox(height: 16),

            // Chart selector - select from saved charts, friends, following
            _ChartSelector(
              selectedChartIds: pentaState.selectedChartIds,
              onToggleChart: (chartId) {
                ref.read(pentaNotifierProvider.notifier).toggleChartSelection(chartId);
              },
            ),
            const SizedBox(height: 16),

            // Calculate button - always visible but disabled if < 3 charts selected
            if (pentaState.penta == null)
              ElevatedButton.icon(
                onPressed: (pentaState.isCalculating || pentaState.selectedChartIds.length < 3)
                    ? null
                    : () {
                        ref.read(pentaNotifierProvider.notifier).calculatePenta();
                      },
                icon: pentaState.isCalculating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.hub_outlined),
                label: Text(
                  pentaState.isCalculating
                      ? l10n.penta_calculating
                      : pentaState.selectedChartIds.length < 3
                          ? 'Select ${3 - pentaState.selectedChartIds.length} more chart(s)'
                          : l10n.penta_calculate,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),

            // Error message
            if (pentaState.errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorCard(context, pentaState.errorMessage!),
            ],

            // Results
            if (pentaState.penta != null) ...[
              const SizedBox(height: 24),
              _buildPentaResults(context, pentaState.penta!, l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: AppColors.primary.withAlpha(25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.penta_infoText,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Card(
      color: AppColors.error.withAlpha(25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPentaResults(BuildContext context, Penta penta, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Health Score
        Center(
          child: HealthScoreMeter(score: penta.healthScore),
        ),
        const SizedBox(height: 24),

        // Roles Section
        Text(
          l10n.penta_groupRoles,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...PentaRole.values.map((role) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: PentaRoleCard(
              role: role,
              roleInfo: penta.filledRoles[role],
            ),
          );
        }),
        const SizedBox(height: 24),

        // Electromagnetic Connections
        if (penta.electromagneticConnections.isNotEmpty) ...[
          Text(
            l10n.penta_electromagneticConnections,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.penta_connectionsDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 12),
          ...penta.electromagneticConnections.map((connection) {
            return ConnectionCard(connection: connection);
          }),
          const SizedBox(height: 24),
        ],

        // Strengths
        if (penta.strengths.isNotEmpty) ...[
          Text(
            l10n.penta_strengths,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: AppColors.success.withAlpha(25),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: penta.strengths.map((strength) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            strength,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Challenges
        if (penta.challenges.isNotEmpty) ...[
          Text(
            l10n.penta_areasForAttention,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: AppColors.warning.withAlpha(25),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: penta.challenges.map((challenge) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            challenge,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],

        const SizedBox(height: 32),
      ],
    );
  }

}

/// Widget for selecting charts for Penta analysis
/// Shows saved charts, friends, and following
class _ChartSelector extends ConsumerWidget {
  const _ChartSelector({
    required this.selectedChartIds,
    required this.onToggleChart,
  });

  final Set<String> selectedChartIds;
  final ValueChanged<String> onToggleChart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsAsync = ref.watch(userSavedChartsProvider);
    final theme = Theme.of(context);

    return chartsAsync.when(
      data: (charts) {
        if (charts.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: 48,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Charts Available',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create charts for family or friends to use them in Penta analysis.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select 3-5 Charts',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: selectedChartIds.length >= 3
                            ? AppColors.success.withAlpha(25)
                            : AppColors.warning.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${selectedChartIds.length}/5',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: selectedChartIds.length >= 3
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...charts.map((chart) {
                  final isSelected = selectedChartIds.contains(chart.id);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (_) => onToggleChart(chart.id),
                    title: Text(chart.name),
                    subtitle: Text(
                      '${chart.type.displayName}${chart.isCurrentUser ? ' • You' : ''}',
                    ),
                    secondary: CircleAvatar(
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondaryLight.withAlpha(50),
                      child: chart.isCurrentUser
                          ? Icon(
                              Icons.person,
                              color: isSelected ? Colors.white : AppColors.textSecondaryLight,
                            )
                          : Text(
                              chart.name.isNotEmpty ? chart.name[0].toUpperCase() : '?',
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondaryLight,
                              ),
                            ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
                if (selectedChartIds.length < 3) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Select at least ${3 - selectedChartIds.length} more chart(s)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(height: 8),
              Text(ErrorHandler.getUserMessage(error, context: 'load charts')),
            ],
          ),
        ),
      ),
    );
  }
}
