/// Models for the content feed feature

enum PostType {
  insight,
  reflection,
  transitShare,
  chartShare,
  question,
  achievement,
}

enum PostVisibility {
  public,
  followers,
  private,
}

enum ReactionType {
  like,
  love,
  insight,
  resonate,
  generatorSacral,
  projectorRecognition,
  manifestorPeace,
  reflectorSurprise,
  mgSatisfaction,
}

class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.userHdType,
    required this.content,
    required this.postType,
    required this.visibility,
    this.mediaUrls,
    this.chartId,
    this.gateNumber,
    this.channelId,
    this.transitData,
    this.badgeId,
    this.isPinned = false,
    required this.reactionCount,
    required this.commentCount,
    required this.shareCount,
    required this.createdAt,
    this.updatedAt,
    this.userReaction,
    this.reactions,
  });

  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? userHdType;
  final String content;
  final PostType postType;
  final PostVisibility visibility;
  final List<String>? mediaUrls;
  final String? chartId;
  final int? gateNumber;
  final String? channelId;
  final Map<String, dynamic>? transitData;
  final String? badgeId;
  final bool isPinned;
  final int reactionCount;
  final int commentCount;
  final int shareCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final ReactionType? userReaction;
  final Map<ReactionType, int>? reactions;

  factory Post.fromJson(Map<String, dynamic> json, {
    ReactionType? userReaction,
    Map<ReactionType, int>? reactions,
  }) {
    final user = json['user'] as Map<String, dynamic>?;

    return Post(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      userHdType: user?['hd_type'] as String?,
      content: json['content'] as String,
      postType: _parsePostType(json['post_type'] as String),
      visibility: _parseVisibility(json['visibility'] as String),
      mediaUrls: (json['media_urls'] as List<dynamic>?)?.cast<String>(),
      chartId: json['chart_id'] as String?,
      gateNumber: json['gate_number'] as int?,
      channelId: json['channel_id'] as String?,
      transitData: json['transit_data'] as Map<String, dynamic>?,
      badgeId: json['badge_id'] as String?,
      isPinned: json['is_pinned'] as bool? ?? false,
      reactionCount: json['reaction_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      shareCount: json['share_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      userReaction: userReaction,
      reactions: reactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'post_type': postType.name,
      'visibility': visibility.name,
      'media_urls': mediaUrls,
      'chart_id': chartId,
      'gate_number': gateNumber,
      'channel_id': channelId,
      'transit_data': transitData,
      'badge_id': badgeId,
      'is_pinned': isPinned,
    };
  }

  Post copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? userHdType,
    String? content,
    PostType? postType,
    PostVisibility? visibility,
    List<String>? mediaUrls,
    String? chartId,
    int? gateNumber,
    String? channelId,
    Map<String, dynamic>? transitData,
    String? badgeId,
    bool? isPinned,
    int? reactionCount,
    int? commentCount,
    int? shareCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReactionType? userReaction,
    Map<ReactionType, int>? reactions,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      userHdType: userHdType ?? this.userHdType,
      content: content ?? this.content,
      postType: postType ?? this.postType,
      visibility: visibility ?? this.visibility,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      chartId: chartId ?? this.chartId,
      gateNumber: gateNumber ?? this.gateNumber,
      channelId: channelId ?? this.channelId,
      transitData: transitData ?? this.transitData,
      badgeId: badgeId ?? this.badgeId,
      isPinned: isPinned ?? this.isPinned,
      reactionCount: reactionCount ?? this.reactionCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userReaction: userReaction ?? this.userReaction,
      reactions: reactions ?? this.reactions,
    );
  }

  static PostType _parsePostType(String value) {
    switch (value) {
      case 'insight':
        return PostType.insight;
      case 'reflection':
        return PostType.reflection;
      case 'transit_share':
        return PostType.transitShare;
      case 'chart_share':
        return PostType.chartShare;
      case 'question':
        return PostType.question;
      case 'achievement':
        return PostType.achievement;
      default:
        return PostType.insight;
    }
  }

  static PostVisibility _parseVisibility(String value) {
    switch (value) {
      case 'public':
        return PostVisibility.public;
      case 'followers':
        return PostVisibility.followers;
      case 'private':
        return PostVisibility.private;
      default:
        return PostVisibility.public;
    }
  }
}

