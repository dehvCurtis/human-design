import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../chart/domain/chart_providers.dart';
import '../data/social_repository.dart';
import '../domain/social_providers.dart';

class GroupDetailScreen extends ConsumerWidget {
  const GroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupAsync = ref.watch(groupProvider(groupId));

    return groupAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(ErrorHandler.getUserMessage(e))),
      ),
      data: (group) {
        if (group == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.group_notFound)),
          );
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(group.name),
              actions: [
                if (group.isAdmin)
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () => _showInviteSheet(context, ref, group),
                    tooltip: l10n.group_invite,
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) =>
                      _handleMenuAction(context, ref, value, group),
                  itemBuilder: (context) => [
                    if (group.isAdmin) ...[
                      PopupMenuItem(
                        value: 'editName',
                        child: Row(
                          children: [
                            const Icon(Icons.edit),
                            const SizedBox(width: 8),
                            Text(l10n.group_editName),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'editDescription',
                        child: Row(
                          children: [
                            const Icon(Icons.description_outlined),
                            const SizedBox(width: 8),
                            Text(l10n.group_editDescription),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete,
                                color: Theme.of(context).colorScheme.error),
                            const SizedBox(width: 8),
                            Text(l10n.group_delete,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.error)),
                          ],
                        ),
                      ),
                    ],
                    PopupMenuItem(
                      value: 'leave',
                      child: Row(
                        children: [
                          const Icon(Icons.exit_to_app),
                          const SizedBox(width: 8),
                          Text(l10n.group_leave),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: [
                  Tab(text: l10n.group_members),
                  Tab(text: l10n.group_sharedCharts),
                  Tab(text: l10n.group_feed),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _MembersTab(groupId: groupId, isAdmin: group.isAdmin),
                _SharedChartsTab(groupId: groupId),
                _FeedTab(groupId: groupId),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInviteSheet(BuildContext context, WidgetRef ref, Group group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _InviteSheet(
          groupId: group.id,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    Group group,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(socialNotifierProvider.notifier);

    switch (action) {
      case 'editName':
        _showEditDialog(
          context: context,
          title: l10n.group_editName,
          initialValue: group.name,
          maxLength: SocialRepository.maxGroupNameLength,
          onSave: (value) async {
            final success = await notifier.updateGroup(
              groupId: group.id,
              name: value,
            );
            if (context.mounted && success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_updated)),
              );
            }
          },
        );
        break;
      case 'editDescription':
        _showEditDialog(
          context: context,
          title: l10n.group_editDescription,
          initialValue: group.description ?? '',
          maxLength: SocialRepository.maxGroupDescriptionLength,
          maxLines: 3,
          onSave: (value) async {
            final success = await notifier.updateGroup(
              groupId: group.id,
              description: value,
            );
            if (context.mounted && success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_updated)),
              );
            }
          },
        );
        break;
      case 'delete':
        _showConfirmDialog(
          context: context,
          title: l10n.group_deleteTitle,
          message: l10n.group_deleteConfirmation(group.name),
          confirmLabel: l10n.common_delete,
          isDestructive: true,
          onConfirm: () async {
            final success = await notifier.deleteGroup(group.id);
            if (context.mounted && success) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_deleted)),
              );
            }
          },
        );
        break;
      case 'leave':
        _showConfirmDialog(
          context: context,
          title: l10n.group_leaveTitle,
          message: l10n.group_leaveConfirmation(group.name),
          confirmLabel: l10n.group_leave,
          isDestructive: false,
          onConfirm: () async {
            final success = await notifier.leaveGroup(group.id);
            if (context.mounted && success) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_left)),
              );
            }
          },
        );
        break;
    }
  }

  void _showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required int maxLength,
    int maxLines = 1,
    required Future<void> Function(String value) onSave,
  }) {
    final controller = TextEditingController(text: initialValue);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () async {
              final value = controller.text.trim();
              if (value.isEmpty) return;
              Navigator.pop(dialogContext);
              await onSave(value);
            },
            child: Text(l10n.common_save),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required bool isDestructive,
    required Future<void> Function() onConfirm,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onConfirm();
            },
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Members Tab
// =============================================================================

class _MembersTab extends ConsumerWidget {
  const _MembersTab({required this.groupId, required this.isAdmin});

