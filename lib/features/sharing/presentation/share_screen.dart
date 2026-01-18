import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/sharing_providers.dart';
import '../domain/models/sharing.dart';

class ShareScreen extends ConsumerStatefulWidget {
  const ShareScreen({super.key});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  Duration? _selectedExpiry;

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
    final sharingState = ref.watch(sharingNotifierProvider);
    final myLinksAsync = ref.watch(myShareLinksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Chart'),
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
                    'Create Share Link',
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
                          label: 'Link',
                          description: 'Share via URL',
                          isSelected: true,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ShareOptionCard(
                          icon: Icons.image,
                          label: 'Image',
                          description: 'Export as PNG',
                          isSelected: false,
                          onTap: () => _exportAsImage(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ShareOptionCard(
                          icon: Icons.picture_as_pdf,
                          label: 'PDF',
                          description: 'Full report',
                          isSelected: false,
                          onTap: () => _exportAsPdf(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Expiry selector
                  Text(
                    'Link Expiration',
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
                            ? 'Creating...'
                            : 'Create Share Link',
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
                                  'Link created!',
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
              child: Center(child: Text('Error: $e')),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Future<void> _createShareLink(BuildContext context) async {
    // For now, we'll use a placeholder chart ID
    // In real implementation, this would come from the user's chart
    try {
      await ref.read(sharingNotifierProvider.notifier).createChartShareLink(
            chartId: 'current-user-chart',
            expiresIn: _selectedExpiry,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _copyLink(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }

  Future<void> _revokeLink(BuildContext context, String shareId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Link'),
        content: const Text(
          'This will permanently disable this share link. Anyone with the link will no longer be able to view your chart.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(sharingNotifierProvider.notifier).revokeShareLink(shareId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link revoked')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _exportAsImage(BuildContext context) {
    // TODO: Implement image export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image export coming soon')),
    );
  }

  void _exportAsPdf(BuildContext context) {
    // TODO: Implement PDF export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF export coming soon')),
    );
  }
}

class _ShareOptionCard extends StatelessWidget {
  const _ShareOptionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
