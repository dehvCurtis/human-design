import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/question_generators/all_generators.dart';
import '../data/quiz_repository.dart';
import 'models/quiz.dart';
import 'models/quiz_progress.dart';

// ==================== Repository Provider ====================

/// Provider for the QuizRepository
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return QuizRepository(supabaseClient: client);
});

// ==================== Quiz List Providers ====================

/// Filter state for quiz list
class QuizFilters {
  const QuizFilters({
    this.category,
    this.difficulty,
    this.showCompleted = true,
  });

  final QuizCategory? category;
  final QuizDifficulty? difficulty;
  final bool showCompleted;

  QuizFilters copyWith({
    QuizCategory? category,
    QuizDifficulty? difficulty,
    bool? showCompleted,
    bool clearCategory = false,
    bool clearDifficulty = false,
  }) {
    return QuizFilters(
      category: clearCategory ? null : (category ?? this.category),
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      showCompleted: showCompleted ?? this.showCompleted,
    );
  }
}

/// Notifier for quiz filters state
class QuizFiltersNotifier extends Notifier<QuizFilters> {
  @override
  QuizFilters build() => const QuizFilters();

  void setCategory(QuizCategory? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void setDifficulty(QuizDifficulty? difficulty) {
    state = state.copyWith(difficulty: difficulty, clearDifficulty: difficulty == null);
  }

  void setShowCompleted(bool show) {
    state = state.copyWith(showCompleted: show);
  }

  void reset() {
    state = const QuizFilters();
  }
}

/// Provider for quiz filters
final quizFiltersProvider = NotifierProvider<QuizFiltersNotifier, QuizFilters>(() {
  return QuizFiltersNotifier();
});

/// Provider for all quizzes with optional filtering
/// Falls back to QuizTemplates when database is empty (for local development)
final quizzesProvider = FutureProvider.autoDispose<List<Quiz>>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);
  final filters = ref.watch(quizFiltersProvider);

  var quizzes = await repository.getAllQuizzes(
    category: filters.category,
    difficulty: filters.difficulty,
  );

  // Fallback to templates if database is empty
  if (quizzes.isEmpty) {
    quizzes = QuizTemplates.getAllTemplateQuizzes();

    // Apply filters manually for template quizzes
    if (filters.category != null) {
      quizzes = quizzes.where((q) => q.category == filters.category).toList();
    }
    if (filters.difficulty != null) {
      quizzes = quizzes.where((q) => q.difficulty == filters.difficulty).toList();
    }
  }

  return quizzes;
});

/// Provider for quizzes with completion status
final quizzesWithStatusProvider = FutureProvider.autoDispose<
    List<({Quiz quiz, bool isCompleted, int? bestScore})>>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);
  final quizzes = await ref.watch(quizzesProvider.future);

  if (quizzes.isEmpty) return [];

  final quizIds = quizzes.map((q) => q.id).toList();
  final completionStatus = await repository.getCompletionStatus(quizIds);
  final bestScores = await repository.getBestScores(quizIds);

  return quizzes.map((quiz) {
    return (
      quiz: quiz,
      isCompleted: completionStatus[quiz.id] ?? false,
      bestScore: bestScores[quiz.id],
    );
  }).toList();
});

// ==================== Quiz Detail Providers ====================

/// Provider for a specific quiz by ID
/// Falls back to QuizTemplates when database returns null
final quizByIdProvider =
    FutureProvider.autoDispose.family<Quiz?, String>((ref, quizId) async {
  final repository = ref.watch(quizRepositoryProvider);
  var quiz = await repository.getQuizById(quizId);

  // Fallback to template if not found in database
  if (quiz == null) {
    final templates = QuizTemplates.getAllTemplateQuizzes();
    quiz = templates.cast<Quiz?>().firstWhere(
      (q) => q?.id == quizId,
      orElse: () => null,
    );
  }

  return quiz;
});

