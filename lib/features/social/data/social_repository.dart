import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for social features (sharing, comments, groups)
class SocialRepository {
  SocialRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  /// Maximum allowed comment content length (matches DB constraint)
  static const int maxCommentLength = 2000;

  // ==================== Sharing ====================

  /// Share chart with a group
  Future<ShareRecord> shareChartWithGroup({
    required String chartId,
    required String groupId,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('shares').insert({
      'chart_id': chartId,
      'shared_by': userId,
      'group_id': groupId,
      'share_type': 'group',
    }).select().single();

    return ShareRecord.fromJson(response);
  }

  /// Get charts shared with me
  Future<List<SharedChart>> getChartsSharedWithMe() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('shares')
        .select('''
          id,
          chart:charts(id, name, type),
          shared_by:profiles!shares_shared_by_fkey(id, name, avatar_url),
          created_at
        ''')
        .eq('shared_with', userId);

    return (response as List)
        .map((json) => SharedChart.fromJson(json))
        .toList();
  }

  /// Revoke a share
  Future<void> revokeShare(String shareId) async {
    await _client.from('shares').delete().eq('id', shareId);
  }

  // ==================== Comments ====================

  /// Get comments for a chart
  Future<List<Comment>> getChartComments(String chartId) async {
    final response = await _client
        .from('comments')
        .select('''
          id,
          content,
          element_type,
          element_id,
          author:profiles!comments_user_id_fkey(id, name, avatar_url),
          parent_id,
          created_at,
          updated_at
        ''')
        .eq('chart_id', chartId)
        .order('created_at', ascending: true);

    return (response as List).map((json) => Comment.fromJson(json)).toList();
  }

  /// Add a comment to a chart
  ///
  /// Enforces content length limit (defense-in-depth; DB also enforces via CHECK).
  Future<Comment> addComment({
    required String chartId,
    required String content,
    String? elementType, // 'gate', 'channel', 'center'
    String? elementId,
    String? parentId, // For replies
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    if (content.length > maxCommentLength) {
      throw ArgumentError(
        'Comment exceeds maximum length of $maxCommentLength characters',
      );
    }

    final response = await _client.from('comments').insert({
      'chart_id': chartId,
      'user_id': userId,
      'content': content,
      'element_type': elementType,
      'element_id': elementId,
      'parent_id': parentId,
    }).select('''
          id,
          content,
          element_type,
          element_id,
          author:profiles!comments_user_id_fkey(id, name, avatar_url),
          parent_id,
          created_at,
          updated_at
        ''').single();

    return Comment.fromJson(response);
  }

  /// Update a comment
  Future<void> updateComment({
    required String commentId,
    required String content,
  }) async {
    if (content.length > maxCommentLength) {
      throw ArgumentError(
        'Comment exceeds maximum length of $maxCommentLength characters',
      );
    }

    await _client.from('comments').update({
      'content': content,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', commentId);
  }

  /// Delete a comment
  Future<void> deleteComment(String commentId) async {
    await _client.from('comments').delete().eq('id', commentId);
  }

  // ==================== Groups ====================

  /// Get user's groups
  Future<List<Group>> getGroups() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('group_members')
        .select('''
          group:groups(id, name, description, avatar_url, created_at),
          role
        ''')
        .eq('user_id', userId);

    return (response as List).map((json) {
      final group = Group.fromJson(json['group']);
      return group.copyWith(userRole: json['role']);
    }).toList();
  }

  /// Create a new group
  Future<Group> createGroup({
    required String name,
    String? description,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    // Create group
    final groupResponse = await _client.from('groups').insert({
      'name': name,
      'description': description,
      'created_by': userId,
    }).select().single();

    final group = Group.fromJson(groupResponse);

    // Add creator as admin
    await _client.from('group_members').insert({
      'group_id': group.id,
      'user_id': userId,
      'role': 'admin',
    });

    return group;
  }

  /// Add member to group
  ///
  /// Only the current user can add themselves, or a group admin can add others.
  /// Server-side RLS enforces this, but we also validate client-side.
  Future<void> addGroupMember({
    required String groupId,
    required String userId,
    String role = 'member',
  }) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) throw StateError('User not authenticated');

    // If adding someone other than yourself, verify caller is an admin
    if (userId != currentUserId) {
      final adminCheck = await _client
          .from('group_members')
          .select('role')
          .eq('group_id', groupId)
          .eq('user_id', currentUserId)
          .maybeSingle();

      if (adminCheck == null || adminCheck['role'] != 'admin') {
        throw StateError('Only group admins can add other members');
      }
    }

    await _client.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
      'role': role,
    });
  }

  /// Remove member from group
  Future<void> removeGroupMember({
    required String groupId,
    required String userId,
  }) async {
    await _client
        .from('group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId);
  }

  /// Get group members
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    final response = await _client
        .from('group_members')
        .select('''
          user:profiles(id, name, avatar_url),
          role,
          joined_at:created_at
        ''')
        .eq('group_id', groupId);

    return (response as List)
        .map((json) => GroupMember.fromJson(json))
        .toList();
  }

  // ==================== Realtime ====================

  /// Subscribe to comments for a chart
  RealtimeChannel subscribeToChartComments(
    String chartId,
    void Function(Comment comment) onNewComment,
  ) {
    return _client
        .channel('comments:$chartId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'comments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chart_id',
            value: chartId,
          ),
          callback: (payload) {
            final comment = Comment.fromJson(payload.newRecord);
            onNewComment(comment);
          },
        )
        .subscribe();
  }
}

