/// Models for the Stories feature (24h ephemeral content)

enum StoryVisibility {
  public,
  followers,
}

class Story {
  const Story({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.content,
    this.mediaUrl,
    this.backgroundColor,
    this.textColor,
    this.transitGate,
    this.affirmationText,
    required this.visibility,
    required this.viewCount,
    required this.expiresAt,
    required this.createdAt,
    this.isViewed = false,
  });

  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? content;
  final String? mediaUrl;
  final String? backgroundColor;
  final String? textColor;
  final int? transitGate;
  final String? affirmationText;
  final StoryVisibility visibility;
  final int viewCount;
  final DateTime expiresAt;
  final DateTime createdAt;
  final bool isViewed;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory Story.fromJson(Map<String, dynamic> json, {bool isViewed = false}) {
    final user = json['user'] as Map<String, dynamic>?;

    return Story(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      content: json['content'] as String?,
      mediaUrl: json['media_url'] as String?,
      backgroundColor: json['background_color'] as String?,
      textColor: json['text_color'] as String?,
      transitGate: json['transit_gate'] as int?,
      affirmationText: json['affirmation_text'] as String?,
      visibility: _parseVisibility(json['visibility'] as String),
      viewCount: json['view_count'] as int? ?? 0,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      isViewed: isViewed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'media_url': mediaUrl,
      'background_color': backgroundColor,
      'text_color': textColor,
      'transit_gate': transitGate,
      'affirmation_text': affirmationText,
      'visibility': visibility.name,
    };
  }

  Story copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? content,
    String? mediaUrl,
    String? backgroundColor,
    String? textColor,
    int? transitGate,
    String? affirmationText,
    StoryVisibility? visibility,
    int? viewCount,
    DateTime? expiresAt,
    DateTime? createdAt,
    bool? isViewed,
  }) {
    return Story(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      transitGate: transitGate ?? this.transitGate,
      affirmationText: affirmationText ?? this.affirmationText,
      visibility: visibility ?? this.visibility,
      viewCount: viewCount ?? this.viewCount,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }

  static StoryVisibility _parseVisibility(String value) {
    switch (value) {
      case 'public':
        return StoryVisibility.public;
      case 'followers':
        return StoryVisibility.followers;
      default:
        return StoryVisibility.followers;
    }
  }
}

class StoryView {
  const StoryView({
    required this.id,
    required this.storyId,
    required this.viewerId,
    required this.viewerName,
    this.viewerAvatarUrl,
    required this.viewedAt,
  });

  final String id;
  final String storyId;
  final String viewerId;
  final String viewerName;
  final String? viewerAvatarUrl;
  final DateTime viewedAt;

  factory StoryView.fromJson(Map<String, dynamic> json) {
    final viewer = json['viewer'] as Map<String, dynamic>?;

    return StoryView(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      viewerId: json['viewer_id'] as String,
      viewerName: viewer?['name'] as String? ?? 'Unknown',
      viewerAvatarUrl: viewer?['avatar_url'] as String?,
      viewedAt: DateTime.parse(json['viewed_at'] as String),
    );
  }
}

/// Groups a user's stories together for the story bar
class UserStories {
  const UserStories({
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.stories,
    this.hasUnviewed = false,
  });

  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final List<Story> stories;
  final bool hasUnviewed;

  factory UserStories.fromStories(List<Story> stories) {
    if (stories.isEmpty) {
      throw ArgumentError('Stories list cannot be empty');
    }

    final first = stories.first;
    final hasUnviewed = stories.any((s) => !s.isViewed && !s.isExpired);

    return UserStories(
      userId: first.userId,
      userName: first.userName,
      userAvatarUrl: first.userAvatarUrl,
      stories: stories,
      hasUnviewed: hasUnviewed,
    );
  }
}
