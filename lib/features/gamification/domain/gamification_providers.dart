import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/gamification_repository.dart';
import 'models/gamification.dart';

/// Provider for the GamificationRepository
final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return GamificationRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for user's points data
final userPointsProvider = FutureProvider<UserPoints?>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getUserPoints();
});

/// Provider for point transaction history
final pointHistoryProvider = FutureProvider<List<PointTransaction>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getPointHistory();
});

/// Provider for all badges with user progress
final badgesWithProgressProvider = FutureProvider<List<({Badge badge, UserBadge? userBadge})>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getBadgesWithProgress();
});

/// Provider for user's earned badges only
final userBadgesProvider = FutureProvider<List<UserBadge>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getUserBadges();
});

/// Provider for active challenges
final activeChallengesProvider = FutureProvider<List<Challenge>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getActiveChallenges();
});

/// Provider for user's current challenges
final userChallengesProvider = FutureProvider<List<UserChallenge>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getUserChallenges();
});

/// Provider for leaderboard
final leaderboardProvider = FutureProvider.family<List<LeaderboardEntry>, LeaderboardType>((ref, type) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getLeaderboard(type: type);
});

/// Provider for user's rank
final userRankProvider = FutureProvider.family<int, LeaderboardType>((ref, type) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getUserRank(type: type);
});

/// Notifier for managing gamification actions
class GamificationNotifier extends Notifier<GamificationState> {
  @override
  GamificationState build() => const GamificationState();

  GamificationRepository get _repository => ref.read(gamificationRepositoryProvider);

  /// Award points for an action
  Future<int> awardPoints({
    required PointActionType actionType,
    String? description,
    String? referenceId,
    int? customPoints,
  }) async {
    final newTotal = await _repository.awardPoints(
      actionType: actionType,
      description: description,
      referenceId: referenceId,
      customPoints: customPoints,
    );

    // Show points animation
    state = state.copyWith(
      lastPointsAwarded: customPoints ?? actionType.defaultPoints,
      showPointsAnimation: true,
    );

    // Refresh points data
    ref.invalidate(userPointsProvider);
    ref.invalidate(pointHistoryProvider);

    // Increment any relevant challenges
    await _repository.incrementChallengeProgress(actionType.dbValue);
    ref.invalidate(userChallengesProvider);

    return newTotal;
  }

  /// Record daily login
  Future<void> recordDailyLogin() async {
    await _repository.recordDailyLogin();
    ref.invalidate(userPointsProvider);
  }

  /// Award a badge
  Future<UserBadge?> awardBadge(String badgeId) async {
    final userBadge = await _repository.awardBadge(badgeId);

    if (userBadge != null) {
      state = state.copyWith(
        lastBadgeEarned: userBadge,
        showBadgeAnimation: true,
      );

      ref.invalidate(userBadgesProvider);
      ref.invalidate(badgesWithProgressProvider);
      ref.invalidate(userPointsProvider);
    }

    return userBadge;
  }

  /// Set a badge as featured
  Future<void> setFeaturedBadge(String userBadgeId, bool isFeatured) async {
    await _repository.setFeaturedBadge(userBadgeId, isFeatured);
    ref.invalidate(userBadgesProvider);
  }

  /// Assign a challenge to user
  Future<UserChallenge> assignChallenge(String challengeId) async {
    final challenge = await _repository.assignChallenge(challengeId);
    ref.invalidate(userChallengesProvider);
    return challenge;
  }

  /// Update challenge progress
  Future<void> updateChallengeProgress(String userChallengeId, int progress) async {
    final updated = await _repository.updateChallengeProgress(userChallengeId, progress);

    if (updated.isCompleted) {
      state = state.copyWith(
        lastChallengeCompleted: updated,
        showChallengeAnimation: true,
      );
    }

    ref.invalidate(userChallengesProvider);
    ref.invalidate(userPointsProvider);
  }

  /// Check for badge eligibility based on conditions
  Future<void> checkBadgeEligibility() async {
    final points = await ref.read(userPointsProvider.future);
    if (points == null) return;

    final badgesWithProgress = await ref.read(badgesWithProgressProvider.future);

    for (final item in badgesWithProgress) {
      if (item.userBadge != null) continue; // Already earned

      final badge = item.badge;
      bool shouldAward = false;

      switch (badge.requirementType) {
        case BadgeRequirementType.streak:
          if (badge.requirementValue != null &&
              points.currentStreak >= badge.requirementValue!) {
            shouldAward = true;
          }
        case BadgeRequirementType.count:
          // Count-based badges require external tracking
          break;
        case BadgeRequirementType.special:
          // Special badges are awarded programmatically
          break;
      }

      if (shouldAward) {
        await awardBadge(badge.id);
      }
    }
  }

  void dismissPointsAnimation() {
    state = state.copyWith(showPointsAnimation: false);
  }

  void dismissBadgeAnimation() {
    state = state.copyWith(showBadgeAnimation: false);
  }

  void dismissChallengeAnimation() {
    state = state.copyWith(showChallengeAnimation: false);
  }
}

final gamificationNotifierProvider = NotifierProvider<GamificationNotifier, GamificationState>(() {
  return GamificationNotifier();
});

/// State class for gamification UI
class GamificationState {
  const GamificationState({
    this.lastPointsAwarded,
    this.showPointsAnimation = false,
    this.lastBadgeEarned,
    this.showBadgeAnimation = false,
    this.lastChallengeCompleted,
    this.showChallengeAnimation = false,
  });

  final int? lastPointsAwarded;
  final bool showPointsAnimation;
  final UserBadge? lastBadgeEarned;
  final bool showBadgeAnimation;
  final UserChallenge? lastChallengeCompleted;
  final bool showChallengeAnimation;

  GamificationState copyWith({
    int? lastPointsAwarded,
    bool? showPointsAnimation,
    UserBadge? lastBadgeEarned,
    bool? showBadgeAnimation,
    UserChallenge? lastChallengeCompleted,
    bool? showChallengeAnimation,
  }) {
    return GamificationState(
      lastPointsAwarded: lastPointsAwarded ?? this.lastPointsAwarded,
      showPointsAnimation: showPointsAnimation ?? this.showPointsAnimation,
      lastBadgeEarned: lastBadgeEarned ?? this.lastBadgeEarned,
      showBadgeAnimation: showBadgeAnimation ?? this.showBadgeAnimation,
      lastChallengeCompleted: lastChallengeCompleted ?? this.lastChallengeCompleted,
      showChallengeAnimation: showChallengeAnimation ?? this.showChallengeAnimation,
    );
  }
}
