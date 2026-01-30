import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../home/domain/home_providers.dart';
import '../../profile/data/profile_repository.dart';
import '../data/social_repository.dart';
import '../domain/social_providers.dart';

class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingRequests = ref.watch(pendingRequestsProvider);
    final pendingCount = pendingRequests.when(
      data: (list) => list.length,
      loading: () => 0,
      error: (_, _) => 0,
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.social_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.dynamic_feed_outlined),
            onPressed: () => context.push(AppRoutes.feed),
            tooltip: 'Feed',
          ),
          IconButton(
            icon: const Icon(Icons.explore_outlined),
            onPressed: () => context.push(AppRoutes.discover),
            tooltip: 'Discover',
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.push(AppRoutes.messages),
            tooltip: 'Messages',
          ),
          if (pendingCount > 0)
            Badge(
              label: Text('$pendingCount'),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _showPendingRequestsDialog(context),
                tooltip: l10n.social_pendingRequests,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () => _showAddFriendDialog(context, ref),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.social_friends),
            Tab(text: l10n.social_groups),
            Tab(text: l10n.social_shared),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FriendsTab(onAddFriend: () => _showAddFriendDialog(context, ref)),
          _GroupsTab(onCreateGroup: () => _showCreateGroupDialog(context, ref)),
          const _SharedTab(),
        ],
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    UserSearchResult? foundUser;
    bool isSearching = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.social_addFriend),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.social_addFriendPrompt),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: l10n.social_emailLabel,
                  hintText: l10n.social_emailHint,
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            final email = emailController.text.trim();
                            if (email.isEmpty) return;

                            setDialogState(() {
                              isSearching = true;
                              errorMessage = null;
                              foundUser = null;
                            });

                            final result = await ref
                                .read(profileRepositoryProvider)
                                .findUserByEmail(email);

                            setDialogState(() {
                              isSearching = false;
                              foundUser = result;
                              if (result == null) {
                                errorMessage = l10n.social_userNotFound;
                              }
                            });
                          },
                        ),
                  errorText: errorMessage,
                ),
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) async {
                  final email = emailController.text.trim();
                  if (email.isEmpty) return;

                  setDialogState(() {
                    isSearching = true;
                    errorMessage = null;
                    foundUser = null;
                  });

                  final result = await ref
                      .read(profileRepositoryProvider)
                      .findUserByEmail(email);

                  setDialogState(() {
                    isSearching = false;
                    foundUser = result;
                    if (result == null) {
                      errorMessage = l10n.social_userNotFound;
                    }
                  });
                },
              ),
              if (foundUser != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: AppColors.success.withAlpha(25),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: foundUser!.avatarUrl != null
                          ? NetworkImage(foundUser!.avatarUrl!)
                          : null,
                      child: foundUser!.avatarUrl == null
                          ? Text(foundUser!.displayName[0].toUpperCase())
                          : null,
                    ),
                    title: Text(foundUser!.displayName),
                    subtitle: Text(foundUser!.email),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.common_cancel),
            ),
            ElevatedButton(
              onPressed: foundUser == null
                  ? null
                  : () async {
                      await ref
                          .read(socialNotifierProvider.notifier)
                          .sendFriendRequest(foundUser!.id);

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.social_requestSent(foundUser!.displayName),
                            ),
                          ),
                        );
                      }
                    },
              child: Text(l10n.social_sendRequest),
            ),
          ],
        ),
      ),
    );
  }

  void _showPendingRequestsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.25,
        maxChildSize: 0.75,
        expand: false,
        builder: (context, scrollController) => Consumer(
          builder: (context, ref, _) {
            final requests = ref.watch(pendingRequestsProvider);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.social_friendRequests,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: requests.when(
                    data: (list) {
                      if (list.isEmpty) {
                        return Center(
                          child: Text(l10n.social_noPendingRequests),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final request = list[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: request.requesterAvatarUrl != null
                                  ? NetworkImage(request.requesterAvatarUrl!)
                                  : null,
                              child: request.requesterAvatarUrl == null
                                  ? Text(request.requesterName[0].toUpperCase())
                                  : null,
                            ),
                            title: Text(request.requesterName),
                            subtitle: Text(
                              l10n.social_sentAgo(_formatDate(request.createdAt, l10n)),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(socialNotifierProvider.notifier)
                                        .declineFriendRequest(request.id);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: AppColors.success,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(socialNotifierProvider.notifier)
                                        .acceptFriendRequest(request.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.social_createGroup),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.social_createGroupPrompt),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.social_groupName,
                hintText: l10n.social_groupNameHint,
                prefixIcon: const Icon(Icons.group_outlined),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: l10n.social_groupDescription,
                hintText: l10n.social_groupDescriptionHint,
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final group = await ref
                  .read(socialNotifierProvider.notifier)
                  .createGroup(
                    name: name,
                    description: descriptionController.text.trim().isNotEmpty
                        ? descriptionController.text.trim()
                        : null,
                  );

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
                if (group != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.social_groupCreated(group.name))),
                  );
                }
              }
            },
            child: Text(l10n.common_create),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return l10n.time_minutesAgo(diff.inMinutes);
      }
      return l10n.time_hoursAgo(diff.inHours);
    } else if (diff.inDays < 7) {
      return l10n.time_daysAgo(diff.inDays);
    }
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab({required this.onAddFriend});

  final VoidCallback onAddFriend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    final l10n = AppLocalizations.of(context)!;

    return friendsAsync.when(
      data: (friends) {
        if (friends.isEmpty) {
          return _EmptyState(
            icon: Icons.people_outline,
            title: l10n.social_noFriendsYet,
            message: l10n.social_noFriendsMessage,
            actionLabel: l10n.social_addFriend,
            onAction: onAddFriend,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(friendsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return _FriendCard(
                friend: friend,
                onTap: () {
                  // Navigate to friend's profile
                  context.push('/user/${friend.friendId}');
                },
                onCompare: () {
                  // Navigate to composite chart
                  context.push(AppRoutes.composite);
                },
              );
            },
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
            Text('${l10n.social_loadFriendsFailed}: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(friendsProvider),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupsTab extends ConsumerWidget {
  const _GroupsTab({required this.onCreateGroup});

  final VoidCallback onCreateGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);
    final l10n = AppLocalizations.of(context)!;

    return groupsAsync.when(
      data: (groups) {
        if (groups.isEmpty) {
          return _EmptyState(
            icon: Icons.groups_outlined,
            title: l10n.social_noGroupsYet,
            message: l10n.social_noGroupsMessage,
            actionLabel: l10n.social_createGroup,
            onAction: onCreateGroup,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(groupsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return _GroupCard(
                group: group,
                onTap: () {
                  // Navigate to group penta analysis
                  context.push(AppRoutes.penta);
                },
              );
            },
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
            Text('${l10n.social_loadGroupsFailed}: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(groupsProvider),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _SharedTab extends ConsumerWidget {
  const _SharedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedAsync = ref.watch(sharedChartsProvider);
    final l10n = AppLocalizations.of(context)!;

    return sharedAsync.when(
      data: (sharedCharts) {
        if (sharedCharts.isEmpty) {
          return _EmptyState(
            icon: Icons.share_outlined,
            title: l10n.social_noSharedCharts,
            message: l10n.social_noSharedChartsMessage,
            actionLabel: null,
            onAction: null,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(sharedChartsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sharedCharts.length,
            itemBuilder: (context, index) {
              final shared = sharedCharts[index];
              return _SharedChartCard(
                sharedChart: shared,
                onTap: () {
                  // Navigate to view shared chart
                  context.push('${AppRoutes.chart}/${shared.chartId}');
                },
              );
            },
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
            Text('${l10n.social_loadSharedFailed}: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(sharedChartsProvider),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FriendCard extends StatelessWidget {
  const _FriendCard({
    required this.friend,
    required this.onTap,
    required this.onCompare,
  });

  final Friend friend;
  final VoidCallback onTap;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withAlpha(25),
          backgroundImage: friend.avatarUrl != null
              ? NetworkImage(friend.avatarUrl!)
              : null,
          child: friend.avatarUrl == null
              ? Text(
                  friend.name[0].toUpperCase(),
                  style: const TextStyle(color: AppColors.primary),
                )
              : null,
        ),
        title: Text(friend.name),
        subtitle: Text(
          l10n.social_friendsSince(_formatDate(friend.createdAt)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.compare_arrows),
              onPressed: onCompare,
              tooltip: l10n.social_compareCharts,
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.onTap,
  });

  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.secondary.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: group.avatarUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(group.avatarUrl!, fit: BoxFit.cover),
                )
              : const Icon(Icons.groups, color: AppColors.secondary),
        ),
        title: Text(group.name),
        subtitle: Text(group.description ?? l10n.social_noDescription),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (group.isAdmin)
              Chip(
                label: Text(l10n.social_admin),
                visualDensity: VisualDensity.compact,
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _SharedChartCard extends StatelessWidget {
  const _SharedChartCard({
    required this.sharedChart,
    required this.onTap,
  });

  final SharedChart sharedChart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.accent.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.auto_graph, color: AppColors.accent),
        ),
        title: Text(sharedChart.chartName),
        subtitle: Text(l10n.social_sharedBy(sharedChart.sharedByName)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
