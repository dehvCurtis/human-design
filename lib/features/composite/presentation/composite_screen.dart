import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../chart/domain/chart_providers.dart';
import '../domain/composite_calculator.dart';
import '../domain/composite_providers.dart';
import 'widgets/channel_connection_card.dart';
import 'widgets/connection_theme_card.dart';

/// Screen for Composite (relationship analysis) between two people
class CompositeScreen extends ConsumerWidget {
  const CompositeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compositeState = ref.watch(compositeNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.composite_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push(AppRoutes.addChart);
            },
            tooltip: l10n.chart_addChart,
          ),
          if (compositeState.result != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(compositeNotifierProvider.notifier).clearAnalysis();
              },
              tooltip: l10n.composite_clearAnalysis,
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

            // Chart selector - select exactly 2 charts
            _ChartSelector(
              selectedChartIds: compositeState.selectedChartIds,
              onToggleChart: (chartId) {
                ref.read(compositeNotifierProvider.notifier).toggleChartSelection(chartId);
              },
            ),
            const SizedBox(height: 16),

            // Calculate button
            if (compositeState.result == null)
              ElevatedButton.icon(
                onPressed: (compositeState.isCalculating || compositeState.selectedChartIds.length != 2)
                    ? null
                    : () {
                        ref.read(compositeNotifierProvider.notifier).calculateComposite();
                      },
                icon: compositeState.isCalculating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.compare_arrows),
                label: Text(
                  compositeState.isCalculating
                      ? l10n.composite_calculating
                      : compositeState.selectedChartIds.length != 2
                          ? l10n.composite_selectTwoCharts
                          : l10n.composite_calculate,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),

            // Error message
            if (compositeState.errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorCard(context, compositeState.errorMessage!),
            ],

            // Results
            if (compositeState.result != null) ...[
              const SizedBox(height: 24),
              _buildCompositeResults(context, compositeState.result!, l10n),
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
                l10n.composite_infoText,
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

  Widget _buildCompositeResults(BuildContext context, CompositeResult result, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Connection Theme Card
        ConnectionThemeCard(
          definedCount: result.definedCentersCount,
          undefinedCount: result.undefinedCentersCount,
          compatibilityScore: result.compatibilityScore,
        ),
        const SizedBox(height: 24),

        // Electromagnetic Channels
        if (result.electromagneticChannels.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            l10n.composite_electromagnetic,
            l10n.composite_electromagneticDesc,
            Icons.electric_bolt,
            AppColors.accent,
          ),
          const SizedBox(height: 8),
          ...result.electromagneticChannels.map((connection) {
            return ChannelConnectionCard(connection: connection);
          }),
          const SizedBox(height: 20),
        ],

        // Companionship Channels
        if (result.companionshipChannels.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            l10n.composite_companionship,
            l10n.composite_companionshipDesc,
            Icons.compare_arrows,
            AppColors.success,
          ),
          const SizedBox(height: 8),
          ...result.companionshipChannels.map((connection) {
            return ChannelConnectionCard(connection: connection);
          }),
          const SizedBox(height: 20),
        ],

        // Dominance Channels
        if (result.dominanceChannels.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            l10n.composite_dominance,
            l10n.composite_dominanceDesc,
            Icons.school,
            AppColors.warning,
          ),
          const SizedBox(height: 8),
          ...result.dominanceChannels.map((connection) {
            return ChannelConnectionCard(connection: connection);
          }),
          const SizedBox(height: 20),
        ],

        // Compromise Channels
        if (result.compromiseChannels.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            l10n.composite_compromise,
            l10n.composite_compromiseDesc,
            Icons.balance,
            AppColors.info,
          ),
          const SizedBox(height: 8),
          ...result.compromiseChannels.map((connection) {
            return ChannelConnectionCard(connection: connection);
          }),
          const SizedBox(height: 20),
        ],

        // No connections message
        if (!result.hasConnections) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.link_off,
                    size: 48,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.composite_noConnections,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.composite_noConnectionsDesc,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

/// Widget for selecting charts for Composite analysis
/// Shows saved charts - user must select exactly 2
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
    final l10n = AppLocalizations.of(context)!;

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
                    l10n.composite_noChartsTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.composite_noChartsDesc,
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

        if (charts.length < 2) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.person_add,
                    size: 48,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.composite_needMoreCharts,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.composite_needMoreChartsDesc,
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
                        l10n.composite_selectTwoCharts,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: selectedChartIds.length == 2
                            ? AppColors.success.withAlpha(25)
                            : AppColors.warning.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${selectedChartIds.length}/2',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: selectedChartIds.length == 2
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
                  final canSelect = isSelected || selectedChartIds.length < 2;
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: canSelect ? (_) => onToggleChart(chart.id) : null,
                    title: Text(
                      chart.name,
                      style: TextStyle(
                        color: canSelect ? null : AppColors.textSecondaryLight,
                      ),
                    ),
                    subtitle: Text(
                      '${chart.type.displayName}${chart.isCurrentUser ? ' • You' : ''}',
                      style: TextStyle(
                        color: canSelect
                            ? AppColors.textSecondaryLight
                            : AppColors.textSecondaryLight.withAlpha(100),
                      ),
                    ),
                    secondary: CircleAvatar(
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : canSelect
                              ? AppColors.textSecondaryLight.withAlpha(50)
                              : AppColors.textSecondaryLight.withAlpha(25),
                      child: chart.isCurrentUser
                          ? Icon(
                              Icons.person,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondaryLight,
                            )
                          : Text(
                              chart.name.isNotEmpty ? chart.name[0].toUpperCase() : '?',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
                if (selectedChartIds.length < 2 && charts.length >= 2) ...[
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
                            selectedChartIds.isEmpty
                                ? l10n.composite_selectTwoHint
                                : l10n.composite_selectOneMore,
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
              Text('Failed to load charts: $error'),
            ],
          ),
        ),
      ),
    );
  }
}
