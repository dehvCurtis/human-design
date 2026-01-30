import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/stories_providers.dart';
import '../domain/models/story.dart';
import 'story_viewer_screen.dart';
import 'widgets/create_story_sheet.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedStoriesAsync = ref.watch(feedStoriesProvider);
    final myStoriesAsync = ref.watch(myStoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showCreateStorySheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(feedStoriesProvider);
          ref.invalidate(myStoriesProvider);
        },
        child: CustomScrollView(
          slivers: [
            // My stories section
            SliverToBoxAdapter(
              child: myStoriesAsync.when(
                data: (myStories) => _MyStoriesSection(
                  stories: myStories,
                  onAddStory: () => _showCreateStorySheet(context),
                  onViewStories: () {
                    if (myStories.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StoryViewerScreen(
                            userStories: UserStories.fromStories(myStories),
                            isOwnStory: true,
                          ),
                        ),
                      );
                    }
                  },
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Divider
            SliverToBoxAdapter(
              child: Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant,
              ),
            ),

            // Feed stories section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Recent Stories',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            feedStoriesAsync.when(
              data: (userStoriesList) {
                if (userStoriesList.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_stories_outlined,
                            size: 80,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No stories to show',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Follow more people to see their stories',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final userStories = userStoriesList[index];
                      return _StoryUserTile(
                        userStories: userStories,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StoryViewerScreen(
                                userStories: userStories,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: userStoriesList.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text('Failed to load stories'),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.invalidate(feedStoriesProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateStorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateStorySheet(),
    );
  }
}

class _MyStoriesSection extends StatelessWidget {
  const _MyStoriesSection({
    required this.stories,
    required this.onAddStory,
    required this.onViewStories,
  });

  final List<Story> stories;
  final VoidCallback onAddStory;
  final VoidCallback onViewStories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Story',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Add story button
              GestureDetector(
                onTap: onAddStory,
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),

              // Show existing stories
              if (stories.isNotEmpty) ...[
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onViewStories,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.surface,
                              ),
                              padding: const EdgeInsets.all(3),
                              child: _buildStoryPreview(stories.first, theme),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                stories.length.toString(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoryPreview(Story story, ThemeData theme) {
    if (story.mediaUrl != null) {
      return ClipOval(
        child: Image.network(
          story.mediaUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildTextPreview(story, theme),
        ),
      );
    }
    return _buildTextPreview(story, theme);
  }

  Widget _buildTextPreview(Story story, ThemeData theme) {
    final bgColor = story.backgroundColor != null
        ? Color(int.parse(story.backgroundColor!.replaceFirst('#', '0xFF')))
        : theme.colorScheme.primaryContainer;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: Center(
        child: Icon(
          Icons.text_fields,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _StoryUserTile extends StatelessWidget {
  const _StoryUserTile({
    required this.userStories,
    required this.onTap,
  });

  final UserStories userStories;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latestStory = userStories.stories.first;
    final timeDiff = DateTime.now().difference(latestStory.createdAt);

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: userStories.hasUnviewed
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                )
              : null,
          color: userStories.hasUnviewed ? null : theme.colorScheme.outline,
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
          ),
          padding: const EdgeInsets.all(2),
          child: CircleAvatar(
            backgroundImage: userStories.userAvatarUrl != null
                ? NetworkImage(userStories.userAvatarUrl!)
                : null,
            child: userStories.userAvatarUrl == null
                ? Text(userStories.userName[0].toUpperCase())
                : null,
          ),
        ),
      ),
      title: Text(
        userStories.userName,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: userStories.hasUnviewed ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        _formatTimeDiff(timeDiff),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${userStories.stories.length}',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.outline,
          ),
        ],
      ),
    );
  }

  String _formatTimeDiff(Duration diff) {
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
