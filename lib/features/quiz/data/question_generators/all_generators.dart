// Barrel file for all question generators
//
// This file exports all question generators and provides a combined
// generator that can produce questions for all categories.

export 'question_generator.dart';
export 'types_questions.dart';
export 'centers_questions.dart';
export 'gates_questions.dart';
export 'channels_questions.dart';
export 'authorities_questions.dart';
export 'profiles_questions.dart';
export 'definitions_questions.dart';

import '../../domain/models/quiz.dart';
import 'question_generator.dart';
import 'types_questions.dart';
import 'centers_questions.dart';
import 'gates_questions.dart';
import 'channels_questions.dart';
import 'authorities_questions.dart';
import 'profiles_questions.dart';
import 'definitions_questions.dart';

/// Combined generator that can produce questions for any category
class CombinedQuestionGenerator {
  CombinedQuestionGenerator()
      : _generators = {
          QuizCategory.types: TypesQuestionGenerator(),
          QuizCategory.centers: CentersQuestionGenerator(),
          QuizCategory.gates: GatesQuestionGenerator(),
          QuizCategory.channels: ChannelsQuestionGenerator(),
          QuizCategory.authorities: AuthoritiesQuestionGenerator(),
          QuizCategory.profiles: ProfilesQuestionGenerator(),
          QuizCategory.definitions: DefinitionsQuestionGenerator(),
        };

  final Map<QuizCategory, QuestionGenerator> _generators;

  /// Generate all questions for a specific category
  List<QuizQuestion> generateForCategory(QuizCategory category) {
    final generator = _generators[category];
    if (generator == null) {
      return [];
    }
    return generator.generateAll();
  }

  /// Generate questions for a specific category and difficulty
  List<QuizQuestion> generateForCategoryAndDifficulty(
    QuizCategory category,
    QuizDifficulty difficulty,
  ) {
    final generator = _generators[category];
    if (generator == null) {
      return [];
    }
    return generator.generateForDifficulty(difficulty);
  }

  /// Generate all questions for all categories
  List<QuizQuestion> generateAll() {
    final questions = <QuizQuestion>[];
    for (final generator in _generators.values) {
      questions.addAll(generator.generateAll());
    }
    return questions;
  }

  /// Generate a random mix of questions
  List<QuizQuestion> generateRandomMix({
    required int count,
    QuizDifficulty? difficulty,
    List<QuizCategory>? categories,
  }) {
    var allQuestions = <QuizQuestion>[];

    final targetCategories = categories ?? _generators.keys.toList();

    for (final category in targetCategories) {
      if (difficulty != null) {
        allQuestions.addAll(generateForCategoryAndDifficulty(category, difficulty));
      } else {
        allQuestions.addAll(generateForCategory(category));
      }
    }

    allQuestions.shuffle();
    return allQuestions.take(count).toList();
  }

  /// Get available categories
  List<QuizCategory> get availableCategories => _generators.keys.toList();

  /// Get question counts by category
  Map<QuizCategory, int> getQuestionCounts() {
    return {
      for (final entry in _generators.entries)
        entry.key: entry.value.generateAll().length,
    };
  }

  /// Get question counts by category and difficulty
  Map<QuizCategory, Map<QuizDifficulty, int>> getDetailedQuestionCounts() {
    final result = <QuizCategory, Map<QuizDifficulty, int>>{};

    for (final entry in _generators.entries) {
      final allQuestions = entry.value.generateAll();
      result[entry.key] = {
        for (final difficulty in QuizDifficulty.values)
          difficulty: allQuestions.where((q) => q.difficulty == difficulty).length,
      };
    }

    return result;
  }
}

/// Pre-defined quiz templates
class QuizTemplates {
  static final CombinedQuestionGenerator _generator = CombinedQuestionGenerator();

