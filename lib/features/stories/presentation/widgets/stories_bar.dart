import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/stories_providers.dart';
import '../../domain/models/story.dart';
import '../story_viewer_screen.dart';
import 'create_story_sheet.dart';

class StoriesBar extends ConsumerWidget {
  const StoriesBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedStoriesAsync = ref.watch(feedStoriesProvider);
    final myStoriesAsync = ref.watch(myStoriesProvider);
    final theme = Theme.of(context);

    return SizedBox(
      height: 100,
      child: Row(
        children: [
          // Add story / My stories
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: myStoriesAsync.when(
              data: (myStories) => _MyStoryCircle(
                stories: myStories,
                onTap: () {
                  if (myStories.isEmpty) {
                    _showCreateStorySheet(context);
                  } else {
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
                onAdd: () => _showCreateStorySheet(context),
              ),
              loading: () => _LoadingCircle(),
              error: (_, _) => _AddStoryCircle(
                onTap: () => _showCreateStorySheet(context),
              ),
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: theme.colorScheme.outlineVariant,
          ),

          // Feed stories
          Expanded(
            child: feedStoriesAsync.when(
              data: (userStoriesList) {
                if (userStoriesList.isEmpty) {
                  return Center(
                    child: Text(
                      'No stories',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 16),
                  itemCount: userStoriesList.length,
                  itemBuilder: (context, index) {
                    final userStories = userStoriesList[index];
                    return _StoryCircle(
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
                );
              },
              loading: () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => _LoadingCircle(),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ],
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

class _MyStoryCircle extends StatelessWidget {
  const _MyStoryCircle({
    required this.stories,
    required this.onTap,
    required this.onAdd,
  });

  final List<Story> stories;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasStories = stories.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: hasStories
                      ? LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        )
                      : null,
                  border: hasStories
                      ? null
                      : Border.all(
                          color: theme.colorScheme.outline,
                          width: 2,
                        ),
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface,
                  ),
                  child: hasStories
                      ? CircleAvatar(
                          backgroundImage: stories.first.mediaUrl != null
                              ? NetworkImage(stories.first.mediaUrl!)
                              : null,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: stories.first.mediaUrl == null
                              ? Icon(
                                  Icons.text_fields,
                                  color: theme.colorScheme.primary,
                                )
                              : null,
                        )
                      : Icon(
                          Icons.person,
                          size: 32,
                          color: theme.colorScheme.outline,
                        ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Your story',
            style: theme.textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _AddStoryCircle extends StatelessWidget {
  const _AddStoryCircle({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.add,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add story',
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _StoryCircle extends StatelessWidget {
  const _StoryCircle({
    required this.userStories,
    required this.onTap,
  });

  final UserStories userStories;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
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
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: Text(
                userStories.userName.split(' ').first,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight:
                      userStories.hasUnviewed ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 48,
            height: 12,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