class PostComment {
  const PostComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.content,
    this.parentId,
    required this.reactionCount,
    required this.createdAt,
    this.updatedAt,
    this.replies,
  });

  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String content;
  final String? parentId;
  final int reactionCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<PostComment>? replies;

  bool get isReply => parentId != null;

  factory PostComment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return PostComment(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      content: json['content'] as String,
      parentId: json['parent_id'] as String?,
      reactionCount: json['reaction_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  PostComment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? content,
    String? parentId,
    int? reactionCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<PostComment>? replies,
  }) {
    return PostComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      content: content ?? this.content,
      parentId: parentId ?? this.parentId,
      reactionCount: reactionCount ?? this.reactionCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      replies: replies ?? this.replies,
    );
  }
}

class Reaction {
  const Reaction({
    required this.id,
    required this.userId,
    this.postId,
    this.commentId,
    required this.reactionType,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String? postId;
  final String? commentId;
  final ReactionType reactionType;
  final DateTime createdAt;

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      postId: json['post_id'] as String?,
      commentId: json['comment_id'] as String?,
      reactionType: _parseReactionType(json['reaction_type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static ReactionType _parseReactionType(String value) {
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

extension ReactionTypeExtension on ReactionType {
  String get dbValue {
    switch (this) {
      case ReactionType.like:
        return 'like';
      case ReactionType.love:
        return 'love';
      case ReactionType.insight:
        return 'insight';
      case ReactionType.resonate:
        return 'resonate';
      case ReactionType.generatorSacral:
        return 'generator_sacral';
      case ReactionType.projectorRecognition:
        return 'projector_recognition';
      case ReactionType.manifestorPeace:
        return 'manifestor_peace';
      case ReactionType.reflectorSurprise:
        return 'reflector_surprise';
      case ReactionType.mgSatisfaction:
        return 'mg_satisfaction';
    }
  }

  String get emoji {
    switch (this) {
      case ReactionType.like:
        return '\u{1F44D}';
      case ReactionType.love:
        return '\u{2764}';
      case ReactionType.insight:
        return '\u{1F4A1}';
      case ReactionType.resonate:
        return '\u{1F31F}';
      case ReactionType.generatorSacral:
        return '\u{1F525}';
      case ReactionType.projectorRecognition:
        return '\u{1F441}';
      case ReactionType.manifestorPeace:
        return '\u{1F54A}';
      case ReactionType.reflectorSurprise:
        return '\u{2728}';
      case ReactionType.mgSatisfaction:
        return '\u{26A1}';
    }
  }

  String get label {
    switch (this) {
      case ReactionType.like:
        return 'Like';
      case ReactionType.love:
        return 'Love';
      case ReactionType.insight:
        return 'Insight';
      case ReactionType.resonate:
        return 'Resonate';
      case ReactionType.generatorSacral:
        return 'Sacral Yes';
      case ReactionType.projectorRecognition:
        return 'I See You';
      case ReactionType.manifestorPeace:
        return 'In Peace';
      case ReactionType.reflectorSurprise:
        return 'Delighted';
      case ReactionType.mgSatisfaction:
        return 'Satisfied';
    }
  }
}

extension PostTypeExtension on PostType {
  String get dbValue {
    switch (this) {
      case PostType.insight:
        return 'insight';
      case PostType.reflection:
        return 'reflection';
      case PostType.transitShare:
        return 'transit_share';
      case PostType.chartShare:
        return 'chart_share';
      case PostType.question:
        return 'question';
      case PostType.achievement:
        return 'achievement';
    }
  }
}
