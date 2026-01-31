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

  // ==================== Reactions ====================

  /// React to a story
  Future<void> reactToStory(String storyId, StoryReactionType reactionType) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Upsert reaction (one per user per story)
    await _client.from('story_reactions').upsert({
      'story_id': storyId,
      'user_id': userId,
      'reaction_type': reactionType.dbValue,
    }, onConflict: 'story_id,user_id');
  }

  /// Remove reaction from a story
  Future<void> removeStoryReaction(String storyId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('story_reactions')
        .delete()
        .eq('story_id', storyId)
        .eq('user_id', userId);
  }

  /// Get reactions for a story
  Future<List<StoryReaction>> getStoryReactions(String storyId) async {
    final response = await _client
        .from('story_reactions')
        .select('''
          *,
          user:profiles!story_reactions_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('story_id', storyId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => StoryReaction.fromJson(json))
        .toList();
  }

  /// Get user's reaction to a story
  Future<StoryReactionType?> getUserReaction(String storyId) async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('story_reactions')
        .select('reaction_type')
        .eq('story_id', storyId)
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return StoryReactionTypeExtension.fromDbValue(response['reaction_type'] as String);
  }

  // ==================== Replies ====================

  /// Reply to a story (creates a DM thread)
  Future<StoryReply> replyToStory(String storyId, String content) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('story_replies').insert({
      'story_id': storyId,
      'user_id': userId,
      'content': content,
    }).select('''
          *,
          user:profiles!story_replies_user_id_fkey(id, name, avatar_url)
        ''').single();

    return StoryReply.fromJson(response);
  }

  /// Get replies for a story (for story owner)
  Future<List<StoryReply>> getStoryReplies(String storyId) async {
    final response = await _client
        .from('story_replies')
        .select('''
          *,
          user:profiles!story_replies_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('story_id', storyId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => StoryReply.fromJson(json))
        .toList();
  }

  // ==================== Polls ====================

  /// Create a poll for a story
  Future<StoryPoll> createPoll({
    required String storyId,
    required String question,
    required List<String> options,
  }) async {
    // Create poll
    final pollResponse = await _client.from('story_polls').insert({
      'story_id': storyId,
      'question': question,
    }).select().single();

    final pollId = pollResponse['id'] as String;

    // Create options
    final optionInserts = options.map((text) => {
      'poll_id': pollId,
      'text': text,
    }).toList();

    await _client.from('poll_options').insert(optionInserts);

    // Fetch complete poll with options
    return getPoll(pollId);
  }

  /// Get a poll by ID
  Future<StoryPoll> getPoll(String pollId) async {
    final pollResponse = await _client
        .from('story_polls')
        .select()
        .eq('id', pollId)
        .single();

    final optionsResponse = await _client
        .from('poll_options')
        .select()
        .eq('poll_id', pollId);

    // Check if user has voted
    final userId = _currentUserId;
    String? userVote;
    if (userId != null) {
      final voteResponse = await _client
          .from('poll_votes')
          .select('option_id')
          .eq('poll_id', pollId)
          .eq('user_id', userId)
          .maybeSingle();
      userVote = voteResponse?['option_id'] as String?;
    }

    return StoryPoll.fromJson({
      ...pollResponse,
      'options': optionsResponse,
    }, userVote: userVote);
  }

  /// Get poll for a story
  Future<StoryPoll?> getStoryPoll(String storyId) async {
    final response = await _client
        .from('story_polls')
        .select()
        .eq('story_id', storyId)
        .maybeSingle();

    if (response == null) return null;
    return getPoll(response['id'] as String);
  }

  /// Vote on a poll
  Future<void> voteOnPoll(String pollId, String optionId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Upsert vote (one per user per poll)
    await _client.from('poll_votes').upsert({
      'poll_id': pollId,
      'option_id': optionId,
      'user_id': userId,
    }, onConflict: 'poll_id,user_id');

    // Update vote count
    await _client.rpc('increment_poll_option_count', params: {
      'option_id': optionId,
    });
  }

  // ==================== Cleanup ====================

  /// Clean up expired stories
  /// Deletes stories that have passed their expiration time
  /// Returns the number of stories deleted
  Future<int> cleanupExpiredStories() async {
    // Get expired story IDs first for counting
    final expiredResponse = await _client
        .from('stories')
        .select('id')
        .lt('expires_at', DateTime.now().toIso8601String());

    final expiredIds = (expiredResponse as List)
        .map((json) => json['id'] as String)
        .toList();

    if (expiredIds.isEmpty) return 0;

    // Delete related data first (cascade may not be set up)
    // Delete views
    await _client
        .from('story_views')
        .delete()
        .inFilter('story_id', expiredIds);

    // Delete reactions
    await _client
        .from('story_reactions')
        .delete()
        .inFilter('story_id', expiredIds);

    // Delete replies
    await _client
        .from('story_replies')
        .delete()
        .inFilter('story_id', expiredIds);

    // Delete polls and their data
    final pollsResponse = await _client
        .from('story_polls')
        .select('id')
        .inFilter('story_id', expiredIds);

    final pollIds = (pollsResponse as List)
        .map((json) => json['id'] as String)
        .toList();

    if (pollIds.isNotEmpty) {
      // Delete poll votes
      await _client
          .from('poll_votes')
          .delete()
          .inFilter('poll_id', pollIds);

      // Delete poll options
      await _client
          .from('poll_options')
          .delete()
          .inFilter('poll_id', pollIds);

      // Delete polls
      await _client
          .from('story_polls')
          .delete()
          .inFilter('story_id', expiredIds);
    }

    // Finally delete the stories
    await _client
        .from('stories')
        .delete()
        .inFilter('id', expiredIds);

    return expiredIds.length;
  }

  /// Clean up expired stories for current user only
  /// More efficient for on-demand cleanup
  Future<int> cleanupMyExpiredStories() async {
    final userId = _currentUserId;
    if (userId == null) return 0;

    final expiredResponse = await _client
        .from('stories')
        .select('id')
        .eq('user_id', userId)
        .lt('expires_at', DateTime.now().toIso8601String());

    final expiredIds = (expiredResponse as List)
        .map((json) => json['id'] as String)
        .toList();

    if (expiredIds.isEmpty) return 0;

    // Delete the user's expired stories
    // Related data will be cleaned up by cascade or left orphaned
    await _client
        .from('stories')
        .delete()
        .inFilter('id', expiredIds);

    return expiredIds.length;
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
