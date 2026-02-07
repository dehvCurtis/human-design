import '../../../../core/constants/human_design_constants.dart';
import '../../domain/models/quiz.dart';
import 'question_generator.dart';

/// Generator for Human Design Definition questions
class DefinitionsQuestionGenerator extends QuestionGenerator {
  @override
  List<QuizQuestion> generateAll() {
    return [
      ..._generateBeginnerQuestions(),
      ..._generateIntermediateQuestions(),
      ..._generateAdvancedQuestions(),
    ];
  }

  List<QuizQuestion> _generateBeginnerQuestions() {
    final questions = <QuizQuestion>[];

    // Basic count question
    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many types of definition exist in Human Design?',
      correctAnswer: '5',
      wrongAnswers: ['4', '7', '9'],
      explanation:
          'There are 5 types of definition: No Definition, Single Definition, Split Definition, Triple Split Definition, and Quadruple Split Definition.',
    ));

    // Definition type questions
    for (final definition in Definition.values) {
      final otherDescriptions = Definition.values
          .where((d) => d != definition)
          .map((d) => d.description)
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.definitions,
        difficulty: QuizDifficulty.beginner,
        questionText: 'What does "${definition.displayName}" mean?',
        correctAnswer: definition.description,
        wrongAnswers: getRandomItems(otherDescriptions, 3),
        explanation:
            '${definition.displayName}: ${definition.description}. This describes how the defined centers in a chart are connected to each other.',
      ));
    }

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What definition type has no defined centers?',
      correctAnswer: 'No Definition',
      wrongAnswers: ['Single Definition', 'Split Definition', 'Quadruple Split'],
      explanation:
          'No Definition means all 9 centers are undefined/open. This is unique to Reflectors, who have no consistent internal energy and sample the energies around them.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      questionText: 'When all defined centers are connected, this is called:',
      correctAnswer: 'Single Definition',
      wrongAnswers: ['Full Definition', 'Complete Definition', 'United Definition'],
      explanation:
          'Single Definition means all defined centers in the chart are connected to each other through channels. Energy flows continuously without gaps between defined areas.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which type always has No Definition?',
      correctAnswer: 'Reflector',
      wrongAnswers: ['Projector', 'Manifestor', 'Generator'],
      explanation:
          'Reflectors are the only type that always has No Definition. They have all 9 centers undefined/open, making them unique in how they experience and process energy.',
    ));

    // Additional beginner questions
    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What does Split Definition mean for someone\'s energy?',
      correctAnswer: 'They need others to bridge their defined areas',
      wrongAnswers: ['They have more energy than others', 'They have no defined centers', 'They are fully self-contained'],
      explanation:
          'Split Definition means there are two or more separate areas of definition in the chart with a gap between them. These individuals often seek out others whose gates bridge their split.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      statement: 'People with Single Definition are completely self-contained and don\'t need others energetically.',
      isTrue: true,
      explanation:
          'Single Definition means all defined centers are connected. While they still need relationships, energetically they are self-contained and don\'t have an internal pull to find bridging energy.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Triple Split Definition has how many separate areas of definition?',
      correctAnswer: '3 separate defined areas',
      wrongAnswers: ['1 connected area', '2 separate areas', '4 or more separate areas'],
      explanation:
          'Triple Split Definition means there are three separate islands of defined centers with gaps between them. This creates a more complex process for integrating energy.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which definition type is the rarest?',
      correctAnswer: 'Quadruple Split',
      wrongAnswers: ['Single Definition', 'Split Definition', 'Triple Split'],
      explanation:
          'Quadruple Split is the rarest definition type, with four separate areas of definition in the chart. These individuals have complex energy dynamics and benefit from group environments.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.beginner,
      statement: 'Definition type tells you how quickly you can process information and make decisions.',
      isTrue: true,
      explanation:
          'Definition type does affect processing speed. Single Definition processes information quickly, while Split and Triple Split may need more time as they have to bridge different parts of their design.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateIntermediateQuestions() {
    final questions = <QuizQuestion>[];

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Split Definition means:',
      correctAnswer: 'Two separate areas of definition that are not connected',
      wrongAnswers: [
        'Only half the centers are defined',
        'The definition changes depending on who you are with',
        'Centers are defined but not active',
      ],
      explanation:
          'Split Definition occurs when defined centers form two separate groups with no channel connecting them. People with Split Definition often feel something is "missing" and seek others who bridge their splits.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.intermediate,
      statement: 'Triple Split Definition has three unconnected defined areas.',
      isTrue: true,
      explanation:
          'Triple Split Definition means the defined centers form three separate groups with no channels connecting them. People with this definition need various different energies to feel complete.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'A person with Split Definition often seeks:',
      correctAnswer: 'Bridging energy from others that connects their split areas',
      wrongAnswers: [
        'More defined centers',
        'Complete isolation for clarity',
        'Only people with the same definition',
      ],
      explanation:
          'People with Split Definition are naturally drawn to others who carry the bridging gates or channels that connect their two areas of definition. This creates a sense of wholeness.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What is the most common definition type?',
      correctAnswer: 'Split Definition',
      wrongAnswers: ['Single Definition', 'Triple Split', 'No Definition'],
      explanation:
          'Split Definition is the most common, found in approximately 45% of the population. Single Definition accounts for about 40%, Triple Split about 10%, and Quadruple Split and No Definition are rare.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.intermediate,
      statement: 'Single Definition people need others to feel complete.',
      isTrue: false,
      explanation:
          'People with Single Definition have all their defined centers connected, so they feel energetically complete on their own. They don\'t depend on others for energetic wholeness, though they still benefit from relationships.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'How does definition affect decision-making speed?',
      correctAnswer: 'Single Definition tends to make decisions faster than Split Definition',
      wrongAnswers: [
        'Split Definition makes faster decisions',
        'Definition type has no effect on decision speed',
        'Only authority determines decision speed',
      ],
      explanation:
          'Single Definition people process information more quickly because their defined areas are already connected. Split Definition people may need more time or to be in the right environment to process effectively.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateAdvancedQuestions() {
    final questions = <QuizQuestion>[];

    questions.add(createTrueFalse(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.advanced,
      statement: 'Quadruple Split Definition is the rarest definition type.',
      isTrue: true,
      explanation:
          'Quadruple Split Definition (four separate areas of defined centers) is extremely rare, occurring in less than 1% of the population. No Definition (Reflectors only) is also rare at about 1%.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'What is the impact of Split Definition on relationships?',
      correctAnswer: 'Creates a natural attraction to those who bridge the split',
      wrongAnswers: [
        'Makes relationships more difficult',
        'Creates independence from others',
        'Has no significant impact on relationships',
      ],
      explanation:
          'Split Definition creates a natural pull toward people who have the gates or channels that bridge the split. This "bridging" energy feels like completeness, which can be both connecting and potentially conditioning.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'A person with Triple Split Definition needs which type of environment to feel whole?',
      correctAnswer: 'Varied social environments with different energies',
      wrongAnswers: [
        'Complete isolation',
        'Only one close relationship',
        'Large crowds exclusively',
      ],
      explanation:
          'Triple Split Definition people have three separate defined areas. They need to sample different energies from different sources to bring their definition together. Variety in relationships and environments helps them process.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'What determines whether a definition is "wide" or "narrow" split?',
      correctAnswer: 'The number of gates needed to bridge the split',
      wrongAnswers: [
        'The total number of defined centers',
        'Which centers are defined',
        'The person\'s type and authority',
      ],
      explanation:
          'A narrow split requires only one gate to bridge (a single gate from one area connects to a gate in another), while a wide split requires a full channel or multiple gates. Narrow splits feel less "separate" than wide splits.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.advanced,
      statement:
          'The transit field can temporarily bridge a Split Definition.',
      isTrue: true,
      explanation:
          'Planetary transits activate gates that can temporarily bridge splits. When the transit field provides the bridging energy, a person with Split Definition may experience temporary feelings of wholeness or completeness.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'How does Quadruple Split Definition affect a person\'s processing style?',
      correctAnswer: 'They need even more time and varied input than other splits',
      wrongAnswers: [
        'They process faster due to more defined areas',
        'They should avoid others completely',
        'Processing is the same as Single Definition',
      ],
      explanation:
          'Quadruple Split has four separate areas that need bridging. This requires sampling many different energies over time. These individuals need patience with their process and should not rush major decisions.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.definitions,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'What is the risk for people who seek "bridging" energy from others?',
      correctAnswer: 'Becoming overly dependent on specific people for feeling complete',
      wrongAnswers: [
        'Bridging is always beneficial with no risks',
        'They may lose their own definition',
        'Bridging energy changes their type',
      ],
      explanation:
          'While bridging feels good, becoming dependent on specific people for that wholeness can lead to unhealthy attachment patterns. The key is awareness - enjoying bridging energy while not needing it for self-worth.',
    ));

    return questions;
  }
}
