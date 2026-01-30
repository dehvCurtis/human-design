/// Models for Compatibility Circles feature
/// Allows group compatibility analysis for 3-5 people

/// Represents a compatibility circle (small group)
class CompatibilityCircle {
  const CompatibilityCircle({
    required this.id,
    required this.name,
    this.description,
    this.iconEmoji,
    required this.creatorId,
    required this.memberCount,
    required this.isPrivate,
    required this.createdAt,
    this.members,
  });

  final String id;
  final String name;
  final String? description;
  final String? iconEmoji;
  final String creatorId;
  final int memberCount;
  final bool isPrivate;
  final DateTime createdAt;
  final List<CircleMember>? members;

  factory CompatibilityCircle.fromJson(Map<String, dynamic> json) {
    return CompatibilityCircle(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconEmoji: json['icon_emoji'] as String?,
      creatorId: json['creator_id'] as String,
      memberCount: json['member_count'] as int? ?? 0,
      isPrivate: json['is_private'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      members: json['members'] != null
          ? (json['members'] as List)
              .map((m) => CircleMember.fromJson(m as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon_emoji': iconEmoji,
      'is_private': isPrivate,
    };
  }

  CompatibilityCircle copyWith({
    String? id,
    String? name,
    String? description,
    String? iconEmoji,
    String? creatorId,
    int? memberCount,
    bool? isPrivate,
    DateTime? createdAt,
    List<CircleMember>? members,
  }) {
    return CompatibilityCircle(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      creatorId: creatorId ?? this.creatorId,
      memberCount: memberCount ?? this.memberCount,
      isPrivate: isPrivate ?? this.isPrivate,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
    );
  }
}

/// Member of a compatibility circle
class CircleMember {
  const CircleMember({
    required this.id,
    required this.circleId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.hdType,
    this.hdAuthority,
    this.hdProfile,
    required this.role,
    required this.joinedAt,
  });

  final String id;
  final String circleId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? hdType;
  final String? hdAuthority;
  final String? hdProfile;
  final CircleRole role;
  final DateTime joinedAt;

  factory CircleMember.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return CircleMember(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      hdType: user?['hd_type'] as String?,
      hdAuthority: user?['hd_authority'] as String?,
      hdProfile: user?['hd_profile'] as String?,
      role: _parseRole(json['role'] as String),
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  static CircleRole _parseRole(String value) {
    switch (value) {
      case 'creator':
        return CircleRole.creator;
      case 'admin':
        return CircleRole.admin;
      case 'member':
        return CircleRole.member;
      default:
        return CircleRole.member;
    }
  }
}

enum CircleRole {
  creator,
  admin,
  member,
}

extension CircleRoleExtension on CircleRole {
  String get dbValue {
    switch (this) {
      case CircleRole.creator:
        return 'creator';
      case CircleRole.admin:
        return 'admin';
      case CircleRole.member:
        return 'member';
    }
  }

  String get displayName {
    switch (this) {
      case CircleRole.creator:
        return 'Creator';
      case CircleRole.admin:
        return 'Admin';
      case CircleRole.member:
        return 'Member';
    }
  }
}

/// Analysis result for a compatibility circle
class CircleCompatibilityAnalysis {
  const CircleCompatibilityAnalysis({
    required this.circleId,
    required this.members,
    required this.typeDistribution,
    required this.electromagneticConnections,
    required this.companionshipConnections,
    required this.dominanceConnections,
    required this.compromiseConnections,
    required this.definedCenters,
    required this.groupStrengths,
    required this.areasForGrowth,
    required this.overallHarmonyScore,
    required this.analyzedAt,
  });

  final String circleId;
  final List<CircleMemberAnalysis> members;
  final Map<String, int> typeDistribution;
  final List<CircleConnection> electromagneticConnections;
  final List<CircleConnection> companionshipConnections;
  final List<CircleConnection> dominanceConnections;
  final List<CircleConnection> compromiseConnections;
  final List<String> definedCenters;
  final List<String> groupStrengths;
  final List<String> areasForGrowth;
  final double overallHarmonyScore;
  final DateTime analyzedAt;

  factory CircleCompatibilityAnalysis.fromJson(Map<String, dynamic> json) {
    return CircleCompatibilityAnalysis(
      circleId: json['circle_id'] as String,
      members: (json['members'] as List)
          .map((m) => CircleMemberAnalysis.fromJson(m as Map<String, dynamic>))
          .toList(),
      typeDistribution: Map<String, int>.from(json['type_distribution'] as Map),
      electromagneticConnections: (json['electromagnetic_connections'] as List)
          .map((c) => CircleConnection.fromJson(c as Map<String, dynamic>))
          .toList(),
      companionshipConnections: (json['companionship_connections'] as List)
          .map((c) => CircleConnection.fromJson(c as Map<String, dynamic>))
          .toList(),
      dominanceConnections: (json['dominance_connections'] as List)
          .map((c) => CircleConnection.fromJson(c as Map<String, dynamic>))
          .toList(),
      compromiseConnections: (json['compromise_connections'] as List)
          .map((c) => CircleConnection.fromJson(c as Map<String, dynamic>))
          .toList(),
      definedCenters: List<String>.from(json['defined_centers'] as List),
      groupStrengths: List<String>.from(json['group_strengths'] as List),
      areasForGrowth: List<String>.from(json['areas_for_growth'] as List),
      overallHarmonyScore: (json['overall_harmony_score'] as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
    );
  }
}

/// Individual member's analysis within the circle
class CircleMemberAnalysis {
  const CircleMemberAnalysis({
    required this.userId,
    required this.userName,
    required this.hdType,
    required this.hdAuthority,
    required this.hdProfile,
    required this.roleInGroup,
    required this.uniqueContributions,
  });

  final String userId;
  final String userName;
  final String hdType;
  final String hdAuthority;
  final String hdProfile;
  final String roleInGroup;
  final List<String> uniqueContributions;

  factory CircleMemberAnalysis.fromJson(Map<String, dynamic> json) {
    return CircleMemberAnalysis(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      hdType: json['hd_type'] as String,
      hdAuthority: json['hd_authority'] as String,
      hdProfile: json['hd_profile'] as String,
      roleInGroup: json['role_in_group'] as String,
      uniqueContributions: List<String>.from(json['unique_contributions'] as List),
    );
  }
}

/// Connection between two members in the circle
class CircleConnection {
  const CircleConnection({
    required this.member1Id,
    required this.member1Name,
    required this.member2Id,
    required this.member2Name,
    required this.connectionType,
    required this.channel,
    this.description,
  });

  final String member1Id;
  final String member1Name;
  final String member2Id;
  final String member2Name;
  final ConnectionType connectionType;
  final String channel;
  final String? description;

  factory CircleConnection.fromJson(Map<String, dynamic> json) {
    return CircleConnection(
      member1Id: json['member1_id'] as String,
      member1Name: json['member1_name'] as String,
      member2Id: json['member2_id'] as String,
      member2Name: json['member2_name'] as String,
      connectionType: _parseConnectionType(json['connection_type'] as String),
      channel: json['channel'] as String,
      description: json['description'] as String?,
    );
  }

  static ConnectionType _parseConnectionType(String value) {
    switch (value) {
      case 'electromagnetic':
        return ConnectionType.electromagnetic;
      case 'companionship':
        return ConnectionType.companionship;
      case 'dominance':
        return ConnectionType.dominance;
      case 'compromise':
        return ConnectionType.compromise;
      default:
        return ConnectionType.companionship;
    }
  }
}

enum ConnectionType {
  electromagnetic,
  companionship,
  dominance,
  compromise,
}

extension ConnectionTypeExtension on ConnectionType {
  String get displayName {
    switch (this) {
      case ConnectionType.electromagnetic:
        return 'Electromagnetic';
      case ConnectionType.companionship:
        return 'Companionship';
      case ConnectionType.dominance:
        return 'Dominance';
      case ConnectionType.compromise:
        return 'Compromise';
    }
  }

  String get description {
    switch (this) {
      case ConnectionType.electromagnetic:
        return 'Intense attraction - you complete each other';
      case ConnectionType.companionship:
        return 'Comfort and stability - shared understanding';
      case ConnectionType.dominance:
        return 'One teaches/conditions the other';
      case ConnectionType.compromise:
        return 'Natural tension - requires awareness';
    }
  }
}

/// Post in a circle's private feed
class CirclePost {
  const CirclePost({
    required this.id,
    required this.circleId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.content,
    this.mediaUrl,
    required this.createdAt,
    this.reactionCount,
    this.commentCount,
  });

  final String id;
  final String circleId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String content;
  final String? mediaUrl;
  final DateTime createdAt;
  final int? reactionCount;
  final int? commentCount;

  factory CirclePost.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return CirclePost(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      content: json['content'] as String,
      mediaUrl: json['media_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      reactionCount: json['reaction_count'] as int?,
      commentCount: json['comment_count'] as int?,
    );
  }
}

/// Circle templates for common use cases
class CircleTemplate {
  const CircleTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.iconEmoji,
    required this.suggestedSize,
  });

  final String id;
  final String name;
  final String description;
  final String iconEmoji;
  final int suggestedSize;
}

/// Pre-defined circle templates
class CircleTemplates {
  static const List<CircleTemplate> templates = [
    CircleTemplate(
      id: 'family',
      name: 'Family Circle',
      description: 'Understand family dynamics and how to support each other',
      iconEmoji: '\u{1F3E0}', // 🏠
      suggestedSize: 4,
    ),
    CircleTemplate(
      id: 'couple',
      name: 'Partnership',
      description: 'Explore your romantic relationship dynamics',
      iconEmoji: '\u{2764}', // ❤️
      suggestedSize: 2,
    ),
    CircleTemplate(
      id: 'team',
      name: 'Work Team',
      description: 'Optimize team collaboration and roles',
      iconEmoji: '\u{1F4BC}', // 💼
      suggestedSize: 5,
    ),
    CircleTemplate(
      id: 'friends',
      name: 'Friend Group',
      description: 'Understand your friend group dynamics',
      iconEmoji: '\u{1F91D}', // 🤝
      suggestedSize: 4,
    ),
    CircleTemplate(
      id: 'roommates',
      name: 'Roommates',
      description: 'Living together harmoniously',
      iconEmoji: '\u{1F3E1}', // 🏡
      suggestedSize: 3,
    ),
  ];
}
