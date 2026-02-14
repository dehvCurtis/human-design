import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus;

import '../../../core/utils/error_handler.dart';
import '../domain/learning_providers.dart';
import '../domain/models/learning.dart';

class ContentDetailScreen extends ConsumerStatefulWidget {
  const ContentDetailScreen({super.key, required this.contentId});

  final String contentId;

  @override
  ConsumerState<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends ConsumerState<ContentDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Record view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(learningNotifierProvider.notifier).recordView(widget.contentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentAsync = ref.watch(contentDetailProvider(widget.contentId));

    return Scaffold(
      body: contentAsync.when(
        data: (content) {
          if (content == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  const Text('Content not found'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go back'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App bar
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  _BookmarkButton(contentId: widget.contentId),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share, color: Colors.white),
                    ),
                    onPressed: () => _shareContent(content),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: content.mediaUrl != null
                      ? Image.network(
                          content.mediaUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildDefaultHeader(content, theme),
                        )
                      : _buildDefaultHeader(content, theme),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        content.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Meta row
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _MetaChip(
                            icon: _getContentTypeIcon(content.contentType),
                            label: _getContentTypeName(content.contentType),
                          ),
                          _MetaChip(
                            icon: Icons.category,
                            label: _getCategoryName(content.category),
                          ),
                          if (content.gateNumber != null)
                            _MetaChip(
                              icon: Icons.hexagon,
                              label: 'Gate ${content.gateNumber}',
                            ),
                          if (content.estimatedReadTime != null)
                            _MetaChip(
                              icon: Icons.schedule,
                              label: '${content.estimatedReadTime} min read',
                            ),
                          if (content.isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.workspace_premium,
                                    size: 16,
                                    color: theme.colorScheme.tertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Premium',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Author
                      if (content.authorName != null) ...[
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: content.authorAvatarUrl != null
                                  ? NetworkImage(content.authorAvatarUrl!)
                                  : null,
                              child: content.authorAvatarUrl == null
                                  ? Text(content.authorName![0].toUpperCase())
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  content.authorName!,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (content.isOfficial) ...[
                                      Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Official',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ] else
                                      Text(
                                        'Community Author',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Progress
                      if (content.userProgress != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Your Progress',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${content.userProgress!.progressPercent}%',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: content.userProgress!.progressPercent / 100,
                                  minHeight: 8,
                                ),
                              ),
                              if (content.userProgress!.isCompleted) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Completed',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Content body (rendered as markdown)
                      MarkdownBody(
                        data: content.content,
                        styleSheet: MarkdownStyleSheet(
                          p: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                          h1: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          h2: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          h3: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          listBullet: theme.textTheme.bodyLarge,
                          strong: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          em: theme.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                          blockSpacing: 16,
                        ),
                        selectable: true,
                      ),

                      const SizedBox(height: 24),

                      // Tags
                      if (content.tags != null && content.tags!.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: content.tags!.map((tag) {
                            return Chip(
                              label: Text(tag),
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Stats
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 18,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${content.viewCount} views',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 18,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${content.likeCount} likes',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(ErrorHandler.getUserMessage(e)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.invalidate(contentDetailProvider(widget.contentId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: contentAsync.when(
        data: (content) {
          if (content == null) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _LikeButton(
                      contentId: content.id,
                      likeCount: content.likeCount,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _markAsComplete(content),
                      icon: Icon(
                        content.userProgress?.isCompleted == true
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                      ),
                      label: Text(
                        content.userProgress?.isCompleted == true
                            ? 'Completed'
                            : 'Mark Complete',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDefaultHeader(LearningContent content, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          _getContentTypeIcon(content.contentType),
          size: 64,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  IconData _getContentTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.article:
        return Icons.article;
      case ContentType.guide:
        return Icons.menu_book;
      case ContentType.quiz:
        return Icons.quiz;
      case ContentType.video:
        return Icons.play_circle;
      case ContentType.infographic:
        return Icons.image;
    }
  }

  String _getContentTypeName(ContentType type) {
    switch (type) {
      case ContentType.article:
        return 'Article';
      case ContentType.guide:
        return 'Guide';
      case ContentType.quiz:
        return 'Quiz';
      case ContentType.video:
        return 'Video';
      case ContentType.infographic:
        return 'Infographic';
    }
  }

  String _getCategoryName(ContentCategory category) {
    switch (category) {
      case ContentCategory.type:
        return 'Type';
      case ContentCategory.authority:
        return 'Authority';
      case ContentCategory.profile:
        return 'Profile';
      case ContentCategory.gate:
        return 'Gate';
      case ContentCategory.channel:
        return 'Channel';
      case ContentCategory.center:
        return 'Center';
      case ContentCategory.transit:
        return 'Transit';
      case ContentCategory.general:
        return 'General';
    }
  }

  Future<void> _markAsComplete(LearningContent content) async {
    final isCompleted = content.userProgress?.isCompleted == true;
    await ref.read(learningNotifierProvider.notifier).updateProgress(
          contentId: content.id,
          isCompleted: !isCompleted,
          progressPercent: !isCompleted ? 100 : 0,
        );
  }

  Future<void> _shareContent(LearningContent content) async {
    final text = '${content.title}\n\nCheck out this Human Design content!';
    await SharePlus.instance.share(ShareParams(text: text, subject: content.title));
  }
}

class _BookmarkButton extends ConsumerWidget {
  const _BookmarkButton({required this.contentId});

  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarkedAsync = ref.watch(isBookmarkedProvider(contentId));

    return isBookmarkedAsync.when(
      data: (isBookmarked) => IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          try {
            final isNowBookmarked = await ref
                .read(learningNotifierProvider.notifier)
                .toggleBookmark(contentId);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isNowBookmarked ? 'Bookmarked' : 'Bookmark removed'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ErrorHandler.getUserMessage(e))),
              );
            }
          }
        },
      ),
      loading: () => IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
        ),
        onPressed: null,
      ),
      error: (_, _) => IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.bookmark_outline, color: Colors.white),
        ),
        onPressed: null,
      ),
    );
  }
}

class _LikeButton extends ConsumerWidget {
  const _LikeButton({
    required this.contentId,
    required this.likeCount,
  });

  final String contentId;
  final int likeCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLikedAsync = ref.watch(isLikedProvider(contentId));

    return isLikedAsync.when(
      data: (isLiked) => OutlinedButton.icon(
        onPressed: () async {
          try {
            await ref.read(learningNotifierProvider.notifier).toggleLike(contentId);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ErrorHandler.getUserMessage(e))),
              );
            }
          }
        },
        icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined),
        label: Text('Like ($likeCount)'),
      ),
      loading: () => OutlinedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: Text('Like ($likeCount)'),
      ),
      error: (_, _) => OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.thumb_up_outlined),
        label: Text('Like ($likeCount)'),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
