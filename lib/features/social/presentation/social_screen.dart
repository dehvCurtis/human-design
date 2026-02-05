import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus;

import '../../../core/router/app_router.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../discovery/domain/discovery_providers.dart';
import '../../discovery/domain/models/user_discovery.dart';
import '../../feed/domain/feed_providers.dart';
import '../../feed/presentation/widgets/post_card.dart';
import '../../feed/presentation/widgets/create_post_sheet.dart';
import '../../../shared/providers/supabase_provider.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.social_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.push(AppRoutes.messages),
            tooltip: 'Messages',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l10n.social_thoughts),
            Tab(text: l10n.social_discover),
            Tab(text: l10n.social_groups),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const _ThoughtsTab(),
          const _DiscoverTab(),
          _GroupsTab(onCreateGroup: () => _showCreateGroupDialog(context, ref)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreatePostSheet(),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    bool isCreating = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                enabled: !isCreating,
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
                enabled: !isCreating,
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isCreating ? null : () => Navigator.pop(dialogContext),
              child: Text(l10n.common_cancel),
            ),
            ElevatedButton(
              onPressed: isCreating
                  ? null
                  : () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        setDialogState(() {
                          errorMessage = l10n.social_groupNameRequired;
                        });
                        return;
                      }

                      setDialogState(() {
                        isCreating = true;
                        errorMessage = null;
                      });

                      final group = await ref
                          .read(socialNotifierProvider.notifier)
                          .createGroup(
                            name: name,
                            description: descriptionController.text.trim().isNotEmpty
                                ? descriptionController.text.trim()
                                : null,
                          );

                      // Check for error from notifier
                      final socialState = ref.read(socialNotifierProvider);

                      if (dialogContext.mounted) {
                        if (group != null) {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.social_groupCreated(group.name))),
                          );
                        } else {
                          setDialogState(() {
                            isCreating = false;
                            errorMessage = socialState.error ?? l10n.social_createGroupFailed;
                          });
                        }
                      }
                    },
              child: isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.common_create),
            ),
          ],
        ),
      ),
    );
  }

}

/// Tab showing the social feed (Thoughts)
class _ThoughtsTab extends ConsumerWidget {
  const _ThoughtsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedProvider);
    final currentUserId = ref.watch(currentUserIdProvider);
    final l10n = AppLocalizations.of(context)!;

    return postsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return _EmptyState(
            icon: Icons.chat_bubble_outline,
            title: l10n.social_noThoughtsYet,
            message: l10n.social_noThoughtsMessage,
            actionLabel: null,
            onAction: null,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(feedProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final isOwnPost = currentUserId != null && post.userId == currentUserId;
              return PostCard(
                post: post,
                isOwnPost: isOwnPost,
                onTap: () => context.push('/feed/post/${post.id}'),
                onUserTap: () => context.push('/user/${post.userId}'),
                onReaction: (reaction) {
                  ref.read(feedNotifierProvider.notifier).reactToPost(
                    post.id,
                    reaction,
                  );
                },
                onComment: () => context.push('/feed/post/${post.id}'),
                onShare: () {
                  SharePlus.instance.share(
                    ShareParams(text: 'Check out this thought on Human Design:\n\n"${post.content}"\n\n- ${post.userName}'),
                  );
                },
                onRegenerate: isOwnPost ? null : () async {
                  try {
                    await ref.read(feedNotifierProvider.notifier).regeneratePost(
                      originalPostId: post.id,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post regenerated to your wall!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to regenerate: $e')),
                      );
                    }
                  }
                },
                onDelete: isOwnPost ? () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Post'),
                      content: const Text('Are you sure you want to delete this post?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref.read(feedNotifierProvider.notifier).deletePost(post.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post deleted')),
                      );
                    }
                  }
                } : null,
                onReport: !isOwnPost ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post reported. Thank you for helping keep our community safe.')),
                  );
                } : null,
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
            Text(ErrorHandler.getUserMessage(error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(feedProvider),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab showing user discovery
class _DiscoverTab extends ConsumerWidget {
  const _DiscoverTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(discoveredUsersProvider);
    final l10n = AppLocalizations.of(context)!;

    return usersAsync.when(
      data: (result) {
        if (result.users.isEmpty) {
          return _EmptyState(
            icon: Icons.explore_outlined,
            title: l10n.discovery_noResults,
            message: l10n.discovery_noResultsMessage,
            actionLabel: null,
            onAction: null,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(discoveredUsersProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: result.users.length,
            itemBuilder: (context, index) {
              final user = result.users[index];
              return _DiscoverUserCard(
                user: user,
                onTap: () => context.push('/user/${user.id}'),
                onFollow: () {
                  ref.read(followNotifierProvider.notifier).toggleFollow(
                    user.id,
                    currentlyFollowing: user.isFollowing,
                  );
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
            Text(ErrorHandler.getUserMessage(error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(discoveredUsersProvider),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card for discovered user in Discover tab
class _DiscoverUserCard extends StatelessWidget {
  const _DiscoverUserCard({
    required this.user,
    required this.onTap,
    required this.onFollow,
  });

  final DiscoveredUser user;
  final VoidCallback onTap;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withAlpha(25),
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(color: AppColors.primary),
                )
              : null,
        ),
        title: Text(user.name),
        subtitle: user.hdType != null
            ? Text(user.hdType!)
            : null,
        trailing: user.isFollowing
            ? OutlinedButton(
                onPressed: onFollow,
                child: Text(l10n.discovery_following),
              )
            : FilledButton(
                onPressed: onFollow,
                child: Text(l10n.discovery_follow),
              ),
        onTap: onTap,
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
            Text(l10n.social_loadGroupsFailed),
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
