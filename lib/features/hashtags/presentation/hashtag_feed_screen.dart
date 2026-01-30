import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../feed/presentation/widgets/post_card.dart';
import '../../feed/domain/feed_providers.dart';
import '../domain/hashtag_providers.dart';
import '../domain/models/hashtag.dart';

/// Screen showing posts for a specific hashtag
class HashtagFeedScreen extends ConsumerWidget {
  const HashtagFeedScreen({
    super.key,
    required this.hashtag,
  });

  final String hashtag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hashtagData = ref.watch(hashtagProvider(hashtag));
    final postsAsync = ref.watch(hashtagPostsProvider(hashtag));

    return Scaffold(
      appBar: AppBar(
        title: Text('#$hashtag'),
        actions: [
          // Show HD badge if this is an HD hashtag
          hashtagData.when(
            data: (data) {
              if (data?.isHdHashtag == true) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_graph,
                        size: 14,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'HD',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Hashtag info header
          hashtagData.when(
            data: (data) {
              if (data == null) return const SizedBox.shrink();
              return _HashtagHeader(hashtag: data);
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Posts
          Expanded(
            child: postsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tag,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.hashtag_noPosts,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.hashtag_beFirst,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(hashtagPostsProvider(hashtag));
                  },
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostCard(
                        post: post,
                        onTap: () {
                          // Navigate to post detail
                          context.push('/feed/post/${post.id}');
                        },
                        onReaction: (type) {
                          ref.read(feedNotifierProvider.notifier).reactToPost(post.id, type);
                        },
                        onComment: () {
                          context.push('/feed/post/${post.id}');
                        },
                        onShare: () {
                          // Handle share
                        },
                        onUserTap: () {
                          // Navigate to user profile
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
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(hashtagPostsProvider(hashtag));
                      },
                      child: Text(l10n.common_retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HashtagHeader extends StatelessWidget {
  const _HashtagHeader({required this.hashtag});

  final Hashtag hashtag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _getCategoryColor(hashtag.hdCategory).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '#',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _getCategoryColor(hashtag.hdCategory),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${hashtag.name}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      l10n.hashtag_postCount(hashtag.postCount),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    if (hashtag.hdCategory != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(hashtag.hdCategory).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hashtag.hdCategory!.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getCategoryColor(hashtag.hdCategory),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(HashtagCategory? category) {
    switch (category) {
      case HashtagCategory.gate:
        return Colors.amber;
      case HashtagCategory.channel:
        return Colors.purple;
      case HashtagCategory.type:
        return Colors.blue;
      case HashtagCategory.authority:
        return Colors.green;
      case HashtagCategory.profile:
        return Colors.orange;
      case HashtagCategory.center:
        return Colors.teal;
      case null:
        return Colors.grey;
    }
  }
}
