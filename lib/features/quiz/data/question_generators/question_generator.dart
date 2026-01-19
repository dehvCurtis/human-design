import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../domain/models/quiz.dart';

/// Base class for generating quiz questions
abstract class QuestionGenerator {
  QuestionGenerator() : _random = Random(), _uuid = const Uuid();

  final Random _random;
  final Uuid _uuid;

  /// Generate a unique ID for a question
  String generateId() => _uuid.v4();

  /// Shuffle a list and return a new list
  List<T> shuffled<T>(List<T> list) {
    final result = List<T>.from(list);
    result.shuffle(_random);
    return result;
  }

  /// Get N random items from a list, excluding specified items
  List<T> getRandomItems<T>(List<T> items, int count, {List<T>? exclude}) {
    final available = exclude != null
        ? items.where((item) => !exclude.contains(item)).toList()
        : List<T>.from(items);
    available.shuffle(_random);
    return available.take(count).toList();
  }

  /// Create a multiple choice question
  QuizQuestion createMultipleChoice({
    required QuizCategory category,
    required QuizDifficulty difficulty,
    required String questionText,
    required String correctAnswer,
    required List<String> wrongAnswers,
    required String explanation,
    int points = 10,
  }) {
    final correctId = 'a';
    final options = <QuizOption>[
      QuizOption(id: correctId, text: correctAnswer),
      ...wrongAnswers.take(3).toList().asMap().entries.map(
            (e) => QuizOption(
              id: String.fromCharCode('b'.codeUnitAt(0) + e.key),
              text: e.value,
            ),
          ),
    ];

    // Shuffle options but track correct answer
    final shuffledOptions = shuffled(options);
    final correctOption = shuffledOptions.firstWhere((o) => o.text == correctAnswer);

    return QuizQuestion(
      id: generateId(),
      type: QuestionType.multipleChoice,
      category: category,
      difficulty: difficulty,
      questionText: questionText,
      options: shuffledOptions,
      correctAnswerId: correctOption.id,
      explanation: explanation,
      points: points,
    );
  }

  /// Create a true/false question
  QuizQuestion createTrueFalse({
    required QuizCategory category,
    required QuizDifficulty difficulty,
    required String statement,
    required bool isTrue,
    required String explanation,
    int points = 10,
  }) {
    return QuizQuestion(
      id: generateId(),
      type: QuestionType.trueFalse,
      category: category,
      difficulty: difficulty,
      questionText: statement,
      options: const [
        QuizOption(id: 'true', text: 'True'),
        QuizOption(id: 'false', text: 'False'),
      ],
      correctAnswerId: isTrue ? 'true' : 'false',
      explanation: explanation,
      points: points,
    );
  }

  /// Generate all questions for this category
  List<QuizQuestion> generateAll();

  /// Generate questions for a specific difficulty
  List<QuizQuestion> generateForDifficulty(QuizDifficulty difficulty) {
    return generateAll().where((q) => q.difficulty == difficulty).toList();
  }
}
