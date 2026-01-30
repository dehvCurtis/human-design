/// Models for user discovery and matching

/// Chart visibility levels for discovered users
enum DiscoveredUserChartVisibility {
  private,
  friends,
  public;

  static DiscoveredUserChartVisibility fromString(String? value) {
    switch (value) {
      case 'public':
        return DiscoveredUserChartVisibility.public;
      case 'friends':
        return DiscoveredUserChartVisibility.friends;
      case 'private':
      default:
        return DiscoveredUserChartVisibility.private;
    }
  }
}

class DiscoveredUser {
  const DiscoveredUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.bio,
    this.hdType,
    this.hdProfile,
    this.hdAuthority,
    this.isPublic = true,
    this.showChartPublicly = false,
    this.chartVisibility = DiscoveredUserChartVisibility.private,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.isFollowedBy = false,
    this.compatibilityScore,
    this.compatibilityDetails,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final String? bio;
  final String? hdType;
  final String? hdProfile;
  final String? hdAuthority;
  final bool isPublic;
  final bool showChartPublicly;
  final DiscoveredUserChartVisibility chartVisibility;
  final int followerCount;
  final int followingCount;
  final bool isFollowing;
  final bool isFollowedBy;
  final int? compatibilityScore;
  final CompatibilityDetails? compatibilityDetails;

  bool get isMutualFollow => isFollowing && isFollowedBy;

  factory DiscoveredUser.fromJson(Map<String, dynamic> json, {
    bool? isFollowing,
    bool? isFollowedBy,
    int? compatibilityScore,
    CompatibilityDetails? compatibilityDetails,
  }) {
    return DiscoveredUser(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      hdType: json['hd_type'] as String?,
      hdProfile: json['hd_profile'] as String?,
      hdAuthority: json['hd_authority'] as String?,
      isPublic: json['is_public'] as bool? ?? true,
      showChartPublicly: json['show_chart_publicly'] as bool? ?? false,
      chartVisibility: DiscoveredUserChartVisibility.fromString(json['chart_visibility'] as String?),
      followerCount: json['follower_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      isFollowing: isFollowing ?? false,
      isFollowedBy: isFollowedBy ?? false,
      compatibilityScore: compatibilityScore,
      compatibilityDetails: compatibilityDetails,
    );
  }

  DiscoveredUser copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? bio,
    String? hdType,
    String? hdProfile,
    String? hdAuthority,
    bool? isPublic,
    bool? showChartPublicly,
    DiscoveredUserChartVisibility? chartVisibility,
    int? followerCount,
    int? followingCount,
    bool? isFollowing,
    bool? isFollowedBy,
    int? compatibilityScore,
    CompatibilityDetails? compatibilityDetails,
  }) {
    return DiscoveredUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      hdType: hdType ?? this.hdType,
      hdProfile: hdProfile ?? this.hdProfile,
      hdAuthority: hdAuthority ?? this.hdAuthority,
      isPublic: isPublic ?? this.isPublic,
      showChartPublicly: showChartPublicly ?? this.showChartPublicly,
      chartVisibility: chartVisibility ?? this.chartVisibility,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
      isFollowedBy: isFollowedBy ?? this.isFollowedBy,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      compatibilityDetails: compatibilityDetails ?? this.compatibilityDetails,
    );
  }
}

class CompatibilityDetails {
  const CompatibilityDetails({
    required this.typeScore,
    required this.profileScore,
    required this.channelScore,
    required this.definitionScore,
    this.typeCompatibility,
    this.profileHarmonics,
    this.complementaryChannels,
    this.bridgingOpportunities,
  });

  final int typeScore;
  final int profileScore;
  final int channelScore;
  final int definitionScore;
  final String? typeCompatibility;
  final String? profileHarmonics;
  final List<String>? complementaryChannels;
  final List<String>? bridgingOpportunities;

  int get totalScore => typeScore + profileScore + channelScore + definitionScore;
}

class FollowRelationship {
  const FollowRelationship({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.createdAt,
  });

  final String id;
  final String followerId;
  final String followingId;
  final DateTime createdAt;

  factory FollowRelationship.fromJson(Map<String, dynamic> json) {
    return FollowRelationship(
      id: json['id'] as String,
      followerId: json['follower_id'] as String,
      followingId: json['following_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class DiscoveryFilter {
  const DiscoveryFilter({
    this.hdTypes,
    this.hdProfiles,
    this.hdAuthorities,
    this.searchQuery,
    this.sortBy = DiscoverySortBy.relevance,
    this.showOnlyWithChart = false,
    this.showOnlyMutualFollows = false,
  });

  final List<String>? hdTypes;
  final List<String>? hdProfiles;
  final List<String>? hdAuthorities;
  final String? searchQuery;
  final DiscoverySortBy sortBy;
  final bool showOnlyWithChart;
  final bool showOnlyMutualFollows;

  DiscoveryFilter copyWith({
    List<String>? hdTypes,
    List<String>? hdProfiles,
    List<String>? hdAuthorities,
    String? searchQuery,
    DiscoverySortBy? sortBy,
    bool? showOnlyWithChart,
    bool? showOnlyMutualFollows,
  }) {
    return DiscoveryFilter(
      hdTypes: hdTypes ?? this.hdTypes,
      hdProfiles: hdProfiles ?? this.hdProfiles,
      hdAuthorities: hdAuthorities ?? this.hdAuthorities,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      showOnlyWithChart: showOnlyWithChart ?? this.showOnlyWithChart,
      showOnlyMutualFollows: showOnlyMutualFollows ?? this.showOnlyMutualFollows,
    );
  }

  bool get hasFilters =>
      (hdTypes?.isNotEmpty ?? false) ||
      (hdProfiles?.isNotEmpty ?? false) ||
      (hdAuthorities?.isNotEmpty ?? false) ||
      (searchQuery?.isNotEmpty ?? false) ||
      showOnlyWithChart ||
      showOnlyMutualFollows;
}

enum DiscoverySortBy {
  relevance,
  compatibility,
  recent,
  followers,
  name,
}

class DiscoveryResult {
  const DiscoveryResult({
    required this.users,
    required this.totalCount,
    required this.hasMore,
    this.nextOffset,
  });

  final List<DiscoveredUser> users;
  final int totalCount;
  final bool hasMore;
  final int? nextOffset;
}
