import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/post.dart';

/// Repository for content feed operations
class FeedRepository {
  FeedRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  /// Maximum allowed post content length
  static const int maxPostLength = 5000;

  /// Maximum allowed comment length
  static const int maxCommentLength = 2000;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Posts ====================

  /// Get the main feed (posts from followed users + public posts)
  /// Includes original post data for regenerated posts
  Future<List<Post>> getFeed({int limit = 20, int offset = 0}) async {
    final userId = _currentUserId;

    // Build the query for posts
    var query = _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type),
          original_post:posts!original_post_id(
            *,
            user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
          )
        ''');

    // If user is logged in, get posts from followed users + public posts
    if (userId != null) {
      // First get the list of followed user IDs
      final followsResponse = await _client
          .from('user_follows')
          .select('following_id')
          .eq('follower_id', userId);

      final followedIds = (followsResponse as List)
          .map((f) => f['following_id'] as String)
          .toList();

      if (followedIds.isNotEmpty) {
        // Show public posts OR posts from followed users
        query = query.or('visibility.eq.public,user_id.in.(${followedIds.join(",")})');
      } else {
        // No follows, just show public posts
        query = query.eq('visibility', 'public');
      }
    } else {
      // Not logged in, just show public posts
      query = query.eq('visibility', 'public');
    }

    final response = await query
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
  /// Includes original post data for regenerated posts
  Future<List<Post>> getUserPosts(String userId, {int limit = 20, int offset = 0}) async {
    final currentUserId = _currentUserId;
    final isOwnProfile = currentUserId == userId;

    var query = _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type),
          original_post:posts!original_post_id(
            *,
            user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
          )
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
  /// Includes original post data for regenerated posts
  Future<Post?> getPost(String postId) async {
    final response = await _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type),
          original_post:posts!original_post_id(
            *,
            user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
          )
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
  ///
  /// Enforces content length limits to prevent abuse.
  Future<Post> createPost({
    required String content,
    required PostType postType,
    PostVisibility visibility = PostVisibility.public,
    List<String>? mediaUrls,
    String? chartId,
    Map<String, dynamic>? chartData,
    int? gateNumber,
    String? channelId,
    Map<String, dynamic>? transitData,
    String? badgeId,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Enforce content length limit
    if (content.length > maxPostLength) {
      throw ArgumentError('Post content exceeds $maxPostLength characters');
    }

    final insertData = <String, dynamic>{
      'user_id': userId,
      'content': content,
      'post_type': postType.dbValue,
      'visibility': visibility.name,
    };
    if (mediaUrls != null) insertData['media_urls'] = mediaUrls;
    if (chartId != null) insertData['chart_id'] = chartId;
    if (chartData != null) insertData['chart_data'] = chartData;
    if (gateNumber != null) insertData['gate_number'] = gateNumber;
    if (channelId != null) insertData['channel_id'] = channelId;
    if (transitData != null) insertData['transit_data'] = transitData;
    if (badgeId != null) insertData['badge_id'] = badgeId;

    final response = await _client
        .from('posts')
        .insert(insertData)
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .single();

    return Post.fromJson(response);
  }

  /// Update a post (ownership enforced by filtering on user_id + RLS)
  Future<Post> updatePost({
    required String postId,
    String? content,
    PostVisibility? visibility,
    bool? isPinned,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Validate content length on update (same as create)
    if (content != null && content.length > maxPostLength) {
      throw ArgumentError('Post content exceeds $maxPostLength characters');
    }

    final updates = <String, dynamic>{};
    if (content != null) updates['content'] = content;
    if (visibility != null) updates['visibility'] = visibility.name;
    if (isPinned != null) updates['is_pinned'] = isPinned;

    final response = await _client
        .from('posts')
        .update(updates)
        .eq('id', postId)
        .eq('user_id', userId)
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .single();

    return Post.fromJson(response);
  }

  /// Delete a post (ownership enforced by filtering on user_id + RLS)
  Future<void> deletePost(String postId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('posts')
        .delete()
        .eq('id', postId)
        .eq('user_id', userId);
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
    final userId = _currentUserId;

    final response = await _client
        .from('post_comments')
        .select('''
          *,
          user:profiles!post_comments_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('post_id', postId)
        .isFilter('parent_id', null)
        .order('created_at', ascending: true);

