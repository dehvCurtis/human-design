import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/constants/human_design_constants.dart';
import '../domain/feed_providers.dart';
import '../domain/models/post.dart';
import 'widgets/post_card.dart';

/// Provider for posts filtered by gate number
final gatePostsProvider = FutureProvider.family<List<Post>, int>((ref, gateNumber) async {
  final repository = ref.watch(feedRepositoryProvider);
  // Get all public posts and filter by gate number
  final allPosts = await repository.getFeed(limit: 100);
  return allPosts.where((post) => post.gateNumber == gateNumber).toList();
});

/// Screen showing posts related to a specific gate
class GateFeedScreen extends ConsumerWidget {
  const GateFeedScreen({
    super.key,
    required this.gateNumber,
  });

  final int gateNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final postsAsync = ref.watch(gatePostsProvider(gateNumber));

    // Get gate info from constants
    final gateInfo = gates[gateNumber];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feed_gateTitle(gateNumber)),
      ),
      body: Column(
        children: [
          // Gate info header
          if (gateInfo != null)
            _GateHeader(
              gateNumber: gateNumber,
              gateInfo: gateInfo,
            ),

          // Posts
          Expanded(
            child: postsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return _EmptyGateFeed(gateNumber: gateNumber);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(gatePostsProvider(gateNumber));
                  },
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostCard(
                        post: post,
                        onTap: () => context.push('/feed/post/${post.id}'),
                        onReaction: (type) {
                          ref.read(feedNotifierProvider.notifier).reactToPost(post.id, type);
                        },
                        onComment: () => context.push('/feed/post/${post.id}'),
                        onShare: () {},
                        onUserTap: () {},
                        onHashtagTap: (hashtag) => context.push('/hashtag/$hashtag'),
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
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(gatePostsProvider(gateNumber)),
                      child: Text(l10n.common_retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Open create post with this gate pre-selected
          _showCreatePostForGate(context, gateNumber);
        },
        icon: const Icon(Icons.add),
        label: const Text('Share about this gate'),
      ),
    );
  }

  void _showCreatePostForGate(BuildContext context, int gateNumber) {
    // This would open the create post sheet with the gate pre-selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Create post about Gate $gateNumber')),
    );
  }
}

class _GateHeader extends StatelessWidget {
  const _GateHeader({
    required this.gateNumber,
    required this.gateInfo,
  });

  final int gateNumber;
  final GateData gateInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = gateInfo.name;
    final keyword = gateInfo.keynote;
    final description = '${gateInfo.center.displayName} Center';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gate number circle
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
            ),
            child: Center(
              child: Text(
                '$gateNumber',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Gate info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (keyword.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      keyword,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyGateFeed extends StatelessWidget {
  const _EmptyGateFeed({required this.gateNumber});

  final int gateNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerHigh,
              ),
              child: Center(
                child: Text(
                  '$gateNumber',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No posts about Gate $gateNumber yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your insights and experiences with this gate!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
