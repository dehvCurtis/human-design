import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/feed_providers.dart';
import '../domain/models/post.dart';

/// Provider for posts related to a specific channel
final channelPostsProvider = FutureProvider.family<List<Post>, ({int gate1, int gate2})>(
  (ref, params) async {
    final repository = ref.watch(feedRepositoryProvider);
    return repository.getPostsByChannel(
      gate1: params.gate1,
      gate2: params.gate2,
    );
  },
);

/// Screen showing a feed of posts related to a specific HD channel
class ChannelDiscussionScreen extends ConsumerWidget {
  const ChannelDiscussionScreen({
    super.key,
    required this.gate1,
    required this.gate2,
  });

  final int gate1;
  final int gate2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (gate1: gate1, gate2: gate2);
    final postsAsync = ref.watch(channelPostsProvider(params));
    final l10n = AppLocalizations.of(context)!;
    final gate1Info = gates[gate1];
    final gate2Info = gates[gate2];

    return Scaffold(
      appBar: AppBar(
        title: Text('Channel $gate1-$gate2'),
      ),
      body: Column(
        children: [
          // Channel info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withValues(alpha: 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${gate1Info?.name ?? 'Gate $gate1'} — ${gate2Info?.name ?? 'Gate $gate2'}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Connects ${gate1Info?.center.displayName ?? 'Unknown'} to ${gate2Info?.center.displayName ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),

          // Posts
          Expanded(
            child: postsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 64,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No posts about this channel yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Share your experience with Channel $gate1-$gate2!',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(channelPostsProvider(params)),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: posts.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _PostTile(post: post);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(l10n.error_generic),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(channelPostsProvider(params)),
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

class _PostTile extends StatelessWidget {
  const _PostTile({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: post.userAvatarUrl != null
                    ? NetworkImage(post.userAvatarUrl!)
                    : null,
                child: post.userAvatarUrl == null
                    ? const Icon(Icons.person, size: 16)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.userName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
