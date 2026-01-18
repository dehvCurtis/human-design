import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/story.dart';

/// Repository for Stories (24h ephemeral content) operations
class StoriesRepository {
  StoriesRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Stories ====================

  /// Get all stories from followed users (for the story bar)
  Future<List<UserStories>> getFeedStories() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    // Get stories from followed users and public stories, not expired
    final response = await _client
        .from('stories')
        .select('''
          *,
          user:profiles!stories_user_id_fkey(id, name, avatar_url)
        ''')
        .gt('expires_at', DateTime.now().toIso8601String())
        .order('created_at', ascending: false);

    // Get viewed story IDs
    final viewedIds = await _getViewedStoryIds();

    // Parse stories
    final stories = (response as List).map((json) {
      return Story.fromJson(
        json,
        isViewed: viewedIds.contains(json['id'] as String),
      );
    }).toList();

    // Group by user
    final storiesByUser = <String, List<Story>>{};
    for (final story in stories) {
      storiesByUser.putIfAbsent(story.userId, () => []).add(story);
    }

    // Put current user's stories first if they have any
    final userStories = <UserStories>[];

    // Add current user's stories first
    if (storiesByUser.containsKey(userId)) {
      userStories.add(UserStories.fromStories(storiesByUser[userId]!));
      storiesByUser.remove(userId);
    }

    // Add other users' stories, prioritizing unviewed
    final otherUserStories = storiesByUser.entries
        .map((e) => UserStories.fromStories(e.value))
        .toList()
      ..sort((a, b) {
        // Unviewed first
        if (a.hasUnviewed && !b.hasUnviewed) return -1;
        if (!a.hasUnviewed && b.hasUnviewed) return 1;
        // Then by most recent
        return b.stories.first.createdAt.compareTo(a.stories.first.createdAt);
      });

    userStories.addAll(otherUserStories);

    return userStories;
  }

  /// Get stories for a specific user
  Future<List<Story>> getUserStories(String userId) async {
    final viewedIds = await _getViewedStoryIds();

    final response = await _client
        .from('stories')
        .select('''
          *,
          user:profiles!stories_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('user_id', userId)
        .gt('expires_at', DateTime.now().toIso8601String())
        .order('created_at', ascending: true);

    return (response as List).map((json) {
      return Story.fromJson(
        json,
        isViewed: viewedIds.contains(json['id'] as String),
      );
    }).toList();
  }

  /// Get current user's own stories
  Future<List<Story>> getMyStories() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    return getUserStories(userId);
  }

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
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('stories').insert({
      'user_id': userId,
      'content': content,
      'media_url': mediaUrl,
      'background_color': backgroundColor,
      'text_color': textColor,
      'transit_gate': transitGate,
      'affirmation_text': affirmationText,
      'visibility': visibility.name,
    }).select('''
          *,
          user:profiles!stories_user_id_fkey(id, name, avatar_url)
        ''').single();

    return Story.fromJson(response);
  }

  /// Delete a story
  Future<void> deleteStory(String storyId) async {
    await _client.from('stories').delete().eq('id', storyId);
  }

  // ==================== Views ====================

  /// Mark a story as viewed
  Future<void> markStoryViewed(String storyId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    // Upsert to handle duplicates
    await _client.from('story_views').upsert({
      'story_id': storyId,
      'viewer_id': userId,
    }, onConflict: 'story_id,viewer_id');
  }

  /// Get viewers of a story (for story owner)
  Future<List<StoryView>> getStoryViewers(String storyId) async {
    final response = await _client
        .from('story_views')
        .select('''
          *,
          viewer:profiles!story_views_viewer_id_fkey(id, name, avatar_url)
        ''')
        .eq('story_id', storyId)
        .order('viewed_at', ascending: false);

    return (response as List).map((json) => StoryView.fromJson(json)).toList();
  }

  // ==================== Realtime ====================

  /// Subscribe to new stories from followed users
  RealtimeChannel subscribeToStories(void Function(Story story) onNewStory) {
    return _client
        .channel('stories_feed')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'stories',
          callback: (payload) async {
            // Fetch full story with user data
            final response = await _client
                .from('stories')
                .select('''
                  *,
                  user:profiles!stories_user_id_fkey(id, name, avatar_url)
                ''')
                .eq('id', payload.newRecord['id'] as String)
                .single();

            onNewStory(Story.fromJson(response));
          },
        )
        .subscribe();
  }

  // ==================== Helper Methods ====================

  Future<Set<String>> _getViewedStoryIds() async {
    final userId = _currentUserId;
    if (userId == null) return {};

    final response = await _client
        .from('story_views')
        .select('story_id')
        .eq('viewer_id', userId);

    return (response as List)
        .map((json) => json['story_id'] as String)
        .toSet();
  }
}
