import '../../../../core/constants/human_design_constants.dart';
import '../../domain/models/quiz.dart';
import 'question_generator.dart';

/// Generator for Human Design Gate questions
/// Dynamically generates questions from the gates constants
class GatesQuestionGenerator extends QuestionGenerator {
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

    // Basic gate count
    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many gates are there in the Human Design system?',
      correctAnswer: '64',
      wrongAnswers: ['36', '72', '48'],
      explanation:
          'There are 64 gates in Human Design, corresponding to the 64 hexagrams of the I Ching. Each gate represents a specific energy or theme.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many lines does each gate have?',
      correctAnswer: '6',
      wrongAnswers: ['4', '5', '8'],
      explanation:
          'Each gate has 6 lines, matching the 6 lines of an I Ching hexagram. Your line determines how you express that gate\'s energy.',
    ));

    // Conceptual questions about gates
    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which center has the most gates?',
      correctAnswer: 'Throat (11 gates)',
      wrongAnswers: ['Sacral (9 gates)', 'Root (9 gates)', 'G Center (8 gates)'],
      explanation:
          'The Throat center has 11 gates, making it the center with the most gates. This reflects its central role as the hub of expression and manifestation in the bodygraph.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'In Human Design, gates represent:',
      correctAnswer: 'Specific themes, energies, or potentials',
      wrongAnswers: [
        'Physical body parts',
        'Different personality disorders',
        'Past life karma',
      ],
      explanation:
          'Each gate represents a specific theme or energy potential. When a gate is defined (colored in), that energy is consistently available to you. The 64 gates correspond to the 64 hexagrams of the I Ching.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'A "hanging gate" is:',
      correctAnswer: 'A defined gate without its connecting gate defined',
      wrongAnswers: [
        'A gate that is broken',
        'A gate that changes every day',
        'A gate connected to two centers',
      ],
      explanation:
          'A hanging gate is when you have one gate of a channel defined, but not the other. This creates an attraction to people who have the opposite gate, as they complete your channel.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How often does the Sun move to a new gate?',
      correctAnswer: 'Approximately every 6 days',
      wrongAnswers: [
        'Every 24 hours',
        'Every month',
        'Once per year',
      ],
      explanation:
          'The Sun spends approximately 5-6 days in each gate as it moves through the 64 gates over the course of a year. This is why transits and daily energies shift regularly.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What is Gate 1 called?',
      correctAnswer: 'The Creative',
      wrongAnswers: ['The Receptive', 'The Beginning', 'The First'],
      explanation:
          'Gate 1 is called "The Creative" and is located in the G Center. It represents creative self-expression and the potential for unique individual contribution.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What is Gate 2 called?',
      correctAnswer: 'The Receptive (Direction of Self)',
      wrongAnswers: ['The Creative', 'The Listener', 'The Driver'],
      explanation:
          'Gate 2 is called "The Receptive" or "Direction of Self" and is in the G Center. It represents receptive direction and is the Driver of the vehicle in Human Design.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      statement: 'Two gates connected by a channel always belong to different centers.',
      isTrue: true,
      explanation:
          'Channels always connect two different centers. Each channel is formed by two gates, with one gate in each of the two centers the channel connects.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      statement: 'A defined gate means you consistently express that energy.',
      isTrue: true,
      explanation:
          'When a gate is defined (colored in) in your chart, that energy is a consistent part of who you are. Undefined gates are areas where you take in and amplify energy from others.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Where do Human Design gates come from?',
      correctAnswer: 'The 64 hexagrams of the I Ching',
      wrongAnswers: [
        'Ancient Egyptian hieroglyphics',
        'The 12 zodiac signs',
        'The 7 chakras',
      ],
      explanation:
          'The 64 gates in Human Design correspond to the 64 hexagrams of the ancient Chinese I Ching (Book of Changes). Each hexagram has been translated into Human Design terminology.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Gate 46 is known as the Gate of:',
      correctAnswer: 'Determination (Love of Body)',
      wrongAnswers: [
        'Confusion',
        'The Creative',
        'Inner Truth',
      ],
      explanation:
          'Gate 46, located in the G Center, is called the Gate of Determination or Love of Body. It represents being in the right place at the right time and the love of the physical body.',
    ));

    // Generate "which center" questions for random gates
    final selectedGates = getRandomItems(gates.keys.toList(), 20);
    for (final gateNum in selectedGates) {
      final gate = gates[gateNum]!;
      final otherCenters = HumanDesignCenter.values
          .where((c) => c != gate.center)
          .map((c) => c.displayName)
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.gates,
        difficulty: QuizDifficulty.beginner,
        questionText: 'Gate $gateNum (${gate.name}) is located in which center?',
        correctAnswer: gate.center.displayName,
        wrongAnswers: getRandomItems(otherCenters, 3),
        explanation:
            'Gate $gateNum "${gate.name}" is in the ${gate.center.displayName} center. Its keynote is "${gate.keynote}".',
      ));
    }

    return questions;
  }

  List<QuizQuestion> _generateIntermediateQuestions() {
    final questions = <QuizQuestion>[];

    // Gate keynote questions
    final selectedGates = getRandomItems(gates.keys.toList(), 15);
    for (final gateNum in selectedGates) {
      final gate = gates[gateNum]!;
      final otherKeynotes = gates.values
          .where((g) => g.number != gateNum)
          .map((g) => g.keynote)
          .toSet()
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.gates,
        difficulty: QuizDifficulty.intermediate,
        questionText: 'What is the keynote for Gate ${gate.number} (${gate.name})?',
        correctAnswer: gate.keynote,
        wrongAnswers: getRandomItems(otherKeynotes, 3),
        explanation:
            'Gate ${gate.number} "${gate.name}" has the keynote "${gate.keynote}". It is located in the ${gate.center.displayName}.',
      ));
    }

    // Gate name identification
    final selectedForNames = getRandomItems(gates.keys.toList(), 10);
    for (final gateNum in selectedForNames) {
      final gate = gates[gateNum]!;

      questions.add(createMultipleChoice(
        category: QuizCategory.gates,
        difficulty: QuizDifficulty.intermediate,
        questionText: 'Which gate is known as "The ${gate.name}"?',
        correctAnswer: 'Gate $gateNum',
        wrongAnswers: getRandomItems(
            gates.entries
                .where((e) => e.key != gateNum)
                .map((e) => 'Gate ${e.key}')
                .toList(),
            3),
        explanation:
            'Gate $gateNum is called "The ${gate.name}" with the keynote "${gate.keynote}". It\'s located in the ${gate.center.displayName}.',
      ));
    }

    // Center-based gate counting
    for (final center in [
      HumanDesignCenter.sacral,
      HumanDesignCenter.throat,
      HumanDesignCenter.g,
      HumanDesignCenter.solarPlexus,
    ]) {
      final gatesInCenter = gates.values.where((g) => g.center == center).length;

      questions.add(createMultipleChoice(
        category: QuizCategory.gates,
        difficulty: QuizDifficulty.intermediate,
        questionText: 'How many gates are in the ${center.displayName} center?',
        correctAnswer: gatesInCenter.toString(),
        wrongAnswers: [
          (gatesInCenter + 2).toString(),
          (gatesInCenter - 1).toString(),
          (gatesInCenter + 4).toString(),
        ],
        explanation:
            'The ${center.displayName} center contains $gatesInCenter gates. This makes it ${gatesInCenter > 7 ? "one of the larger centers" : "a medium-sized center"} in terms of gate count.',
      ));
    }

    return questions;
  }

  List<QuizQuestion> _generateAdvancedQuestions() {
    final questions = <QuizQuestion>[];

    // Line-specific questions
    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'The 6 lines of each gate follow which progression?',
      correctAnswer: 'Investigator, Hermit, Martyr, Opportunist, Heretic, Role Model',
      wrongAnswers: [
        'Leader, Follower, Observer, Teacher, Student, Master',
        'Creator, Destroyer, Preserver, Transformer, Liberator, Integrator',
        'Earth, Water, Fire, Air, Spirit, Void',
      ],
      explanation:
          'The 6 lines progress from: 1st Line (Investigator/Foundation), 2nd (Hermit/Natural), 3rd (Martyr/Trial & Error), 4th (Opportunist/Network), 5th (Heretic/Universal), 6th (Role Model/Administrator).',
    ));

    // Gate groupings by theme
    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Gates 1-8 form which channel and what does it represent?',
      correctAnswer: 'The Channel of Inspiration - Creative expression',
      wrongAnswers: [
        'The Channel of Discovery - Learning',
        'The Channel of Money - Material resources',
        'The Channel of Power - Leadership',
      ],
      explanation:
          'Gates 1 (The Creative in G) and 8 (Contribution in Throat) form the Channel of Inspiration, governing creative self-expression and making a unique contribution.',
    ));

    // Harmonic gates
    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'What is the harmonic gate to Gate 1 (The Creative)?',
      correctAnswer: 'Gate 2 (The Receptive)',
      wrongAnswers: [
        'Gate 8 (Contribution)',
        'Gate 64 (Confusion)',
        'Gate 10 (Behavior of Self)',
      ],
      explanation:
          'Gate 1 and Gate 2 are harmonics in the G Center. Gate 1 represents active creative direction while Gate 2 represents receptive direction, the Driver of the vehicle.',
    ));

    // Gate sequences
    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Which gate starts at 0° Aries in the Human Design wheel?',
      correctAnswer: 'Gate 41 (Contraction)',
      wrongAnswers: [
        'Gate 1 (The Creative)',
        'Gate 64 (Confusion)',
        'Gate 13 (The Listener)',
      ],
      explanation:
          'Gate 41 begins at 0° Aries and represents the codon that initiates the human experiential way. It\'s in the Root center and relates to the start of experience.',
    ));

    // Incarnation Cross gates
    questions.add(createTrueFalse(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.advanced,
      statement:
          'Your Incarnation Cross is determined by the gates of your conscious and unconscious Sun and Earth.',
      isTrue: true,
      explanation:
          'The Incarnation Cross is formed by 4 gates: your conscious Sun and Earth gates, and your unconscious (Design) Sun and Earth gates. These form your life\'s purpose.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.advanced,
      statement: 'Earth gates are always 180° opposite from Sun gates.',
      isTrue: true,
      explanation:
          'Earth is always exactly opposite the Sun in the zodiac (180°). If your Sun is in Gate 1, your Earth will be in Gate 2 (the opposite position on the wheel).',
    ));

    // Circuit groupings
    questions.add(createMultipleChoice(
      category: QuizCategory.gates,
      difficulty: QuizDifficulty.advanced,
      questionText: 'Gates and channels belong to which three main circuits?',
      correctAnswer: 'Individual, Collective, and Tribal',
      wrongAnswers: [
        'Physical, Mental, and Spiritual',
        'Past, Present, and Future',
        'Creation, Maintenance, and Destruction',
      ],
      explanation:
          'Human Design circuits are: Individual (mutation, uniqueness), Collective (sharing, logic/abstract), and Tribal (support, community). There\'s also an Integration circuit.',
    ));

    return questions;
  }
}
