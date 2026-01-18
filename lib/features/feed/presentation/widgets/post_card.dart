import 'package:flutter/material.dart';

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
    this.showFullContent = false,
  });

  final Post post;
  final VoidCallback onTap;
  final void Function(ReactionType) onReaction;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onUserTap;
  final bool showFullContent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

              // Content
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

              const SizedBox(height: 12),

              // Stats
              _PostStats(
                reactionCount: post.reactionCount,
                commentCount: post.commentCount,
                shareCount: post.shareCount,
              ),

              const Divider(height: 24),

              // Actions
              ReactionBar(
                currentReaction: post.userReaction,
                onReaction: onReaction,
                onComment: onComment,
                onShare: onShare,
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
    final theme = Theme.of(context);
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
    if (mediaUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          mediaUrls.first,
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mediaUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              mediaUrls[index],
              fit: BoxFit.cover,
              width: 200,
            ),
          );
        },
      ),
    );
  }
}

class _PostStats extends StatelessWidget {
  const _PostStats({
    required this.reactionCount,
    required this.commentCount,
    required this.shareCount,
  });

  final int reactionCount;
  final int commentCount;
  final int shareCount;

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
        if (shareCount > 0) Text('$shareCount shares', style: textStyle),
      ],
    );
  }
}
