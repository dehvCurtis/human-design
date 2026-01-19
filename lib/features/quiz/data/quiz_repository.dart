import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../domain/models/quiz.dart';
import '../domain/models/quiz_progress.dart';

/// Repository for Quiz operations
class QuizRepository {
  QuizRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;
  final _uuid = const Uuid();

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Quizzes ====================

  /// Get all active quizzes
  Future<List<Quiz>> getAllQuizzes({
    QuizCategory? category,
    QuizDifficulty? difficulty,
    bool includePremium = true,
  }) async {
    var query = _client
        .from('quizzes')
        .select('*, question_ids:quiz_question_map(question_id)')
        .eq('is_active', true);

    if (category != null) {
      query = query.eq('category', category.dbValue);
    }

    if (difficulty != null) {
      query = query.eq('difficulty', difficulty.dbValue);
    }

    if (!includePremium) {
      query = query.eq('is_premium', false);
    }

    final response = await query.order('sort_order', ascending: true);

    return (response as List).map((json) {
      // Extract question IDs from the join
      final questionIds = (json['question_ids'] as List?)
              ?.map((e) => e['question_id'] as String)
              .toList() ??
          [];
      return Quiz.fromJson({
        ...json,
        'question_ids': questionIds,
      });
    }).toList();
  }

  /// Get a specific quiz by ID
  Future<Quiz?> getQuizById(String quizId) async {
    final response = await _client
        .from('quizzes')
        .select('*, question_ids:quiz_question_map(question_id)')
        .eq('id', quizId)
        .maybeSingle();

    if (response == null) return null;

    final questionIds = (response['question_ids'] as List?)
            ?.map((e) => e['question_id'] as String)
            .toList() ??
        [];

    return Quiz.fromJson({
      ...response,
      'question_ids': questionIds,
    });
  }

  /// Get quiz with all questions loaded
  Future<QuizWithQuestions?> getQuizWithQuestions(String quizId) async {
    final quiz = await getQuizById(quizId);
    if (quiz == null) return null;

    if (quiz.questionIds.isEmpty) return QuizWithQuestions(quiz: quiz, questions: []);

    final response = await _client
        .from('quiz_questions')
        .select('*')
        .inFilter('id', quiz.questionIds)
        .eq('is_active', true);

    final questions = (response as List)
        .map((json) => QuizQuestion.fromJson(json))
        .toList();

    // Sort questions by the order in quiz.questionIds
    final questionMap = {for (final q in questions) q.id: q};
    final orderedQuestions = quiz.questionIds
        .map((id) => questionMap[id])
        .whereType<QuizQuestion>()
        .toList();

    return QuizWithQuestions(quiz: quiz, questions: orderedQuestions);
  }

  // ==================== Questions ====================

  /// Get questions by category
  Future<List<QuizQuestion>> getQuestionsByCategory(
    QuizCategory category, {
    QuizDifficulty? difficulty,
    int? limit,
  }) async {
    var query = _client
        .from('quiz_questions')
        .select('*')
        .eq('category', category.dbValue)
        .eq('is_active', true);

    if (difficulty != null) {
      query = query.eq('difficulty', difficulty.dbValue);
    }

    final response = limit != null
        ? await query.limit(limit)
        : await query;

    return (response as List)
        .map((json) => QuizQuestion.fromJson(json))
        .toList();
  }

  /// Get random questions for a category
  Future<List<QuizQuestion>> getRandomQuestions({
    required QuizCategory category,
    required int count,
    QuizDifficulty? difficulty,
  }) async {
    // Note: For a real random query, you'd want to use a database function
    // This is a simplified approach that fetches more and shuffles
    final questions = await getQuestionsByCategory(
      category,
      difficulty: difficulty,
      limit: count * 3, // Fetch more to have variety
    );

    questions.shuffle();
    return questions.take(count).toList();
  }

  // ==================== Attempts ====================

  /// Start a new quiz attempt
  Future<QuizAttempt> startQuizAttempt(String quizId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Get quiz to know question count
    final quiz = await getQuizById(quizId);
    if (quiz == null) throw StateError('Quiz not found');

    final attemptId = _uuid.v4();
    final response = await _client.from('quiz_attempts').insert({
      'id': attemptId,
      'user_id': userId,
      'quiz_id': quizId,
      'total_questions': quiz.questionCount,
      'started_at': DateTime.now().toIso8601String(),
    }).select().single();

    return QuizAttempt.fromJson(response);
  }

