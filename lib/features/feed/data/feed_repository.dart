import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/post.dart';

/// Repository for content feed operations
class FeedRepository {
  FeedRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Posts ====================

  /// Get the main feed (posts from followed users + public posts)
  Future<List<Post>> getFeed({int limit = 20, int offset = 0}) async {
    final userId = _currentUserId;

    // Get posts from followed users and public posts
    final response = await _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .or('visibility.eq.public${userId != null ? ',user_id.in.(select following_id from user_follows where follower_id=eq.$userId)' : ''}')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    final posts = (response as List)
        .map((json) => Post.fromJson(json))
        .toList();

    // Get user's reactions for these posts
    if (userId != null && posts.isNotEmpty) {
      final postIds = posts.map((p) => p.id).toList();
      final reactions = await _getUserReactionsForPosts(postIds);

      return posts.map((post) {
        return post.copyWith(userReaction: reactions[post.id]);
      }).toList();
    }

    return posts;
  }

  /// Get posts by a specific user
  Future<List<Post>> getUserPosts(String userId, {int limit = 20, int offset = 0}) async {
    final currentUserId = _currentUserId;
    final isOwnProfile = currentUserId == userId;

    var query = _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('user_id', userId);

    // Only show public posts if not own profile
    if (!isOwnProfile) {
      query = query.eq('visibility', 'public');
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  /// Get a single post by ID
  Future<Post?> getPost(String postId) async {
    final response = await _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('id', postId)
        .maybeSingle();

    if (response == null) return null;

    final post = Post.fromJson(response);

    // Get user's reaction
    final userId = _currentUserId;
    if (userId != null) {
      final reaction = await _getUserReactionForPost(postId);
      return post.copyWith(userReaction: reaction);
    }

    return post;
  }

  /// Create a new post
  Future<Post> createPost({
    required String content,
    required PostType postType,
    PostVisibility visibility = PostVisibility.public,
    List<String>? mediaUrls,
    String? chartId,
    int? gateNumber,
    String? channelId,
    Map<String, dynamic>? transitData,
    String? badgeId,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('posts').insert({
      'user_id': userId,
      'content': content,
      'post_type': postType.dbValue,
      'visibility': visibility.name,
      'media_urls': mediaUrls,
      'chart_id': chartId,
      'gate_number': gateNumber,
      'channel_id': channelId,
      'transit_data': transitData,
      'badge_id': badgeId,
    }).select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''').single();

    return Post.fromJson(response);
  }

  /// Update a post
  Future<Post> updatePost({
    required String postId,
    String? content,
    PostVisibility? visibility,
    bool? isPinned,
  }) async {
    final updates = <String, dynamic>{};
    if (content != null) updates['content'] = content;
    if (visibility != null) updates['visibility'] = visibility.name;
    if (isPinned != null) updates['is_pinned'] = isPinned;

    final response = await _client
        .from('posts')
        .update(updates)
        .eq('id', postId)
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .single();

    return Post.fromJson(response);
  }

  /// Delete a post
  Future<void> deletePost(String postId) async {
    await _client.from('posts').delete().eq('id', postId);
  }

  // ==================== Reactions ====================

  /// Add a reaction to a post
  Future<void> addReaction(String postId, ReactionType reactionType) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Remove existing reaction first (if any)
    await _client
        .from('reactions')
        .delete()
        .eq('user_id', userId)
        .eq('post_id', postId);

    // Add new reaction
    await _client.from('reactions').insert({
      'user_id': userId,
      'post_id': postId,
      'reaction_type': reactionType.dbValue,
    });
  }

  /// Remove a reaction from a post
  Future<void> removeReaction(String postId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('reactions')
        .delete()
        .eq('user_id', userId)
        .eq('post_id', postId);
  }

  /// Get reaction counts for a post
  Future<Map<ReactionType, int>> getReactionCounts(String postId) async {
    final response = await _client
        .from('reactions')
        .select('reaction_type')
        .eq('post_id', postId);

    final counts = <ReactionType, int>{};
    for (final json in response as List) {
      final type = _parseReactionType(json['reaction_type'] as String);
      counts[type] = (counts[type] ?? 0) + 1;
    }

    return counts;
  }

  // ==================== Comments ====================

  /// Get comments for a post
  Future<List<PostComment>> getPostComments(String postId) async {
    final response = await _client
        .from('post_comments')
        .select('''
          *,
          user:profiles!post_comments_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('post_id', postId)
        .isFilter('parent_id', null)
        .order('created_at', ascending: true);

    final comments =
        (response as List).map((json) => PostComment.fromJson(json)).toList();

    // Get replies for each comment
    final commentIds = comments.map((c) => c.id).toList();
    if (commentIds.isNotEmpty) {
      final repliesResponse = await _client
          .from('post_comments')
          .select('''
            *,
            user:profiles!post_comments_user_id_fkey(id, name, avatar_url)
          ''')
          .inFilter('parent_id', commentIds)
          .order('created_at', ascending: true);

      final replies = (repliesResponse as List)
          .map((json) => PostComment.fromJson(json))
          .toList();

      // Group replies by parent
      final repliesByParent = <String, List<PostComment>>{};
      for (final reply in replies) {
        repliesByParent
            .putIfAbsent(reply.parentId!, () => [])
            .add(reply);
      }

      // Attach replies to comments
      return comments.map((comment) {
        return comment.copyWith(
          replies: repliesByParent[comment.id] ?? [],
        );
      }).toList();
    }

    return comments;
  }

  /// Add a comment to a post
  Future<PostComment> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('post_comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'parent_id': parentId,
    }).select('''
          *,
          user:profiles!post_comments_user_id_fkey(id, name, avatar_url)
        ''').single();

    return PostComment.fromJson(response);
  }

  /// Update a comment
  Future<PostComment> updateComment({
    required String commentId,
    required String content,
  }) async {
    final response = await _client
        .from('post_comments')
        .update({'content': content})
        .eq('id', commentId)
        .select('''
          *,
          user:profiles!post_comments_user_id_fkey(id, name, avatar_url)
        ''')
        .single();

    return PostComment.fromJson(response);
  }

  /// Delete a comment
  Future<void> deleteComment(String commentId) async {
    await _client.from('post_comments').delete().eq('id', commentId);
  }

  // ==================== Realtime ====================

  /// Subscribe to new posts in feed
  RealtimeChannel subscribeToFeed(void Function(Post post) onNewPost) {
    return _client
        .channel('public_posts')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'posts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'visibility',
            value: 'public',
          ),
          callback: (payload) async {
            // Fetch full post with user data
            final post = await getPost(payload.newRecord['id'] as String);
            if (post != null) {
              onNewPost(post);
            }
          },
        )
        .subscribe();
  }

  /// Subscribe to reactions on a specific post
  RealtimeChannel subscribeToPostReactions(
    String postId,
    void Function(int count) onReactionChange,
  ) {
    return _client
        .channel('post_reactions:$postId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'reactions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'post_id',
            value: postId,
          ),
          callback: (payload) async {
            // Get updated count
            final response = await _client
                .from('posts')
                .select('reaction_count')
                .eq('id', postId)
                .single();
            onReactionChange(response['reaction_count'] as int);
          },
        )
        .subscribe();
  }

  // ==================== Helper Methods ====================

  Future<Map<String, ReactionType>> _getUserReactionsForPosts(
      List<String> postIds) async {
    final userId = _currentUserId;
    if (userId == null) return {};

    final response = await _client
        .from('reactions')
        .select('post_id, reaction_type')
        .eq('user_id', userId)
        .inFilter('post_id', postIds);

    final reactions = <String, ReactionType>{};
    for (final json in response as List) {
      reactions[json['post_id'] as String] =
          _parseReactionType(json['reaction_type'] as String);
    }

    return reactions;
  }

  Future<ReactionType?> _getUserReactionForPost(String postId) async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('reactions')
        .select('reaction_type')
        .eq('user_id', userId)
        .eq('post_id', postId)
        .maybeSingle();

    if (response == null) return null;
    return _parseReactionType(response['reaction_type'] as String);
  }

  ReactionType _parseReactionType(String value) {
    switch (value) {
      case 'like':
        return ReactionType.like;
      case 'love':
        return ReactionType.love;
      case 'insight':
        return ReactionType.insight;
      case 'resonate':
        return ReactionType.resonate;
      case 'generator_sacral':
        return ReactionType.generatorSacral;
      case 'projector_recognition':
        return ReactionType.projectorRecognition;
      case 'manifestor_peace':
        return ReactionType.manifestorPeace;
      case 'reflector_surprise':
        return ReactionType.reflectorSurprise;
      case 'mg_satisfaction':
        return ReactionType.mgSatisfaction;
      default:
        return ReactionType.like;
    }
  }
}
