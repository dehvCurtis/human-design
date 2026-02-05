import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/dialogs/detail_bottom_sheet.dart';
import '../domain/chart_providers.dart';
import '../domain/models/human_design_chart.dart';
import 'widgets/bodygraph/bodygraph_widget.dart';
import 'widgets/chart_name_dialog.dart';

/// Screen for viewing and managing saved charts
class SavedChartsScreen extends ConsumerWidget {
  const SavedChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsAsync = ref.watch(userSavedChartsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chart_savedCharts),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
      ),
      body: chartsAsync.when(
        data: (charts) {
          if (charts.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: charts.length,
            itemBuilder: (context, index) {
              final chart = charts[index];
              return _ChartCard(
                chartSummary: chart,
                onTap: () {
                  // Navigate to chart detail
                  context.push('${AppRoutes.chart}/${chart.id}');
                },
                onRename: chart.isCurrentUser
                    ? null
                    : () => _showRenameDialog(context, ref, chart),
                onDelete: chart.isCurrentUser
                    ? null
                    : () => _showDeleteDialog(context, ref, chart),
                onShare: () {
                  context.push(AppRoutes.share);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(l10n.chart_loadFailed),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userSavedChartsProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add chart screen to create a chart for someone else
          context.push(AppRoutes.addChart);
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.chart_addChart),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.folder_outlined,
              size: 64,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.chart_noSavedCharts,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chart_noSavedChartsMessage,
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

  Future<void> _showRenameDialog(
    BuildContext context,
    WidgetRef ref,
    ChartSummary chart,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final newName = await ChartNameDialog.show(
      context,
      initialName: chart.name,
      title: l10n.chart_renameChart,
      actionLabel: l10n.chart_rename,
    );

    if (newName != null && context.mounted) {
      final success = await ref
          .read(savedChartsNotifierProvider.notifier)
          .renameChart(chart.id, newName);

      if (!success && context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(l10n.chart_renameFailed)),
        );
      }
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    ChartSummary chart,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chart_deleteChart),
        content: Text(l10n.chart_deleteConfirm(chart.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(savedChartsNotifierProvider.notifier)
          .deleteChart(chart.id);

      if (!success && context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(l10n.chart_deleteFailed)),
        );
      }
    }
  }
}

/// Full chart card with bodygraph visualization
class _ChartCard extends ConsumerWidget {
  const _ChartCard({
    required this.chartSummary,
    required this.onTap,
    this.onRename,
    this.onDelete,
    required this.onShare,
  });

  final ChartSummary chartSummary;
  final VoidCallback onTap;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final chartAsync = ref.watch(chartByIdProvider(chartSummary.id));

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: chartAsync.when(
          data: (chart) => chart != null
              ? _buildFullCard(context, theme, l10n, chart)
              : _buildLoadingCard(context, theme, l10n),
          loading: () => _buildLoadingCard(context, theme, l10n),
          error: (_, _) => _buildErrorCard(context, theme, l10n),
        ),
      ),
    );
  }

  Widget _buildFullCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    HumanDesignChart chart,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with name and actions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTypeColor(chart.type).withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person,
                  color: _getTypeColor(chart.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            chart.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chartSummary.isCurrentUser) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              l10n.chart_you,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${chart.type.displayName} • ${chart.profile.notation}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionsMenu(context, l10n),
            ],
          ),
        ),

        // Bodygraph preview
        Container(
          height: 350,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: BodygraphWidget(
            chart: chart,
            interactive: true,
            showGateNumbers: true,
            onGateTap: (gate) => _showGateDetail(context, gate),
            onChannelTap: (channel) => _showChannelDetail(context, channel),
            onCenterTap: (center) => _showCenterDetail(context, center, chart),
          ),
        ),

        // Quick stats
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: l10n.home_definedCenters,
                value: '${chart.definedCenters.length}/9',
                color: AppColors.centerDefined,
              ),
              _StatItem(
                label: l10n.home_activeChannels,
                value: '${chart.activeChannels.length}',
                color: AppColors.channelConscious,
              ),
              _StatItem(
                label: l10n.home_activeGates,
                value: '${chart.allGates.length}',
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              chartSummary.name,
              style: theme.textTheme.titleMedium,
            ),
            Text(
              chartSummary.type.displayName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.error_outline, color: AppColors.error),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chartSummary.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  l10n.chart_loadFailed,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          _buildActionsMenu(context, l10n),
        ],
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context, AppLocalizations l10n) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'rename':
            onRename?.call();
            break;
          case 'share':
            onShare();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (onRename != null)
          PopupMenuItem(
            value: 'rename',
            child: ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.chart_rename),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        PopupMenuItem(
          value: 'share',
          child: ListTile(
            leading: const Icon(Icons.share_outlined),
            title: Text(l10n.common_share),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (onDelete != null)
          PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(l10n.common_delete,
                  style: const TextStyle(color: AppColors.error)),
              contentPadding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }

  Color _getTypeColor(HumanDesignType type) {
    return switch (type) {
      HumanDesignType.manifestor => AppColors.primary,
      HumanDesignType.generator => AppColors.success,
      HumanDesignType.manifestingGenerator => AppColors.accent,
      HumanDesignType.projector => AppColors.info,
      HumanDesignType.reflector => AppColors.secondary,
    };
  }

  void _showGateDetail(BuildContext context, int gateNumber) {
    final gateInfo = gates[gateNumber];
    if (gateInfo == null) return;

    DetailBottomSheet.show(
      context: context,
      title: 'Gate $gateNumber',
      subtitle: gateInfo.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            label: 'Center',
            value: gateInfo.center.displayName,
          ),
          const Divider(),
          _DetailRow(
            label: 'Keynote',
            value: gateInfo.keynote,
          ),
        ],
      ),
    );
  }

  void _showChannelDetail(BuildContext context, String channelId) {
    final parts = channelId.split('-');
    if (parts.length != 2) return;

    final gate1 = int.tryParse(parts[0]);
    final gate2 = int.tryParse(parts[1]);
    if (gate1 == null || gate2 == null) return;

    final gate1Info = gates[gate1];
    final gate2Info = gates[gate2];

    DetailBottomSheet.show(
      context: context,
      title: 'Channel $channelId',
      subtitle:
          '${gate1Info?.name ?? 'Gate $gate1'} - ${gate2Info?.name ?? 'Gate $gate2'}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChannelGateRow(gateNumber: gate1, gateInfo: gate1Info),
          const SizedBox(height: 16),
          const Center(
            child: Icon(Icons.swap_vert, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          _ChannelGateRow(gateNumber: gate2, gateInfo: gate2Info),
        ],
      ),
    );
  }

  void _showCenterDetail(
      BuildContext context, HumanDesignCenter center, HumanDesignChart chart) {
    DetailBottomSheet.show(
      context: context,
      title: center.displayName,
      subtitle: chart.isCenterDefined(center) ? 'Defined' : 'Undefined',
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: chart.isCenterDefined(center)
              ? AppColors.centerDefined
              : AppColors.centerUndefined,
          shape: BoxShape.circle,
          border: Border.all(
            color: chart.isCenterDefined(center)
                ? AppColors.centerDefinedBorder
                : AppColors.centerUndefinedBorder,
            width: 2,
          ),
        ),
      ),
      child: Text(
        chart.isCenterDefined(center)
            ? 'This center is defined in this chart, providing consistent energy.'
            : 'This center is undefined, meaning it is open to influence from others.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelGateRow extends StatelessWidget {
  const _ChannelGateRow({
    required this.gateNumber,
    required this.gateInfo,
  });

  final int gateNumber;
  final GateData? gateInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Gate $gateNumber',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  gateInfo?.name ?? 'Unknown',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          if (gateInfo != null) ...[
            const SizedBox(height: 8),
            Text(
              gateInfo!.keynote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
