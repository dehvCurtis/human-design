import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/stories_providers.dart';
import '../domain/models/story.dart';

class StoryViewerScreen extends ConsumerStatefulWidget {
  const StoryViewerScreen({
    super.key,
    required this.userStories,
    this.isOwnStory = false,
  });

  final UserStories userStories;
  final bool isOwnStory;

  @override
  ConsumerState<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends ConsumerState<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentIndex = 0;
  bool _isPaused = false;

  static const Duration _storyDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: _storyDuration,
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _startProgress();
    _markAsViewed();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _markAsViewed() {
    if (!widget.isOwnStory) {
      final story = widget.userStories.stories[_currentIndex];
      ref.read(storiesNotifierProvider.notifier).markViewed(story.id);
    }
  }

  void _startProgress() {
    _progressController.forward(from: 0);
  }

  void _pauseProgress() {
    _progressController.stop();
    setState(() => _isPaused = true);
  }

  void _resumeProgress() {
    _progressController.forward();
    setState(() => _isPaused = false);
  }

  void _nextStory() {
    if (_currentIndex < widget.userStories.stories.length - 1) {
      setState(() => _currentIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgress();
      _markAsViewed();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgress();
    } else {
      _progressController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.userStories.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (_) => _pauseProgress(),
        onTapUp: (_) => _resumeProgress(),
        onTapCancel: () => _resumeProgress(),
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Story content
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.userStories.stories.length,
              itemBuilder: (context, index) {
                return _StoryContent(story: widget.userStories.stories[index]);
              },
            ),

            // Touch zones for navigation
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: _previousStory,
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox.expand(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: _nextStory,
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),

            // Top overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Progress bars
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          children: List.generate(
                            widget.userStories.stories.length,
                            (index) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: _ProgressBar(
                                  isActive: index == _currentIndex,
                                  isCompleted: index < _currentIndex,
                                  controller: index == _currentIndex
                                      ? _progressController
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // User info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage:
                                  widget.userStories.userAvatarUrl != null
                                      ? NetworkImage(
                                          widget.userStories.userAvatarUrl!)
                                      : null,
                              child: widget.userStories.userAvatarUrl == null
                                  ? Text(widget.userStories.userName[0]
                                      .toUpperCase())
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userStories.userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _formatTime(story.createdAt),
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            if (widget.isOwnStory)
                              IconButton(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.white),
                                onPressed: () =>
                                    _showStoryOptions(context, story),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom overlay for own stories
            if (widget.isOwnStory)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.visibility,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${story.viewCount} views',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Paused indicator
            if (_isPaused)
              Center(
                child: Icon(
                  Icons.pause_circle_filled,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
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

  void _showStoryOptions(BuildContext context, Story story) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: Text(AppLocalizations.of(context)!.story_viewViewers),
              onTap: () {
                Navigator.pop(context);
                _showViewers(context, story.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              title: Text(
                'Delete story',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _deleteStory(story.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showViewers(BuildContext context, String storyId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final viewersAsync = ref.watch(storyViewersProvider(storyId));

          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return viewersAsync.when(
                data: (viewers) {
                  if (viewers.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.story_noViewers),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: viewers.length,
                    itemBuilder: (context, index) {
                      final viewer = viewers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: viewer.viewerAvatarUrl != null
                              ? NetworkImage(viewer.viewerAvatarUrl!)
                              : null,
                          child: viewer.viewerAvatarUrl == null
                              ? Text(viewer.viewerName[0].toUpperCase())
                              : null,
                        ),
                        title: Text(viewer.viewerName),
                        subtitle: Text(_formatTime(viewer.viewedAt)),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteStory(String storyId) async {
    await ref.read(storiesNotifierProvider.notifier).deleteStory(storyId);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _StoryContent extends StatelessWidget {
  const _StoryContent({required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    // If media URL, show image
    if (story.mediaUrl != null) {
      return Image.network(
        story.mediaUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildTextContent(context),
      );
    }

    return _buildTextContent(context);
  }

  Widget _buildTextContent(BuildContext context) {
    final bgColor = story.backgroundColor != null
        ? Color(int.parse(story.backgroundColor!.replaceFirst('#', '0xFF')))
        : const Color(0xFF6366F1);
    final textColor = story.textColor != null
        ? Color(int.parse(story.textColor!.replaceFirst('#', '0xFF')))
        : Colors.white;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (story.transitGate != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Gate ${story.transitGate}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            if (story.content != null)
              Text(
                story.content!,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            if (story.affirmationText != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  story.affirmationText!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.isActive,
    required this.isCompleted,
    this.controller,
  });

  final bool isActive;
  final bool isCompleted;
  final AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
      child: isCompleted
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            )
          : isActive && controller != null
              ? AnimatedBuilder(
                  animation: controller!,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: controller!.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                )
              : null,
    );
  }
}