// ==================== Models ====================

class ShareRecord {
  const ShareRecord({
    required this.id,
    required this.chartId,
    required this.sharedBy,
    this.sharedWith,
    this.groupId,
    required this.shareType,
    required this.createdAt,
  });

  final String id;
  final String chartId;
  final String sharedBy;
  final String? sharedWith;
  final String? groupId;
  final String shareType;
  final DateTime createdAt;

  factory ShareRecord.fromJson(Map<String, dynamic> json) {
    return ShareRecord(
      id: json['id'] as String,
      chartId: json['chart_id'] as String,
      sharedBy: json['shared_by'] as String,
      sharedWith: json['shared_with'] as String?,
      groupId: json['group_id'] as String?,
      shareType: json['share_type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class SharedChart {
  const SharedChart({
    required this.id,
    required this.chartId,
    required this.chartName,
    required this.chartType,
    required this.sharedById,
    required this.sharedByName,
    this.sharedByAvatarUrl,
    required this.createdAt,
  });

  final String id;
  final String chartId;
  final String chartName;
  final String chartType;
  final String sharedById;
  final String sharedByName;
  final String? sharedByAvatarUrl;
  final DateTime createdAt;

  factory SharedChart.fromJson(Map<String, dynamic> json) {
    final chart = json['chart'] as Map<String, dynamic>;
    final sharedBy = json['shared_by'] as Map<String, dynamic>;
    return SharedChart(
      id: json['id'] as String,
      chartId: chart['id'] as String,
      chartName: chart['name'] as String,
      chartType: chart['type'] as String,
      sharedById: sharedBy['id'] as String,
      sharedByName: sharedBy['name'] as String? ?? 'Unknown',
      sharedByAvatarUrl: sharedBy['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class Comment {
  const Comment({
    required this.id,
    required this.content,
    this.elementType,
    this.elementId,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    this.parentId,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String content;
  final String? elementType;
  final String? elementId;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String? parentId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get isReply => parentId != null;
  bool get isContextual => elementType != null && elementId != null;

  factory Comment.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return Comment(
      id: json['id'] as String,
      content: json['content'] as String,
      elementType: json['element_type'] as String?,
      elementId: json['element_id'] as String?,
      authorId: author?['id'] as String? ?? '',
      authorName: author?['name'] as String? ?? 'Unknown',
      authorAvatarUrl: author?['avatar_url'] as String?,
      parentId: json['parent_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

class Group {
  const Group({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    required this.createdAt,
    this.userRole,
  });

  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final DateTime createdAt;
  final String? userRole;

  bool get isAdmin => userRole == 'admin';

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarUrl,
    DateTime? createdAt,
    String? userRole,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      userRole: userRole ?? this.userRole,
    );
  }
}

class GroupMember {
  const GroupMember({
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
  });

  final String userId;
  final String name;
  final String? avatarUrl;
  final String role;
  final DateTime joinedAt;

  bool get isAdmin => role == 'admin';

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return GroupMember(
      userId: user['id'] as String,
      name: user['name'] as String? ?? 'Unknown',
      avatarUrl: user['avatar_url'] as String?,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }
}
