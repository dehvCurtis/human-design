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

// ==================== Story Reactions ====================

/// Reaction types for stories
enum StoryReactionType {
  love,
  fire,
  wow,
  sad,
  laugh,
  // HD-specific reactions
  sacralYes,
  projectorSee,
  manifestorPeace,
  reflectorMirror,
}

extension StoryReactionTypeExtension on StoryReactionType {
  String get dbValue {
    switch (this) {
      case StoryReactionType.love:
        return 'love';
      case StoryReactionType.fire:
        return 'fire';
      case StoryReactionType.wow:
        return 'wow';
      case StoryReactionType.sad:
        return 'sad';
      case StoryReactionType.laugh:
        return 'laugh';
      case StoryReactionType.sacralYes:
        return 'sacral_yes';
      case StoryReactionType.projectorSee:
        return 'projector_see';
      case StoryReactionType.manifestorPeace:
        return 'manifestor_peace';
      case StoryReactionType.reflectorMirror:
        return 'reflector_mirror';
    }
  }

  String get emoji {
    switch (this) {
      case StoryReactionType.love:
        return '\u{2764}'; // ❤️
      case StoryReactionType.fire:
        return '\u{1F525}'; // 🔥
      case StoryReactionType.wow:
        return '\u{1F62E}'; // 😮
      case StoryReactionType.sad:
        return '\u{1F622}'; // 😢
      case StoryReactionType.laugh:
        return '\u{1F602}'; // 😂
      case StoryReactionType.sacralYes:
        return '\u{26A1}'; // ⚡
      case StoryReactionType.projectorSee:
        return '\u{1F441}'; // 👁️
      case StoryReactionType.manifestorPeace:
        return '\u{1F54A}'; // 🕊️
      case StoryReactionType.reflectorMirror:
        return '\u{2728}'; // ✨
    }
  }

  String get label {
    switch (this) {
      case StoryReactionType.love:
        return 'Love';
      case StoryReactionType.fire:
        return 'Fire';
      case StoryReactionType.wow:
        return 'Wow';
      case StoryReactionType.sad:
        return 'Sad';
      case StoryReactionType.laugh:
        return 'Haha';
      case StoryReactionType.sacralYes:
        return 'Sacral Yes';
      case StoryReactionType.projectorSee:
        return 'I See You';
      case StoryReactionType.manifestorPeace:
        return 'In Peace';
      case StoryReactionType.reflectorMirror:
        return 'Reflecting';
    }
  }

  static StoryReactionType fromDbValue(String value) {
    switch (value) {
      case 'love':
        return StoryReactionType.love;
      case 'fire':
        return StoryReactionType.fire;
      case 'wow':
        return StoryReactionType.wow;
      case 'sad':
        return StoryReactionType.sad;
      case 'laugh':
        return StoryReactionType.laugh;
      case 'sacral_yes':
        return StoryReactionType.sacralYes;
      case 'projector_see':
        return StoryReactionType.projectorSee;
      case 'manifestor_peace':
        return StoryReactionType.manifestorPeace;
      case 'reflector_mirror':
        return StoryReactionType.reflectorMirror;
      default:
        return StoryReactionType.love;
    }
  }
}

/// Represents a reaction on a story
class StoryReaction {
  const StoryReaction({
    required this.id,
    required this.storyId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.reactionType,
    required this.createdAt,
  });

  final String id;
  final String storyId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final StoryReactionType reactionType;
  final DateTime createdAt;

  factory StoryReaction.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return StoryReaction(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      reactionType: StoryReactionTypeExtension.fromDbValue(json['reaction_type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// ==================== Story Replies ====================

/// Represents a reply to a story
class StoryReply {
  const StoryReply({
    required this.id,
    required this.storyId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String storyId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String content;
  final DateTime createdAt;

  factory StoryReply.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return StoryReply(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// ==================== Story Polls ====================

/// Represents a poll in a story
class StoryPoll {
  const StoryPoll({
    required this.id,
    required this.storyId,
    required this.question,
    required this.options,
    required this.createdAt,
    this.userVote,
  });

  final String id;
  final String storyId;
  final String question;
  final List<PollOption> options;
  final DateTime createdAt;
  final String? userVote; // The option ID the user voted for, if any

  int get totalVotes => options.fold(0, (sum, opt) => sum + opt.voteCount);

  factory StoryPoll.fromJson(Map<String, dynamic> json, {String? userVote}) {
    return StoryPoll(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List)
          .map((o) => PollOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      userVote: userVote,
    );
  }

  StoryPoll copyWith({
    String? id,
    String? storyId,
    String? question,
    List<PollOption>? options,
    DateTime? createdAt,
    String? userVote,
  }) {
    return StoryPoll(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      question: question ?? this.question,
      options: options ?? this.options,
      createdAt: createdAt ?? this.createdAt,
      userVote: userVote ?? this.userVote,
    );
  }
}

/// Represents an option in a poll
class PollOption {
  const PollOption({
    required this.id,
    required this.text,
    required this.voteCount,
  });

  final String id;
  final String text;
  final int voteCount;

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] as String,
      text: json['text'] as String,
      voteCount: json['vote_count'] as int? ?? 0,
    );
  }

  PollOption copyWith({
    String? id,
    String? text,
    int? voteCount,
  }) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      voteCount: voteCount ?? this.voteCount,
    );
  }
}

/// User's vote on a poll
class PollVote {
  const PollVote({
    required this.id,
    required this.pollId,
    required this.optionId,
    required this.userId,
    required this.createdAt,
  });

  final String id;
  final String pollId;
  final String optionId;
  final String userId;
  final DateTime createdAt;

  factory PollVote.fromJson(Map<String, dynamic> json) {
    return PollVote(
      id: json['id'] as String,
      pollId: json['poll_id'] as String,
      optionId: json['option_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// ==================== Pre-defined HD Poll Questions ====================

/// Pre-defined poll questions for HD-themed stories
class HdPollTemplates {
  static const List<PollTemplate> templates = [
    PollTemplate(
      question: 'Which gate resonates with you today?',
      options: ['Gate 1', 'Gate 2', 'Gate 64', 'Gate 41'],
    ),
    PollTemplate(
      question: "How's your sacral energy?",
      options: ['Full power!', 'Waiting to respond', 'Need rest', 'Mixed signals'],
    ),
    PollTemplate(
      question: 'Feeling your authority today?',
      options: ['Crystal clear', 'Still waiting', 'Learning to trust it', 'What authority?'],
    ),
    PollTemplate(
      question: 'Current transit mood?',
      options: ['Energized', 'Contemplative', 'Restless', 'At peace'],
    ),
    PollTemplate(
      question: "Today's strategy status:",
      options: ['Following it!', 'Struggling', 'Testing boundaries', 'In the flow'],
    ),
  ];
}

class PollTemplate {
  const PollTemplate({
    required this.question,
    required this.options,
  });

  final String question;
  final List<String> options;
}
