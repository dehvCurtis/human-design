// Quiz models for the Human Design quiz system

/// Types of quiz questions
enum QuestionType {
  multipleChoice,
  trueFalse,
}

extension QuestionTypeExtension on QuestionType {
  String get dbValue {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'multiple_choice';
      case QuestionType.trueFalse:
        return 'true_false';
    }
  }

  static QuestionType fromDbValue(String value) {
    switch (value) {
      case 'multiple_choice':
        return QuestionType.multipleChoice;
      case 'true_false':
        return QuestionType.trueFalse;
      default:
        return QuestionType.multipleChoice;
    }
  }
}

/// Quiz difficulty levels
enum QuizDifficulty {
  beginner,
  intermediate,
  advanced,
}

extension QuizDifficultyExtension on QuizDifficulty {
  String get dbValue => name;

  String get displayName {
    switch (this) {
      case QuizDifficulty.beginner:
        return 'Beginner';
      case QuizDifficulty.intermediate:
        return 'Intermediate';
      case QuizDifficulty.advanced:
        return 'Advanced';
    }
  }

  int get pointMultiplier {
    switch (this) {
      case QuizDifficulty.beginner:
        return 1;
      case QuizDifficulty.intermediate:
        return 2;
      case QuizDifficulty.advanced:
        return 3;
    }
  }

  static QuizDifficulty fromDbValue(String value) {
    return QuizDifficulty.values.firstWhere(
      (e) => e.name == value,
      orElse: () => QuizDifficulty.beginner,
    );
  }
}

/// Quiz categories based on Human Design concepts
enum QuizCategory {
  types,
  centers,
  authorities,
  profiles,
  gates,
  channels,
  definitions,
  general,
}

extension QuizCategoryExtension on QuizCategory {
  String get dbValue => name;

  String get displayName {
    switch (this) {
      case QuizCategory.types:
        return 'Types';
      case QuizCategory.centers:
        return 'Centers';
      case QuizCategory.authorities:
        return 'Authorities';
      case QuizCategory.profiles:
        return 'Profiles';
      case QuizCategory.gates:
        return 'Gates';
      case QuizCategory.channels:
        return 'Channels';
      case QuizCategory.definitions:
        return 'Definitions';
      case QuizCategory.general:
        return 'General';
    }
  }

  String get description {
    switch (this) {
      case QuizCategory.types:
        return 'Learn about the 5 Human Design types';
      case QuizCategory.centers:
        return 'Explore the 9 energy centers';
      case QuizCategory.authorities:
        return 'Understand decision-making authorities';
      case QuizCategory.profiles:
        return 'Discover the 12 profile combinations';
      case QuizCategory.gates:
        return 'Deep dive into the 64 gates';
      case QuizCategory.channels:
        return 'Study the 36 channels';
      case QuizCategory.definitions:
        return 'Learn about definition types';
      case QuizCategory.general:
        return 'Mixed Human Design knowledge';
    }
  }

  static QuizCategory fromDbValue(String value) {
    return QuizCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => QuizCategory.general,
    );
  }
}

/// An option in a quiz question
class QuizOption {
  const QuizOption({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

/// A quiz question
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.type,
    required this.category,
    required this.difficulty,
    required this.questionText,
    required this.options,
    required this.correctAnswerId,
    required this.explanation,
    this.points = 10,
    this.isActive = true,
  });