  final String groupId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(groupMembersProvider(groupId));

    return membersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
      data: (members) {
        if (members.isEmpty) {
          return Center(child: Text(l10n.group_noMembers));
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.refresh(groupMembersProvider(groupId).future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return _MemberCard(
                member: member,
                groupId: groupId,
                isAdmin: isAdmin,
              );
            },
          ),
        );
      },
    );
  }
}

class _MemberCard extends ConsumerWidget {
  const _MemberCard({
    required this.member,
    required this.groupId,
    required this.isAdmin,
  });

  final GroupMember member;
  final String groupId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = ref.watch(currentUserIdProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: member.avatarUrl != null
              ? NetworkImage(member.avatarUrl!)
              : null,
          child: member.avatarUrl == null
              ? Text(member.name[0].toUpperCase())
              : null,
        ),
        title: Row(
          children: [
            Flexible(child: Text(member.name, overflow: TextOverflow.ellipsis)),
            if (member.isAdmin) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.social_admin,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ],
        ),
        trailing: isAdmin && member.userId != currentUserId
            ? PopupMenuButton<String>(
                onSelected: (value) =>
                    _handleMemberAction(context, ref, value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: member.isAdmin ? 'demote' : 'promote',
                    child: Text(member.isAdmin
                        ? l10n.group_demote
                        : l10n.group_promote),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(
                      l10n.group_removeMember,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
              )
            : null,
        onTap: () => context.push('/user/${member.userId}'),
      ),
    );
  }

  void _handleMemberAction(
      BuildContext context, WidgetRef ref, String action) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(socialNotifierProvider.notifier);

    switch (action) {
      case 'promote':
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.group_promoteTitle),
            content: Text(l10n.group_promoteConfirmation(member.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.common_cancel),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await notifier.updateMemberRole(
                    groupId: groupId,
                    userId: member.userId,
                    role: 'admin',
                  );
                },
                child: Text(l10n.group_promote),
              ),
            ],
          ),
        );
        break;
      case 'demote':
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.group_demoteTitle),
            content: Text(l10n.group_demoteConfirmation(member.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.common_cancel),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await notifier.updateMemberRole(
                    groupId: groupId,
                    userId: member.userId,
                    role: 'member',
                  );
                },
                child: Text(l10n.group_demote),
              ),
            ],
          ),
        );
        break;
      case 'remove':
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.group_removeMemberTitle),
            content: Text(l10n.group_removeMemberConfirmation(member.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.common_cancel),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await notifier.removeMember(
                    groupId: groupId,
                    userId: member.userId,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(l10n.group_removeMember),
              ),
            ],
          ),
        );
        break;
    }
  }
}

// =============================================================================
// Shared Charts Tab
// =============================================================================

class _SharedChartsTab extends ConsumerWidget {
  const _SharedChartsTab({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final chartsAsync = ref.watch(groupSharedChartsProvider(groupId));

    return Column(
      children: [
        // Share button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showChartPicker(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.group_shareChart),
            ),
          ),
        ),

        // Charts list
        Expanded(
          child: chartsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(ErrorHandler.getUserMessage(e))),
            data: (charts) {
              if (charts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_graph_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.group_noSharedCharts,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.group_noSharedChartsMessage,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(groupSharedChartsProvider(groupId).future),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: charts.length,
                  itemBuilder: (context, index) {
                    final chart = charts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.auto_graph),
                        ),
                        title: Text(chart.chartName),
                        subtitle:
                            Text(l10n.social_sharedBy(chart.sharedByName)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push('/chart/${chart.chartId}'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showChartPicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _ChartPickerSheet(
        groupId: groupId,
        l10n: l10n,
      ),
    );
  }
}

class _ChartPickerSheet extends ConsumerWidget {
  const _ChartPickerSheet({required this.groupId, required this.l10n});

  final String groupId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsAsync = ref.watch(userSavedChartsProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.group_shareChart,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Flexible(
            child: chartsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(ErrorHandler.getUserMessage(e))),
              data: (charts) {
                if (charts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      l10n.group_noChartsToShare,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: charts.length,
                  itemBuilder: (context, index) {
                    final chart = charts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.auto_graph),
                        ),
                        title: Text(chart.name),
                        subtitle: Text(
                            '${chart.type.displayName} • ${chart.profile}'),
                        trailing: FilledButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await ref
                                .read(socialNotifierProvider.notifier)
                                .shareChartWithGroup(
                                  chartId: chart.id,
                                  groupId: groupId,
                                );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text(l10n.group_chartShared)),
                              );
                            }
                          },
                          child: Text(l10n.group_share),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Feed Tab
// =============================================================================

class _FeedTab extends ConsumerStatefulWidget {
  const _FeedTab({required this.groupId});

