import 'package:supabase_flutter/supabase_flutter.dart';

import '../../chart/domain/models/human_design_chart.dart';
import '../../chart/domain/usecases/calculate_chart.dart';
import '../../ephemeris/data/ephemeris_service.dart';
import '../domain/models/user_discovery.dart';
import '../domain/matching_service.dart';

/// Repository for user discovery and follow features
class DiscoveryRepository {
  DiscoveryRepository({
    required SupabaseClient supabaseClient,
    MatchingService? matchingService,
  })  : _client = supabaseClient,
        _matchingService = matchingService ?? MatchingService();

  final SupabaseClient _client;
  final MatchingService _matchingService;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Follow System ====================

  /// Follow a user
  Future<void> followUser(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) throw StateError('User not authenticated');
    if (currentUserId == userId) throw ArgumentError('Cannot follow yourself');

    await _client.from('user_follows').insert({
      'follower_id': currentUserId,
      'following_id': userId,
    });
  }

  /// Unfollow a user
  Future<void> unfollowUser(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) throw StateError('User not authenticated');

    await _client
        .from('user_follows')
        .delete()
        .eq('follower_id', currentUserId)
        .eq('following_id', userId);
  }

  /// Check if current user follows a specific user
  Future<bool> isFollowing(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return false;

    final response = await _client
        .from('user_follows')
        .select('id')
        .eq('follower_id', currentUserId)
        .eq('following_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Check if a specific user follows current user
  Future<bool> isFollowedBy(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return false;

    final response = await _client
        .from('user_follows')
        .select('id')
        .eq('follower_id', userId)
        .eq('following_id', currentUserId)
        .maybeSingle();

    return response != null;
  }

  /// Get users the current user is following
  Future<List<DiscoveredUser>> getFollowing({int limit = 50, int offset = 0}) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return [];

    final response = await _client
        .from('user_follows')
        .select('''
          following:profiles!user_follows_following_id_fkey(
            id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
            is_public, show_chart_publicly, chart_visibility, follower_count, following_count
          )
        ''')
        .eq('follower_id', currentUserId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((json) {
      return DiscoveredUser.fromJson(
        json['following'] as Map<String, dynamic>,
        isFollowing: true,
      );
    }).toList();
  }

  /// Get users following the current user
  Future<List<DiscoveredUser>> getFollowers({int limit = 50, int offset = 0}) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return [];

    final response = await _client
        .from('user_follows')
        .select('''
          follower:profiles!user_follows_follower_id_fkey(
            id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
            is_public, show_chart_publicly, chart_visibility, follower_count, following_count
          )
        ''')
        .eq('following_id', currentUserId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    // Check which followers we follow back
    final followerIds = (response as List)
        .map((json) => (json['follower'] as Map<String, dynamic>)['id'] as String)
        .toList();

    final followingBack = await _getFollowingSet(followerIds);

    return response.map((json) {
      final follower = json['follower'] as Map<String, dynamic>;
      return DiscoveredUser.fromJson(
        follower,
        isFollowing: followingBack.contains(follower['id']),
        isFollowedBy: true,
      );
    }).toList();
  }

  /// Get follow counts for a user
  Future<({int followers, int following})> getFollowCounts(String userId) async {
    final response = await _client
        .from('profiles')
        .select('follower_count, following_count')
        .eq('id', userId)
        .single();

    return (
      followers: response['follower_count'] as int? ?? 0,
      following: response['following_count'] as int? ?? 0,
    );
  }

  /// Get a specific user's followers
  Future<List<DiscoveredUser>> getUserFollowers(String userId) async {
    final currentUserId = _currentUserId;

    final response = await _client
        .from('user_follows')
        .select('''
          follower:profiles!user_follows_follower_id_fkey(
            id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
            is_public, show_chart_publicly, chart_visibility, follower_count, following_count
          )
        ''')
        .eq('following_id', userId)
        .order('created_at', ascending: false);

    final followerIds = (response as List)
        .map((json) => (json['follower'] as Map<String, dynamic>)['id'] as String)
        .toList();

    final followingSet = currentUserId != null
        ? await _getFollowingSet(followerIds)
        : <String>{};

    return response.map((json) {
      final follower = json['follower'] as Map<String, dynamic>;
      return DiscoveredUser.fromJson(
        follower,
        isFollowing: followingSet.contains(follower['id']),
      );
    }).toList();
  }

  /// Get a specific user's following list
  Future<List<DiscoveredUser>> getUserFollowing(String userId) async {
    final currentUserId = _currentUserId;

    final response = await _client
        .from('user_follows')
        .select('''
          following:profiles!user_follows_following_id_fkey(
            id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
            is_public, show_chart_publicly, chart_visibility, follower_count, following_count
          )
        ''')
        .eq('follower_id', userId)
        .order('created_at', ascending: false);

    final followingIds = (response as List)
        .map((json) => (json['following'] as Map<String, dynamic>)['id'] as String)
        .toList();

    final followingSet = currentUserId != null
        ? await _getFollowingSet(followingIds)
        : <String>{};

    return response.map((json) {
      final following = json['following'] as Map<String, dynamic>;
      return DiscoveredUser.fromJson(
        following,
        isFollowing: followingSet.contains(following['id']),
      );
    }).toList();
  }

  /// Get a specific user's profile
  Future<DiscoveredUser?> getUserProfile(String userId) async {
    final currentUserId = _currentUserId;

    final response = await _client
        .from('profiles')
        .select('''
          id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
          is_public, show_chart_publicly, chart_visibility, follower_count, following_count
        ''')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;

    // Check if current user follows this user
    bool isFollowing = false;
    bool isFollowedBy = false;
    int? compatibilityScore;

    if (currentUserId != null && currentUserId != userId) {
      final followCheck = await _client
          .from('user_follows')
          .select('follower_id, following_id')
          .or('and(follower_id.eq.$currentUserId,following_id.eq.$userId),and(follower_id.eq.$userId,following_id.eq.$currentUserId)');

      for (final row in followCheck) {
        if (row['follower_id'] == currentUserId && row['following_id'] == userId) {
          isFollowing = true;
        }
        if (row['follower_id'] == userId && row['following_id'] == currentUserId) {
          isFollowedBy = true;
        }
      }

      // Calculate basic compatibility if both users have HD type
      final currentUserProfile = await _client
          .from('profiles')
          .select('hd_type, hd_profile, hd_authority')
          .eq('id', currentUserId)
          .maybeSingle();

      if (currentUserProfile != null &&
          currentUserProfile['hd_type'] != null &&
          response['hd_type'] != null) {
        // Calculate basic compatibility using matching service
        final details = _matchingService.calculateCompatibility(
          userType: currentUserProfile['hd_type'] as String?,
          userProfile: currentUserProfile['hd_profile'] as String?,
          userGates: null, // Gates not available in basic profile query
          userDefinedCenters: null,
          otherType: response['hd_type'] as String?,
          otherProfile: response['hd_profile'] as String?,
          otherGates: null,
          otherDefinedCenters: null,
        );
        compatibilityScore = details.totalScore;
      }
    }

    return DiscoveredUser.fromJson(
      response,
      isFollowing: isFollowing,
      isFollowedBy: isFollowedBy,
      compatibilityScore: compatibilityScore,
    );
  }

  // ==================== Discovery ====================

  /// Discover users with optional filters
  Future<DiscoveryResult> discoverUsers({
    DiscoveryFilter? filter,
    int limit = 20,
    int offset = 0,
  }) async {
    final currentUserId = _currentUserId;
    filter ??= const DiscoveryFilter();

    var query = _client
        .from('profiles')
        .select('''
          id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
          is_public, show_chart_publicly, follower_count, following_count
        ''')
        .eq('is_public', true);

    // Exclude current user
    if (currentUserId != null) {
      query = query.neq('id', currentUserId);
    }

    // Apply type filter
    if (filter.hdTypes != null && filter.hdTypes!.isNotEmpty) {
      query = query.inFilter('hd_type', filter.hdTypes!);
    }

    // Apply profile filter
    if (filter.hdProfiles != null && filter.hdProfiles!.isNotEmpty) {
      query = query.inFilter('hd_profile', filter.hdProfiles!);
    }

    // Apply authority filter
    if (filter.hdAuthorities != null && filter.hdAuthorities!.isNotEmpty) {
      query = query.inFilter('hd_authority', filter.hdAuthorities!);
    }

    // Apply search query
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final sanitized = _sanitizeSearchQuery(filter.searchQuery!);
      query = query.ilike('name', '%$sanitized%');
    }

    // Only users with chart data
    if (filter.showOnlyWithChart) {
      query = query.not('hd_type', 'is', null);
    }

    // Apply sorting and pagination (must be last as they return PostgrestTransformBuilder)
    final String orderColumn;
    final bool ascending;
    switch (filter.sortBy) {
      case DiscoverySortBy.followers:
        orderColumn = 'follower_count';
        ascending = false;
      case DiscoverySortBy.recent:
        orderColumn = 'created_at';
        ascending = false;
      case DiscoverySortBy.name:
        orderColumn = 'name';
        ascending = true;
      case DiscoverySortBy.relevance:
      case DiscoverySortBy.compatibility:
        // For compatibility, we'll sort after fetching
        orderColumn = 'follower_count';
        ascending = false;
    }

    // Execute query with ordering and pagination
    final response = await query
        .order(orderColumn, ascending: ascending)
        .range(offset, offset + limit - 1);

    // Get follow relationships
    final userIds = (response as List)
        .map((json) => json['id'] as String)
        .toList();

    final followingSet = currentUserId != null
        ? await _getFollowingSet(userIds)
        : <String>{};

    final followedBySet = currentUserId != null
        ? await _getFollowedBySet(userIds)
        : <String>{};

    // Convert to DiscoveredUser objects
    List<DiscoveredUser> users = response.map((json) {
      final userId = json['id'] as String;
      return DiscoveredUser.fromJson(
        json,
        isFollowing: followingSet.contains(userId),
        isFollowedBy: followedBySet.contains(userId),
      );
    }).toList();

    // Filter mutual follows only if requested
    if (filter.showOnlyMutualFollows) {
      users = users.where((u) => u.isMutualFollow).toList();
    }

    return DiscoveryResult(
      users: users,
      totalCount: users.length,
      hasMore: users.length == limit,
      nextOffset: users.length == limit ? offset + limit : null,
    );
  }

  /// Search users by name or email
  Future<List<DiscoveredUser>> searchUsers(String query, {int limit = 20}) async {
    if (query.isEmpty) return [];

    final currentUserId = _currentUserId;

    var dbQuery = _client
        .from('profiles')
        .select('''
          id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
          is_public, show_chart_publicly, follower_count, following_count
        ''')
        .eq('is_public', true)
        .ilike('name', '%${_sanitizeSearchQuery(query)}%');

    // Apply filter before transform operations
    if (currentUserId != null) {
      dbQuery = dbQuery.neq('id', currentUserId);
    }

    final response = await dbQuery.limit(limit);

    final userIds = (response as List)
        .map((json) => json['id'] as String)
        .toList();

    final followingSet = currentUserId != null
        ? await _getFollowingSet(userIds)
        : <String>{};

    return response.map((json) {
      final userId = json['id'] as String;
      return DiscoveredUser.fromJson(
        json,
        isFollowing: followingSet.contains(userId),
      );
    }).toList();
  }

  /// Get suggested users based on HD compatibility
  Future<List<DiscoveredUser>> getSuggestedUsers({
    required String? userType,
    required String? userProfile,
    required List<int>? userGates,
    required List<String>? userDefinedCenters,
    int limit = 10,
  }) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return [];

    // Get users with chart data that we don't already follow
    final response = await _client
        .from('profiles')
        .select('''
          id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
          is_public, show_chart_publicly, follower_count, following_count
        ''')
        .eq('is_public', true)
        .neq('id', currentUserId)
        .not('hd_type', 'is', null)
        .limit(50); // Fetch more to filter and sort

    // Get current following
    final followingSet = await _getFollowingSet(
        (response as List).map((j) => j['id'] as String).toList());

    // Calculate compatibility for each user
    final usersWithCompatibility = <(DiscoveredUser, int)>[];

    for (final json in response) {
      final userId = json['id'] as String;

      // Skip users we already follow
      if (followingSet.contains(userId)) continue;

      // Calculate compatibility
      final compatibility = _matchingService.calculateCompatibility(
        userType: userType,
        userProfile: userProfile,
        userGates: userGates,
        userDefinedCenters: userDefinedCenters,
        otherType: json['hd_type'] as String?,
        otherProfile: json['hd_profile'] as String?,
        otherGates: null, // Would need to fetch from chart data
        otherDefinedCenters: null,
      );

      final user = DiscoveredUser.fromJson(
        json,
        isFollowing: false,
        compatibilityScore: compatibility.totalScore,
        compatibilityDetails: compatibility,
      );

      usersWithCompatibility.add((user, compatibility.totalScore));
    }

    // Sort by compatibility score
    usersWithCompatibility.sort((a, b) => b.$2.compareTo(a.$2));

    return usersWithCompatibility
        .take(limit)
        .map((tuple) => tuple.$1)
        .toList();
  }

  /// Get users with the same HD type
  Future<List<DiscoveredUser>> getUsersByType(String hdType, {int limit = 20}) async {
    final currentUserId = _currentUserId;

    var query = _client
        .from('profiles')
        .select('''
          id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
          is_public, show_chart_publicly, follower_count, following_count
        ''')
        .eq('is_public', true)
        .eq('hd_type', hdType);

    // Apply filter before transform operations
    if (currentUserId != null) {
      query = query.neq('id', currentUserId);
    }

    final response = await query
        .order('follower_count', ascending: false)
        .limit(limit);

    final userIds = (response as List)
        .map((json) => json['id'] as String)
        .toList();

    final followingSet = currentUserId != null
        ? await _getFollowingSet(userIds)
        : <String>{};

    return response.map((json) {
      final userId = json['id'] as String;
      return DiscoveredUser.fromJson(
        json,
        isFollowing: followingSet.contains(userId),
      );
    }).toList();
  }

  // ==================== Blocking ====================

  /// Block a user
  Future<void> blockUser(String userId, {String? reason}) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) throw StateError('User not authenticated');

    // Remove any existing follow relationships
    await _client
        .from('user_follows')
        .delete()
        .or('and(follower_id.eq.$currentUserId,following_id.eq.$userId),and(follower_id.eq.$userId,following_id.eq.$currentUserId)');

    // Add block record
    await _client.from('blocked_users').insert({
      'blocker_id': currentUserId,
      'blocked_id': userId,
      'reason': reason,
    });
  }

  /// Unblock a user
  Future<void> unblockUser(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) throw StateError('User not authenticated');

    await _client
        .from('blocked_users')
        .delete()
        .eq('blocker_id', currentUserId)
        .eq('blocked_id', userId);
  }

  /// Get list of blocked users
  Future<List<DiscoveredUser>> getBlockedUsers() async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return [];

    final response = await _client
        .from('blocked_users')
        .select('''
          blocked:profiles!blocked_users_blocked_id_fkey(
            id, name, avatar_url, bio
          )
        ''')
        .eq('blocker_id', currentUserId);

    return (response as List).map((json) {
      return DiscoveredUser.fromJson(json['blocked'] as Map<String, dynamic>);
    }).toList();
  }

  /// Check if a user is blocked
  Future<bool> isBlocked(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return false;

    final response = await _client
        .from('blocked_users')
        .select('id')
        .eq('blocker_id', currentUserId)
        .eq('blocked_id', userId)
        .maybeSingle();

    return response != null;
  }

  // ==================== Input Sanitization ====================

  /// Escape LIKE/ILIKE special characters to prevent pattern injection
  String _sanitizeSearchQuery(String query) {
    return query
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }

  // ==================== Helper Methods ====================

  Future<Set<String>> _getFollowingSet(List<String> userIds) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || userIds.isEmpty) return {};

    final response = await _client
        .from('user_follows')
        .select('following_id')
        .eq('follower_id', currentUserId)
        .inFilter('following_id', userIds);

    return (response as List)
        .map((json) => json['following_id'] as String)
        .toSet();
  }

  Future<Set<String>> _getFollowedBySet(List<String> userIds) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || userIds.isEmpty) return {};

    final response = await _client
        .from('user_follows')
        .select('follower_id')
        .eq('following_id', currentUserId)
        .inFilter('follower_id', userIds);

    return (response as List)
        .map((json) => json['follower_id'] as String)
        .toSet();
  }

  // ==================== Chart Visibility ====================

  /// Check if two users are mutual followers
  Future<bool> areMutualFollowers(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return false;
    if (currentUserId == userId) return true; // User can always see their own chart

    // Check if current user follows the target user
    final followingResponse = await _client
        .from('user_follows')
        .select('id')
        .eq('follower_id', currentUserId)
        .eq('following_id', userId)
        .maybeSingle();

    if (followingResponse == null) return false;

    // Check if target user follows current user
    final followedByResponse = await _client
        .from('user_follows')
        .select('id')
        .eq('follower_id', userId)
        .eq('following_id', currentUserId)
        .maybeSingle();

    return followedByResponse != null;
  }

  /// Check if current user can view another user's chart
  /// Facebook-like model:
  /// - Private: Only owner can see
  /// - Friends: Mutual followers can see
  /// - Public: Anyone who follows them can see
  Future<bool> canViewUserChart(String userId) async {
    final currentUserId = _currentUserId;

    // User can always view their own chart
    if (currentUserId == userId) return true;

    // Get the target user's profile to check visibility setting
    final response = await _client
        .from('profiles')
        .select('chart_visibility')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return false;

    final visibility = DiscoveredUserChartVisibility.fromString(
      response['chart_visibility'] as String?,
    );

    switch (visibility) {
      case DiscoveredUserChartVisibility.public:
        // Public: followers can see the chart
        return await isFollowing(userId);
      case DiscoveredUserChartVisibility.friends:
        // Friends: mutual followers can see
        return await areMutualFollowers(userId);
      case DiscoveredUserChartVisibility.private:
        // Private: only owner can see
        return false;
    }
  }

  /// Get another user's chart (if allowed)
  Future<HumanDesignChart?> getUserChart(String userId) async {
    // First check if we can view the chart
    final canView = await canViewUserChart(userId);
    if (!canView) return null;

    // Get user's birth data
    final response = await _client
        .from('profiles')
        .select('id, name, birth_date, birth_location, timezone')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;

    final birthDateStr = response['birth_date'] as String?;
    final birthLocationJson = response['birth_location'] as Map<String, dynamic>?;
    final timezone = response['timezone'] as String?;

    if (birthDateStr == null || birthLocationJson == null || timezone == null) {
      return null;
    }

    final birthDateTime = DateTime.parse(birthDateStr);
    final birthLocation = BirthLocation.fromJson(birthLocationJson);

    // Calculate the chart
    final ephemerisService = EphemerisService.instance;
    final calculateChart = CalculateChartUseCase(ephemerisService: ephemerisService);

    return calculateChart.execute(
      userId: userId,
      name: response['name'] as String? ?? 'Unknown',
      birthDateTime: birthDateTime,
      birthLocation: birthLocation,
      timezone: timezone,
    );
  }

  /// Get popular public charts sorted by follower count
  Future<List<DiscoveredUser>> getPopularCharts({int limit = 20}) async {
    final currentUserId = _currentUserId;

    var query = _client
        .from('profiles')
        .select('''
          id, name, avatar_url, bio, hd_type, hd_profile, hd_authority,
          is_public, show_chart_publicly, chart_visibility, follower_count, following_count
        ''')
        .eq('chart_visibility', 'public')
        .not('hd_type', 'is', null); // Only users with calculated charts

    // Exclude current user
    if (currentUserId != null) {
      query = query.neq('id', currentUserId);
    }

    final response = await query
        .order('follower_count', ascending: false)
        .limit(limit);

    // Get follow relationships
    final userIds = (response as List)
        .map((json) => json['id'] as String)
        .toList();

    final followingSet = currentUserId != null
        ? await _getFollowingSet(userIds)
        : <String>{};

    return response.map((json) {
      final userId = json['id'] as String;
      return DiscoveredUser.fromJson(
        json,
        isFollowing: followingSet.contains(userId),
      );
    }).toList();
  }
}
