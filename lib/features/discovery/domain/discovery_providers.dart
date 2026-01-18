import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/discovery_repository.dart';
import 'models/user_discovery.dart';
import 'matching_service.dart';

/// Provider for the MatchingService
final matchingServiceProvider = Provider<MatchingService>((ref) {
  return MatchingService();
});

/// Provider for the DiscoveryRepository
final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepository(
    supabaseClient: ref.watch(supabaseClientProvider),
    matchingService: ref.watch(matchingServiceProvider),
  );
});

/// Provider for the current discovery filter state
final discoveryFilterProvider = StateProvider<DiscoveryFilter>((ref) {
  return const DiscoveryFilter();
});

/// Provider for discovered users based on current filter
final discoveredUsersProvider = FutureProvider<DiscoveryResult>((ref) async {
  final repository = ref.watch(discoveryRepositoryProvider);
  final filter = ref.watch(discoveryFilterProvider);

  return repository.discoverUsers(filter: filter);
});

/// Provider for user search results
final userSearchProvider = FutureProvider.family<List<DiscoveredUser>, String>((ref, query) async {
  if (query.isEmpty) return [];

  final repository = ref.watch(discoveryRepositoryProvider);
  return repository.searchUsers(query);
});

/// Provider for users the current user is following
final followingListProvider = FutureProvider<List<DiscoveredUser>>((ref) async {
  final repository = ref.watch(discoveryRepositoryProvider);
  return repository.getFollowing();
});

/// Provider for users following the current user
final followersListProvider = FutureProvider<List<DiscoveredUser>>((ref) async {
  final repository = ref.watch(discoveryRepositoryProvider);
  return repository.getFollowers();
});

/// Provider for follow counts of a specific user
final followCountsProvider = FutureProvider.family<({int followers, int following}), String>((ref, userId) async {
  final repository = ref.watch(discoveryRepositoryProvider);
  return repository.getFollowCounts(userId);
});

/// Provider for users by HD type
final usersByTypeProvider = FutureProvider.family<List<DiscoveredUser>, String>((ref, hdType) async {
  final repository = ref.watch(discoveryRepositoryProvider);
  return repository.getUsersByType(hdType);
});

/// Provider for blocked users
final blockedUsersProvider = FutureProvider<List<DiscoveredUser>>((ref) async {
  final repository = ref.watch(discoveryRepositoryProvider);
  return repository.getBlockedUsers();
});

/// Notifier for managing follow actions
class FollowNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  DiscoveryRepository get _repository => ref.read(discoveryRepositoryProvider);

  /// Toggle follow status for a user
  Future<void> toggleFollow(String userId, {required bool currentlyFollowing}) async {
    // Optimistic update
    state = {...state, userId: !currentlyFollowing};

    try {
      if (currentlyFollowing) {
        await _repository.unfollowUser(userId);
      } else {
        await _repository.followUser(userId);
      }

      // Invalidate related providers
      ref.invalidate(followingListProvider);
      ref.invalidate(followersListProvider);
      ref.invalidate(discoveredUsersProvider);
    } catch (e) {
      // Revert on error
      state = {...state, userId: currentlyFollowing};
      rethrow;
    }
  }

  /// Check if user is being followed (from local state or would need fresh check)
  bool? getFollowStatus(String userId) {
    return state[userId];
  }
}

final followNotifierProvider = NotifierProvider<FollowNotifier, Map<String, bool>>(() {
  return FollowNotifier();
});

/// Notifier for managing block actions
class BlockNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  DiscoveryRepository get _repository => ref.read(discoveryRepositoryProvider);

  Future<void> blockUser(String userId, {String? reason}) async {
    await _repository.blockUser(userId, reason: reason);
    state = {...state, userId};

    // Invalidate related providers
    ref.invalidate(blockedUsersProvider);
    ref.invalidate(followingListProvider);
    ref.invalidate(followersListProvider);
    ref.invalidate(discoveredUsersProvider);
  }

  Future<void> unblockUser(String userId) async {
    await _repository.unblockUser(userId);
    state = {...state}..remove(userId);

    ref.invalidate(blockedUsersProvider);
    ref.invalidate(discoveredUsersProvider);
  }

  bool isBlocked(String userId) => state.contains(userId);
}

final blockNotifierProvider = NotifierProvider<BlockNotifier, Set<String>>(() {
  return BlockNotifier();
});

/// Provider for suggested users based on compatibility
/// Requires passing user's chart data for calculation
final suggestedUsersProvider = FutureProvider.family<List<DiscoveredUser>, SuggestedUsersParams>((ref, params) async {
  final repository = ref.watch(discoveryRepositoryProvider);

  return repository.getSuggestedUsers(
    userType: params.userType,
    userProfile: params.userProfile,
    userGates: params.userGates,
    userDefinedCenters: params.userDefinedCenters,
  );
});

/// Parameters for suggested users provider
class SuggestedUsersParams {
  const SuggestedUsersParams({
    this.userType,
    this.userProfile,
    this.userGates,
    this.userDefinedCenters,
  });

  final String? userType;
  final String? userProfile;
  final List<int>? userGates;
  final List<String>? userDefinedCenters;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SuggestedUsersParams &&
        other.userType == userType &&
        other.userProfile == userProfile;
  }

  @override
  int get hashCode => Object.hash(userType, userProfile);
}
