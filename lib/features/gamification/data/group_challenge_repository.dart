import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/group_challenge.dart';

/// Repository for group challenges and team leaderboards
class GroupChallengeRepository {
  GroupChallengeRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Teams ====================

  /// Create a new team
  Future<ChallengeTeam> createTeam({
    required String name,
    String? description,
    String? avatarUrl,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('challenge_teams').insert({
      'name': name,
      'description': description,
      'avatar_url': avatarUrl,
      'creator_id': userId,
    }).select().single();

    final team = ChallengeTeam.fromJson(response);

    // Add creator as admin
    await joinTeam(team.id, role: TeamRole.admin);

    return team;
  }

  /// Get a team by ID
  Future<ChallengeTeam?> getTeam(String teamId) async {
    final response = await _client
        .from('challenge_teams')
        .select()
        .eq('id', teamId)
        .maybeSingle();

    if (response == null) return null;
    return ChallengeTeam.fromJson(response);
  }

  /// Get teams for current user
  Future<List<ChallengeTeam>> getMyTeams() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('team_members')
        .select('team:challenge_teams(*)')
        .eq('user_id', userId);

    return (response as List)
        .map((json) => ChallengeTeam.fromJson(json['team']))
        .toList();
  }

  /// Get team members
  Future<List<TeamMember>> getTeamMembers(String teamId) async {
    final response = await _client
        .from('team_members')
        .select('''
          *,
          user:profiles!team_members_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('team_id', teamId)
        .order('points_contributed', ascending: false);

    return (response as List)
        .map((json) => TeamMember.fromJson(json))
        .toList();
  }

  /// Join a team
  Future<void> joinTeam(String teamId, {TeamRole role = TeamRole.member}) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client.from('team_members').insert({
      'team_id': teamId,
      'user_id': userId,
      'role': role.dbValue,
    });

    // Update member count
    await _client.rpc('increment_team_member_count', params: {
      'team_id': teamId,
    });
  }

  /// Leave a team
  Future<void> leaveTeam(String teamId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('team_members')
        .delete()
        .eq('team_id', teamId)
        .eq('user_id', userId);

    // Update member count
    await _client.rpc('decrement_team_member_count', params: {
      'team_id': teamId,
    });
  }

  /// Check if user is in a team
  Future<bool> isTeamMember(String teamId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('team_members')
        .select('id')
        .eq('team_id', teamId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  // ==================== Group Challenges ====================

  /// Get active group challenges
  Future<List<GroupChallenge>> getActiveGroupChallenges() async {
    final now = DateTime.now().toIso8601String();

    final response = await _client
        .from('group_challenges')
        .select()
        .eq('is_active', true)
        .or('end_date.is.null,end_date.gte.$now')
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => GroupChallenge.fromJson(json))
        .toList();
  }

  /// Get a group challenge by ID
  Future<GroupChallenge?> getGroupChallenge(String challengeId) async {
    final response = await _client
        .from('group_challenges')
        .select()
        .eq('id', challengeId)
        .maybeSingle();

    if (response == null) return null;
    return GroupChallenge.fromJson(response);
  }

  /// Enroll a team in a group challenge
  Future<void> enrollTeamInChallenge(String teamId, String challengeId) async {
    await _client.from('team_challenge_progress').insert({
      'team_id': teamId,
      'challenge_id': challengeId,
      'progress': 0,
      'is_completed': false,
    });
  }

  /// Get team's progress in a challenge
  Future<TeamChallengeProgress?> getTeamProgress(
    String teamId,
    String challengeId,
  ) async {
    final response = await _client
        .from('team_challenge_progress')
        .select()
        .eq('team_id', teamId)
        .eq('challenge_id', challengeId)
        .maybeSingle();

    if (response == null) return null;
    return TeamChallengeProgress.fromJson(response);
  }

  /// Update team's challenge progress
  Future<void> updateTeamProgress({
    required String teamId,
    required String challengeId,
    required int progressIncrement,
  }) async {
    await _client.rpc('increment_team_challenge_progress', params: {
      'target_team_id': teamId,
      'target_challenge_id': challengeId,
      'increment': progressIncrement,
    });
  }

  /// Contribute points to team
  Future<void> contributePointsToTeam({
    required String teamId,
    required int points,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Update member's contribution
    await _client.rpc('contribute_points_to_team', params: {
      'target_team_id': teamId,
      'contributor_id': userId,
      'points': points,
    });
  }

  // ==================== Team Leaderboards ====================

  /// Get team leaderboard
  Future<List<TeamLeaderboardEntry>> getTeamLeaderboard({
    TeamLeaderboardType type = TeamLeaderboardType.allTime,
    int limit = 50,
  }) async {
    String orderBy;
    switch (type) {
      case TeamLeaderboardType.weekly:
        orderBy = 'weekly_points';
        break;
      case TeamLeaderboardType.monthly:
        orderBy = 'monthly_points';
        break;
      case TeamLeaderboardType.allTime:
      case TeamLeaderboardType.challengeSpecific:
        orderBy = 'total_points';
        break;
    }

    final response = await _client
        .from('challenge_teams')
        .select()
        .order(orderBy, ascending: false)
        .limit(limit);

    final teams = (response as List);
    return teams.asMap().entries.map((entry) {
      return TeamLeaderboardEntry.fromJson(entry.value, entry.key + 1);
    }).toList();
  }

  /// Get user's team rank
  Future<int?> getUserTeamRank(String teamId, {
    TeamLeaderboardType type = TeamLeaderboardType.allTime,
  }) async {
    final team = await getTeam(teamId);
    if (team == null) return null;

    String column;
    switch (type) {
      case TeamLeaderboardType.weekly:
        column = 'weekly_points';
        break;
      case TeamLeaderboardType.monthly:
        column = 'monthly_points';
        break;
      case TeamLeaderboardType.allTime:
      case TeamLeaderboardType.challengeSpecific:
        column = 'total_points';
        break;
    }

    final response = await _client
        .from('challenge_teams')
        .select('id')
        .gt(column, team.totalPoints);

    return (response as List).length + 1;
  }

  /// Get challenge-specific leaderboard
  Future<List<TeamLeaderboardEntry>> getChallengeLeaderboard(
    String challengeId, {
    int limit = 50,
  }) async {
    final response = await _client
        .from('team_challenge_progress')
        .select('team:challenge_teams(*), progress')
        .eq('challenge_id', challengeId)
        .order('progress', ascending: false)
        .limit(limit);

    final entries = (response as List);
    return entries.asMap().entries.map((entry) {
      final json = entry.value['team'] as Map<String, dynamic>;
      json['total_points'] = entry.value['progress'];
      return TeamLeaderboardEntry.fromJson(json, entry.key + 1);
    }).toList();
  }

  // ==================== Realtime ====================

  /// Subscribe to team updates
  RealtimeChannel subscribeToTeam(
    String teamId,
    void Function(ChallengeTeam team) onUpdate,
  ) {
    return _client
        .channel('team:$teamId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'challenge_teams',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: teamId,
          ),
          callback: (payload) {
            onUpdate(ChallengeTeam.fromJson(payload.newRecord));
          },
        )
        .subscribe();
  }
}
