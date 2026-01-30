import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/activity_repository.dart';
import 'models/activity.dart';

/// Provider for the ActivityRepository
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for friend activity feed
final friendActivityFeedProvider = FutureProvider<List<Activity>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getFriendActivities();
});

/// Provider for a user's own activities
final userActivityProvider = FutureProvider.family<List<Activity>, String>((ref, userId) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getUserActivity(userId);
});

/// Provider for checking if user has reacted to an activity
final hasReactedProvider = FutureProvider.family<bool, String>((ref, activityId) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.hasReacted(activityId);
});

/// Provider for activity reaction counts
final activityReactionCountProvider = FutureProvider.family<int, String>((ref, activityId) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getReactionCount(activityId);
});

/// Notifier for managing activity operations
class ActivityNotifier extends Notifier<ActivityState> {
  @override
  ActivityState build() => const ActivityState();

  ActivityRepository get _repository => ref.read(activityRepositoryProvider);

  /// Create a new activity
  Future<void> createActivity({
    required ActivityType activityType,
    String? targetId,
    String? targetName,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _repository.createActivity(
        activityType: activityType,
        targetId: targetId,
        targetName: targetName,
        metadata: metadata,
      );
      ref.invalidate(friendActivityFeedProvider);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// React to an activity
  Future<void> reactToActivity(String activityId) async {
    try {
      await _repository.reactToActivity(activityId);
      ref.invalidate(hasReactedProvider(activityId));
      ref.invalidate(activityReactionCountProvider(activityId));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Remove reaction from an activity
  Future<void> removeReaction(String activityId) async {
    try {
      await _repository.removeReaction(activityId);
      ref.invalidate(hasReactedProvider(activityId));
      ref.invalidate(activityReactionCountProvider(activityId));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final activityNotifierProvider = NotifierProvider<ActivityNotifier, ActivityState>(() {
  return ActivityNotifier();
});

/// State class for activity operations
class ActivityState {
  const ActivityState({
    this.error,
  });

  final String? error;

  ActivityState copyWith({
    String? error,
  }) {
    return ActivityState(
      error: error,
    );
  }
}
