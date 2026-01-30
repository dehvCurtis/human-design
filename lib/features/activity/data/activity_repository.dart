import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/activity.dart';

/// Repository for friend activity feed operations
class ActivityRepository {
  ActivityRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Activity Feed ====================

  /// Get activity feed from friends/followed users
  Future<List<Activity>> getFriendActivityFeed({
    int limit = 50,
    int offset = 0,
  }) async {
    final userId = _currentUserId;
    if (userId == null) return [];

    // Get activities from users that the current user follows
    final response = await _client
        .from('activities')
        .select('''
          *,
          user:profiles!activities_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .inFilter('user_id', [
          // Get followed user IDs via RPC or subquery
          await _client.rpc('get_following_ids', params: {'user_id': userId}),
        ])
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => Activity.fromJson(json))
        .toList();
  }

  /// Get activity feed using a direct query (alternative approach)
  Future<List<Activity>> getFriendActivities({
    int limit = 50,
    int offset = 0,
  }) async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client.rpc('get_friend_activities', params: {
      'current_user_id': userId,
      'limit_count': limit,
      'offset_count': offset,
    });

    return (response as List)
        .map((json) => Activity.fromJson(json))
        .toList();
  }

  /// Get a user's own activity
  Future<List<Activity>> getUserActivity(
    String userId, {
    int limit = 20,
  }) async {
    final response = await _client
        .from('activities')
        .select('''
          *,
          user:profiles!activities_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => Activity.fromJson(json))
        .toList();
  }

  // ==================== Create Activity ====================

  /// Record an activity (typically called by other services)
  Future<Activity> createActivity({
    required ActivityType activityType,
    String? targetId,
    String? targetName,
    Map<String, dynamic>? metadata,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('activities').insert({
      'user_id': userId,
      'activity_type': activityType.dbValue,
      'target_id': targetId,
      'target_name': targetName,
      'metadata': metadata,
    }).select('''
          *,
          user:profiles!activities_user_id_fkey(id, name, avatar_url, hd_type)
        ''').single();

    return Activity.fromJson(response);
  }

  // ==================== Reactions ====================

  /// React to an activity (e.g., "celebrate" a friend's achievement)
  Future<void> reactToActivity(
    String activityId, {
    String reactionType = 'celebrate',
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Upsert to prevent duplicate reactions
    await _client.from('activity_reactions').upsert({
      'activity_id': activityId,
      'user_id': userId,
      'reaction_type': reactionType,
    }, onConflict: 'activity_id,user_id');
  }

  /// Remove reaction from an activity
  Future<void> removeReaction(String activityId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('activity_reactions')
        .delete()
        .eq('activity_id', activityId)
        .eq('user_id', userId);
  }

  /// Check if user has reacted to an activity
  Future<bool> hasReacted(String activityId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('activity_reactions')
        .select('id')
        .eq('activity_id', activityId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Get reaction count for an activity
  Future<int> getReactionCount(String activityId) async {
    final response = await _client
        .from('activity_reactions')
        .select('id')
        .eq('activity_id', activityId);

    return (response as List).length;
  }

  // ==================== Realtime ====================

  /// Subscribe to new activities from friends
  RealtimeChannel subscribeToFriendActivities(
    void Function(Activity activity) onNewActivity,
  ) {
    final userId = _currentUserId;
    if (userId == null) {
      throw StateError('User not authenticated');
    }

    return _client
        .channel('friend_activities:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'activities',
          callback: (payload) async {
            // Check if this is from a followed user
            final activityUserId = payload.newRecord['user_id'] as String;
            final isFollowing = await _isFollowing(activityUserId);

            if (isFollowing) {
              final activity = await _getActivityById(payload.newRecord['id'] as String);
              if (activity != null) {
                onNewActivity(activity);
              }
            }
          },
        )
        .subscribe();
  }

  // ==================== Helper Methods ====================

  Future<bool> _isFollowing(String targetUserId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('user_follows')
        .select('id')
        .eq('follower_id', userId)
        .eq('following_id', targetUserId)
        .maybeSingle();

    return response != null;
  }

  Future<Activity?> _getActivityById(String activityId) async {
    final response = await _client
        .from('activities')
        .select('''
          *,
          user:profiles!activities_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('id', activityId)
        .maybeSingle();

    if (response == null) return null;
    return Activity.fromJson(response);
  }
}