/// Provider for quiz with questions loaded
/// Falls back to generated questions when database is empty
final quizWithQuestionsProvider =
    FutureProvider.autoDispose.family<QuizWithQuestions?, String>((ref, quizId) async {
  final repository = ref.watch(quizRepositoryProvider);
  var quizWithQuestions = await repository.getQuizWithQuestions(quizId);

  // Fallback to templates if not found or no questions
  if (quizWithQuestions == null || quizWithQuestions.questions.isEmpty) {
    final quiz = await ref.watch(quizByIdProvider(quizId).future);
    if (quiz != null) {
      // Generate questions for this quiz's category and difficulty
      final generator = CombinedQuestionGenerator();
      final questions = generator.generateForCategoryAndDifficulty(
        quiz.category,
        quiz.difficulty,
      );
      // Take the appropriate number of questions
      final questionCount = quiz.questionCount > 0 ? quiz.questionCount : 10;
      final selectedQuestions = (List<QuizQuestion>.from(questions)..shuffle())
          .take(questionCount)
          .toList();
      quizWithQuestions = QuizWithQuestions(quiz: quiz, questions: selectedQuestions);
    }
  }

  return quizWithQuestions;
});

/// Provider for quiz attempts history
final quizAttemptsProvider =
    FutureProvider.autoDispose.family<List<QuizAttempt>, String>((ref, quizId) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizAttempts(quizId);
});

/// Provider for quiz best score
final quizBestScoreProvider =
    FutureProvider.autoDispose.family<int?, String>((ref, quizId) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getBestScore(quizId);
});

// ==================== Progress Providers ====================

/// Provider for user's overall quiz progress
final quizProgressProvider = FutureProvider.autoDispose<QuizProgress>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizProgress();
});

/// Provider for quiz statistics
final quizStatsProvider = FutureProvider.autoDispose<QuizStats>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizStats();
});

// ==================== Quiz Taking State ====================

/// State for an active quiz session
class QuizSessionState {
  const QuizSessionState({
    required this.quiz,
    required this.questions,
    this.attemptId,
    this.currentQuestionIndex = 0,
    this.answers = const [],
    this.isComplete = false,
    this.startedAt,
  });

  final Quiz quiz;
  final List<QuizQuestion> questions;
  final String? attemptId;
  final int currentQuestionIndex;
  final List<QuestionAnswer> answers;
  final bool isComplete;
  final DateTime? startedAt;

  QuizQuestion? get currentQuestion =>
      currentQuestionIndex < questions.length
          ? questions[currentQuestionIndex]
          : null;

  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get totalQuestions => questions.length;
  double get progress =>
      totalQuestions > 0 ? (currentQuestionIndex) / totalQuestions : 0.0;
  int get score =>
      totalQuestions > 0 ? ((correctCount / totalQuestions) * 100).round() : 0;
  bool get isPerfect => score == 100;

  bool hasAnswered(String questionId) =>
      answers.any((a) => a.questionId == questionId);

  QuestionAnswer? getAnswer(String questionId) =>
      answers.cast<QuestionAnswer?>().firstWhere(
            (a) => a?.questionId == questionId,
            orElse: () => null,
          );

