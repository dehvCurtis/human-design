import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/social_repository.dart';

/// Provider for the social repository
final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SocialRepository(supabaseClient: client);
});

/// Provider for the user's friends list
final friendsProvider = FutureProvider<List<Friend>>((ref) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getFriends();
});

/// Provider for pending friend requests
final pendingRequestsProvider = FutureProvider<List<FriendRequest>>((ref) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getPendingRequests();
});

/// Provider for the user's groups
final groupsProvider = FutureProvider<List<Group>>((ref) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getGroups();
});

/// Provider for charts shared with the user
final sharedChartsProvider = FutureProvider<List<SharedChart>>((ref) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getChartsSharedWithMe();
});

/// Provider for group members (by group ID)
final groupMembersProvider =
    FutureProvider.family<List<GroupMember>, String>((ref, groupId) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getGroupMembers(groupId);
});

/// Provider for chart comments (by chart ID)
final chartCommentsProvider =
    FutureProvider.family<List<Comment>, String>((ref, chartId) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getChartComments(chartId);
});

/// Notifier for social actions
class SocialNotifier extends Notifier<SocialState> {
  @override
  SocialState build() {
    return const SocialState();
  }

  SocialRepository get _repository => ref.read(socialRepositoryProvider);

  /// Send a friend request by user ID
  Future<void> sendFriendRequest(String friendId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.sendFriendRequest(friendId);
      state = state.copyWith(isLoading: false);
      // Invalidate pending requests to refresh
      ref.invalidate(pendingRequestsProvider);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Accept a friend request
  Future<void> acceptFriendRequest(String requestId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.acceptFriendRequest(requestId);
      state = state.copyWith(isLoading: false);
      // Invalidate both lists to refresh
      ref.invalidate(friendsProvider);
      ref.invalidate(pendingRequestsProvider);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Decline a friend request
  Future<void> declineFriendRequest(String requestId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.declineFriendRequest(requestId);
      state = state.copyWith(isLoading: false);
      ref.invalidate(pendingRequestsProvider);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create a new group
  Future<Group?> createGroup({
    required String name,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final group = await _repository.createGroup(
        name: name,
        description: description,
      );
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupsProvider);
      return group;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Share chart with a friend
  Future<void> shareChartWithFriend({
    required String chartId,
    required String friendId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.shareChartWithFriend(
        chartId: chartId,
        friendId: friendId,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Share chart with a group
  Future<void> shareChartWithGroup({
    required String chartId,
    required String groupId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.shareChartWithGroup(
        chartId: chartId,
        groupId: groupId,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Add a comment to a chart
  Future<Comment?> addComment({
    required String chartId,
    required String content,
    String? elementType,
    String? elementId,
    String? parentId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final comment = await _repository.addComment(
        chartId: chartId,
        content: content,
        elementType: elementType,
        elementId: elementId,
        parentId: parentId,
      );
      state = state.copyWith(isLoading: false);
      ref.invalidate(chartCommentsProvider(chartId));
      return comment;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for the social notifier
final socialNotifierProvider =
    NotifierProvider<SocialNotifier, SocialState>(SocialNotifier.new);

/// State for social operations
class SocialState {
  const SocialState({
    this.isLoading = false,
    this.error,
  });

  final bool isLoading;
  final String? error;

  SocialState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return SocialState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
