import '../../../../core/constants/human_design_constants.dart';
import '../../domain/models/quiz.dart';
import 'question_generator.dart';

/// Generator for Human Design Center questions
class CentersQuestionGenerator extends QuestionGenerator {
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

    // Basic center count
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many energy centers are in the Human Design bodygraph?',
      correctAnswer: '9',
      wrongAnswers: ['7', '8', '12'],
      explanation:
          'The Human Design bodygraph has 9 centers, which correspond to chakras but with some modifications based on the evolution of consciousness.',
    ));

    // Center function questions
    for (final center in HumanDesignCenter.values) {
      final otherDescriptions = HumanDesignCenter.values
          .where((c) => c != center)
          .map((c) => c.description)
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.centers,
        difficulty: QuizDifficulty.beginner,
        questionText: 'What is the ${center.displayName} center associated with?',
        correctAnswer: center.description,
        wrongAnswers: getRandomItems(otherDescriptions, 3),
        explanation:
            'The ${center.displayName} center governs ${center.description}.',
      ));
    }

    // Motor centers
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many motor centers are there in the bodygraph?',
      correctAnswer: '4',
      wrongAnswers: ['3', '5', '2'],
      explanation:
          'There are 4 motor centers: the Sacral (life force), Heart/Ego (willpower), Solar Plexus (emotional), and Root (adrenaline/pressure).',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which center is responsible for life force energy and sexuality?',
      correctAnswer: 'Sacral',
      wrongAnswers: ['Root', 'Solar Plexus', 'Heart'],
      explanation:
          'The Sacral center is the powerhouse of life force energy. It provides sustainable energy for work and is connected to sexuality and reproduction.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which center governs communication and manifestation?',
      correctAnswer: 'Throat',
      wrongAnswers: ['G Center', 'Ajna', 'Head'],
      explanation:
          'The Throat center is the hub for communication and manifestation. It transforms energy into action and expression in the world.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which center is associated with identity, love, and direction?',
      correctAnswer: 'G/Self',
      wrongAnswers: ['Heart', 'Solar Plexus', 'Sacral'],
      explanation:
          'The G Center (also called Self Center) is the center of identity, love, and direction in life. It houses the magnetic monopole.',
    ));

    // Biological correlation questions
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which biological system is the Sacral center connected to?',
      correctAnswer: 'Ovaries and testes (reproductive system)',
      wrongAnswers: ['Heart and circulatory system', 'Lungs and respiratory system', 'Brain and nervous system'],
      explanation:
          'The Sacral center is biologically connected to the ovaries and testes - the reproductive organs. This connects to its themes of life force energy, sexuality, and generation.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which body system is the Spleen center connected to?',
      correctAnswer: 'Lymphatic and immune system',
      wrongAnswers: ['Digestive system', 'Reproductive system', 'Circulatory system'],
      explanation:
          'The Spleen center is biologically connected to the lymphatic system, spleen organ, and immune function. This is why it governs survival instinct, health awareness, and intuitive body intelligence.',
    ));

    // Additional beginner questions
    questions.add(createTrueFalse(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      statement: 'When a center is undefined, you are inconsistent in that area but can also be very wise about it.',
      isTrue: true,
      explanation:
          'Undefined centers are areas where we take in and amplify energy from others. While this creates inconsistency, it also gives us the potential for deep wisdom through experiencing many different expressions of that energy.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What does it mean when a center is colored in on your chart?',
      correctAnswer: 'The center is defined - it operates consistently',
      wrongAnswers: ['The center is damaged', 'The center is blocked', 'The center needs healing'],
      explanation:
          'A colored/filled-in center is defined, meaning it operates consistently and reliably. You broadcast this energy to others rather than taking it in.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which center is responsible for mental anxiety and inspiration?',
      correctAnswer: 'Head',
      wrongAnswers: ['Ajna', 'Throat', 'G Center'],
      explanation:
          'The Head center is the pressure center for mental activity - it creates the pressure to think and be inspired. When undefined, it can lead to thinking about things that don\'t matter.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which center processes thoughts and creates fixed concepts?',
      correctAnswer: 'Ajna',
      wrongAnswers: ['Head', 'Throat', 'Spleen'],
      explanation:
          'The Ajna center is the awareness center for mental conceptualization. It processes the inspiration from the Head center into concepts, theories, and opinions.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateIntermediateQuestions() {
    final questions = <QuizQuestion>[];

    // Awareness centers
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Which three centers are considered awareness centers?',
      correctAnswer: 'Ajna, Spleen, Solar Plexus',
      wrongAnswers: [
        'Head, Throat, G Center',
        'Sacral, Root, Heart',
        'Spleen, Sacral, Throat',
      ],
      explanation:
          'The three awareness centers are: Ajna (mental awareness), Spleen (body awareness/intuition), and Solar Plexus (emotional awareness).',
    ));

    // Pressure centers
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Which two centers are pressure centers?',
      correctAnswer: 'Head and Root',
      wrongAnswers: [
        'Sacral and Solar Plexus',
        'Throat and G Center',
        'Heart and Spleen',
      ],
      explanation:
          'The Head (mental pressure to answer questions) and Root (pressure to act) are the two pressure centers that create drive and motivation.',
    ));

    // Defined vs undefined questions
    questions.add(createTrueFalse(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      statement: 'An undefined center indicates weakness in that area.',
      isTrue: false,
      explanation:
          'Undefined centers are not weaknesses - they are areas of wisdom potential. Through these centers, we can sample and learn from others\' energy, becoming wise about that domain.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      statement:
          'A defined center provides consistent, reliable energy in that area.',
      isTrue: true,
      explanation:
          'Defined centers produce consistent energy that we can rely on. This energy is fixed and doesn\'t change based on who we\'re around.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      statement:
          'People with an undefined Sacral center have sustainable work energy.',
      isTrue: false,
      explanation:
          'The undefined Sacral does not generate its own sustainable life force. People with undefined Sacrals (Projectors, Manifestors, Reflectors) need to work differently and rest more.',
    ));

    // Center conditioning
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      questionText:
          'What happens when you have an undefined center around someone with that center defined?',
      correctAnswer: 'You amplify and absorb their energy',
      wrongAnswers: [
        'Your center becomes temporarily defined',
        'Nothing happens',
        'You repel their energy',
      ],
      explanation:
          'Undefined centers take in and amplify the energy from defined centers around them. This is how conditioning happens - we absorb others\' energy.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      questionText:
          'If you have an undefined Solar Plexus, what might you experience?',
      correctAnswer: 'Amplifying others\' emotions and avoiding confrontation',
      wrongAnswers: [
        'No emotional awareness',
        'Consistent emotional waves',
        'Inability to feel emotions',
      ],
      explanation:
          'People with undefined Solar Plexus can deeply feel others\' emotions, often more intensely than the other person. They may avoid confrontation to escape emotional discomfort.',
    ));

    // More biological correlations
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'The Solar Plexus center is biologically connected to:',
      correctAnswer: 'Kidneys, pancreas, lungs, and nervous system',
      wrongAnswers: [
        'Only the heart',
        'Brain and pituitary gland',
        'Ovaries and testes',
      ],
      explanation:
          'The Solar Plexus has extensive biological connections: kidneys, pancreas, lungs, prostate/uterus, and the nervous system. This explains why emotional stress affects so many physical systems.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'The Root center is biologically connected to:',
      correctAnswer: 'Adrenal glands (stress response)',
      wrongAnswers: [
        'Thyroid gland',
        'Pineal gland',
        'Pituitary gland',
      ],
      explanation:
          'The Root center connects to the adrenal glands, which produce adrenaline and cortisol. This is why the Root governs pressure, stress, and the drive to act.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'The Head center is biologically connected to:',
      correctAnswer: 'Pineal gland',
      wrongAnswers: [
        'Pituitary gland',
        'Thyroid gland',
        'Adrenal glands',
      ],
      explanation:
          'The Head center connects to the pineal gland, associated with inspiration, mental pressure, and the pressure to make sense of the unknown. It creates questions seeking answers.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'The Ajna center is biologically connected to:',
      correctAnswer: 'Pituitary gland (anterior and posterior)',
      wrongAnswers: [
        'Pineal gland',
        'Thyroid gland',
        'Adrenal glands',
      ],
      explanation:
          'The Ajna center connects to the pituitary gland - the master gland of the endocrine system. This reflects the Ajna\'s role in processing and conceptualizing information.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateAdvancedQuestions() {
    final questions = <QuizQuestion>[];

    // Not-self questions for each center
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'The not-self question for the undefined Head center is:',
      correctAnswer: '"Am I trying to answer questions that don\'t matter?"',
      wrongAnswers: [
        '"Am I sure enough?"',
        '"Am I trying to get attention?"',
        '"Am I in the right place?"',
      ],
      explanation:
          'The undefined Head center can get stuck trying to answer every mental question, even ones that aren\'t important. The key is learning to let go of mental pressure.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'The not-self question for the undefined G Center is:',
      correctAnswer: '"Am I looking for love and direction?"',
      wrongAnswers: [
        '"Am I trying to be certain?"',
        '"Am I talking to get attention?"',
        '"Am I avoiding confrontation?"',
      ],
      explanation:
          'People with undefined G Centers may constantly seek love, identity, or direction from outside themselves. The wisdom is learning that identity isn\'t fixed.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'The not-self question for the undefined Sacral is:',
      correctAnswer: '"Am I knowing when enough is enough?"',
      wrongAnswers: [
        '"Am I trying to attract attention?"',
        '"Am I avoiding truth?"',
        '"Am I holding on to what isn\'t good for me?"',
      ],
      explanation:
          'The undefined Sacral doesn\'t know its own limits and can overwork trying to keep up with Generators. Learning when to stop is key.',
    ));

    // Complex center interactions
    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'If someone has only the G Center and Throat connected, what type are they likely to be?',
      correctAnswer: 'Projector with Self-Projected Authority',
      wrongAnswers: [
        'Manifestor with Ego Authority',
        'Generator with Sacral Authority',
        'Reflector',
      ],
      explanation:
          'With only G-Throat connection (no motors connected to Throat, no defined Sacral), this is a Self-Projected Projector. They make decisions by hearing themselves speak.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.advanced,
      statement:
          'The Solar Plexus center operates in waves and is never in the now.',
      isTrue: true,
      explanation:
          'The Solar Plexus is a motor and awareness center that operates through emotional waves over time. Unlike the Spleen (in the moment), emotional clarity requires waiting for the wave to pass.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.advanced,
      statement:
          'The Spleen center provides moment-by-moment survival awareness that doesn\'t repeat.',
      isTrue: true,
      explanation:
          'The Spleen is the body\'s immune system and intuitive awareness center. It communicates once, in the moment, and won\'t repeat. If you miss the splenic hit, it\'s gone.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Which center, when defined, always creates Emotional Authority regardless of other definitions?',
      correctAnswer: 'Solar Plexus',
      wrongAnswers: ['Sacral', 'Spleen', 'G Center'],
      explanation:
          'A defined Solar Plexus always creates Emotional Authority. This center\'s emotional wave must be navigated before making decisions, overriding other potential authorities.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.centers,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'The Heart/Ego center is connected to which biological systems?',
      correctAnswer: 'Heart, stomach, gallbladder, and thymus',
      wrongAnswers: [
        'Lungs and respiratory system',
        'Kidneys and adrenals',
        'Liver and pancreas',
      ],
      explanation:
          'The Heart/Ego center is connected to the heart, stomach, gallbladder, and thymus gland. It governs willpower, self-worth, and material resources.',
    ));

    return questions;
  }
}
