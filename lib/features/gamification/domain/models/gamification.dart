/// Models for the Gamification system (points, badges, challenges, leaderboards)

// ==================== Points ====================

class UserPoints {
  const UserPoints({
    required this.userId,
    required this.totalPoints,
    required this.currentLevel,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    required this.weeklyPoints,
    required this.monthlyPoints,
    required this.createdAt,
    this.updatedAt,
  });

  final String userId;
  final int totalPoints;
  final int currentLevel;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final int weeklyPoints;
  final int monthlyPoints;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Calculate points needed for next level
  int get pointsForNextLevel => ((currentLevel * currentLevel) * 100);

  /// Calculate progress to next level (0.0 - 1.0)
  double get levelProgress {
    final pointsForCurrent = (((currentLevel - 1) * (currentLevel - 1)) * 100);
    final pointsInLevel = totalPoints - pointsForCurrent;
    final pointsNeeded = pointsForNextLevel - pointsForCurrent;
    return (pointsInLevel / pointsNeeded).clamp(0.0, 1.0);
  }

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      userId: json['user_id'] as String,
      totalPoints: json['total_points'] as int? ?? 0,
      currentLevel: json['current_level'] as int? ?? 1,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.parse(json['last_activity_date'] as String)
          : null,
      weeklyPoints: json['weekly_points'] as int? ?? 0,
      monthlyPoints: json['monthly_points'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  UserPoints copyWith({
    String? userId,
    int? totalPoints,
    int? currentLevel,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    int? weeklyPoints,
    int? monthlyPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPoints(
      userId: userId ?? this.userId,
      totalPoints: totalPoints ?? this.totalPoints,
      currentLevel: currentLevel ?? this.currentLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      weeklyPoints: weeklyPoints ?? this.weeklyPoints,
      monthlyPoints: monthlyPoints ?? this.monthlyPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PointTransaction {
  const PointTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.actionType,
    this.description,
    this.referenceId,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final int points;
  final PointActionType actionType;
  final String? description;
  final String? referenceId;
  final DateTime createdAt;

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      points: json['points'] as int,
      actionType: _parseActionType(json['action_type'] as String),
      description: json['description'] as String?,
      referenceId: json['reference_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static PointActionType _parseActionType(String value) {
    return PointActionType.values.firstWhere(
      (e) => e.dbValue == value,
      orElse: () => PointActionType.dailyLogin,
    );
  }
}

enum PointActionType {
  dailyLogin,
  checkTransit,
  saveAffirmation,
  journalEntry,
  createPost,
  postReaction,
  comment,
  friendAdded,
  shareChart,
  completeChallenge,
  streakBonus7,
  streakBonus30,
  badgeEarned,
  referral,
  firstChart,
  premiumBonus,
  // Quiz-related actions
  quizComplete,
  quizPerfectScore,
  quizStreak7,
  quizCategoryMastery,
}

extension PointActionTypeExtension on PointActionType {
  String get dbValue {
    switch (this) {
      case PointActionType.dailyLogin:
        return 'daily_login';
      case PointActionType.checkTransit:
        return 'check_transit';
      case PointActionType.saveAffirmation:
        return 'save_affirmation';
      case PointActionType.journalEntry:
        return 'journal_entry';
      case PointActionType.createPost:
        return 'create_post';
      case PointActionType.postReaction:
        return 'post_reaction';
      case PointActionType.comment:
        return 'comment';
      case PointActionType.friendAdded:
        return 'friend_added';
      case PointActionType.shareChart:
        return 'share_chart';
      case PointActionType.completeChallenge:
        return 'complete_challenge';
      case PointActionType.streakBonus7:
        return 'streak_bonus_7';
      case PointActionType.streakBonus30:
        return 'streak_bonus_30';
      case PointActionType.badgeEarned:
        return 'badge_earned';
      case PointActionType.referral:
        return 'referral';
      case PointActionType.firstChart:
        return 'first_chart';
      case PointActionType.premiumBonus:
        return 'premium_bonus';
      case PointActionType.quizComplete:
        return 'quiz_complete';
      case PointActionType.quizPerfectScore:
        return 'quiz_perfect_score';
      case PointActionType.quizStreak7:
        return 'quiz_streak_7';
      case PointActionType.quizCategoryMastery:
        return 'quiz_category_mastery';
    }
  }

  int get defaultPoints {
    switch (this) {
      case PointActionType.dailyLogin:
        return 10;
      case PointActionType.checkTransit:
        return 5;
      case PointActionType.saveAffirmation:
        return 5;
      case PointActionType.journalEntry:
        return 15;
      case PointActionType.createPost:
        return 10;
      case PointActionType.postReaction:
        return 2;
      case PointActionType.comment:
        return 5;
      case PointActionType.friendAdded:
        return 20;
      case PointActionType.shareChart:
        return 10;
      case PointActionType.completeChallenge:
        return 25;
      case PointActionType.streakBonus7:
        return 50;
      case PointActionType.streakBonus30:
        return 200;
      case PointActionType.badgeEarned:
        return 25;
      case PointActionType.referral:
        return 50;
      case PointActionType.firstChart:
        return 50;
      case PointActionType.premiumBonus:
        return 100;
      case PointActionType.quizComplete:
        return 25;
      case PointActionType.quizPerfectScore:
        return 50;
      case PointActionType.quizStreak7:
        return 75;
      case PointActionType.quizCategoryMastery:
        return 100;
    }
  }
}

// ==================== Badges ====================

class Badge {
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.category,
    required this.requirementType,
    this.requirementValue,
    this.requirementData,
    required this.pointsAwarded,
    required this.isHidden,
    required this.sortOrder,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final String iconName;
  final BadgeCategory category;
  final BadgeRequirementType requirementType;
  final int? requirementValue;
  final Map<String, dynamic>? requirementData;
  final int pointsAwarded;
  final bool isHidden;
  final int sortOrder;
  final DateTime createdAt;

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconName: json['icon_name'] as String,
      category: _parseCategory(json['category'] as String),
      requirementType: _parseRequirementType(json['requirement_type'] as String),
      requirementValue: json['requirement_value'] as int?,
      requirementData: json['requirement_data'] as Map<String, dynamic>?,
      pointsAwarded: json['points_awarded'] as int? ?? 0,
      isHidden: json['is_hidden'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static BadgeCategory _parseCategory(String value) {
    return BadgeCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BadgeCategory.achievement,
    );
  }

  static BadgeRequirementType _parseRequirementType(String value) {
    return BadgeRequirementType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BadgeRequirementType.count,
    );
  }
}

enum BadgeCategory {
  social,
  learning,
  engagement,
  transit,
  achievement,
}

enum BadgeRequirementType {
  count,
  streak,
  special,
}

class UserBadge {
  const UserBadge({
    required this.id,
    required this.userId,
    required this.badgeId,
    required this.badge,
    required this.earnedAt,
    required this.progress,
    required this.isFeatured,
  });

  final String id;
  final String userId;
  final String badgeId;
  final Badge badge;
  final DateTime earnedAt;
  final int progress;
  final bool isFeatured;

  factory UserBadge.fromJson(Map<String, dynamic> json, Badge badge) {
    return UserBadge(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      badgeId: json['badge_id'] as String,
      badge: badge,
      earnedAt: DateTime.parse(json['earned_at'] as String),
      progress: json['progress'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }
}

// ==================== Challenges ====================

class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.challengeType,
    required this.actionType,
    required this.targetValue,
    required this.pointsReward,
    this.hdTypeFilter,
    this.gateFilter,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final ChallengeType challengeType;
  final String actionType;
  final int targetValue;
  final int pointsReward;
  final List<String>? hdTypeFilter;
  final List<int>? gateFilter;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      challengeType: _parseChallengeType(json['challenge_type'] as String),
      actionType: json['action_type'] as String,
      targetValue: json['target_value'] as int,
      pointsReward: json['points_reward'] as int,
      hdTypeFilter: (json['hd_type_filter'] as List<dynamic>?)?.cast<String>(),
      gateFilter: (json['gate_filter'] as List<dynamic>?)?.cast<int>(),
      isActive: json['is_active'] as bool? ?? true,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static ChallengeType _parseChallengeType(String value) {
    return ChallengeType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ChallengeType.daily,
    );
  }
}

enum ChallengeType {
  daily,
  weekly,
  monthly,
  special,
}

class UserChallenge {
  const UserChallenge({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.challenge,
    required this.progress,
    required this.isCompleted,
    this.completedAt,
    required this.assignedDate,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String challengeId;
  final Challenge challenge;
  final int progress;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime assignedDate;
  final DateTime createdAt;

  double get progressPercent => (progress / challenge.targetValue).clamp(0.0, 1.0);

  factory UserChallenge.fromJson(Map<String, dynamic> json, Challenge challenge) {
    return UserChallenge(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      challengeId: json['challenge_id'] as String,
      challenge: challenge,
      progress: json['progress'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      assignedDate: DateTime.parse(json['assigned_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// ==================== Leaderboard ====================

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.userHdType,
    required this.points,
    required this.level,
  });

  final int rank;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? userHdType;
  final int points;
  final int level;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json, int rank) {
    final profile = json['profile'] as Map<String, dynamic>?;

    return LeaderboardEntry(
      rank: rank,
      userId: json['user_id'] as String,
      userName: profile?['name'] as String? ?? 'Unknown',
      userAvatarUrl: profile?['avatar_url'] as String?,
      userHdType: profile?['hd_type'] as String?,
      points: json['total_points'] as int? ?? json['weekly_points'] as int? ?? json['current_streak'] as int? ?? 0,
      level: json['current_level'] as int? ?? 1,
    );
  }
}

enum LeaderboardType {
  weekly,
  monthly,
  allTime,
  streak,
}
