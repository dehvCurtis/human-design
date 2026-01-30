import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../../feed/data/feed_repository.dart';
import '../../feed/domain/models/post.dart';
import '../data/hashtag_repository.dart';
import 'models/hashtag.dart';

/// Provider for the HashtagRepository
final hashtagRepositoryProvider = Provider<HashtagRepository>((ref) {
  return HashtagRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for trending hashtags
final trendingHashtagsProvider = FutureProvider<List<TrendingHashtag>>((ref) async {
  final repository = ref.watch(hashtagRepositoryProvider);
  return repository.getTrendingHashtags(limit: 10);
});

/// Provider for popular hashtags
final popularHashtagsProvider = FutureProvider<List<Hashtag>>((ref) async {
  final repository = ref.watch(hashtagRepositoryProvider);
  return repository.getPopularHashtags(limit: 20);
});

/// Provider for HD-specific hashtags
final hdHashtagsProvider = FutureProvider<List<Hashtag>>((ref) async {
  final repository = ref.watch(hashtagRepositoryProvider);
  return repository.getHdHashtags(limit: 20);
});

/// Provider for searching hashtags
final hashtagSearchProvider = FutureProvider.family<List<Hashtag>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(hashtagRepositoryProvider);
  return repository.searchHashtags(query, limit: 20);
});

/// Provider for a single hashtag by name
final hashtagProvider = FutureProvider.family<Hashtag?, String>((ref, name) async {
  final repository = ref.watch(hashtagRepositoryProvider);
  return repository.getHashtag(name);
});

/// Provider for posts with a specific hashtag
final hashtagPostsProvider = FutureProvider.family<List<Post>, String>((ref, hashtagName) async {
  final hashtagRepo = ref.watch(hashtagRepositoryProvider);
  final feedRepo = ref.watch(feedRepositoryProvider);

  // Get post IDs for this hashtag
  final postIds = await hashtagRepo.getPostIdsByHashtag(hashtagName);

  if (postIds.isEmpty) return [];

  // Fetch the actual posts
  final posts = await Future.wait(
    postIds.map((id) => feedRepo.getPost(id)),
  );

  return posts.whereType<Post>().toList();
});

/// Provider for hashtag suggestions based on content
final hashtagSuggestionsProvider = FutureProvider.family<List<Hashtag>, String>((ref, content) async {
  if (content.length < 10) return [];
  final repository = ref.watch(hashtagRepositoryProvider);
  return repository.getSuggestedHashtags(content, limit: 5);
});

/// Notifier for managing hashtag operations
class HashtagNotifier extends Notifier<HashtagState> {
  @override
  HashtagState build() => const HashtagState();

  HashtagRepository get _repository => ref.read(hashtagRepositoryProvider);

  /// Add hashtags to a post (called when creating a post)
  Future<void> addHashtagsToPost(String postId, String content) async {
    final hashtags = HashtagParser.extractHashtags(content);
    if (hashtags.isEmpty) return;

    try {
      await _repository.addHashtagsToPost(postId, hashtags);
      // Invalidate trending to reflect new data
      ref.invalidate(trendingHashtagsProvider);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Remove hashtags from a post (called when deleting a post)
  Future<void> removeHashtagsFromPost(String postId) async {
    try {
      await _repository.removeHashtagsFromPost(postId);
      ref.invalidate(trendingHashtagsProvider);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final hashtagNotifierProvider = NotifierProvider<HashtagNotifier, HashtagState>(() {
  return HashtagNotifier();
});

/// State class for hashtag operations
class HashtagState {
  const HashtagState({
    this.error,
  });

  final String? error;

  HashtagState copyWith({
    String? error,
  }) {
    return HashtagState(
      error: error,
    );
  }
}

/// Provider for the FeedRepository (forwarded from feed feature)
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(supabaseClient: ref.watch(supabaseClientProvider));
});
