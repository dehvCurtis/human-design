import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/social_repository.dart';

/// Provider for the social repository
final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SocialRepository(supabaseClient: client);
});

/// Provider for the user's groups
final groupsProvider = FutureProvider<List<Group>>((ref) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getGroups();
});

/// Provider for a single group (derived from groupsProvider)
final groupProvider =
    FutureProvider.family<Group?, String>((ref, groupId) async {
  final groups = await ref.watch(groupsProvider.future);
  try {
    return groups.firstWhere((g) => g.id == groupId);
  } catch (_) {
    return null;
  }
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

/// Provider for group posts (by group ID)
final groupPostsProvider =
    FutureProvider.family<List<GroupPost>, String>((ref, groupId) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getGroupPosts(groupId);
});

/// Provider for charts shared with a group
final groupSharedChartsProvider =
    FutureProvider.family<List<SharedChart>, String>((ref, groupId) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getGroupSharedCharts(groupId);
});

/// Parameters for invite search
class InviteSearchParams {
  const InviteSearchParams({required this.query, required this.groupId});

  final String query;
  final String groupId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InviteSearchParams &&
          query == other.query &&
          groupId == other.groupId;

  @override
  int get hashCode => Object.hash(query, groupId);
}

/// Provider for searching users to invite to a group
final groupInviteSearchProvider = FutureProvider.family<List<UserSearchResult>,
    InviteSearchParams>((ref, params) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.searchUsersForInvite(
    query: params.query,
    groupId: params.groupId,
  );
});

/// Notifier for social actions
class SocialNotifier extends Notifier<SocialState> {
  @override
  SocialState build() {
    return const SocialState();
  }

  SocialRepository get _repository => ref.read(socialRepositoryProvider);

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

  /// Update group details (admin only)
  Future<bool> updateGroup({
    required String groupId,
    String? name,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateGroup(
        groupId: groupId,
        name: name,
        description: description,
      );
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupsProvider);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Delete a group (admin only)
  Future<bool> deleteGroup(String groupId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteGroup(groupId);
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupsProvider);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Leave a group (remove self)
  Future<bool> leaveGroup(String groupId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userId = ref.read(supabaseClientProvider).auth.currentUser?.id;
      if (userId == null) throw StateError('User not authenticated');

      await _repository.removeGroupMember(
        groupId: groupId,
        userId: userId,
      );
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupsProvider);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Add member to group
  Future<bool> addMember({
    required String groupId,
    required String userId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.addGroupMember(
        groupId: groupId,
        userId: userId,
      );
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupMembersProvider(groupId));
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Remove member from group
  Future<bool> removeMember({
    required String groupId,
    required String userId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.removeGroupMember(
        groupId: groupId,
        userId: userId,
      );
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupMembersProvider(groupId));
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Update member role
  Future<bool> updateMemberRole({
    required String groupId,
    required String userId,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateMemberRole(
        groupId: groupId,
        userId: userId,
        role: role,
      );
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupMembersProvider(groupId));
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Create a post in a group
  Future<bool> createGroupPost({
    required String groupId,
    required String content,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.createGroupPost(
        groupId: groupId,
        content: content,
      );
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupPostsProvider(groupId));
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Delete a post in a group
  Future<bool> deleteGroupPost({
    required String groupId,
    required String postId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteGroupPost(postId);
      state = state.copyWith(isLoading: false);
      ref.invalidate(groupPostsProvider(groupId));
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
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
      ref.invalidate(groupSharedChartsProvider(groupId));
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
