import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/chart_providers.dart';
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
          onPressed: () => context.pop(),
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
                chart: chart,
                onTap: () {
                  // Navigate to chart detail
                  context.push('${AppRoutes.chart}/${chart.id}');
                },
                onRename: () => _showRenameDialog(context, ref, chart),
                onDelete: chart.isCurrentUser
                    ? null
                    : () => _showDeleteDialog(context, ref, chart),
                onShare: () {
                  // TODO: Implement share
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
              Text('${l10n.chart_loadFailed}: $error'),
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

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.chart,
    required this.onTap,
    required this.onRename,
    this.onDelete,
    required this.onShare,
  });

  final ChartSummary chart;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback? onDelete;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMd();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Type indicator
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor(chart.type).withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    chart.name.isNotEmpty ? chart.name[0].toUpperCase() : '?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: _getTypeColor(chart.type),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chart.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (chart.isCurrentUser)
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
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chart.type.displayName} • ${chart.profile}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(chart.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'rename':
                      onRename();
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
                        title: Text(l10n.common_delete, style: const TextStyle(color: AppColors.error)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
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
}