  final String groupId;

  @override
  ConsumerState<_FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends ConsumerState<_FeedTab> {
  final _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final postsAsync = ref.watch(groupPostsProvider(widget.groupId));
    final currentUserId = ref.watch(currentUserIdProvider);

    return Column(
      children: [
        // Post composer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _postController,
                  decoration: InputDecoration(
                    hintText: l10n.group_writePost,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                  maxLength: SocialRepository.maxGroupPostLength,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          required maxLength}) =>
                      null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _submitPost,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),

        // Posts list
        Expanded(
          child: postsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(ErrorHandler.getUserMessage(e))),
            data: (posts) {
              if (posts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.group_noPosts,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.group_beFirstToPost,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref
                    .refresh(groupPostsProvider(widget.groupId).future),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final isOwn = post.userId == currentUserId;
                    return _GroupPostCard(
                      post: post,
                      isOwn: isOwn,
                      onDelete: isOwn
                          ? () => _deletePost(context, ref, post)
                          : null,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _submitPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) return;

    final success =
        await ref.read(socialNotifierProvider.notifier).createGroupPost(
              groupId: widget.groupId,
              content: content,
            );

    if (success) {
      _postController.clear();
    }
  }

  void _deletePost(BuildContext context, WidgetRef ref, GroupPost post) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.common_delete),
        content: Text(l10n.group_deletePostConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(socialNotifierProvider.notifier).deleteGroupPost(
                    groupId: widget.groupId,
                    postId: post.id,
                  );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }
}

class _GroupPostCard extends StatelessWidget {
  const _GroupPostCard({
    required this.post,
    required this.isOwn,
    this.onDelete,
  });

  final GroupPost post;
  final bool isOwn;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: post.userAvatarUrl != null
                      ? NetworkImage(post.userAvatarUrl!)
                      : null,
                  child: post.userAvatarUrl == null
                      ? Text(post.userName[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        _formatTime(post.createdAt),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                      ),
                    ],
                  ),
                ),
                if (isOwn && onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}

// =============================================================================
// Invite Bottom Sheet
// =============================================================================

class _InviteSheet extends ConsumerStatefulWidget {
  const _InviteSheet({
    required this.groupId,
    required this.scrollController,
  });

  final String groupId;
  final ScrollController scrollController;

  @override
  ConsumerState<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<_InviteSheet> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.group_inviteMembers,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.group_searchUsers,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: _onSearchChanged,
            autofocus: true,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _query.length < 2
              ? Center(
                  child: Text(
                    l10n.group_searchHint,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                )
              : _SearchResults(
                  groupId: widget.groupId,
                  query: _query,
                  scrollController: widget.scrollController,
                ),
        ),
      ],
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({
    required this.groupId,
    required this.query,
    required this.scrollController,
  });

  final String groupId;
  final String query;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final params = InviteSearchParams(query: query, groupId: groupId);
    final resultsAsync = ref.watch(groupInviteSearchProvider(params));

    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
      data: (results) {
        if (results.isEmpty) {
          return Center(child: Text(l10n.group_noUsersFound));
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final user = results[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? Text(user.name[0].toUpperCase())
                      : null,
                ),
                title: Text(user.name),
                subtitle: user.hdType != null ? Text(user.hdType!) : null,
                trailing: FilledButton(
                  onPressed: () async {
                    final success = await ref
                        .read(socialNotifierProvider.notifier)
                        .addMember(groupId: groupId, userId: user.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? l10n.group_memberAdded(user.name)
                              : l10n.group_addMemberFailed),
                        ),
                      );
                      if (success) {
                        // Refresh search to remove the added user
                        ref.invalidate(groupInviteSearchProvider(params));
                      }
                    }
                  },
                  child: Text(l10n.group_invite),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
