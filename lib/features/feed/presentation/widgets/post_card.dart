import 'package:flutter/material.dart';

import '../../../../core/utils/url_validator.dart';
import '../../../hashtags/presentation/widgets/hashtag_text.dart';
import '../../domain/models/post.dart';
import 'reaction_bar.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onReaction,
    required this.onComment,
    required this.onShare,
    required this.onUserTap,
    this.onHashtagTap,
    this.onRegenerate,
    this.onOriginalUserTap,
    this.showFullContent = false,
    this.canRegenerate = true,
  });

  final Post post;
  final VoidCallback onTap;
  final void Function(ReactionType) onReaction;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onUserTap;
  final void Function(String hashtag)? onHashtagTap;
  final VoidCallback? onRegenerate;
  final VoidCallback? onOriginalUserTap;
  final bool showFullContent;
  final bool canRegenerate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final originalPost = post.originalPost;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Regenerate header (if this is a regenerated post)
              if (post.isRegenerate && originalPost != null) ...[
                _RegenerateHeader(
                  originalUserName: originalPost.userName,
                  onOriginalUserTap: onOriginalUserTap,
                ),
                const SizedBox(height: 8),
              ],

              // Header
              _PostHeader(
                userName: post.userName,
                userAvatarUrl: post.userAvatarUrl,
                userHdType: post.userHdType,
                postType: post.postType,
                createdAt: post.createdAt,
                onUserTap: onUserTap,
              ),

              const SizedBox(height: 12),

              // User's additional comment (for regenerated posts)
              if (post.isRegenerate && post.content.isNotEmpty) ...[
                if (onHashtagTap != null)
                  HashtagText(
                    text: post.content,
                    onHashtagTap: onHashtagTap!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: showFullContent ? null : 3,
                    overflow: showFullContent ? null : TextOverflow.ellipsis,
                  )
                else
                  Text(
                    post.content,
                    style: theme.textTheme.bodyMedium,
                    maxLines: showFullContent ? null : 3,
                    overflow: showFullContent ? null : TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),
              ],

              // Original post content (quoted style for regenerated posts)
              if (post.isRegenerate && originalPost != null) ...[
                _QuotedOriginalPost(
                  originalPost: originalPost,
                  showFullContent: showFullContent,
                  onHashtagTap: onHashtagTap,
                  onOriginalUserTap: onOriginalUserTap,
                ),
              ] else ...[
                // Regular content with tappable hashtags
                if (onHashtagTap != null)
                  HashtagText(
                    text: post.content,
                    onHashtagTap: onHashtagTap!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: showFullContent ? null : 5,
                    overflow: showFullContent ? null : TextOverflow.ellipsis,
                  )
                else
                  Text(
                    post.content,
                    style: theme.textTheme.bodyMedium,
                    maxLines: showFullContent ? null : 5,
                    overflow: showFullContent ? null : TextOverflow.ellipsis,
                  ),

                // Gate/Channel tag
                if (post.gateNumber != null || post.channelId != null) ...[
                  const SizedBox(height: 12),
                  _PostTag(
                    gateNumber: post.gateNumber,
                    channelId: post.channelId,
                  ),
                ],

                // Media
                if (post.mediaUrls?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  _PostMedia(mediaUrls: post.mediaUrls!),
                ],
              ],

              const SizedBox(height: 12),

              // Stats
              _PostStats(
                reactionCount: post.reactionCount,
                commentCount: post.commentCount,
                shareCount: post.shareCount,
                regenerateCount: post.regenerateCount,
              ),

              const Divider(height: 24),

              // Actions
              _PostActionBar(
                currentReaction: post.userReaction,
                onReaction: onReaction,
                onComment: onComment,
                onShare: onShare,
                onRegenerate: onRegenerate,
                canRegenerate: canRegenerate,
                isRegenerate: post.isRegenerate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.userName,
    this.userAvatarUrl,
    this.userHdType,
    required this.postType,
    required this.createdAt,
    required this.onUserTap,
  });

  final String userName;
  final String? userAvatarUrl;
  final String? userHdType;
  final PostType postType;
  final DateTime createdAt;
  final VoidCallback onUserTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(userHdType);

    return Row(
      children: [
        // Avatar
        GestureDetector(
          onTap: onUserTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: typeColor, width: 2),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundImage:
                  userAvatarUrl != null ? NetworkImage(userAvatarUrl!) : null,
              child: userAvatarUrl == null
                  ? Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?')
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Name and metadata
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: onUserTap,
                      child: Text(
                        userName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (userHdType != null) ...[
                    const SizedBox(width: 8),
                    _TypeBadge(type: userHdType!),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  _PostTypeBadge(postType: postType),
                  const SizedBox(width: 8),
                  Text(
                    _formatTimeAgo(createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Menu
        IconButton(
          icon: const Icon(Icons.more_vert, size: 20),
          onPressed: () {
            // Show post menu
          },
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';
    return '${dateTime.day}/${dateTime.month}';
  }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'Generator':
        return Colors.orange;
      case 'Manifesting Generator':
        return Colors.deepOrange;
      case 'Projector':
        return Colors.blue;
      case 'Manifestor':
        return Colors.red;
      case 'Reflector':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(type);
    final shortType = type == 'Manifesting Generator' ? 'MG' : type;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        shortType,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Generator':
        return Colors.orange;
      case 'Manifesting Generator':
        return Colors.deepOrange;
      case 'Projector':
        return Colors.blue;
      case 'Manifestor':
        return Colors.red;
      case 'Reflector':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _PostTypeBadge extends StatelessWidget {
  const _PostTypeBadge({required this.postType});

  final PostType postType;

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = _getPostTypeInfo(postType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String, Color) _getPostTypeInfo(PostType type) {
    switch (type) {
      case PostType.insight:
        return (Icons.lightbulb_outline, 'Insight', Colors.amber);
      case PostType.reflection:
        return (Icons.psychology_outlined, 'Reflection', Colors.purple);
      case PostType.transitShare:
        return (Icons.autorenew, 'Transit', Colors.cyan);
      case PostType.chartShare:
        return (Icons.pie_chart_outline, 'Chart', Colors.indigo);
      case PostType.question:
        return (Icons.help_outline, 'Question', Colors.teal);
      case PostType.achievement:
        return (Icons.emoji_events_outlined, 'Achievement', Colors.orange);
      case PostType.regenerate:
        return (Icons.repeat, 'Regenerate', Colors.green);
    }
  }
}

class _PostTag extends StatelessWidget {
  const _PostTag({
    this.gateNumber,
    this.channelId,
  });

  final int? gateNumber;
  final String? channelId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      children: [
        if (gateNumber != null)
          Chip(
            label: Text('Gate $gateNumber'),
            labelStyle: const TextStyle(fontSize: 12),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            backgroundColor: theme.colorScheme.secondaryContainer,
          ),
        if (channelId != null)
          Chip(
            label: Text('Channel $channelId'),
            labelStyle: const TextStyle(fontSize: 12),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            backgroundColor: theme.colorScheme.tertiaryContainer,
          ),
      ],
    );
  }
}

class _PostMedia extends StatelessWidget {
  const _PostMedia({required this.mediaUrls});

  final List<String> mediaUrls;

  @override
  Widget build(BuildContext context) {
    // Filter URLs to only allow trusted domains (SSRF prevention)
    final validUrls = mediaUrls.where((url) => UrlValidator.isAllowedImageUrl(url)).toList();

    if (validUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    if (validUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          validUrls.first,
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
          errorBuilder: (_, _, _) => _buildErrorPlaceholder(context),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: validUrls.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              validUrls[index],
              fit: BoxFit.cover,
              width: 200,
              errorBuilder: (_, _, _) => _buildErrorPlaceholder(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

class _PostStats extends StatelessWidget {
  const _PostStats({
    required this.reactionCount,
    required this.commentCount,
    required this.shareCount,
    this.regenerateCount = 0,
  });

  final int reactionCount;
  final int commentCount;
  final int shareCount;
  final int regenerateCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Row(
      children: [
        if (reactionCount > 0) ...[
          Text('$reactionCount reactions', style: textStyle),
          const SizedBox(width: 16),
        ],
        if (commentCount > 0) ...[
          Text('$commentCount comments', style: textStyle),
          const SizedBox(width: 16),
        ],
        if (shareCount > 0) ...[
          Text('$shareCount shares', style: textStyle),
          const SizedBox(width: 16),
        ],
        if (regenerateCount > 0) ...[
          Icon(Icons.repeat, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          const SizedBox(width: 4),
          Text('$regenerateCount', style: textStyle),
        ],
      ],
    );
  }
}

class _RegenerateHeader extends StatelessWidget {
  const _RegenerateHeader({
    required this.originalUserName,
    this.onOriginalUserTap,
  });

  final String originalUserName;
  final VoidCallback? onOriginalUserTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.repeat,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Text(
          'Regenerated from ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: onOriginalUserTap,
          child: Text(
            '@$originalUserName',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuotedOriginalPost extends StatelessWidget {
  const _QuotedOriginalPost({
    required this.originalPost,
    required this.showFullContent,
    this.onHashtagTap,
    this.onOriginalUserTap,
  });

  final Post originalPost;
  final bool showFullContent;
  final void Function(String hashtag)? onHashtagTap;
  final VoidCallback? onOriginalUserTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original author info
          Row(
            children: [
              GestureDetector(
                onTap: onOriginalUserTap,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getTypeColor(originalPost.userHdType),
                          width: 1.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: originalPost.userAvatarUrl != null
                            ? NetworkImage(originalPost.userAvatarUrl!)
                            : null,
                        child: originalPost.userAvatarUrl == null
                            ? Text(
                                originalPost.userName.isNotEmpty
                                    ? originalPost.userName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(fontSize: 10),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      originalPost.userName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTimeAgo(originalPost.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Original content
          if (onHashtagTap != null)
            HashtagText(
              text: originalPost.content,
              onHashtagTap: onHashtagTap!,
              style: theme.textTheme.bodySmall,
              maxLines: showFullContent ? null : 4,
              overflow: showFullContent ? null : TextOverflow.ellipsis,
            )
          else
            Text(
              originalPost.content,
              style: theme.textTheme.bodySmall,
              maxLines: showFullContent ? null : 4,
              overflow: showFullContent ? null : TextOverflow.ellipsis,
            ),

          // Gate/Channel tag for original
          if (originalPost.gateNumber != null || originalPost.channelId != null) ...[
            const SizedBox(height: 8),
            _PostTag(
              gateNumber: originalPost.gateNumber,
              channelId: originalPost.channelId,
            ),
          ],

          // Media for original
          if (originalPost.mediaUrls?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            _PostMedia(mediaUrls: originalPost.mediaUrls!),
          ],
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
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';
    return '${dateTime.day}/${dateTime.month}';
  }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'Generator':
        return Colors.orange;
      case 'Manifesting Generator':
        return Colors.deepOrange;
      case 'Projector':
        return Colors.blue;
      case 'Manifestor':
        return Colors.red;
      case 'Reflector':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _PostActionBar extends StatelessWidget {
  const _PostActionBar({
    this.currentReaction,
    required this.onReaction,
    required this.onComment,
    required this.onShare,
    this.onRegenerate,
    this.canRegenerate = true,
    this.isRegenerate = false,
  });

  final ReactionType? currentReaction;
  final void Function(ReactionType) onReaction;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback? onRegenerate;
  final bool canRegenerate;
  final bool isRegenerate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Reaction button from ReactionBar
        Expanded(
          child: _ReactionButtonCompact(
            currentReaction: currentReaction,
            onReaction: onReaction,
          ),
        ),
        // Comment button
        Expanded(
          child: _ActionButtonCompact(
            icon: Icons.chat_bubble_outline,
            label: 'Comment',
            onTap: onComment,
          ),
        ),
        // Regenerate button (only show if handler provided and can regenerate)
        if (onRegenerate != null)
          Expanded(
            child: _ActionButtonCompact(
              icon: Icons.repeat,
              label: 'Regenerate',
              onTap: canRegenerate ? onRegenerate! : null,
              isDisabled: !canRegenerate,
              isActive: isRegenerate,
            ),
          ),
        // Share button
        Expanded(
          child: _ActionButtonCompact(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: onShare,
          ),
        ),
      ],
    );
  }
}

class _ReactionButtonCompact extends StatelessWidget {
  const _ReactionButtonCompact({
    this.currentReaction,
    required this.onReaction,
  });

  final ReactionType? currentReaction;
  final void Function(ReactionType) onReaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasReaction = currentReaction != null;

    return GestureDetector(
      onTap: () => onReaction(currentReaction ?? ReactionType.like),
      onLongPress: () => _showReactionPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasReaction)
              Text(
                currentReaction!.emoji,
                style: const TextStyle(fontSize: 16),
              )
            else
              Icon(
                Icons.thumb_up_outlined,
                size: 18,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                hasReaction ? currentReaction!.label : 'React',
                style: TextStyle(
                  fontSize: 12,
                  color: hasReaction
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: hasReaction ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReactionPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReactionPicker(
        currentReaction: currentReaction,
        onReaction: (type) {
          Navigator.pop(context);
          onReaction(type);
        },
      ),
    );
  }
}

class _ActionButtonCompact extends StatelessWidget {
  const _ActionButtonCompact({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDisabled = false,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDisabled;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDisabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
        : isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
