import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/compatibility_circle_repository.dart';
import 'models/compatibility_circle.dart';

/// Repository provider
final compatibilityCircleRepositoryProvider = Provider<CompatibilityCircleRepository>((ref) {
  return CompatibilityCircleRepository(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

// ==================== Circles ====================

/// Get user's circles
final myCirclesProvider = FutureProvider<List<CompatibilityCircle>>((ref) async {
  final repository = ref.watch(compatibilityCircleRepositoryProvider);
  return repository.getMyCircles();
});

/// Get a specific circle
final circleProvider = FutureProvider.family<CompatibilityCircle?, String>((ref, circleId) async {
  final repository = ref.watch(compatibilityCircleRepositoryProvider);
  return repository.getCircle(circleId);
});

/// Get circle members
final circleMembersProvider = FutureProvider.family<List<CircleMember>, String>((ref, circleId) async {
  final repository = ref.watch(compatibilityCircleRepositoryProvider);
  return repository.getCircleMembers(circleId);
});

/// Check if user is a member of a circle
final isCircleMemberProvider = FutureProvider.family<bool, String>((ref, circleId) async {
  final repository = ref.watch(compatibilityCircleRepositoryProvider);
  return repository.isMember(circleId);
});

/// Get pending invitations
final pendingCircleInvitationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(compatibilityCircleRepositoryProvider);
  return repository.getPendingInvitations();
});

// ==================== Circle Feed ====================

/// Get circle posts
final circlePostsProvider = FutureProvider.family<List<CirclePost>, String>((ref, circleId) async {
  final repository = ref.watch(compatibilityCircleRepositoryProvider);
  return repository.getCirclePosts(circleId);
});

// ==================== Analysis ====================

/// Get circle compatibility analysis
final circleAnalysisProvider = FutureProvider.family<CircleCompatibilityAnalysis?, String>((ref, circleId) async {
  final repository = ref.watch(compatibilityCircleRepositoryProvider);
  return repository.getCircleAnalysis(circleId);
});

// ==================== Notifier ====================

/// Notifier for compatibility circle mutations
class CompatibilityCircleNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  CompatibilityCircleRepository get _repository => ref.read(compatibilityCircleRepositoryProvider);

  /// Create a new circle
  Future<CompatibilityCircle?> createCircle({
    required String name,
    String? description,
    String? iconEmoji,
    bool isPrivate = true,
  }) async {
    state = const AsyncValue.loading();
    try {
      final circle = await _repository.createCircle(
        name: name,
        description: description,
        iconEmoji: iconEmoji,
        isPrivate: isPrivate,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(myCirclesProvider);
      return circle;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update a circle
  Future<bool> updateCircle({
    required String circleId,
    String? name,
    String? description,
    String? iconEmoji,
    bool? isPrivate,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateCircle(
        circleId: circleId,
        name: name,
        description: description,
        iconEmoji: iconEmoji,
        isPrivate: isPrivate,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(circleProvider(circleId));
      ref.invalidate(myCirclesProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Delete a circle
  Future<bool> deleteCircle(String circleId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteCircle(circleId);
      state = const AsyncValue.data(null);
      ref.invalidate(myCirclesProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Add a member to a circle
  Future<bool> addMember(String circleId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addMember(circleId, userId);
      state = const AsyncValue.data(null);
      ref.invalidate(circleMembersProvider(circleId));
      ref.invalidate(circleProvider(circleId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Remove a member from a circle
  Future<bool> removeMember(String circleId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeMember(circleId, userId);
      state = const AsyncValue.data(null);
      ref.invalidate(circleMembersProvider(circleId));
      ref.invalidate(circleProvider(circleId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Invite a user to a circle
  Future<bool> inviteUser(String circleId, String email) async {
    state = const AsyncValue.loading();
    try {
      await _repository.inviteUser(circleId, email);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Accept a circle invitation
  Future<bool> acceptInvitation(String invitationId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.acceptInvitation(invitationId);
      state = const AsyncValue.data(null);
      ref.invalidate(myCirclesProvider);
      ref.invalidate(pendingCircleInvitationsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Decline a circle invitation
  Future<bool> declineInvitation(String invitationId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.declineInvitation(invitationId);
      state = const AsyncValue.data(null);
      ref.invalidate(pendingCircleInvitationsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Create a post in a circle
  Future<CirclePost?> createPost({
    required String circleId,
    required String content,
    String? mediaUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      final post = await _repository.createPost(
        circleId: circleId,
        content: content,
        mediaUrl: mediaUrl,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(circlePostsProvider(circleId));
      return post;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Delete a post
  Future<bool> deletePost(String circleId, String postId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deletePost(postId);
      state = const AsyncValue.data(null);
      ref.invalidate(circlePostsProvider(circleId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Request a new analysis
  Future<bool> requestAnalysis(String circleId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.requestAnalysis(circleId);
      state = const AsyncValue.data(null);
      ref.invalidate(circleAnalysisProvider(circleId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final compatibilityCircleNotifierProvider = NotifierProvider<CompatibilityCircleNotifier, AsyncValue<void>>(() {
  return CompatibilityCircleNotifier();
});
