import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/models/sharing.dart';
import '../domain/sharing_providers.dart';

/// Screen for viewing and managing all shared links
class MySharesScreen extends ConsumerWidget {
  const MySharesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final linksAsync = ref.watch(myShareLinksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.share_myShares),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.share_createNew,
            onPressed: () => context.push('/share'),
          ),
        ],
      ),
      body: linksAsync.when(
        data: (links) {
          if (links.isEmpty) {
            return _buildEmptyState(context, l10n);
          }

          // Separate active and expired links
          final activeLinks = links.where((l) => !l.isExpired).toList();
          final expiredLinks = links.where((l) => l.isExpired).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myShareLinksProvider);
            },
            child: CustomScrollView(
              slivers: [
                // Stats header
                SliverToBoxAdapter(
                  child: _ShareStats(links: links),
                ),

                // Active links section
                if (activeLinks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: 20,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.share_activeLinks(activeLinks.length),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ShareLinkCard(
                        link: activeLinks[index],
                        onCopy: () => _copyLink(context, activeLinks[index].url, l10n),
                        onRevoke: () => _revokeLink(context, ref, activeLinks[index], l10n),
                      ),
                      childCount: activeLinks.length,
                    ),
                  ),
                ],

                // Expired links section
                if (expiredLinks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_off,
                            size: 20,
                            color: AppColors.textSecondaryLight,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.share_expiredLinks(expiredLinks.length),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _clearExpired(context, ref, expiredLinks, l10n),
                            child: Text(l10n.share_clearExpired),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Opacity(
                        opacity: 0.6,
                        child: _ShareLinkCard(
                          link: expiredLinks[index],
                          onCopy: null,
                          onRevoke: () => _revokeLink(context, ref, expiredLinks[index], l10n),
                        ),
                      ),
                      childCount: expiredLinks.length,
                    ),
                  ),
                ],

                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(ErrorHandler.getUserMessage(error)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(myShareLinksProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/share'),
        icon: const Icon(Icons.add_link),
        label: Text(l10n.share_newLink),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share_outlined,
              size: 64,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.share_noShares,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.share_noSharesMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push('/share'),
              icon: const Icon(Icons.add_link),
              label: Text(l10n.share_createFirst),
            ),
          ],
        ),
      ),
    );
  }

  void _copyLink(BuildContext context, String url, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.share_linkCopied)),
    );
  }

  Future<void> _revokeLink(
    BuildContext context,
    WidgetRef ref,
    SharedLink link,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.share_revokeTitle),
        content: Text(l10n.share_revokeMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(l10n.share_revoke),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(sharingNotifierProvider.notifier).revokeShareLink(link.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.share_linkRevoked)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _clearExpired(
    BuildContext context,
    WidgetRef ref,
    List<SharedLink> expiredLinks,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.share_clearExpiredTitle),
        content: Text(l10n.share_clearExpiredMessage(expiredLinks.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.share_clearAll),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      for (final link in expiredLinks) {
        await ref.read(sharingNotifierProvider.notifier).revokeShareLink(link.id);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.share_expiredCleared)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _ShareStats extends StatelessWidget {
  const _ShareStats({required this.links});

  final List<SharedLink> links;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final activeCount = links.where((l) => !l.isExpired).length;
    final totalViews = links.fold<int>(0, (sum, l) => sum + l.viewCount);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withAlpha(20),
            AppColors.secondary.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withAlpha(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(
            icon: Icons.link,
            value: links.length.toString(),
            label: l10n.share_totalLinks,
            color: AppColors.primary,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.dividerLight,
          ),
          _StatColumn(
            icon: Icons.check_circle,
            value: activeCount.toString(),
            label: l10n.share_active,
            color: AppColors.success,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.dividerLight,
          ),
          _StatColumn(
            icon: Icons.visibility,
            value: totalViews.toString(),
            label: l10n.share_totalViews,
            color: AppColors.info,
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class _ShareLinkCard extends StatelessWidget {
  const _ShareLinkCard({
    required this.link,
    required this.onCopy,
    required this.onRevoke,
  });

  final SharedLink link;
  final VoidCallback? onCopy;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isExpired = link.isExpired;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? AppColors.error.withAlpha(25)
                        : AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isExpired ? Icons.link_off : Icons.link,
                    color: isExpired ? AppColors.error : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getContentTypeLabel(link.contentType, l10n),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: isExpired ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(link.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? AppColors.error.withAlpha(25)
                        : AppColors.success.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isExpired ? l10n.share_expired : l10n.share_activeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isExpired ? AppColors.error : AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // URL row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      link.url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: isExpired
                            ? AppColors.textSecondaryLight
                            : theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onCopy != null)
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: onCopy,
                      tooltip: l10n.common_copy,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Stats and actions row
            Row(
              children: [
                // Views
                Icon(
                  Icons.visibility,
                  size: 16,
                  color: AppColors.textSecondaryLight,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.share_views(link.viewCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),

                // Expiry
                if (link.expiresAt != null) ...[
                  const SizedBox(width: 16),
                  Icon(
                    isExpired ? Icons.timer_off : Icons.timer,
                    size: 16,
                    color: isExpired ? AppColors.error : AppColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isExpired
                        ? l10n.share_expiredOn(_formatDate(link.expiresAt!))
                        : l10n.share_expiresIn(_formatExpiry(link.expiresAt!)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isExpired ? AppColors.error : AppColors.textSecondaryLight,
                    ),
                  ),
                ],

                const Spacer(),

                // Delete button
                TextButton.icon(
                  onPressed: onRevoke,
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppColors.error,
                  ),
                  label: Text(
                    l10n.share_revoke,
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getContentTypeLabel(String contentType, AppLocalizations l10n) {
    switch (contentType) {
      case 'chart':
        return l10n.share_chartLink;
      case 'transit':
        return l10n.share_transitLink;
      case 'compatibility':
        return l10n.share_compatibilityLink;
      default:
        return l10n.share_link;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatExpiry(DateTime expiresAt) {
    final diff = expiresAt.difference(DateTime.now());

    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'soon';
    }
  }
}
