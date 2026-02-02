import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
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

class _ShareChartDialogState extends ConsumerState<ShareChartDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSharing = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _shareWithFriend(String friendId, String friendName) async {
    setState(() {
      _isSharing = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await ref.read(socialNotifierProvider.notifier).shareChartWithFriend(
            chartId: widget.chartId,
            friendId: friendId,
          );

      if (mounted) {
        setState(() {
          _isSharing = false;
          _successMessage = 'Chart shared with $friendName';
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

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Friends'),
              Tab(text: 'Groups'),
            ],
          ),

          // Content
          Expanded(
            child: _isSharing
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _FriendsTab(onShare: _shareWithFriend),
                      _GroupsTab(onShare: _shareWithGroup),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab({required this.onShare});

  final void Function(String friendId, String friendName) onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    final theme = Theme.of(context);

    return friendsAsync.when(
      data: (friends) {
        if (friends.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: AppColors.textSecondaryLight.withAlpha(150),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Friends Yet',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add friends to share your chart with them.',
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

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withAlpha(25),
                backgroundImage: friend.avatarUrl != null
                    ? NetworkImage(friend.avatarUrl!)
                    : null,
                child: friend.avatarUrl == null
                    ? Text(
                        friend.name.isNotEmpty
                            ? friend.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(color: AppColors.primary),
                      )
                    : null,
              ),
              title: Text(friend.name),
              trailing: FilledButton.icon(
                onPressed: () => onShare(friend.friendId, friend.name),
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Share'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(ErrorHandler.getUserMessage(error, context: 'load friends')),
      ),
    );
  }
}

class _GroupsTab extends ConsumerWidget {
  const _GroupsTab({required this.onShare});

  final void Function(String groupId, String groupName) onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);
    final theme = Theme.of(context);

    return groupsAsync.when(
      data: (groups) {
        if (groups.isEmpty) {
          return Center(
            child: Padding(
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
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
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
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(ErrorHandler.getUserMessage(error, context: 'load groups')),
      ),
    );
  }
}
