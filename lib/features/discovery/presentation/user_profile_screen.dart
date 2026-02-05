import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../chart/presentation/widgets/bodygraph/bodygraph_widget.dart';
import '../../feed/domain/feed_providers.dart';
import '../../feed/domain/models/post.dart';
import '../domain/discovery_providers.dart';
import '../domain/models/user_discovery.dart';

/// Provider to fetch a specific user's profile
final userProfileProvider = FutureProvider.family<DiscoveredUser?, String>((ref, userId) async {
  final repository = ref.watch(discoveryRepositoryProvider);
  return repository.getUserProfile(userId);
});

/// Screen to view another user's profile
class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(userProfileProvider(widget.userId));

    return userAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(ErrorHandler.getUserMessage(e))),
      ),
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.discovery_userNotFound)),
          );
        }

        // Initialize follow state from user data
        _isFollowing = user.isFollowing;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Header with user info
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _UserHeader(
                    user: user,
                    onFollowersTap: () => _showFollowersList(context, widget.userId),
                    onFollowingTap: () => _showFollowingList(context, widget.userId),
                  ),
                ),
              ),

              // Follow button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _isFollowing
                                ? OutlinedButton.icon(
                                    onPressed: () => _unfollowUser(user),
                                    icon: const Icon(Icons.check),
                                    label: Text(l10n.discovery_following),
                                  )
                                : FilledButton.icon(
                                    onPressed: () => _followUser(user),
                                    icon: const Icon(Icons.person_add),
                                    label: Text(l10n.discovery_follow),
                                  ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.outlined(
                        onPressed: () => _startConversation(context, widget.userId),
                        icon: const Icon(Icons.message_outlined),
                        tooltip: l10n.discovery_sendMessage,
                      ),
                    ],
                  ),
                ),
              ),

              // Bio section
              if (user.bio != null && user.bio!.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.discovery_about,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(user.bio!),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // HD Info section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.discovery_humanDesign,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (user.hdType != null)
                            _InfoRow(
                              icon: Icons.category_outlined,
                              label: l10n.discovery_type,
                              value: user.hdType!,
                            ),
                          if (user.hdProfile != null) ...[
                            const Divider(height: 16),
                            _InfoRow(
                              icon: Icons.person_outline,
                              label: l10n.discovery_profile,
                              value: user.hdProfile!,
                            ),
                          ],
                          if (user.hdAuthority != null) ...[
                            const Divider(height: 16),
                            _InfoRow(
                              icon: Icons.psychology_outlined,
                              label: l10n.discovery_authority,
                              value: user.hdAuthority!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Thoughts section
              SliverToBoxAdapter(
                child: _ThoughtsSection(userId: widget.userId),
              ),

              // Bodygraph section (with access control)
              SliverToBoxAdapter(
                child: _ChartSection(
                  userId: widget.userId,
                  user: user,
                  isFollowing: _isFollowing,
                ),
              ),

              // Compatibility section (if available)
              if (user.compatibilityScore != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.compare_arrows,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.discovery_compatibility,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: user.compatibilityScore! / 100,
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${user.compatibilityScore!}% ${l10n.discovery_compatible}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _followUser(DiscoveredUser user) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(followNotifierProvider.notifier).toggleFollow(
        widget.userId,
        currentlyFollowing: false,
      );
      setState(() {
        _isFollowing = true;
        _isLoading = false;
      });
      ref.invalidate(userProfileProvider(widget.userId));
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'follow'))),
        );
      }
    }
  }

  Future<void> _unfollowUser(DiscoveredUser user) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(followNotifierProvider.notifier).toggleFollow(
        widget.userId,
        currentlyFollowing: true,
      );
      setState(() {
        _isFollowing = false;
        _isLoading = false;
      });
      ref.invalidate(userProfileProvider(widget.userId));
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'unfollow'))),
        );
      }
    }
  }

  void _startConversation(BuildContext context, String userId) {
    context.push('/messages/user/$userId');
  }

  void _showFollowersList(BuildContext context, String userId) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _FollowListSheet(
          title: l10n.userProfile_followersList,
          userId: userId,
          isFollowers: true,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _showFollowingList(BuildContext context, String userId) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _FollowListSheet(
          title: l10n.userProfile_followingList,
          userId: userId,
          isFollowers: false,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader({
    required this.user,
    required this.onFollowersTap,
    required this.onFollowingTap,
  });

  final DiscoveredUser user;
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 32),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // HD Type badge and Privacy badge
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: [
                if (user.hdType != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      user.hdType!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                // Privacy status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPrivacyIcon(user.chartVisibility),
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getPrivacyLabel(l10n, user.chartVisibility),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats row - now clickable
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onFollowersTap,
                  child: _StatItem(
                    value: user.followerCount.toString(),
                    label: l10n.discovery_followers,
                  ),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: onFollowingTap,
                  child: _StatItem(
                    value: user.followingCount.toString(),
                    label: l10n.discovery_followingLabel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPrivacyIcon(DiscoveredUserChartVisibility visibility) {
    switch (visibility) {
      case DiscoveredUserChartVisibility.public:
        return Icons.public;
      case DiscoveredUserChartVisibility.friends:
        return Icons.people;
      case DiscoveredUserChartVisibility.private:
        return Icons.lock;
    }
  }

  String _getPrivacyLabel(AppLocalizations l10n, DiscoveredUserChartVisibility visibility) {
    switch (visibility) {
      case DiscoveredUserChartVisibility.public:
        return l10n.userProfile_publicProfile;
      case DiscoveredUserChartVisibility.friends:
        return l10n.userProfile_friendsOnlyProfile;
      case DiscoveredUserChartVisibility.private:
        return l10n.userProfile_privateProfile;
    }
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ChartSection extends ConsumerWidget {
  const _ChartSection({
    required this.userId,
    required this.user,
    required this.isFollowing,
  });

  final String userId;
  final DiscoveredUser user;
  final bool isFollowing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final chartAsync = ref.watch(userPublicChartProvider(userId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_graph,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.userProfile_viewChart,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              chartAsync.when(
                data: (chart) {
                  if (chart == null) {
                    // Chart is not visible - show appropriate message
                    return _ChartNotVisibleMessage(
                      visibility: user.chartVisibility,
                      isFollowing: isFollowing,
                      isMutualFollow: user.isMutualFollow,
                    );
                  }
                  // Chart is visible - show bodygraph
                  return SizedBox(
                    height: 350,
                    child: BodygraphWidget(
                      chart: chart,
                      interactive: true,
                      showGateNumbers: true,
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'Failed to load chart',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartNotVisibleMessage extends StatelessWidget {
  const _ChartNotVisibleMessage({
    required this.visibility,
    required this.isFollowing,
    required this.isMutualFollow,
  });

  final DiscoveredUserChartVisibility visibility;
  final bool isFollowing;
  final bool isMutualFollow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String message;
    IconData icon;

    switch (visibility) {
      case DiscoveredUserChartVisibility.private:
        // Private: no one can see except owner
        message = l10n.userProfile_chartPrivate;
        icon = Icons.lock_outlined;
        break;
      case DiscoveredUserChartVisibility.friends:
        // Friends: need mutual follow
        message = l10n.userProfile_chartFriendsOnly;
        icon = Icons.people_outlined;
        break;
      case DiscoveredUserChartVisibility.public:
        // Public: need to follow them to see
        if (!isFollowing) {
          message = l10n.userProfile_chartFollowToView;
          icon = Icons.person_add_outlined;
        } else {
          // Should not happen - if following and public, chart should be visible
          message = 'Chart not available';
          icon = Icons.visibility_off_outlined;
        }
        break;
    }

    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Section showing user's recent thoughts/posts
class _ThoughtsSection extends ConsumerWidget {
  const _ThoughtsSection({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final postsAsync = ref.watch(userPostsProvider(userId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.userProfile_thoughts,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  postsAsync.when(
                    data: (posts) => posts.length > 3
                        ? TextButton(
                            onPressed: () => _showAllPosts(context, userId),
                            child: Text(l10n.userProfile_showAll),
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          l10n.userProfile_noThoughts,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    );
                  }

                  // Show only first 3 posts
                  final displayPosts = posts.take(3).toList();
                  return Column(
                    children: displayPosts.map((post) => _ThoughtTile(post: post)).toList(),
                  );
                },
                loading: () => const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      ErrorHandler.getUserMessage(error),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAllPosts(BuildContext context, String userId) {
    // Navigate to user's posts feed
    context.push('/feed/user/$userId');
  }
}

/// Single thought/post tile for the profile
class _ThoughtTile extends StatelessWidget {
  const _ThoughtTile({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.favorite_outline,
                size: 14,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.reactionCount}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chat_bubble_outline,
                size: 14,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.commentCount}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(post.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m';
      }
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    }
    return '${date.month}/${date.day}';
  }
}

/// Bottom sheet showing followers or following list
class _FollowListSheet extends ConsumerWidget {
  const _FollowListSheet({
    required this.title,
    required this.userId,
    required this.isFollowers,
    required this.scrollController,
  });

  final String title;
  final String userId;
  final bool isFollowers;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final usersAsync = isFollowers
        ? ref.watch(userFollowersProvider(userId))
        : ref.watch(userFollowingProvider(userId));

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // List
        Expanded(
          child: usersAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFollowers ? Icons.people_outline : Icons.person_search,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isFollowers
                            ? l10n.userProfile_noFollowers
                            : l10n.userProfile_noFollowing,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
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
                    trailing: user.isFollowing
                        ? const Chip(
                            label: Text('Following'),
                            visualDensity: VisualDensity.compact,
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/user/${user.id}');
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(ErrorHandler.getUserMessage(error)),
            ),
          ),
        ),
      ],
    );
  }
}
