import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../chart/presentation/widgets/bodygraph/bodygraph_widget.dart';
import '../../home/domain/home_providers.dart';
import '../services/chart_export_service.dart';

class ShareScreen extends ConsumerStatefulWidget {
  const ShareScreen({super.key});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  bool _isExporting = false;
  final GlobalKey _bodygraphKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(supabaseClientProvider).auth.currentUser;
    final userChartAsync = ref.watch(userChartProvider);

    // Auth check - redirect to sign in if not authenticated
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.share_shareChart),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.share_signInToShare,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.share_createShareableLinks,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.signIn),
                  icon: const Icon(Icons.login),
                  label: Text(l10n.auth_signIn),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.share_shareChart),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.share_shareChart,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Export options: Image and PDF
            Row(
              children: [
                Expanded(
                  child: _ShareOptionCard(
                    icon: Icons.image,
                    label: l10n.share_linkImage,
                    description: l10n.share_exportAsPng,
                    isLoading: _isExporting,
                    onTap: _isExporting ? () {} : () => _exportAsImage(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ShareOptionCard(
                    icon: Icons.picture_as_pdf,
                    label: l10n.share_pdf,
                    description: l10n.share_fullReport,
                    isLoading: _isExporting,
                    onTap: _isExporting ? () {} : () => _exportAsPdf(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Chart preview for export
            Text(
              'Chart Preview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            userChartAsync.when(
              data: (chart) {
                if (chart == null) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No chart available',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add your birth data in Profile',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: RepaintBoundary(
                      key: _bodygraphKey,
                      child: Container(
                        color: theme.colorScheme.surface,
                        padding: const EdgeInsets.all(16),
                        child: BodygraphWidget(
                          chart: chart,
                          interactive: false,
                          showGateNumbers: true,
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => Container(
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Container(
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Error loading chart',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAsImage(BuildContext context) async {
    final userChartAsync = ref.read(userChartProvider);
    final chart = userChartAsync.hasValue ? userChartAsync.value : null;
    if (chart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.sharing_noChartAvailable)),
      );
      return;
    }

    if (_isExporting) return;
    setState(() => _isExporting = true);

    final errorColor = Theme.of(context).colorScheme.error;
    try {
      await ChartExportService.exportAsImage(
        repaintBoundaryKey: _bodygraphKey,
        chartName: chart.name,
        context: context,
      );
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'export')),
            backgroundColor: errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportAsPdf(BuildContext context) async {
    final userChartAsync = ref.read(userChartProvider);
    final chart = userChartAsync.hasValue ? userChartAsync.value : null;
    if (chart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.sharing_noChartAvailable)),
      );
      return;
    }

    if (_isExporting) return;
    setState(() => _isExporting = true);

    final errorColor = Theme.of(context).colorScheme.error;
    try {
      await ChartExportService.exportAsPdf(
        chart: chart,
        bodygraphKey: _bodygraphKey,
        context: context,
      );
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'PDF export')),
            backgroundColor: errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}

class _ShareOptionCard extends StatelessWidget {
  const _ShareOptionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (isLoading)
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
