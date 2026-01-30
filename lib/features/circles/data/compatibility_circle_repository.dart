import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/compatibility_circle.dart';

/// Repository for Compatibility Circles operations
class CompatibilityCircleRepository {
  CompatibilityCircleRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Circles ====================

  /// Create a new compatibility circle
  Future<CompatibilityCircle> createCircle({
    required String name,
    String? description,
    String? iconEmoji,
    bool isPrivate = true,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('compatibility_circles').insert({
      'name': name,
      'description': description,
      'icon_emoji': iconEmoji,
      'creator_id': userId,
      'is_private': isPrivate,
    }).select().single();

    final circle = CompatibilityCircle.fromJson(response);

    // Add creator as member
    await addMember(circle.id, userId, role: CircleRole.creator);

    return circle;
  }

  /// Get a circle by ID
  Future<CompatibilityCircle?> getCircle(String circleId) async {
    final response = await _client
        .from('compatibility_circles')
        .select()
        .eq('id', circleId)
        .maybeSingle();

    if (response == null) return null;
    return CompatibilityCircle.fromJson(response);
  }

  /// Get user's circles
  Future<List<CompatibilityCircle>> getMyCircles() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('circle_members')
        .select('circle:compatibility_circles(*)')
        .eq('user_id', userId)
        .order('joined_at', ascending: false);

    return (response as List)
        .map((json) => CompatibilityCircle.fromJson(json['circle'] as Map<String, dynamic>))
        .toList();
  }

  /// Update a circle
  Future<void> updateCircle({
    required String circleId,
    String? name,
    String? description,
    String? iconEmoji,
    bool? isPrivate,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;
    if (iconEmoji != null) updates['icon_emoji'] = iconEmoji;
    if (isPrivate != null) updates['is_private'] = isPrivate;

    if (updates.isEmpty) return;

    await _client
        .from('compatibility_circles')
        .update(updates)
        .eq('id', circleId);
  }

  /// Delete a circle
  Future<void> deleteCircle(String circleId) async {
    await _client.from('compatibility_circles').delete().eq('id', circleId);
  }

  // ==================== Members ====================

  /// Add a member to a circle
  Future<void> addMember(
    String circleId,
    String userId, {
    CircleRole role = CircleRole.member,
  }) async {
    await _client.from('circle_members').insert({
      'circle_id': circleId,
      'user_id': userId,
      'role': role.dbValue,
    });

    // Update member count
    await _client.rpc('increment_circle_member_count', params: {
      'target_circle_id': circleId,
    });
  }

  /// Remove a member from a circle
  Future<void> removeMember(String circleId, String userId) async {
    await _client
        .from('circle_members')
        .delete()
        .eq('circle_id', circleId)
        .eq('user_id', userId);

    // Update member count
    await _client.rpc('decrement_circle_member_count', params: {
      'target_circle_id': circleId,
    });
  }

  /// Get circle members
  Future<List<CircleMember>> getCircleMembers(String circleId) async {
    final response = await _client
        .from('circle_members')
        .select('''
          *,
          user:profiles!circle_members_user_id_fkey(id, name, avatar_url, hd_type, hd_authority, hd_profile)
        ''')
        .eq('circle_id', circleId)
        .order('joined_at', ascending: true);

    return (response as List)
        .map((json) => CircleMember.fromJson(json))
        .toList();
  }

  /// Check if user is a member of a circle
  Future<bool> isMember(String circleId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('circle_members')
        .select('id')
        .eq('circle_id', circleId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Invite a user to a circle
  Future<void> inviteUser(String circleId, String email) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Find user by email
    final userResponse = await _client
        .from('profiles')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    if (userResponse == null) {
      throw Exception('User not found');
    }

    final inviteeId = userResponse['id'] as String;

    // Create invitation
    await _client.from('circle_invitations').insert({
      'circle_id': circleId,
      'inviter_id': userId,
      'invitee_id': inviteeId,
    });
  }

  /// Accept a circle invitation
  Future<void> acceptInvitation(String invitationId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Get invitation details
    final invitation = await _client
        .from('circle_invitations')
        .select()
        .eq('id', invitationId)
        .eq('invitee_id', userId)
        .single();

    // Add as member
    await addMember(invitation['circle_id'] as String, userId);

    // Delete invitation
    await _client.from('circle_invitations').delete().eq('id', invitationId);
  }

  /// Decline a circle invitation
  Future<void> declineInvitation(String invitationId) async {
    await _client.from('circle_invitations').delete().eq('id', invitationId);
  }

  /// Get pending invitations for current user
  Future<List<Map<String, dynamic>>> getPendingInvitations() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('circle_invitations')
        .select('''
          *,
          circle:compatibility_circles(*),
          inviter:profiles!circle_invitations_inviter_id_fkey(id, name, avatar_url)
        ''')
        .eq('invitee_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  // ==================== Circle Feed ====================

  /// Create a post in a circle's private feed
  Future<CirclePost> createPost({
    required String circleId,
    required String content,
    String? mediaUrl,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('circle_posts').insert({
      'circle_id': circleId,
      'user_id': userId,
      'content': content,
      'media_url': mediaUrl,
    }).select('''
          *,
          user:profiles!circle_posts_user_id_fkey(id, name, avatar_url)
        ''').single();

    return CirclePost.fromJson(response);
  }

  /// Get posts for a circle
  Future<List<CirclePost>> getCirclePosts(String circleId, {int limit = 50}) async {
    final response = await _client
        .from('circle_posts')
        .select('''
          *,
          user:profiles!circle_posts_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('circle_id', circleId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => CirclePost.fromJson(json))
        .toList();
  }

  /// Delete a post
  Future<void> deletePost(String postId) async {
    await _client.from('circle_posts').delete().eq('id', postId);
  }

  // ==================== Analysis ====================

  /// Get or generate compatibility analysis for a circle
  /// Note: This would typically call a backend function that computes the analysis
  Future<CircleCompatibilityAnalysis?> getCircleAnalysis(String circleId) async {
    final response = await _client
        .from('circle_compatibility_analyses')
        .select()
        .eq('circle_id', circleId)
        .order('analyzed_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return CircleCompatibilityAnalysis.fromJson(response);
  }

  /// Request a new compatibility analysis
  Future<void> requestAnalysis(String circleId) async {
    await _client.rpc('analyze_circle_compatibility', params: {
      'target_circle_id': circleId,
    });
  }

  // ==================== Realtime ====================

  /// Subscribe to circle updates
  RealtimeChannel subscribeToCircle(
    String circleId,
    void Function(CompatibilityCircle circle) onUpdate,
  ) {
    return _client
        .channel('circle:$circleId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'compatibility_circles',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: circleId,
          ),
          callback: (payload) {
            onUpdate(CompatibilityCircle.fromJson(payload.newRecord));
          },
        )
        .subscribe();
  }

  /// Subscribe to circle posts
  RealtimeChannel subscribeToCirclePosts(
    String circleId,
    void Function(CirclePost post) onNewPost,
  ) {
    return _client
        .channel('circle_posts:$circleId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'circle_posts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'circle_id',
            value: circleId,
          ),
          callback: (payload) async {
            // Fetch full post with user data
            final response = await _client
                .from('circle_posts')
                .select('''
                  *,
                  user:profiles!circle_posts_user_id_fkey(id, name, avatar_url)
                ''')
                .eq('id', payload.newRecord['id'] as String)
                .single();

            onNewPost(CirclePost.fromJson(response));
          },
        )
        .subscribe();
  }
}