  /// Complete a quiz attempt
  Future<({QuizAttempt attempt, bool isNewBest, bool streakUpdated})>
      completeQuizAttempt({
    required String attemptId,
    required List<QuestionAnswer> answers,
    required int score,
    required int correctCount,
    required int totalQuestions,
    required int pointsAwarded,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Use database function to update everything atomically
    final result = await _client.rpc('complete_quiz_attempt', params: {
      'p_attempt_id': attemptId,
      'p_answers': answers.map((a) => a.toJson()).toList(),
      'p_score': score,
      'p_correct_count': correctCount,
      'p_total_questions': totalQuestions,
      'p_points_awarded': pointsAwarded,
    });

    // Fetch the updated attempt
    final attemptResponse = await _client
        .from('quiz_attempts')
        .select('*')
        .eq('id', attemptId)
        .single();

    return (
      attempt: QuizAttempt.fromJson(attemptResponse),
      isNewBest: result['is_new_best'] as bool? ?? false,
      streakUpdated: result['streak_updated'] as bool? ?? false,
    );
  }

  /// Get user's attempts for a specific quiz
  Future<List<QuizAttempt>> getQuizAttempts(String quizId) async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('quiz_attempts')
        .select('*')
        .eq('user_id', userId)
        .eq('quiz_id', quizId)
        .not('completed_at', 'is', null)
        .order('completed_at', ascending: false);

    return (response as List)
        .map((json) => QuizAttempt.fromJson(json))
        .toList();
  }

  /// Get user's best score for a quiz
  Future<int?> getBestScore(String quizId) async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('quiz_best_scores')
        .select('best_score')
        .eq('user_id', userId)
        .eq('quiz_id', quizId)
        .maybeSingle();

    return response?['best_score'] as int?;
  }

  /// Get best scores for multiple quizzes
  Future<Map<String, int>> getBestScores(List<String> quizIds) async {
    final userId = _currentUserId;
    if (userId == null) return {};

    if (quizIds.isEmpty) return {};

    final response = await _client
        .from('quiz_best_scores')
        .select('quiz_id, best_score')
        .eq('user_id', userId)
        .inFilter('quiz_id', quizIds);

    return {
      for (final row in response as List)
        row['quiz_id'] as String: row['best_score'] as int,
    };
  }

  // ==================== Progress ====================

  /// Get user's quiz progress
  Future<QuizProgress> getQuizProgress() async {
    final userId = _currentUserId;
    if (userId == null) return QuizProgress.empty('');

    final response = await _client
        .from('quiz_progress')
        .select('*')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return QuizProgress.empty(userId);
    }

    return QuizProgress.fromJson(response);
  }

  /// Get quiz stats for the user
  Future<QuizStats> getQuizStats() async {
    final progress = await getQuizProgress();
    return QuizStats.fromProgress(progress);
  }

  // ==================== Completion Status ====================

  /// Check if user has completed a quiz
  Future<bool> hasCompletedQuiz(String quizId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('quiz_best_scores')
        .select('quiz_id')
        .eq('user_id', userId)
        .eq('quiz_id', quizId)
        .maybeSingle();

    return response != null;
  }

  /// Get completion status for multiple quizzes
  Future<Map<String, bool>> getCompletionStatus(List<String> quizIds) async {
    final userId = _currentUserId;
    if (userId == null) return {};

    if (quizIds.isEmpty) return {};

    final response = await _client
        .from('quiz_best_scores')
        .select('quiz_id')
        .eq('user_id', userId)
        .inFilter('quiz_id', quizIds);

    final completedIds = (response as List)
        .map((row) => row['quiz_id'] as String)
        .toSet();

    return {for (final id in quizIds) id: completedIds.contains(id)};
  }

  // ==================== Leaderboard ====================

  /// Get quiz leaderboard (by total points earned from quizzes)
  Future<List<({String oderId, String userName, int totalPoints, int quizCount})>>
      getQuizLeaderboard({int limit = 50}) async {
    final response = await _client
        .from('quiz_progress')
        .select('user_id, total_points_earned, total_quizzes_completed, profile:profiles!quiz_progress_user_id_fkey(name)')
        .order('total_points_earned', ascending: false)
        .limit(limit);

    return (response as List).map((row) {
      final profile = row['profile'] as Map<String, dynamic>?;
      return (
        oderId: row['user_id'] as String,
        userName: profile?['name'] as String? ?? 'Unknown',
        totalPoints: row['total_points_earned'] as int? ?? 0,
        quizCount: row['total_quizzes_completed'] as int? ?? 0,
      );
    }).toList();
  }

  // ==================== Point Calculation ====================

  /// Calculate points for a quiz completion
  int calculatePoints({
    required Quiz quiz,
    required int correctCount,
    required int totalQuestions,
    required bool isPerfect,
  }) {
    // Base points from quiz reward
    int points = quiz.pointsReward;

    // Bonus for each correct answer (scaled by difficulty)
    final difficultyMultiplier = quiz.difficulty.pointMultiplier;
    points += correctCount * 5 * difficultyMultiplier;

    // Perfect score bonus
    if (isPerfect) {
      points += 50;
    }

    return points;
  }
}