  final String id;
  final QuestionType type;
  final QuizCategory category;
  final QuizDifficulty difficulty;
  final String questionText;
  final List<QuizOption> options;
  final String correctAnswerId;
  final String explanation;
  final int points;
  final bool isActive;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as List<dynamic>;
    return QuizQuestion(
      id: json['id'] as String,
      type: QuestionTypeExtension.fromDbValue(json['question_type'] as String),
      category: QuizCategoryExtension.fromDbValue(json['category'] as String),
      difficulty:
          QuizDifficultyExtension.fromDbValue(json['difficulty'] as String),
      questionText: json['question_text'] as String,
      options: optionsJson
          .map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctAnswerId: json['correct_answer'] as String,
      explanation: json['explanation'] as String,
      points: json['points'] as int? ?? 10,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_type': type.dbValue,
      'category': category.dbValue,
      'difficulty': difficulty.dbValue,
      'question_text': questionText,
      'options': options.map((e) => e.toJson()).toList(),
      'correct_answer': correctAnswerId,
      'explanation': explanation,
      'points': points,
      'is_active': isActive,
    };
  }

  /// Get the correct answer option
  QuizOption get correctAnswer =>
      options.firstWhere((o) => o.id == correctAnswerId);

  /// Check if the given answer is correct
  bool isCorrect(String answerId) => answerId == correctAnswerId;

  QuizQuestion copyWith({
    String? id,
    QuestionType? type,
    QuizCategory? category,
    QuizDifficulty? difficulty,
    String? questionText,
    List<QuizOption>? options,
    String? correctAnswerId,
    String? explanation,
    int? points,
    bool? isActive,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswerId: correctAnswerId ?? this.correctAnswerId,
      explanation: explanation ?? this.explanation,
      points: points ?? this.points,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// A quiz containing multiple questions
class Quiz {
  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.questionIds,
    this.pointsReward = 25,
    this.timeLimit,
    this.isPremium = false,
    this.isActive = true,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final QuizCategory category;
  final QuizDifficulty difficulty;
  final List<String> questionIds;
  final int pointsReward;
  final int? timeLimit; // seconds
  final bool isPremium;
  final bool isActive;
  final DateTime? createdAt;

  int get questionCount => questionIds.length;

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: QuizCategoryExtension.fromDbValue(json['category'] as String),
      difficulty:
          QuizDifficultyExtension.fromDbValue(json['difficulty'] as String),
      questionIds: (json['question_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      pointsReward: json['points_reward'] as int? ?? 25,
      timeLimit: json['time_limit'] as int?,
      isPremium: json['is_premium'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.dbValue,
      'difficulty': difficulty.dbValue,
      'question_ids': questionIds,
      'points_reward': pointsReward,
      'time_limit': timeLimit,
      'is_premium': isPremium,
      'is_active': isActive,
    };
  }

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    QuizCategory? category,
    QuizDifficulty? difficulty,
    List<String>? questionIds,
    int? pointsReward,
    int? timeLimit,
    bool? isPremium,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      questionIds: questionIds ?? this.questionIds,
      pointsReward: pointsReward ?? this.pointsReward,
      timeLimit: timeLimit ?? this.timeLimit,
      isPremium: isPremium ?? this.isPremium,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// A quiz with its questions loaded
class QuizWithQuestions {
  const QuizWithQuestions({
    required this.quiz,
    required this.questions,
  });

  final Quiz quiz;
  final List<QuizQuestion> questions;

  int get questionCount => questions.length;
  int get totalPoints =>
      questions.fold(0, (sum, q) => sum + q.points) + quiz.pointsReward;
}

/// User's answer to a question
class QuestionAnswer {
  const QuestionAnswer({
    required this.questionId,
    required this.selectedAnswerId,
    required this.isCorrect,
    this.answeredAt,
  });

  final String questionId;
  final String selectedAnswerId;
  final bool isCorrect;
  final DateTime? answeredAt;

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      questionId: json['question_id'] as String,
      selectedAnswerId: json['selected_answer_id'] as String,
      isCorrect: json['is_correct'] as bool,
      answeredAt: json['answered_at'] != null
          ? DateTime.parse(json['answered_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'selected_answer_id': selectedAnswerId,
      'is_correct': isCorrect,
      'answered_at': answeredAt?.toIso8601String(),
    };
  }
}

/// A user's attempt at a quiz
class QuizAttempt {
  const QuizAttempt({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.answers,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.pointsAwarded,
    this.startedAt,
    this.completedAt,
  });

  final String id;
  final String userId;
  final String quizId;
  final List<QuestionAnswer> answers;
  final int score; // percentage 0-100
  final int correctCount;
  final int totalQuestions;
  final int pointsAwarded;
  final DateTime? startedAt;
  final DateTime? completedAt;

  bool get isPerfect => score == 100;

  Duration? get duration {
    if (startedAt != null && completedAt != null) {
      return completedAt!.difference(startedAt!);
    }
    return null;
  }

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    final answersJson = json['answers'] as List<dynamic>? ?? [];
    return QuizAttempt(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      quizId: json['quiz_id'] as String,
      answers: answersJson
          .map((e) => QuestionAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      score: json['score'] as int? ?? 0,
      correctCount: json['correct_count'] as int? ?? 0,
      totalQuestions: json['total_questions'] as int? ?? 0,
      pointsAwarded: json['points_awarded'] as int? ?? 0,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'quiz_id': quizId,
      'answers': answers.map((e) => e.toJson()).toList(),
      'score': score,
      'correct_count': correctCount,
      'total_questions': totalQuestions,
      'points_awarded': pointsAwarded,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
