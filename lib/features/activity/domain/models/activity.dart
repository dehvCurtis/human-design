// Models for the friend activity feed feature

/// Represents a user activity that can appear in the friend activity feed
class Activity {
  const Activity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.userHdType,
    required this.activityType,
    required this.createdAt,
    this.targetId,
    this.targetName,
    this.metadata,
  });

  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? userHdType;
  final ActivityType activityType;
  final DateTime createdAt;
  final String? targetId;
  final String? targetName;
  final Map<String, dynamic>? metadata;

  /// Get a human-readable description of the activity
  String getDescription() {
    switch (activityType) {
      case ActivityType.completedChallenge:
        return 'completed the challenge "${targetName ?? "Unknown"}"';
      case ActivityType.earnedBadge:
        return 'earned the "${targetName ?? "Unknown"}" badge';
      case ActivityType.reachedLevel:
        final level = metadata?['level'] ?? '?';
        return 'reached Level $level';
      case ActivityType.sharedChart:
        return 'shared their chart';
      case ActivityType.createdPost:
        return 'shared a new post';
      case ActivityType.followedUser:
        return 'started following ${targetName ?? "someone"}';
      case ActivityType.joinedGroup:
        return 'joined the group "${targetName ?? "Unknown"}"';
      case ActivityType.completedQuiz:
        final score = metadata?['score'] ?? '?';
        return 'scored $score% on "${targetName ?? "a quiz"}"';
      case ActivityType.achievedStreak:
        final days = metadata?['days'] ?? '?';
        return 'achieved a $days-day streak';
      case ActivityType.joinedTransitEvent:
        return 'joined the transit event "${targetName ?? "Unknown"}"';
    }
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return Activity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      userHdType: user?['hd_type'] as String?,
      activityType: _parseActivityType(json['activity_type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      targetId: json['target_id'] as String?,
      targetName: json['target_name'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'activity_type': activityType.dbValue,
      'target_id': targetId,
      'target_name': targetName,
      'metadata': metadata,
    };
  }

  static ActivityType _parseActivityType(String value) {
    switch (value) {
      case 'completed_challenge':
        return ActivityType.completedChallenge;
      case 'earned_badge':
        return ActivityType.earnedBadge;
      case 'reached_level':
        return ActivityType.reachedLevel;
      case 'shared_chart':
        return ActivityType.sharedChart;
      case 'created_post':
        return ActivityType.createdPost;
      case 'followed_user':
        return ActivityType.followedUser;
      case 'joined_group':
        return ActivityType.joinedGroup;
      case 'completed_quiz':
        return ActivityType.completedQuiz;
      case 'achieved_streak':
        return ActivityType.achievedStreak;
      case 'joined_transit_event':
        return ActivityType.joinedTransitEvent;
      default:
        return ActivityType.createdPost;
    }
  }
}

/// Types of activities that can appear in the feed
enum ActivityType {
  completedChallenge,
  earnedBadge,
  reachedLevel,
  sharedChart,
  createdPost,
  followedUser,
  joinedGroup,
  completedQuiz,
  achievedStreak,
  joinedTransitEvent,
}

extension ActivityTypeExtension on ActivityType {
  String get dbValue {
    switch (this) {
      case ActivityType.completedChallenge:
        return 'completed_challenge';
      case ActivityType.earnedBadge:
        return 'earned_badge';
      case ActivityType.reachedLevel:
        return 'reached_level';
      case ActivityType.sharedChart:
        return 'shared_chart';
      case ActivityType.createdPost:
        return 'created_post';
      case ActivityType.followedUser:
        return 'followed_user';
      case ActivityType.joinedGroup:
        return 'joined_group';
      case ActivityType.completedQuiz:
        return 'completed_quiz';
      case ActivityType.achievedStreak:
        return 'achieved_streak';
      case ActivityType.joinedTransitEvent:
        return 'joined_transit_event';
    }
  }

  String get emoji {
    switch (this) {
      case ActivityType.completedChallenge:
        return '\u{1F3C6}'; // 🏆
      case ActivityType.earnedBadge:
        return '\u{1F3C5}'; // 🏅
      case ActivityType.reachedLevel:
        return '\u{2B50}'; // ⭐
      case ActivityType.sharedChart:
        return '\u{1F4CA}'; // 📊
      case ActivityType.createdPost:
        return '\u{1F4DD}'; // 📝
      case ActivityType.followedUser:
        return '\u{1F465}'; // 👥
      case ActivityType.joinedGroup:
        return '\u{1F91D}'; // 🤝
      case ActivityType.completedQuiz:
        return '\u{1F4A1}'; // 💡
      case ActivityType.achievedStreak:
        return '\u{1F525}'; // 🔥
      case ActivityType.joinedTransitEvent:
        return '\u{2600}'; // ☀️
    }
  }

  String get displayName {
    switch (this) {
      case ActivityType.completedChallenge:
        return 'Challenge';
      case ActivityType.earnedBadge:
        return 'Badge';
      case ActivityType.reachedLevel:
        return 'Level Up';
      case ActivityType.sharedChart:
        return 'Share';
      case ActivityType.createdPost:
        return 'Post';
      case ActivityType.followedUser:
        return 'Follow';
      case ActivityType.joinedGroup:
        return 'Group';
      case ActivityType.completedQuiz:
        return 'Quiz';
      case ActivityType.achievedStreak:
        return 'Streak';
      case ActivityType.joinedTransitEvent:
        return 'Event';
    }
  }
}

/// Reaction to an activity
class ActivityReaction {
  const ActivityReaction({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.reactionType,
    required this.createdAt,
  });

  final String id;
  final String activityId;
  final String userId;
  final String reactionType;
  final DateTime createdAt;

  factory ActivityReaction.fromJson(Map<String, dynamic> json) {
    return ActivityReaction(
      id: json['id'] as String,
      activityId: json['activity_id'] as String,
      userId: json['user_id'] as String,
      reactionType: json['reaction_type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
