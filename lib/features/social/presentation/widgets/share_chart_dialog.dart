import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../sharing/domain/sharing_providers.dart';
import '../../domain/social_providers.dart';

/// Dialog for sharing a chart with friends or groups
class ShareChartDialog extends ConsumerStatefulWidget {
  const ShareChartDialog({
    super.key,
    required this.chartId,
    required this.chartName,
  });

  final String chartId;
  final String chartName;

  /// Show the share chart dialog
  static Future<bool?> show(
    BuildContext context, {
    required String chartId,
    required String chartName,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareChartDialog(
        chartId: chartId,
        chartName: chartName,
      ),
    );
  }

  @override
  ConsumerState<ShareChartDialog> createState() => _ShareChartDialogState();
}

class _ShareChartDialogState extends ConsumerState<ShareChartDialog> {
  bool _isSharing = false;
  bool _isCreatingLink = false;
  String? _errorMessage;
  String? _successMessage;
  String? _shareLink;

  Future<void> _createShareLink() async {
    setState(() {
      _isCreatingLink = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final link = await ref.read(sharingNotifierProvider.notifier).createChartShareLink(
            chartId: widget.chartId,
          );

      if (mounted) {
        setState(() {
          _isCreatingLink = false;
          _shareLink = link.url;
          _successMessage = 'Share link created!';
        });

        // Copy to clipboard
        await Clipboard.setData(ClipboardData(text: link.url));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCreatingLink = false;
          _errorMessage = ErrorHandler.getUserMessage(e, context: 'create share link');
        });
      }
    }
  }

  Future<void> _shareWithGroup(String groupId, String groupName) async {
    setState(() {
      _isSharing = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await ref.read(socialNotifierProvider.notifier).shareChartWithGroup(
            chartId: widget.chartId,
            groupId: groupId,
          );

      if (mounted) {
        setState(() {
          _isSharing = false;
          _successMessage = 'Chart shared with $groupName';
        });

        // Close dialog after short delay
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSharing = false;
          _errorMessage = ErrorHandler.getUserMessage(e, context: 'share chart');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondaryLight.withAlpha(100),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.share_outlined, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share Chart',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.chartName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                // Status messages
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_successMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _successMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.success,
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

          // Content
          Expanded(
            child: _isSharing || _isCreatingLink
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Primary option: Create Share Link
                        _ShareLinkSection(
                          shareLink: _shareLink,
                          onCreateLink: _createShareLink,
                          onCopyLink: () async {
                            if (_shareLink != null) {
                              await Clipboard.setData(ClipboardData(text: _shareLink!));
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Link copied to clipboard')),
                              );
                            }
                          },
                          onManageLinks: () {
                            Navigator.of(context).pop();
                            context.push(AppRoutes.myShares);
                          },
                        ),

                        const Divider(height: 32),

                        // Secondary option: Share with Groups
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Share with Groups',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _GroupsList(onShare: _shareWithGroup),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ShareLinkSection extends StatelessWidget {
  const _ShareLinkSection({
    required this.shareLink,
    required this.onCreateLink,
    required this.onCopyLink,
    required this.onManageLinks,
  });

  final String? shareLink;
  final VoidCallback onCreateLink;
  final VoidCallback onCopyLink;
  final VoidCallback onManageLinks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.link, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Share Link',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Anyone with the link can view your chart',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (shareLink != null) ...[
            // Show the created link
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
                      shareLink!,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: onCopyLink,
                    tooltip: 'Copy link',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onManageLinks,
                    icon: const Icon(Icons.settings, size: 18),
                    label: const Text('Manage Links'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onCopyLink,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Copy Link'),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Show create button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCreateLink,
                icon: const Icon(Icons.add_link),
                label: const Text('Create Share Link'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: onManageLinks,
                child: const Text('View existing links'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GroupsList extends ConsumerWidget {
  const _GroupsList({required this.onShare});

  final void Function(String groupId, String groupName) onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);
    final theme = Theme.of(context);

    return groupsAsync.when(
      data: (groups) {
        if (groups.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.groups_outlined,
                  size: 48,
                  color: AppColors.textSecondaryLight.withAlpha(150),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Groups Yet',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a group to share your chart with multiple people.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: groups.map((group) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.accent.withAlpha(25),
                backgroundImage: group.avatarUrl != null
                    ? NetworkImage(group.avatarUrl!)
                    : null,
                child: group.avatarUrl == null
                    ? const Icon(Icons.groups, color: AppColors.accent)
                    : null,
              ),
              title: Text(group.name),
              subtitle: group.description != null
                  ? Text(
                      group.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: FilledButton.icon(
                onPressed: () => onShare(group.id, group.name),
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Share'),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(32),
        child: Text(ErrorHandler.getUserMessage(error, context: 'load groups')),
      ),
    );
  }
}
