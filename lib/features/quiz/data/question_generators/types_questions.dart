import '../../../../core/constants/human_design_constants.dart';
import '../../domain/models/quiz.dart';
import 'question_generator.dart';

/// Generator for Human Design Type questions
class TypesQuestionGenerator extends QuestionGenerator {
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

    // Strategy questions for each type
    for (final type in HumanDesignType.values) {
      final otherStrategies = HumanDesignType.values
          .where((t) => t != type)
          .map((t) => t.strategy)
          .toSet()
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.types,
        difficulty: QuizDifficulty.beginner,
        questionText: 'What is the ${type.displayName}\'s strategy?',
        correctAnswer: type.strategy,
        wrongAnswers: getRandomItems(otherStrategies, 3),
        explanation:
            'The ${type.displayName}\'s strategy is "${type.strategy}". This helps them make correct decisions aligned with their design.',
      ));
    }

    // Not-self theme questions
    for (final type in HumanDesignType.values) {
      final otherThemes = HumanDesignType.values
          .where((t) => t != type)
          .map((t) => t.notSelfTheme)
          .toSet()
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.types,
        difficulty: QuizDifficulty.beginner,
        questionText:
            'What is the not-self theme (feeling when out of alignment) for a ${type.displayName}?',
        correctAnswer: type.notSelfTheme,
        wrongAnswers: getRandomItems(otherThemes, 3),
        explanation:
            'When a ${type.displayName} is not living correctly, they experience ${type.notSelfTheme}. This is a sign to return to their strategy.',
      ));
    }

    // Signature questions
    for (final type in HumanDesignType.values) {
      final otherSignatures = HumanDesignType.values
          .where((t) => t != type)
          .map((t) => t.signature)
          .toSet()
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.types,
        difficulty: QuizDifficulty.beginner,
        questionText:
            'What is the signature (feeling when aligned) for a ${type.displayName}?',
        correctAnswer: type.signature,
        wrongAnswers: getRandomItems(otherSignatures, 3),
        explanation:
            'When a ${type.displayName} is living correctly and following their strategy, they experience ${type.signature}.',
      ));
    }

    // Basic type identification
    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many Human Design types are there?',
      correctAnswer: '5',
      wrongAnswers: ['4', '7', '9'],
      explanation:
          'There are 5 Human Design types: Manifestor, Generator, Manifesting Generator, Projector, and Reflector.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which type makes up the largest percentage of the population?',
      correctAnswer: 'Generator',
      wrongAnswers: ['Projector', 'Manifestor', 'Reflector'],
      explanation:
          'Generators make up about 37% of the population. Combined with Manifesting Generators (33%), they represent about 70% of all people.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which type is the rarest?',
      correctAnswer: 'Reflector',
      wrongAnswers: ['Manifestor', 'Projector', 'Generator'],
      explanation:
          'Reflectors make up only about 1% of the population. They have no defined centers and are deeply connected to the lunar cycle.',
    ));

    // Population percentage questions
    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Approximately what percentage of the population are Projectors?',
      correctAnswer: '20%',
      wrongAnswers: ['10%', '37%', '33%'],
      explanation:
          'Projectors make up approximately 20% of the population. They are here to guide and direct the energy of others when properly recognized and invited.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What percentage of people are Manifestors?',
      correctAnswer: 'About 8%',
      wrongAnswers: ['About 20%', 'About 33%', 'About 1%'],
      explanation:
          'Manifestors make up approximately 8-9% of the population. Historically they were the rulers and leaders before the shift to Generators building the workforce.',
    ));

    // Additional beginner questions
    questions.add(createTrueFalse(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      statement: 'Generators have sustainable life force energy from their defined Sacral center.',
      isTrue: true,
      explanation:
          'The Sacral center, when defined, provides Generators with sustainable life force energy. This is what allows them to work consistently and build things over time.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What should a Manifestor do before taking action that affects others?',
      correctAnswer: 'Inform those who will be impacted',
      wrongAnswers: ['Wait for an invitation', 'Ask for permission', 'Respond to external stimuli'],
      explanation:
          'Manifestors should inform (not ask permission) those who will be affected by their actions. This reduces resistance and helps others feel included rather than caught off guard.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which type is designed to guide and direct the energy of others?',
      correctAnswer: 'Projector',
      wrongAnswers: ['Generator', 'Manifestor', 'Reflector'],
      explanation:
          'Projectors are designed to guide and direct the energy of others. They have a penetrating aura that allows them to see deeply into systems and people.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateIntermediateQuestions() {
    final questions = <QuizQuestion>[];

    // True/false questions about types
    questions.add(createTrueFalse(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      statement:
          'Manifesting Generators share the same strategy as pure Generators.',
      isTrue: true,
      explanation:
          'Both Generators and Manifesting Generators have the strategy "To Respond." The difference is that Manifesting Generators have a motor connected to the Throat, giving them manifestor qualities.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      statement: 'Projectors have sustainable life force energy like Generators.',
      isTrue: false,
      explanation:
          'Projectors do not have a defined Sacral center, so they do not have sustainable life force energy. They need to work in focused bursts and rest.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      statement: 'Manifestors are designed to initiate and inform others.',
      isTrue: true,
      explanation:
          'Manifestors are the only type designed to initiate. Their strategy includes informing those who will be impacted by their actions to reduce resistance.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      statement:
          'Reflectors should make major decisions within 24 hours.',
      isTrue: false,
      explanation:
          'Reflectors are advised to wait a full lunar cycle (approximately 28 days) before making major decisions, as they need to experience all lunar gates.',
    ));

    // Center-based type questions
    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      questionText:
          'What defines a Generator type in terms of center definition?',
      correctAnswer: 'Defined Sacral with no motor connected to Throat',
      wrongAnswers: [
        'Defined Sacral with motor connected to Throat',
        'Undefined Sacral with defined Throat',
        'All centers undefined',
      ],
      explanation:
          'A pure Generator has a defined Sacral center but no motor center connected to the Throat. This gives them sustainable energy but not the ability to initiate like a Manifestor.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      questionText:
          'What makes someone a Manifesting Generator rather than a pure Generator?',
      correctAnswer: 'Defined Sacral AND a motor connected to the Throat',
      wrongAnswers: [
        'Faster energy than a Generator',
        'More defined centers',
        'A defined Head center',
      ],
      explanation:
          'Manifesting Generators have both a defined Sacral AND a motor center (Sacral, Heart, Solar Plexus, or Root) connected to the Throat center.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What center configuration defines a Projector?',
      correctAnswer: 'Undefined Sacral with no motor connected to Throat',
      wrongAnswers: [
        'Defined Sacral with no motor connected to Throat',
        'All centers undefined',
        'Only the Throat defined',
      ],
      explanation:
          'Projectors have an undefined Sacral center and no motor center connected to the Throat. They are designed to guide and direct others\' energy.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Which type requires recognition and invitation before engaging?',
      correctAnswer: 'Projector',
      wrongAnswers: ['Generator', 'Manifestor', 'Reflector'],
      explanation:
          'Projectors need to be recognized for their gifts and invited before sharing their guidance. Without an invitation, their wisdom often goes unheard.',
    ));

    // Aura type questions
    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What type of aura does a Manifestor have?',
      correctAnswer: 'Closed and repelling aura',
      wrongAnswers: ['Open and enveloping aura', 'Focused and penetrating aura', 'Sampling aura'],
      explanation:
          'Manifestors have a closed, repelling aura that pushes energy outward. This protects them from being controlled but can feel intimidating to others, which is why informing is important.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What type of aura do Generators and Manifesting Generators have?',
      correctAnswer: 'Open and enveloping aura',
      wrongAnswers: ['Closed and repelling aura', 'Focused and absorbing aura', 'Resistant and protective aura'],
      explanation:
          'Generators have an open, enveloping aura that draws life to them. This is why their strategy is to respond - life naturally comes to them for their energy to respond to.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What type of aura does a Projector have?',
      correctAnswer: 'Focused and penetrating aura',
      wrongAnswers: ['Open and enveloping aura', 'Closed and repelling aura', 'Resistant and sampling aura'],
      explanation:
          'Projectors have a focused, penetrating aura that can deeply see into others. This is why they are natural guides, but they need to be invited to share their insights.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What makes the Reflector\'s aura unique among all types?',
      correctAnswer: 'It is resistant and sampling, taking in and reflecting the environment',
      wrongAnswers: [
        'It is the most powerful and repelling',
        'It is completely closed off',
        'It is identical to a Projector\'s aura',
      ],
      explanation:
          'Reflectors have a resistant, sampling aura that takes in the energies around them without holding on. They become a mirror for their environment, reflecting the health of their community.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateAdvancedQuestions() {
    final questions = <QuizQuestion>[];

    // Complex scenario-based questions
    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'A person has a defined Sacral, a defined Solar Plexus connected to their Throat, and experiences frustration when not following their strategy. What is their type?',
      correctAnswer: 'Manifesting Generator',
      wrongAnswers: ['Generator', 'Manifestor', 'Projector'],
      explanation:
          'This person is a Manifesting Generator because they have a defined Sacral (Generator energy) plus a motor (Solar Plexus) connected to the Throat (Manifestor channel). Their not-self theme of frustration confirms Generator energy.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'A person has all 9 centers undefined. What special decision-making process do they use?',
      correctAnswer: 'Waiting through a complete lunar cycle',
      wrongAnswers: [
        'Sacral response',
        'Emotional wave clarity',
        'Splenic intuition',
      ],
      explanation:
          'With no defined centers, this person is a Reflector. Their unique process involves waiting approximately 28 days (a lunar cycle) to sample all the energies before making major decisions.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Which motor centers can create a Manifestor or Manifesting Generator when connected to the Throat?',
      correctAnswer: 'Sacral, Heart, Solar Plexus, or Root',
      wrongAnswers: [
        'Only Sacral',
        'Sacral and Heart only',
        'All defined centers',
      ],
      explanation:
          'The four motor centers are Sacral, Heart (Ego), Solar Plexus, and Root. Any of these, when connected to the Throat, creates the capacity to initiate action.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.advanced,
      statement:
          'A Manifestor with Emotional Authority should inform others and then wait for emotional clarity before acting.',
      isTrue: true,
      explanation:
          'While Manifestors are initiators, if they have Emotional Authority (defined Solar Plexus), they still need to ride their emotional wave for clarity before making decisions. Informing helps reduce resistance to their actions.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.advanced,
      statement:
          'Projectors can have the Root center defined and still be Projectors.',
      isTrue: true,
      explanation:
          'Projectors can have the Root defined as long as it\'s not connected to the Throat AND they don\'t have a defined Sacral. The Root provides pressure energy, not the Sacral\'s sustainable life force.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.types,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'What distinguishes an Energy Projector from a Classic Projector?',
      correctAnswer: 'Energy Projectors have at least one motor center defined (but not Sacral)',
      wrongAnswers: [
        'Energy Projectors have more energy',
        'Energy Projectors can initiate like Manifestors',
        'Energy Projectors have a defined Throat',
      ],
      explanation:
          'Energy Projectors have one or more motor centers defined (Heart, Solar Plexus, or Root) but not the Sacral. This gives them more energy than Classic Projectors who have no motors defined.',
    ));

    return questions;
  }
}
