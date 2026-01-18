import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/stories_repository.dart';
import 'models/story.dart';

/// Provider for the StoriesRepository
final storiesRepositoryProvider = Provider<StoriesRepository>((ref) {
  return StoriesRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for feed stories (stories from followed users)
final feedStoriesProvider = FutureProvider<List<UserStories>>((ref) async {
  final repository = ref.watch(storiesRepositoryProvider);
  return repository.getFeedStories();
});

/// Provider for a specific user's stories
final userStoriesProvider = FutureProvider.family<List<Story>, String>((ref, userId) async {
  final repository = ref.watch(storiesRepositoryProvider);
  return repository.getUserStories(userId);
});

/// Provider for current user's own stories
final myStoriesProvider = FutureProvider<List<Story>>((ref) async {
  final repository = ref.watch(storiesRepositoryProvider);
  return repository.getMyStories();
});

/// Provider for story viewers
final storyViewersProvider = FutureProvider.family<List<StoryView>, String>((ref, storyId) async {
  final repository = ref.watch(storiesRepositoryProvider);
  return repository.getStoryViewers(storyId);
});

/// Notifier for managing stories state and actions
class StoriesNotifier extends Notifier<StoriesState> {
  @override
  StoriesState build() => const StoriesState();

  StoriesRepository get _repository => ref.read(storiesRepositoryProvider);

  /// Create a new story
  Future<Story> createStory({
    String? content,
    String? mediaUrl,
    String? backgroundColor,
    String? textColor,
    int? transitGate,
    String? affirmationText,
    StoryVisibility visibility = StoryVisibility.followers,
  }) async {
    state = state.copyWith(isCreating: true);

    try {
      final story = await _repository.createStory(
        content: content,
        mediaUrl: mediaUrl,
        backgroundColor: backgroundColor,
        textColor: textColor,
        transitGate: transitGate,
        affirmationText: affirmationText,
        visibility: visibility,
      );

      // Refresh stories
      ref.invalidate(feedStoriesProvider);
      ref.invalidate(myStoriesProvider);

      state = state.copyWith(isCreating: false);
      return story;
    } catch (e) {
      state = state.copyWith(isCreating: false, error: e.toString());
      rethrow;
    }
  }

  /// Delete a story
  Future<void> deleteStory(String storyId) async {
    await _repository.deleteStory(storyId);
    ref.invalidate(feedStoriesProvider);
    ref.invalidate(myStoriesProvider);
  }

  /// Mark a story as viewed
  Future<void> markViewed(String storyId) async {
    await _repository.markStoryViewed(storyId);
    // Don't invalidate immediately - update locally for smoother UX
    state = state.copyWith(
      viewedStoryIds: {...state.viewedStoryIds, storyId},
    );
  }

  /// Check if a story has been viewed
  bool isViewed(String storyId) => state.viewedStoryIds.contains(storyId);

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final storiesNotifierProvider = NotifierProvider<StoriesNotifier, StoriesState>(() {
  return StoriesNotifier();
});

/// State class for stories operations
class StoriesState {
  const StoriesState({
    this.isCreating = false,
    this.viewedStoryIds = const {},
    this.error,
  });

  final bool isCreating;
  final Set<String> viewedStoryIds;
  final String? error;

  StoriesState copyWith({
    bool? isCreating,
    Set<String>? viewedStoryIds,
    String? error,
  }) {
    return StoriesState(
      isCreating: isCreating ?? this.isCreating,
      viewedStoryIds: viewedStoryIds ?? this.viewedStoryIds,
      error: error,
    );
  }
}
