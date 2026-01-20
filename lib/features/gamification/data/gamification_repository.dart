import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/gamification.dart';

/// Repository for Gamification operations (points, badges, challenges, leaderboards)
class GamificationRepository {
  GamificationRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Points ====================

  /// Get current user's points data
  Future<UserPoints?> getUserPoints() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('user_points')
        .select('*')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      // Create initial record
      final newRecord = await _client.from('user_points').insert({
        'user_id': userId,
      }).select().single();
      return UserPoints.fromJson(newRecord);
    }

    return UserPoints.fromJson(response);
  }

  /// Award points to user (calls database function)
  Future<int> awardPoints({
    required PointActionType actionType,
    String? description,
    String? referenceId,
    int? customPoints,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final points = customPoints ?? actionType.defaultPoints;

    final response = await _client.rpc('award_points', params: {
      'p_user_id': userId,
      'p_points': points,
      'p_action_type': actionType.dbValue,
      'p_description': description,
      'p_reference_id': referenceId,
    });

    return response as int;
  }

  /// Get user's point transaction history
  Future<List<PointTransaction>> getPointHistory({int limit = 50}) async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('point_transactions')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => PointTransaction.fromJson(json))
        .toList();
  }

  // ==================== Badges ====================

  /// Get all available badges
  Future<List<Badge>> getAllBadges() async {
    final response = await _client
        .from('badges')
        .select('*')
        .eq('is_hidden', false)
        .order('sort_order', ascending: true);

    return (response as List).map((json) => Badge.fromJson(json)).toList();
  }

  /// Get user's earned badges
  Future<List<UserBadge>> getUserBadges() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('user_badges')
        .select('*, badge:badges(*)')
        .eq('user_id', userId)
        .order('earned_at', ascending: false);

    return (response as List).map((json) {
      final badgeJson = json['badge'] as Map<String, dynamic>;
      return UserBadge.fromJson(json, Badge.fromJson(badgeJson));
    }).toList();
  }

  /// Get badges with user progress (earned and unearned)
  Future<List<({Badge badge, UserBadge? userBadge})>> getBadgesWithProgress() async {
    final allBadges = await getAllBadges();
    final userBadges = await getUserBadges();

    final userBadgeMap = {for (final ub in userBadges) ub.badgeId: ub};

    return allBadges.map((badge) {
      return (badge: badge, userBadge: userBadgeMap[badge.id]);
    }).toList();
  }

  /// Award a badge to user
  Future<UserBadge?> awardBadge(String badgeId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Check if already earned
    final existing = await _client
        .from('user_badges')
        .select('*')
        .eq('user_id', userId)
        .eq('badge_id', badgeId)
        .maybeSingle();

    if (existing != null) return null; // Already earned

    // Award badge
    final response = await _client.from('user_badges').insert({
      'user_id': userId,
      'badge_id': badgeId,
    }).select('*, badge:badges(*)').single();

    final badgeJson = response['badge'] as Map<String, dynamic>;
    final badge = Badge.fromJson(badgeJson);

    // Award points for badge
    if (badge.pointsAwarded > 0) {
      await awardPoints(
        actionType: PointActionType.badgeEarned,
        customPoints: badge.pointsAwarded,
        description: 'Earned badge: ${badge.name}',
        referenceId: badgeId,
      );
    }

    return UserBadge.fromJson(response, badge);
  }

  /// Set a badge as featured on profile
  Future<void> setFeaturedBadge(String userBadgeId, bool isFeatured) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // If setting as featured, unfeature others first
    if (isFeatured) {
      await _client
          .from('user_badges')
          .update({'is_featured': false})
          .eq('user_id', userId);
    }

    await _client
        .from('user_badges')
        .update({'is_featured': isFeatured})
        .eq('id', userBadgeId);
  }

  // ==================== Challenges ====================

  /// Get active challenges
  Future<List<Challenge>> getActiveChallenges({ChallengeType? type}) async {
    var query = _client
        .from('challenges')
        .select('*')
        .eq('is_active', true);

    if (type != null) {
      query = query.eq('challenge_type', type.name);
    }

    final response = await query;
    return (response as List).map((json) => Challenge.fromJson(json)).toList();
  }

  /// Get user's current challenges
  Future<List<UserChallenge>> getUserChallenges({bool includeCompleted = false}) async {
    final userId = _currentUserId;
    if (userId == null) return [];

    var query = _client
        .from('user_challenges')
        .select('*, challenge:challenges(*)')
        .eq('user_id', userId);

    if (!includeCompleted) {
      query = query.eq('is_completed', false);
    }

    final response = await query.order('assigned_date', ascending: false);

    return (response as List).map((json) {
      final challengeJson = json['challenge'] as Map<String, dynamic>;
      return UserChallenge.fromJson(json, Challenge.fromJson(challengeJson));
    }).toList();
  }

  /// Assign a challenge to user
  Future<UserChallenge> assignChallenge(String challengeId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Get challenge details first
    final challengeResponse = await _client
        .from('challenges')
        .select('*')
        .eq('id', challengeId)
        .single();

    final challenge = Challenge.fromJson(challengeResponse);

    final response = await _client.from('user_challenges').insert({
      'user_id': userId,
      'challenge_id': challengeId,
    }).select('*, challenge:challenges(*)').single();

    return UserChallenge.fromJson(response, challenge);
  }

  /// Update challenge progress
  Future<UserChallenge> updateChallengeProgress(
    String userChallengeId,
    int newProgress,
  ) async {
    // Get current challenge to check completion
    final current = await _client
        .from('user_challenges')
        .select('*, challenge:challenges(*)')
        .eq('id', userChallengeId)
        .single();

    final challengeJson = current['challenge'] as Map<String, dynamic>;
    final challenge = Challenge.fromJson(challengeJson);

    final isCompleted = newProgress >= challenge.targetValue;

    final response = await _client
        .from('user_challenges')
        .update({
          'progress': newProgress,
          'is_completed': isCompleted,
          if (isCompleted) 'completed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userChallengeId)
        .select('*, challenge:challenges(*)')
        .single();

    // Award points if completed
    if (isCompleted && !(current['is_completed'] as bool)) {
      await awardPoints(
        actionType: PointActionType.completeChallenge,
        customPoints: challenge.pointsReward,
        description: 'Completed challenge: ${challenge.title}',
        referenceId: userChallengeId,
      );
    }

    return UserChallenge.fromJson(response, challenge);
  }

  /// Increment challenge progress by action type
  Future<void> incrementChallengeProgress(String actionType) async {
    final userId = _currentUserId;
    if (userId == null) return;

    // Find active challenges that match this action
    final userChallenges = await _client
        .from('user_challenges')
        .select('*, challenge:challenges(*)')
        .eq('user_id', userId)
        .eq('is_completed', false);

    for (final uc in userChallenges as List) {
      final challenge = Challenge.fromJson(uc['challenge'] as Map<String, dynamic>);
      if (challenge.actionType == actionType) {
        await updateChallengeProgress(
          uc['id'] as String,
          (uc['progress'] as int) + 1,
        );
      }
    }
  }

  // ==================== Leaderboards ====================

  /// Get leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard({
    LeaderboardType type = LeaderboardType.weekly,
    int limit = 50,
  }) async {
    String orderColumn;
    switch (type) {
      case LeaderboardType.weekly:
        orderColumn = 'weekly_points';
      case LeaderboardType.monthly:
        orderColumn = 'monthly_points';
      case LeaderboardType.allTime:
        orderColumn = 'total_points';
      case LeaderboardType.streak:
        orderColumn = 'current_streak';
    }

    final response = await _client
        .from('user_points')
        .select('*, profile:profiles!user_points_user_id_fkey(name, avatar_url, hd_type)')
        .order(orderColumn, ascending: false)
        .limit(limit);

    return (response as List).asMap().entries.map((entry) {
      return LeaderboardEntry.fromJson(entry.value, entry.key + 1);
    }).toList();
  }

  /// Get user's rank on leaderboard
  Future<int> getUserRank({LeaderboardType type = LeaderboardType.weekly}) async {
    final userId = _currentUserId;
    if (userId == null) return -1;

    String orderColumn;
    switch (type) {
      case LeaderboardType.weekly:
        orderColumn = 'weekly_points';
      case LeaderboardType.monthly:
        orderColumn = 'monthly_points';
      case LeaderboardType.allTime:
        orderColumn = 'total_points';
      case LeaderboardType.streak:
        orderColumn = 'current_streak';
    }

    // Get user's score
    final userResponse = await _client
        .from('user_points')
        .select(orderColumn)
        .eq('user_id', userId)
        .maybeSingle();

    if (userResponse == null) return -1;

    final userScore = userResponse[orderColumn] as int;

    // Count users with higher score
    final countResponse = await _client
        .from('user_points')
        .select('user_id')
        .gt(orderColumn, userScore);

    return (countResponse as List).length + 1;
  }

  // ==================== Streaks ====================

  /// Check and update daily streak
  Future<({int currentStreak, bool isNewDay})> checkStreak() async {
    final points = await getUserPoints();
    if (points == null) return (currentStreak: 0, isNewDay: false);

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (points.lastActivityDate == null) {
      return (currentStreak: 0, isNewDay: true);
    }

    final lastDate = DateTime(
      points.lastActivityDate!.year,
      points.lastActivityDate!.month,
      points.lastActivityDate!.day,
    );

    if (lastDate.isAtSameMomentAs(todayDate)) {
      // Already logged in today
      return (currentStreak: points.currentStreak, isNewDay: false);
    }

    final yesterday = todayDate.subtract(const Duration(days: 1));
    if (lastDate.isAtSameMomentAs(yesterday)) {
      // Continuing streak
      return (currentStreak: points.currentStreak + 1, isNewDay: true);
    }

    // Streak broken
    return (currentStreak: 1, isNewDay: true);
  }

  /// Award daily login points and check for streak bonuses
  Future<void> recordDailyLogin() async {
    final streakInfo = await checkStreak();

    if (streakInfo.isNewDay) {
      // Award daily login points
      await awardPoints(actionType: PointActionType.dailyLogin);

      // Check for streak milestones
      if (streakInfo.currentStreak == 7) {
        await awardPoints(
          actionType: PointActionType.streakBonus7,
          description: '7-day streak bonus!',
        );
      } else if (streakInfo.currentStreak == 30) {
        await awardPoints(
          actionType: PointActionType.streakBonus30,
          description: '30-day streak bonus!',
        );
      }

      // Auto-assign daily challenges
      await autoAssignDailyChallenges();
    }
  }

  /// Auto-assign daily challenges if not already assigned today
  Future<void> autoAssignDailyChallenges() async {
    final userId = _currentUserId;
    if (userId == null) return;

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Check if daily challenges already assigned today
    final existingToday = await _client
        .from('user_challenges')
        .select('challenge_id')
        .eq('user_id', userId)
        .gte('assigned_date', todayStart.toIso8601String());

    final assignedChallengeIds = (existingToday as List)
        .map((e) => e['challenge_id'] as String)
        .toSet();

    // Get active daily challenges
    final dailyChallenges = await getActiveChallenges(type: ChallengeType.daily);

    // Assign any not yet assigned for today
    for (final challenge in dailyChallenges) {
      if (!assignedChallengeIds.contains(challenge.id)) {
        try {
          await assignChallenge(challenge.id);
        } catch (_) {
          // Ignore if already assigned (race condition)
        }
      }
    }
  }

  /// Initialize gamification for user (call on app start)
  Future<void> initializeForUser() async {
    if (_currentUserId == null) return;

    // Ensure user_points record exists
    await getUserPoints();

    // Record daily login and auto-assign challenges
    await recordDailyLogin();
  }
}
