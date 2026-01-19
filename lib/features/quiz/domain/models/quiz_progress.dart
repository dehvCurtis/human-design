// Quiz progress tracking models

import 'quiz.dart';

/// Progress for a specific category
class CategoryProgress {
  const CategoryProgress({
    required this.category,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.quizzesCompleted,
    required this.bestScore,
  });

  final QuizCategory category;
  final int questionsAnswered;
  final int correctAnswers;
  final int quizzesCompleted;
  final int bestScore; // percentage 0-100

  double get accuracy =>
      questionsAnswered > 0 ? correctAnswers / questionsAnswered : 0.0;

  bool get hasMastery => accuracy >= 0.9 && questionsAnswered >= 10;

  factory CategoryProgress.fromJson(Map<String, dynamic> json) {
    return CategoryProgress(
      category: QuizCategoryExtension.fromDbValue(json['category'] as String),
      questionsAnswered: json['questions_answered'] as int? ?? 0,
      correctAnswers: json['correct_answers'] as int? ?? 0,
      quizzesCompleted: json['quizzes_completed'] as int? ?? 0,
      bestScore: json['best_score'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.dbValue,
      'questions_answered': questionsAnswered,
      'correct_answers': correctAnswers,
      'quizzes_completed': quizzesCompleted,
      'best_score': bestScore,
    };
  }

  CategoryProgress copyWith({
    QuizCategory? category,
    int? questionsAnswered,
    int? correctAnswers,
    int? quizzesCompleted,
    int? bestScore,
  }) {
    return CategoryProgress(
      category: category ?? this.category,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      bestScore: bestScore ?? this.bestScore,
    );
  }
}

/// Overall user quiz progress
class QuizProgress {
  const QuizProgress({
    required this.userId,
    required this.totalQuizzesCompleted,
    required this.totalQuestionsAnswered,
    required this.totalCorrectAnswers,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalPointsEarned,
    required this.categoryProgress,
    this.lastQuizDate,
  });

  final String userId;
  final int totalQuizzesCompleted;
  final int totalQuestionsAnswered;
  final int totalCorrectAnswers;
  final int currentStreak;
  final int bestStreak;
  final int totalPointsEarned;
  final Map<QuizCategory, CategoryProgress> categoryProgress;
  final DateTime? lastQuizDate;

  double get overallAccuracy => totalQuestionsAnswered > 0
      ? totalCorrectAnswers / totalQuestionsAnswered
      : 0.0;

  int get masteredCategories =>
      categoryProgress.values.where((p) => p.hasMastery).length;

  /// Check if user has completed a quiz today
  bool get hasCompletedQuizToday {
    if (lastQuizDate == null) return false;
    final now = DateTime.now();
    return lastQuizDate!.year == now.year &&
        lastQuizDate!.month == now.month &&
        lastQuizDate!.day == now.day;
  }

  factory QuizProgress.empty(String userId) {
    return QuizProgress(
      userId: userId,
      totalQuizzesCompleted: 0,
      totalQuestionsAnswered: 0,
      totalCorrectAnswers: 0,
      currentStreak: 0,
      bestStreak: 0,
      totalPointsEarned: 0,
      categoryProgress: {},
    );
  }

