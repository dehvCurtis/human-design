import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../chart/presentation/widgets/bodygraph/bodygraph_widget.dart';
import '../../home/domain/home_providers.dart';
import '../domain/sharing_providers.dart';
import '../domain/models/sharing.dart';
import '../services/chart_export_service.dart';

class ShareScreen extends ConsumerStatefulWidget {
  const ShareScreen({super.key});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  Duration? _selectedExpiry;
  bool _isExporting = false;
  final GlobalKey _bodygraphKey = GlobalKey();

  static const List<({String label, Duration? duration})> _expiryOptions = [
    (label: 'Never expires', duration: null),
    (label: '1 hour', duration: Duration(hours: 1)),
    (label: '24 hours', duration: Duration(hours: 24)),
    (label: '7 days', duration: Duration(days: 7)),
    (label: '30 days', duration: Duration(days: 30)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(supabaseClientProvider).auth.currentUser;
    final sharingState = ref.watch(sharingNotifierProvider);
    final myLinksAsync = ref.watch(myShareLinksProvider);
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
      body: CustomScrollView(
        slivers: [
          // Share options
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.share_createShareLink,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Share options cards
                  Row(
                    children: [
                      Expanded(
                        child: _ShareOptionCard(
                          icon: Icons.link,
                          label: l10n.share_link,
                          description: l10n.share_shareViaUrl,
                          isSelected: true,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ShareOptionCard(
                          icon: Icons.image,
                          label: l10n.share_linkImage,
                          description: l10n.share_exportAsPng,
                          isSelected: false,
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
                          isSelected: false,
                          isLoading: _isExporting,
                          onTap: _isExporting ? () {} : () => _exportAsPdf(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Expiry selector
                  Text(
                    l10n.share_linkExpiration,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _expiryOptions.map((option) {
                      final isSelected = _selectedExpiry == option.duration;
                      return ChoiceChip(
                        label: Text(option.label),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedExpiry = option.duration);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Create link button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: sharingState.isCreatingLink
                          ? null
                          : () => _createShareLink(context),
                      icon: sharingState.isCreatingLink
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.link),
                      label: Text(
                        sharingState.isCreatingLink
                            ? l10n.share_creating
                            : l10n.share_createShareLink,
                      ),
                    ),
                  ),

                  // Last created link
                  if (sharingState.lastCreatedLink != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.share_linkCopied,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  sharingState.lastCreatedLink!.url,
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () => _copyLink(
                              context,
                              sharingState.lastCreatedLink!.url,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Chart preview for export
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
          ),

          // Divider
          const SliverToBoxAdapter(
            child: Divider(height: 32),
          ),

          // My share links
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'My Share Links',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          myLinksAsync.when(
            data: (links) {
              if (links.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.link_off,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No share links yet',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _ShareLinkTile(
                    link: links[index],
                    onCopy: () => _copyLink(context, links[index].url),
                    onRevoke: () => _revokeLink(context, links[index].id),
                  ),
                  childCount: links.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(child: Text(ErrorHandler.getUserMessage(e))),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Future<void> _createShareLink(BuildContext context) async {
    final errorColor = Theme.of(context).colorScheme.error;

    // Get the user's chart to share
    final userChart = await ref.read(userChartProvider.future);
    if (userChart == null) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please complete your birth data first to share your chart'),
            backgroundColor: errorColor,
          ),
        );
      }
      return;
    }

    try {
      await ref.read(sharingNotifierProvider.notifier).createChartShareLink(
            chartId: userChart.id,
            expiresIn: _selectedExpiry,
          );
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e)),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }

  void _copyLink(BuildContext context, String url) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.share_linkCopied)),
    );
  }

  Future<void> _revokeLink(BuildContext context, String shareId) async {
    final l10n = AppLocalizations.of(context)!;
    final errorColor = Theme.of(context).colorScheme.error;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.share_revokeTitle),
        content: Text(l10n.share_revokeMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.share_revoke),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(sharingNotifierProvider.notifier).revokeShareLink(shareId);
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.share_linkRevoked)),
        );
      }
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e)),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }

  Future<void> _exportAsImage(BuildContext context) async {
    final userChartAsync = ref.read(userChartProvider);
    final chart = userChartAsync.hasValue ? userChartAsync.value : null;
    if (chart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No chart available to export')),
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
        const SnackBar(content: Text('No chart available to export')),
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
    required this.isSelected,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
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
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.outline,
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

class _ShareLinkTile extends StatelessWidget {
  const _ShareLinkTile({
    required this.link,
    required this.onCopy,
    required this.onRevoke,
  });

  final SharedLink link;
  final VoidCallback onCopy;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpired = link.isExpired;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isExpired
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.link,
          color: isExpired
              ? theme.colorScheme.error
              : theme.colorScheme.primary,
        ),
      ),
      title: Text(
        link.url.length > 40 ? '${link.url.substring(0, 40)}...' : link.url,
        style: theme.textTheme.bodyMedium?.copyWith(
          decoration: isExpired ? TextDecoration.lineThrough : null,
          color: isExpired ? theme.colorScheme.outline : null,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.visibility,
            size: 14,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(width: 4),
          Text(
            '${link.viewCount} views',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          if (link.expiresAt != null) ...[
            const SizedBox(width: 12),
            Icon(
              isExpired ? Icons.timer_off : Icons.timer,
              size: 14,
              color: isExpired
                  ? theme.colorScheme.error
                  : theme.colorScheme.outline,
            ),
            const SizedBox(width: 4),
            Text(
              isExpired ? 'Expired' : _formatExpiry(link.expiresAt!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isExpired
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
              ),
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isExpired)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: onCopy,
            ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
            ),
            onPressed: onRevoke,
          ),
        ],
      ),
    );
  }

  String _formatExpiry(DateTime expiresAt) {
    final diff = expiresAt.difference(DateTime.now());

    if (diff.inDays > 0) {
      return '${diff.inDays}d left';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h left';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m left';
    } else {
      return 'Soon';
    }
  }
}