  QuizSessionState copyWith({
    Quiz? quiz,
    List<QuizQuestion>? questions,
    String? attemptId,
    int? currentQuestionIndex,
    List<QuestionAnswer>? answers,
    bool? isComplete,
    DateTime? startedAt,
  }) {
    return QuizSessionState(
      quiz: quiz ?? this.quiz,
      questions: questions ?? this.questions,
      attemptId: attemptId ?? this.attemptId,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      isComplete: isComplete ?? this.isComplete,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

/// Notifier for managing quiz session state
class QuizSessionNotifier extends Notifier<QuizSessionState?> {
  @override
  QuizSessionState? build() => null;

  QuizRepository get _repository => ref.read(quizRepositoryProvider);

  /// Start a new quiz session
  Future<void> startQuiz(String quizId) async {
    var quizWithQuestions = await _repository.getQuizWithQuestions(quizId);

    // Fallback to generated questions when DB has none
    if (quizWithQuestions == null || quizWithQuestions.questions.isEmpty) {
      final quiz = quizWithQuestions?.quiz ?? await _repository.getQuizById(quizId);
      if (quiz == null) {
        throw StateError('Quiz not found');
      }
      final generator = CombinedQuestionGenerator();
      final questions = generator.generateForCategoryAndDifficulty(
        quiz.category,
        quiz.difficulty,
      );
      final questionCount = quiz.questionCount > 0 ? quiz.questionCount : 10;
      final selectedQuestions = (List<QuizQuestion>.from(questions)..shuffle())
          .take(questionCount)
          .toList();
      quizWithQuestions = QuizWithQuestions(quiz: quiz, questions: selectedQuestions);
    }

    if (quizWithQuestions.questions.isEmpty) {
      throw StateError('No questions available for this quiz');
    }

    // Shuffle questions for variety
    final shuffledQuestions = List<QuizQuestion>.from(quizWithQuestions.questions)
      ..shuffle();

    final attempt = await _repository.startQuizAttempt(quizId);

    state = QuizSessionState(
      quiz: quizWithQuestions.quiz,
      questions: shuffledQuestions,
      attemptId: attempt.id,
      startedAt: DateTime.now(),
    );
  }

  /// Answer the current question
  void answerQuestion(String answerId) {
    final currentState = state;
    if (currentState == null) return;

    final question = currentState.currentQuestion;
    if (question == null) return;

    // Don't allow re-answering
    if (currentState.hasAnswered(question.id)) return;

    final answer = QuestionAnswer(
      questionId: question.id,
      selectedAnswerId: answerId,
      isCorrect: question.isCorrect(answerId),
      answeredAt: DateTime.now(),
    );

    state = currentState.copyWith(
      answers: [...currentState.answers, answer],
    );
  }

  /// Move to the next question
  void nextQuestion() {
    final currentState = state;
    if (currentState == null) return;

    final nextIndex = currentState.currentQuestionIndex + 1;

    if (nextIndex >= currentState.questions.length) {
      // Quiz complete
      state = currentState.copyWith(
        isComplete: true,
      );
    } else {
      state = currentState.copyWith(
        currentQuestionIndex: nextIndex,
      );
    }
  }

  /// Complete the quiz and save results
  Future<({QuizAttempt attempt, bool isNewBest, bool streakUpdated, int pointsEarned})?>
      completeQuiz() async {
    final currentState = state;
    if (currentState == null || currentState.attemptId == null) return null;

    final pointsEarned = _repository.calculatePoints(
      quiz: currentState.quiz,
      correctCount: currentState.correctCount,
      totalQuestions: currentState.totalQuestions,
      isPerfect: currentState.isPerfect,
    );

    final result = await _repository.completeQuizAttempt(
      attemptId: currentState.attemptId!,
      answers: currentState.answers,
      score: currentState.score,
      correctCount: currentState.correctCount,
      totalQuestions: currentState.totalQuestions,
      pointsAwarded: pointsEarned,
    );

    return (
      attempt: result.attempt,
      isNewBest: result.isNewBest,
      streakUpdated: result.streakUpdated,
      pointsEarned: pointsEarned,
    );
  }

  /// Reset the session
  void reset() {
    state = null;
  }
}

/// Provider for quiz session notifier
final quizSessionProvider =
    NotifierProvider<QuizSessionNotifier, QuizSessionState?>(() {
  return QuizSessionNotifier();
});

// ==================== Category Stats ====================

/// Provider for category-specific progress
final categoryProgressProvider =
    Provider.autoDispose.family<CategoryProgress?, QuizCategory>((ref, category) {
  final progress = ref.watch(quizProgressProvider);
  return progress.whenOrNull(
    data: (p) => p.categoryProgress[category],
  );
});
