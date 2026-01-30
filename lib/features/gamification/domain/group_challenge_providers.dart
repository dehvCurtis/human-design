import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/group_challenge_repository.dart';
import 'models/group_challenge.dart';

/// Repository provider
final groupChallengeRepositoryProvider = Provider<GroupChallengeRepository>((ref) {
  return GroupChallengeRepository(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

// ==================== Teams ====================

/// Get user's teams
final myTeamsProvider = FutureProvider<List<ChallengeTeam>>((ref) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getMyTeams();
});

/// Get a specific team
final teamProvider = FutureProvider.family<ChallengeTeam?, String>((ref, teamId) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getTeam(teamId);
});

/// Get team members
final teamMembersProvider = FutureProvider.family<List<TeamMember>, String>((ref, teamId) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getTeamMembers(teamId);
});

/// Check if user is member of a team
final isTeamMemberProvider = FutureProvider.family<bool, String>((ref, teamId) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.isTeamMember(teamId);
});

// ==================== Group Challenges ====================

/// Get active group challenges
final activeGroupChallengesProvider = FutureProvider<List<GroupChallenge>>((ref) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getActiveGroupChallenges();
});

/// Get a specific group challenge
final groupChallengeProvider = FutureProvider.family<GroupChallenge?, String>((ref, challengeId) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getGroupChallenge(challengeId);
});

/// Get team's progress in a challenge
final teamChallengeProgressProvider = FutureProvider.family<TeamChallengeProgress?, ({String teamId, String challengeId})>((ref, params) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getTeamProgress(params.teamId, params.challengeId);
});

// ==================== Leaderboards ====================

/// Get team leaderboard
final teamLeaderboardProvider = FutureProvider.family<List<TeamLeaderboardEntry>, TeamLeaderboardType>((ref, type) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getTeamLeaderboard(type: type);
});

/// Get challenge-specific leaderboard
final challengeLeaderboardProvider = FutureProvider.family<List<TeamLeaderboardEntry>, String>((ref, challengeId) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getChallengeLeaderboard(challengeId);
});

/// Get user's team rank
final userTeamRankProvider = FutureProvider.family<int?, ({String teamId, TeamLeaderboardType type})>((ref, params) async {
  final repository = ref.watch(groupChallengeRepositoryProvider);
  return repository.getUserTeamRank(params.teamId, type: params.type);
});

// ==================== Notifier ====================

/// Notifier for group challenge mutations
class GroupChallengeNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  GroupChallengeRepository get _repository => ref.read(groupChallengeRepositoryProvider);

  /// Create a new team
  Future<ChallengeTeam?> createTeam({
    required String name,
    String? description,
    String? avatarUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      final team = await _repository.createTeam(
        name: name,
        description: description,
        avatarUrl: avatarUrl,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(myTeamsProvider);
      return team;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Join a team
  Future<bool> joinTeam(String teamId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.joinTeam(teamId);
      state = const AsyncValue.data(null);
      ref.invalidate(myTeamsProvider);
      ref.invalidate(teamMembersProvider(teamId));
      ref.invalidate(isTeamMemberProvider(teamId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Leave a team
  Future<bool> leaveTeam(String teamId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.leaveTeam(teamId);
      state = const AsyncValue.data(null);
      ref.invalidate(myTeamsProvider);
      ref.invalidate(teamMembersProvider(teamId));
      ref.invalidate(isTeamMemberProvider(teamId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Enroll team in a challenge
  Future<bool> enrollTeamInChallenge(String teamId, String challengeId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.enrollTeamInChallenge(teamId, challengeId);
      state = const AsyncValue.data(null);
      ref.invalidate(teamChallengeProgressProvider((teamId: teamId, challengeId: challengeId)));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Contribute points to team
  Future<bool> contributePointsToTeam(String teamId, int points) async {
    state = const AsyncValue.loading();
    try {
      await _repository.contributePointsToTeam(teamId: teamId, points: points);
      state = const AsyncValue.data(null);
      ref.invalidate(teamProvider(teamId));
      ref.invalidate(teamMembersProvider(teamId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final groupChallengeNotifierProvider = NotifierProvider<GroupChallengeNotifier, AsyncValue<void>>(() {
  return GroupChallengeNotifier();
});