  /// Create a beginner types quiz
  static Quiz createTypesBeginnerQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.types,
      QuizDifficulty.beginner,
    );
    return Quiz(
      id: 'types-beginner',
      title: 'Types Basics',
      description: 'Learn the fundamentals of the 5 Human Design types',
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      questionIds: questions.take(10).map((q) => q.id).toList(),
      pointsReward: 25,
    );
  }

  /// Create a centers introduction quiz
  static Quiz createCentersBeginnerQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.centers,
      QuizDifficulty.beginner,
    );
    return Quiz(
      id: 'centers-beginner',
      title: 'Centers Introduction',
      description: 'Discover the 9 energy centers of the bodygraph',
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionIds: questions.take(10).map((q) => q.id).toList(),
      pointsReward: 25,
    );
  }

  /// Create a gates beginner quiz
  static Quiz createGatesBeginnerQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.gates,
      QuizDifficulty.beginner,
    );
    return Quiz(
      id: 'gates-beginner',
      title: 'Gates Introduction',
      description: 'Begin exploring the 64 gates and their centers',
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionIds: questions.take(10).map((q) => q.id).toList(),
      pointsReward: 25,
    );
  }

  /// Create a gates exploration quiz
  static Quiz createGatesIntermediateQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.gates,
      QuizDifficulty.intermediate,
    );
    return Quiz(
      id: 'gates-intermediate',
      title: 'Gate Exploration',
      description: 'Deepen your understanding of the 64 gates',
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.intermediate,
      questionIds: questions.take(15).map((q) => q.id).toList(),
      pointsReward: 50,
    );
  }

  /// Create a channels mastery quiz
  static Quiz createChannelsAdvancedQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.channels,
      QuizDifficulty.advanced,
    );
    return Quiz(
      id: 'channels-advanced',
      title: 'Channel Mastery',
      description: 'Test your knowledge of the 36 channels',
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.advanced,
      questionIds: questions.take(12).map((q) => q.id).toList(),
      pointsReward: 75,
      timeLimit: 600, // 10 minutes
    );
  }

  /// Create a beginner authorities quiz
  static Quiz createAuthoritiesBeginnerQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.authorities,
      QuizDifficulty.beginner,
    );
    return Quiz(
      id: 'authorities-beginner',
      title: 'Authority Basics',
      description: 'Learn the fundamentals of the 7 decision-making authorities',
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionIds: questions.take(10).map((q) => q.id).toList(),
      pointsReward: 25,
    );
  }

  /// Create an intermediate authorities quiz
  static Quiz createAuthoritiesIntermediateQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.authorities,
      QuizDifficulty.intermediate,
    );
    return Quiz(
      id: 'authorities-intermediate',
      title: 'Know Your Authority',
      description: 'Deepen your understanding of inner authority',
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.intermediate,
      questionIds: questions.take(10).map((q) => q.id).toList(),
      pointsReward: 50,
    );
  }

  /// Create a beginner profiles quiz
  static Quiz createProfilesBeginnerQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.profiles,
      QuizDifficulty.beginner,
    );
    return Quiz(
      id: 'profiles-beginner',
      title: 'Profile Introduction',
      description: 'Discover the 12 profile combinations and 6 line themes',
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionIds: questions.take(10).map((q) => q.id).toList(),
      pointsReward: 25,
    );
  }

  /// Create an intermediate profiles quiz
  static Quiz createProfilesIntermediateQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.profiles,
      QuizDifficulty.intermediate,
    );
    return Quiz(
      id: 'profiles-intermediate',
      title: 'Profile Mastery',
      description: 'Master the intricacies of profiles and line harmonics',
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      questionIds: questions.take(10).map((q) => q.id).toList(),
      pointsReward: 50,
    );
  }

  /// Create a beginner definitions quiz
  static Quiz createDefinitionsBeginnerQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.definitions,
      QuizDifficulty.beginner,
    );
    return Quiz(
      id: 'definitions-beginner',
      title: 'Definition Types',
      description: 'Learn how centers connect in the 5 definition types',
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      questionIds: questions.take(8).map((q) => q.id).toList(),
      pointsReward: 25,
    );
  }

  /// Create a beginner channels quiz
  static Quiz createChannelsBeginnerQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.channels,
      QuizDifficulty.beginner,
    );
    return Quiz(
      id: 'channels-beginner',
      title: 'Channel Basics',
      description: 'Learn the fundamentals of how gates form channels',
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.beginner,
      questionIds: questions.take(10).map((q) => q.id).toList(),
      pointsReward: 25,
    );
  }

  /// Create a channels intermediate quiz
  static Quiz createChannelsIntermediateQuiz() {
    final questions = _generator.generateForCategoryAndDifficulty(
      QuizCategory.channels,
      QuizDifficulty.intermediate,
    );
    return Quiz(
      id: 'channels-intermediate',
      title: 'Channel Connections',
      description: 'Explore how gates form the 36 channels',
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.intermediate,
      questionIds: questions.take(12).map((q) => q.id).toList(),
      pointsReward: 50,
    );
  }

  /// Create a mixed general quiz
  static Quiz createGeneralQuiz(QuizDifficulty difficulty) {
    final questions = _generator.generateRandomMix(
      count: 15,
      difficulty: difficulty,
    );
    return Quiz(
      id: 'general-${difficulty.name}',
      title: 'Human Design ${difficulty.displayName}',
      description: 'A mixed quiz covering all Human Design concepts',
      category: QuizCategory.general,
      difficulty: difficulty,
      questionIds: questions.map((q) => q.id).toList(),
      pointsReward: 25 * difficulty.pointMultiplier,
    );
  }

  /// Get all predefined quizzes
  static List<Quiz> getAllTemplateQuizzes() {
    return [
      createTypesBeginnerQuiz(),
      createCentersBeginnerQuiz(),
      createAuthoritiesBeginnerQuiz(),
      createAuthoritiesIntermediateQuiz(),
      createProfilesBeginnerQuiz(),
      createProfilesIntermediateQuiz(),
      createDefinitionsBeginnerQuiz(),
      createGatesBeginnerQuiz(),
      createGatesIntermediateQuiz(),
      createChannelsBeginnerQuiz(),
      createChannelsIntermediateQuiz(),
      createChannelsAdvancedQuiz(),
      createGeneralQuiz(QuizDifficulty.beginner),
      createGeneralQuiz(QuizDifficulty.intermediate),
      createGeneralQuiz(QuizDifficulty.advanced),
    ];
  }
}
