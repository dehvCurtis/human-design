/// Models for group challenges and team leaderboards

/// Represents a group/team that competes together
class ChallengeTeam {
  const ChallengeTeam({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    required this.creatorId,
    required this.totalPoints,
    required this.memberCount,
    required this.createdAt,
    this.members,
  });

  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final String creatorId;
  final int totalPoints;
  final int memberCount;
  final DateTime createdAt;
  final List<TeamMember>? members;

  factory ChallengeTeam.fromJson(Map<String, dynamic> json) {
    return ChallengeTeam(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      creatorId: json['creator_id'] as String,
      totalPoints: json['total_points'] as int? ?? 0,
      memberCount: json['member_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      members: json['members'] != null
          ? (json['members'] as List)
              .map((m) => TeamMember.fromJson(m))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'avatar_url': avatarUrl,
    };
  }

  ChallengeTeam copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarUrl,
    String? creatorId,
    int? totalPoints,
    int? memberCount,
    DateTime? createdAt,
    List<TeamMember>? members,
  }) {
    return ChallengeTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      creatorId: creatorId ?? this.creatorId,
      totalPoints: totalPoints ?? this.totalPoints,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
    );
  }
}

/// Member of a challenge team
class TeamMember {
  const TeamMember({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.userHdType,
    required this.role,
    required this.pointsContributed,
    required this.joinedAt,
  });

  final String id;
  final String teamId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? userHdType;
  final TeamRole role;
  final int pointsContributed;
  final DateTime joinedAt;

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return TeamMember(
      id: json['id'] as String,
      teamId: json['team_id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      userHdType: user?['hd_type'] as String?,
      role: _parseRole(json['role'] as String),
      pointsContributed: json['points_contributed'] as int? ?? 0,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  static TeamRole _parseRole(String value) {
    switch (value) {
      case 'admin':
        return TeamRole.admin;
      case 'member':
        return TeamRole.member;
      default:
        return TeamRole.member;
    }
  }
}

enum TeamRole {
  admin,
  member,
}

extension TeamRoleExtension on TeamRole {
  String get dbValue {
    switch (this) {
      case TeamRole.admin:
        return 'admin';
      case TeamRole.member:
        return 'member';
    }
  }
}

/// Group challenge - extends regular challenge with team features
class GroupChallenge {
  const GroupChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.challengeType,
    this.hdTypeFilter,
    required this.targetValue,
    required this.pointsReward,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.teamCount,
    required this.totalParticipants,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final GroupChallengeType challengeType;
  final List<String>? hdTypeFilter;
  final int targetValue;
  final int pointsReward;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final int teamCount;
  final int totalParticipants;
  final DateTime createdAt;

  bool get isOngoing => startDate != null && endDate != null
      ? DateTime.now().isAfter(startDate!) && DateTime.now().isBefore(endDate!)
      : isActive;

  factory GroupChallenge.fromJson(Map<String, dynamic> json) {
    return GroupChallenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      challengeType: _parseChallengeType(json['challenge_type'] as String),
      hdTypeFilter: (json['hd_type_filter'] as List<dynamic>?)?.cast<String>(),
      targetValue: json['target_value'] as int,
      pointsReward: json['points_reward'] as int,
      isActive: json['is_active'] as bool? ?? false,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      teamCount: json['team_count'] as int? ?? 0,
      totalParticipants: json['total_participants'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static GroupChallengeType _parseChallengeType(String value) {
    switch (value) {
      case 'team_posts':
        return GroupChallengeType.teamPosts;
      case 'team_reactions':
        return GroupChallengeType.teamReactions;
      case 'team_comments':
        return GroupChallengeType.teamComments;
      case 'team_quizzes':
        return GroupChallengeType.teamQuizzes;
      case 'team_streaks':
        return GroupChallengeType.teamStreaks;
      default:
        return GroupChallengeType.teamPosts;
    }
  }
}

enum GroupChallengeType {
  teamPosts,
  teamReactions,
  teamComments,
  teamQuizzes,
  teamStreaks,
}

extension GroupChallengeTypeExtension on GroupChallengeType {
  String get dbValue {
    switch (this) {
      case GroupChallengeType.teamPosts:
        return 'team_posts';
      case GroupChallengeType.teamReactions:
        return 'team_reactions';
      case GroupChallengeType.teamComments:
        return 'team_comments';
      case GroupChallengeType.teamQuizzes:
        return 'team_quizzes';
      case GroupChallengeType.teamStreaks:
        return 'team_streaks';
    }
  }

  String get displayName {
    switch (this) {
      case GroupChallengeType.teamPosts:
        return 'Team Posts';
      case GroupChallengeType.teamReactions:
        return 'Team Reactions';
      case GroupChallengeType.teamComments:
        return 'Team Comments';
      case GroupChallengeType.teamQuizzes:
        return 'Team Quizzes';
      case GroupChallengeType.teamStreaks:
        return 'Team Streaks';
    }
  }

  String get description {
    switch (this) {
      case GroupChallengeType.teamPosts:
        return 'Your team creates posts together';
      case GroupChallengeType.teamReactions:
        return 'Your team reacts to posts together';
      case GroupChallengeType.teamComments:
        return 'Your team comments together';
      case GroupChallengeType.teamQuizzes:
        return 'Your team completes quizzes together';
      case GroupChallengeType.teamStreaks:
        return 'Your team maintains login streaks';
    }
  }
}

/// Team's progress in a group challenge
class TeamChallengeProgress {
  const TeamChallengeProgress({
    required this.id,
    required this.teamId,
    required this.challengeId,
    required this.progress,
    required this.isCompleted,
    this.completedAt,
    required this.updatedAt,
  });

  final String id;
  final String teamId;
  final String challengeId;
  final int progress;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime updatedAt;

  factory TeamChallengeProgress.fromJson(Map<String, dynamic> json) {
    return TeamChallengeProgress(
      id: json['id'] as String,
      teamId: json['team_id'] as String,
      challengeId: json['challenge_id'] as String,
      progress: json['progress'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

/// Entry in the team leaderboard
class TeamLeaderboardEntry {
  const TeamLeaderboardEntry({
    required this.rank,
    required this.team,
    required this.points,
    this.weeklyPoints,
    this.monthlyPoints,
  });

  final int rank;
  final ChallengeTeam team;
  final int points;
  final int? weeklyPoints;
  final int? monthlyPoints;

  factory TeamLeaderboardEntry.fromJson(Map<String, dynamic> json, int rank) {
    return TeamLeaderboardEntry(
      rank: rank,
      team: ChallengeTeam.fromJson(json),
      points: json['total_points'] as int? ?? 0,
      weeklyPoints: json['weekly_points'] as int?,
      monthlyPoints: json['monthly_points'] as int?,
    );
  }
}

/// Types of team leaderboards
enum TeamLeaderboardType {
  allTime,
  weekly,
  monthly,
  challengeSpecific,
}
