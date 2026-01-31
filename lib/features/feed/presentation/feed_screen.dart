import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../domain/feed_providers.dart';
import '../domain/models/post.dart';
import 'widgets/post_card.dart';
import 'widgets/create_post_sheet.dart';
import 'widgets/regenerate_dialog.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final feedAsync = ref.watch(feedProvider);
    final currentUserId = ref.watch(supabaseClientProvider).auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.thought_feedTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: feedAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return _EmptyFeed(onCreatePost: () => _showCreatePostSheet(context));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(feedProvider);
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final isOwnPost = post.userId == currentUserId;

                return PostCard(
                  post: post,
                  onTap: () => _navigateToPost(context, post),
                  onReaction: (type) => _handleReaction(post, type),
                  onComment: () => _navigateToPost(context, post),
                  onShare: () => _sharePost(post),
                  onUserTap: () => _navigateToUserProfile(post.userId),
                  onRegenerate: isOwnPost ? null : () => _handleRegenerate(context, post),
                  onOriginalUserTap: post.originalPost != null
                      ? () => _navigateToUserProfile(post.originalPost!.userId)
                      : null,
                  canRegenerate: !isOwnPost,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorView(
          error: error.toString(),
          onRetry: () => ref.invalidate(feedProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostSheet(context),
        tooltip: l10n.thought_createNew,
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showCreatePostSheet(BuildContext context) {
    final currentUser = ref.read(supabaseClientProvider).auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please sign in to create posts'),
          action: SnackBarAction(
            label: 'Sign In',
            onPressed: () => context.go(AppRoutes.signIn),
          ),
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreatePostSheet(),
    );
  }

  void _navigateToPost(BuildContext context, Post post) {
    context.pushNamed('postDetail', pathParameters: {'id': post.id});
  }

  void _handleReaction(Post post, ReactionType type) {
    ref.read(feedNotifierProvider.notifier).reactToPost(post.id, type);
  }

  void _sharePost(Post post) async {
    // Generate a deep link to the post
    // Format: humandesign://post/{postId} or https://app.humandesign.com/post/{postId}
    final deepLink = '${AppConfig.appUrl}/post/${post.id}';

    // Create share text with post preview
    final shareText = '''
${post.userName} shared on Human Design App:

"${post.content.length > 200 ? '${post.content.substring(0, 200)}...' : post.content}"

View the full post: $deepLink
''';

    try {
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'Human Design Post by ${post.userName}',
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _navigateToUserProfile(String userId) {
    context.pushNamed('userProfile', pathParameters: {'id': userId});
  }

  void _handleRegenerate(BuildContext context, Post post) {
    // Check if this is the user's own post (they can't regenerate their own)
    final currentUserId = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (post.userId == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.thought_cannotRegenerateOwn),
        ),
      );
      return;
    }

    showRegenerateDialog(
      context: context,
      originalPost: post,
      onConfirm: ({String? comment, PostVisibility visibility = PostVisibility.public}) async {
        try {
          await ref.read(feedNotifierProvider.notifier).regeneratePost(
            originalPostId: post.id,
            additionalComment: comment,
            visibility: visibility,
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.thought_regenerateSuccess),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}

class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final postAsync = ref.watch(postProvider(postId));
    final commentsAsync = ref.watch(postCommentsProvider(postId));
    final currentUserId = ref.watch(supabaseClientProvider).auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.thought_postDetail),
      ),
      body: postAsync.when(
        data: (post) {
          if (post == null) {
            return const Center(child: Text('Post not found'));
          }

          final isOwnPost = post.userId == currentUserId;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PostCard(
                        post: post,
                        showFullContent: true,
                        onTap: () {},
                        onReaction: (type) {
                          ref.read(feedNotifierProvider.notifier)
                              .reactToPost(post.id, type);
                        },
                        onComment: () {},
                        onShare: () {},
                        onUserTap: () => context.pushNamed('userProfile', pathParameters: {'id': post.userId}),
                        onRegenerate: isOwnPost ? null : () => _handleRegenerate(context, ref, post),
                        onOriginalUserTap: post.originalPost != null
                            ? () => context.pushNamed('userProfile', pathParameters: {'id': post.originalPost!.userId})
                            : null,
                        canRegenerate: !isOwnPost,
                      ),
                      const Divider(),
                      commentsAsync.when(
                        data: (comments) => _CommentsSection(
                          comments: comments,
                          postId: postId,
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, _) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Error loading comments: $e'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _CommentInput(postId: postId),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _handleRegenerate(BuildContext context, WidgetRef ref, Post post) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = ref.read(supabaseClientProvider).auth.currentUser?.id;

    if (post.userId == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.thought_cannotRegenerateOwn)),
      );
      return;
    }

    showRegenerateDialog(
      context: context,
      originalPost: post,
      onConfirm: ({String? comment, PostVisibility visibility = PostVisibility.public}) async {
        try {
          await ref.read(feedNotifierProvider.notifier).regeneratePost(
            originalPostId: post.id,
            additionalComment: comment,
            visibility: visibility,
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.thought_regenerateSuccess)),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}

class _CommentsSection extends StatelessWidget {
  const _CommentsSection({
    required this.comments,
    required this.postId,
  });

  final List<PostComment> comments;
  final String postId;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No comments yet. Be the first to comment!',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return _CommentTile(
          comment: comments[index],
          postId: postId,
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.postId,
  });

  final PostComment comment;
  final String postId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: comment.isReply ? 48 : 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: comment.userAvatarUrl != null
                ? NetworkImage(comment.userAvatarUrl!)
                : null,
            child: comment.userAvatarUrl == null
                ? Text(comment.userName[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimeAgo(comment.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.content),
                if (comment.replies?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  ...comment.replies!.map((reply) => _CommentTile(
                        comment: reply,
                        postId: postId,
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dateTime.day}/${dateTime.month}';
  }
}

class _CommentInput extends ConsumerStatefulWidget {
  const _CommentInput({required this.postId});

  final String postId;

  @override
  ConsumerState<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<_CommentInput> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                maxLines: 3,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitComment(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              onPressed: _isSubmitting ? null : _submitComment,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitComment() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(feedNotifierProvider.notifier).addComment(
            postId: widget.postId,
            content: content,
          );
      _controller.clear();
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed({required this.onCreatePost});

  final VoidCallback onCreatePost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dynamic_feed_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.thought_emptyFeed,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.thought_emptyFeedMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreatePost,
              icon: const Icon(Icons.edit),
              label: Text(l10n.thought_createNew),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading feed', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