  factory QuizProgress.fromJson(Map<String, dynamic> json) {
    final categoryJson =
        json['category_progress'] as Map<String, dynamic>? ?? {};
    final categoryMap = <QuizCategory, CategoryProgress>{};

    categoryJson.forEach((key, value) {
      final category = QuizCategoryExtension.fromDbValue(key);
      categoryMap[category] =
          CategoryProgress.fromJson(value as Map<String, dynamic>);
    });

    return QuizProgress(
      userId: json['user_id'] as String,
      totalQuizzesCompleted: json['total_quizzes_completed'] as int? ?? 0,
      totalQuestionsAnswered: json['total_questions_answered'] as int? ?? 0,
      totalCorrectAnswers: json['total_correct_answers'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      bestStreak: json['best_streak'] as int? ?? 0,
      totalPointsEarned: json['total_points_earned'] as int? ?? 0,
      categoryProgress: categoryMap,
      lastQuizDate: json['last_quiz_date'] != null
          ? DateTime.parse(json['last_quiz_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final categoryJson = <String, dynamic>{};
    categoryProgress.forEach((key, value) {
      categoryJson[key.dbValue] = value.toJson();
    });

    return {
      'user_id': userId,
      'total_quizzes_completed': totalQuizzesCompleted,
      'total_questions_answered': totalQuestionsAnswered,
      'total_correct_answers': totalCorrectAnswers,
      'current_streak': currentStreak,
      'best_streak': bestStreak,
      'total_points_earned': totalPointsEarned,
      'category_progress': categoryJson,
      'last_quiz_date': lastQuizDate?.toIso8601String(),
    };
  }

  QuizProgress copyWith({
    String? userId,
    int? totalQuizzesCompleted,
    int? totalQuestionsAnswered,
    int? totalCorrectAnswers,
    int? currentStreak,
    int? bestStreak,
    int? totalPointsEarned,
    Map<QuizCategory, CategoryProgress>? categoryProgress,
    DateTime? lastQuizDate,
  }) {
    return QuizProgress(
      userId: userId ?? this.userId,
      totalQuizzesCompleted:
          totalQuizzesCompleted ?? this.totalQuizzesCompleted,
      totalQuestionsAnswered:
          totalQuestionsAnswered ?? this.totalQuestionsAnswered,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      categoryProgress: categoryProgress ?? this.categoryProgress,
      lastQuizDate: lastQuizDate ?? this.lastQuizDate,
    );
  }
}

/// Summary of user's quiz statistics
class QuizStats {
  const QuizStats({
    required this.totalQuizzes,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.perfectScores,
    required this.currentStreak,
    required this.longestStreak,
    required this.favoriteCategory,
    required this.strongestCategory,
    required this.weakestCategory,
  });

  final int totalQuizzes;
  final int totalQuestions;
  final int correctAnswers;
  final int perfectScores;
  final int currentStreak;
  final int longestStreak;
  final QuizCategory? favoriteCategory;
  final QuizCategory? strongestCategory;
  final QuizCategory? weakestCategory;

  double get overallAccuracy =>
      totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;

  factory QuizStats.fromProgress(QuizProgress progress) {
    QuizCategory? favorite;
    QuizCategory? strongest;
    QuizCategory? weakest;
    int maxQuizzes = 0;
    double maxAccuracy = 0.0;
    double minAccuracy = 1.0;

    progress.categoryProgress.forEach((category, categoryProgress) {
      if (categoryProgress.quizzesCompleted > maxQuizzes) {
        maxQuizzes = categoryProgress.quizzesCompleted;
        favorite = category;
      }

      if (categoryProgress.questionsAnswered >= 5) {
        if (categoryProgress.accuracy > maxAccuracy) {
          maxAccuracy = categoryProgress.accuracy;
          strongest = category;
        }
        if (categoryProgress.accuracy < minAccuracy) {
          minAccuracy = categoryProgress.accuracy;
          weakest = category;
        }
      }
    });

    return QuizStats(
      totalQuizzes: progress.totalQuizzesCompleted,
      totalQuestions: progress.totalQuestionsAnswered,
      correctAnswers: progress.totalCorrectAnswers,
      perfectScores: 0, // This would need to be tracked separately
      currentStreak: progress.currentStreak,
      longestStreak: progress.bestStreak,
      favoriteCategory: favorite,
      strongestCategory: strongest,
      weakestCategory: weakest,
    );
  }
}

/// Quiz completion result for display
class QuizResult {
  const QuizResult({
    required this.quiz,
    required this.attempt,
    required this.isNewHighScore,
    required this.streakUpdated,
    required this.badgesEarned,
  });

  final Quiz quiz;
  final QuizAttempt attempt;
  final bool isNewHighScore;
  final bool streakUpdated;
  final List<String> badgesEarned;

  bool get isPerfect => attempt.isPerfect;
  int get score => attempt.score;
  int get pointsEarned => attempt.pointsAwarded;
}
