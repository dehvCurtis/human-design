import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/error_handler.dart';
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
          error: ErrorHandler.getUserMessage(error, context: 'load feed'),
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
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.read(supabaseClientProvider).auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.auth_signInRequired),
          action: SnackBarAction(
            label: l10n.auth_signIn,
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
            content: Text(ErrorHandler.getUserMessage(e, context: 'share')),
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

    final l10n = AppLocalizations.of(context)!;
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

          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.thought_regenerateSuccess),
              ),
            );
          }
        } catch (e) {
          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ErrorHandler.getUserMessage(e)),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  PostComment? _replyingTo;

  void _setReplyingTo(PostComment? comment) {
    setState(() => _replyingTo = comment);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final postAsync = ref.watch(postProvider(widget.postId));
    final commentsAsync = ref.watch(postCommentsProvider(widget.postId));
    final currentUserId = ref.watch(supabaseClientProvider).auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.thought_postDetail),
      ),
      body: postAsync.when(
        data: (post) {
          if (post == null) {
            return Center(child: Text(l10n.common_error));
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
                        onRegenerate: isOwnPost ? null : () => _handleRegenerate(context, post),
                        onOriginalUserTap: post.originalPost != null
                            ? () => context.pushNamed('userProfile', pathParameters: {'id': post.originalPost!.userId})
                            : null,
                        canRegenerate: !isOwnPost,
                      ),
                      const Divider(),
                      commentsAsync.when(
                        data: (comments) => _CommentsSection(
                          comments: comments,
                          postId: widget.postId,
                          onReply: _setReplyingTo,
                          currentUserId: currentUserId,
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, _) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(ErrorHandler.getUserMessage(e, context: 'load comments')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _CommentInput(
                postId: widget.postId,
                replyingTo: _replyingTo,
                onCancelReply: () => _setReplyingTo(null),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(ErrorHandler.getUserMessage(error))),
      ),
    );
  }

  void _handleRegenerate(BuildContext context, Post post) {
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
                content: Text(ErrorHandler.getUserMessage(e)),
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
    required this.onReply,
    this.currentUserId,
  });

  final List<PostComment> comments;
  final String postId;
  final void Function(PostComment comment) onReply;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          l10n.thought_noComments,
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
          onReply: onReply,
          currentUserId: currentUserId,
        );
      },
    );
  }
}

class _CommentTile extends ConsumerWidget {
  const _CommentTile({
    required this.comment,
    required this.postId,
    required this.onReply,
    this.currentUserId,
  });

  final PostComment comment;
  final String postId;
  final void Function(PostComment comment) onReply;
  final String? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isOwnComment = comment.userId == currentUserId;

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
          GestureDetector(
            onTap: () => context.pushNamed('userProfile', pathParameters: {'id': comment.userId}),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: comment.userAvatarUrl != null
                  ? NetworkImage(comment.userAvatarUrl!)
                  : null,
              child: comment.userAvatarUrl == null
                  ? Text(comment.userName[0].toUpperCase())
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pushNamed('userProfile', pathParameters: {'id': comment.userId}),
                      child: Text(
                        comment.userName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
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
                const SizedBox(height: 4),
                // Action buttons
                Row(
                  children: [
                    // Like button
                    _CommentActionButton(
                      icon: comment.userReaction != null
                          ? Icons.favorite
                          : Icons.favorite_border,
                      isActive: comment.userReaction != null,
                      label: comment.reactionCount > 0 ? '${comment.reactionCount}' : l10n.common_like,
                      onTap: () {
                        ref.read(feedNotifierProvider.notifier).toggleCommentReaction(
                          postId,
                          comment.id,
                          comment.userReaction,
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    // Reply button (only for top-level comments)
                    if (!comment.isReply)
                      _CommentActionButton(
                        icon: Icons.reply,
                        label: l10n.common_reply,
                        onTap: () => onReply(comment),
                      ),
                    const Spacer(),
                    // Delete button (only for own comments)
                    if (isOwnComment)
                      _CommentActionButton(
                        icon: Icons.delete_outline,
                        label: l10n.common_delete,
                        onTap: () => _confirmDelete(context, ref),
                      ),
                  ],
                ),
                if (comment.replies?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  ...comment.replies!.map((reply) => _CommentTile(
                        comment: reply,
                        postId: postId,
                        onReply: onReply,
                        currentUserId: currentUserId,
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.common_delete),
        content: Text(l10n.common_deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(feedNotifierProvider.notifier).deleteComment(postId, comment.id);
            },
            child: Text(l10n.common_delete),
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

class _CommentActionButton extends StatelessWidget {
  const _CommentActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends ConsumerStatefulWidget {
  const _CommentInput({
    required this.postId,
    this.replyingTo,
    this.onCancelReply,
  });

  final String postId;
  final PostComment? replyingTo;
  final VoidCallback? onCancelReply;

  @override
  ConsumerState<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<_CommentInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void didUpdateWidget(covariant _CommentInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Focus the input when replying to someone
    if (widget.replyingTo != null && oldWidget.replyingTo == null) {
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isReplying = widget.replyingTo != null;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reply indicator
            if (isReplying)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.reply,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.thought_replyingTo(widget.replyingTo!.userName),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onCancelReply,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: isReplying
                          ? l10n.thought_writeReply
                          : l10n.thought_addComment,
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
            parentId: widget.replyingTo?.id,
          );
      _controller.clear();
      widget.onCancelReply?.call();
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
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(l10n.common_error, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}