    var comments =
        (response as List).map((json) => PostComment.fromJson(json)).toList();

    // Get replies for each comment
    final commentIds = comments.map((c) => c.id).toList();
    List<PostComment> allReplies = [];

    if (commentIds.isNotEmpty) {
      final repliesResponse = await _client
          .from('post_comments')
          .select('''
            *,
            user:profiles!post_comments_user_id_fkey(id, name, avatar_url)
          ''')
          .inFilter('parent_id', commentIds)
          .order('created_at', ascending: true);

      allReplies = (repliesResponse as List)
          .map((json) => PostComment.fromJson(json))
          .toList();
    }

    // Get user's reactions for all comments and replies
    if (userId != null) {
      final allCommentIds = [...commentIds, ...allReplies.map((r) => r.id)];
      if (allCommentIds.isNotEmpty) {
        final userReactions = await _getUserCommentReactions(allCommentIds);

        // Attach reactions to top-level comments
        comments = comments.map((comment) {
          return comment.copyWith(userReaction: userReactions[comment.id]);
        }).toList();

        // Attach reactions to replies
        allReplies = allReplies.map((reply) {
          return reply.copyWith(userReaction: userReactions[reply.id]);
        }).toList();
      }
    }

    // Group replies by parent and attach to comments
    if (allReplies.isNotEmpty) {
      final repliesByParent = <String, List<PostComment>>{};
      for (final reply in allReplies) {
        repliesByParent
            .putIfAbsent(reply.parentId!, () => [])
            .add(reply);
      }

      return comments.map((comment) {
        return comment.copyWith(
          replies: repliesByParent[comment.id] ?? [],
        );
      }).toList();
    }

    return comments;
  }

  /// Add a comment to a post
  ///
  /// Enforces content length limits to prevent abuse.
  Future<PostComment> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Enforce content length limit
    if (content.length > maxCommentLength) {
      throw ArgumentError('Comment exceeds $maxCommentLength characters');
    }

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

  /// Update a comment (ownership enforced by filtering on user_id + RLS)
  Future<PostComment> updateComment({
    required String commentId,
    required String content,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    if (content.length > maxCommentLength) {
      throw ArgumentError('Comment exceeds $maxCommentLength characters');
    }

    final response = await _client
        .from('post_comments')
        .update({'content': content})
        .eq('id', commentId)
        .eq('user_id', userId)
        .select('''
          *,
          user:profiles!post_comments_user_id_fkey(id, name, avatar_url)
        ''')
        .single();

    return PostComment.fromJson(response);
  }

  /// Delete a comment (ownership enforced by filtering on user_id + RLS)
  Future<void> deleteComment(String commentId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('post_comments')
        .delete()
        .eq('id', commentId)
        .eq('user_id', userId);
  }

  // ==================== Comment Reactions ====================

  /// Add a reaction to a comment
  Future<void> addCommentReaction(String commentId, ReactionType reactionType) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Remove existing reaction first (if any)
    await _client
        .from('reactions')
        .delete()
        .eq('user_id', userId)
        .eq('comment_id', commentId);

    // Add new reaction
    await _client.from('reactions').insert({
      'user_id': userId,
      'comment_id': commentId,
      'reaction_type': reactionType.dbValue,
    });
  }

  /// Remove a reaction from a comment
  Future<void> removeCommentReaction(String commentId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('reactions')
        .delete()
        .eq('user_id', userId)
        .eq('comment_id', commentId);
  }

  /// Get user's reactions for a list of comments
  Future<Map<String, ReactionType>> _getUserCommentReactions(List<String> commentIds) async {
    final userId = _currentUserId;
    if (userId == null) return {};

    final response = await _client
        .from('reactions')
        .select('comment_id, reaction_type')
        .eq('user_id', userId)
        .inFilter('comment_id', commentIds);

    final reactions = <String, ReactionType>{};
    for (final json in response as List) {
      reactions[json['comment_id'] as String] =
          _parseReactionType(json['reaction_type'] as String);
    }

    return reactions;
  }

  // ==================== Regenerate (Repost) ====================

  /// Regenerate (repost) a thought to your wall
  /// Creates a new post that references the original post
  Future<Post> regeneratePost({
    required String originalPostId,
    String? additionalComment,
    PostVisibility visibility = PostVisibility.public,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Get the original post to verify it exists and is public/accessible
    final originalPost = await getPost(originalPostId);
    if (originalPost == null) {
      throw StateError('Original post not found');
    }

    // Can't regenerate your own post
    if (originalPost.userId == userId) {
      throw StateError('Cannot regenerate your own post');
    }

    // Create the regenerate post
    final response = await _client.from('posts').insert({
      'user_id': userId,
      'content': additionalComment ?? '',
      'post_type': PostType.regenerate.dbValue,
      'visibility': visibility.name,
      'original_post_id': originalPostId,
      'is_regenerate': true,
    }).select('''
      *,
      user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type),
      original_post:posts!original_post_id(
        *,
        user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
      )
    ''').single();

    return Post.fromJson(response);
  }

  /// Get user's wall (their thoughts + regenerated thoughts)
  /// Shows both original posts and regenerated posts
  Future<List<Post>> getUserWall(String userId, {int limit = 20, int offset = 0}) async {
    final currentUserId = _currentUserId;
    final isOwnProfile = currentUserId == userId;

    var query = _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type),
          original_post:posts!original_post_id(
            *,
            user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
          )
        ''')
        .eq('user_id', userId);

    // Only show public posts if not own profile
    if (!isOwnProfile) {
      query = query.eq('visibility', 'public');
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    final posts = (response as List).map((json) => Post.fromJson(json)).toList();

    // Get user's reactions for these posts
    if (currentUserId != null && posts.isNotEmpty) {
      final postIds = posts.map((p) => p.id).toList();
      final reactions = await _getUserReactionsForPosts(postIds);

      return posts.map((post) {
        return post.copyWith(userReaction: reactions[post.id]);
      }).toList();
    }

    return posts;
  }

  /// Check if the current user can regenerate a post
  /// Returns false if: post doesn't exist, user owns the post, or user already regenerated it
  Future<bool> canRegeneratePost(String postId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    // Get the post
    final post = await getPost(postId);
    if (post == null) return false;

    // Can't regenerate own post
    if (post.userId == userId) return false;

    // Check if user already regenerated this post
    final existingRegenerate = await _client
        .from('posts')
        .select('id')
        .eq('user_id', userId)
        .eq('original_post_id', postId)
        .eq('is_regenerate', true)
        .maybeSingle();

    return existingRegenerate == null;
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

  // ==================== Type/Channel Discussion Feeds ====================

  /// Get posts filtered by HD type.
  /// Users posting in type-specific feeds must have that type in their profile.
  Future<List<Post>> getPostsByType({
    required String hdType,
    int limit = 20,
    int offset = 0,
  }) async {
    // Validate hdType to prevent injection
    const validTypes = [
      'Manifestor',
      'Generator',
      'Manifesting Generator',
      'Projector',
      'Reflector',
    ];
    if (!validTypes.contains(hdType)) {
      throw ArgumentError('Invalid HD type: $hdType');
    }

    final data = await _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('visibility', 'public')
        .eq('user.hd_type', hdType)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return data.map((json) => Post.fromJson(json)).toList();
  }

  /// Get posts that mention a specific channel (by gate numbers).
  /// Searches for channel references in post content.
  Future<List<Post>> getPostsByChannel({
    required int gate1,
    required int gate2,
    int limit = 20,
    int offset = 0,
  }) async {
    // Validate gate numbers
    if (gate1 < 1 || gate1 > 64 || gate2 < 1 || gate2 > 64) {
      throw ArgumentError('Invalid gate numbers');
    }

    final channelId = '$gate1-$gate2';
    final reverseChannelId = '$gate2-$gate1';

    // Search for posts mentioning this channel
    final data = await _client
        .from('posts')
        .select('''
          *,
          user:profiles!posts_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('visibility', 'public')
        .or('content.ilike.%$channelId%,content.ilike.%$reverseChannelId%')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return data.map((json) => Post.fromJson(json)).toList();
  }
}
