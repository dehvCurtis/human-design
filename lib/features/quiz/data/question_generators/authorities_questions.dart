import '../../../../core/constants/human_design_constants.dart';
import '../../domain/models/quiz.dart';
import 'question_generator.dart';

/// Generator for Human Design Authority questions
class AuthoritiesQuestionGenerator extends QuestionGenerator {
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
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many types of authority are there in Human Design?',
      correctAnswer: '7',
      wrongAnswers: ['5', '9', '12'],
      explanation:
          'There are 7 types of authority in Human Design: Emotional, Sacral, Splenic, Ego/Heart, Self-Projected, Mental/Environmental, and Lunar.',
    ));

    // Authority description questions
    for (final authority in Authority.values) {
      final otherDescriptions = Authority.values
          .where((a) => a != authority)
          .map((a) => a.description)
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.authorities,
        difficulty: QuizDifficulty.beginner,
        questionText: 'What is the guidance for ${authority.displayName} Authority?',
        correctAnswer: authority.description,
        wrongAnswers: getRandomItems(otherDescriptions, 3),
        explanation:
            '${authority.displayName} Authority guidance: "${authority.description}". This is how people with this authority make correct decisions.',
      ));
    }

    // Specific beginner questions
    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which authority requires waiting 28 days before making major decisions?',
      correctAnswer: 'Lunar',
      wrongAnswers: ['Emotional', 'Sacral', 'Splenic'],
      explanation:
          'Lunar Authority is unique to Reflectors, who have no defined centers. They need to wait a full lunar cycle (approximately 28 days) to experience all the energies before making major decisions.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Sacral Authority responds with what kind of response?',
      correctAnswer: 'Gut responses in the moment',
      wrongAnswers: ['Emotional waves', 'Mental analysis', 'Intuitive hits'],
      explanation:
          'Sacral Authority uses immediate gut responses - sounds like "uh-huh" (yes) or "un-un" (no). These responses come in the moment when asked yes/no questions.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What is the most common authority type?',
      correctAnswer: 'Emotional Authority',
      wrongAnswers: ['Sacral Authority', 'Splenic Authority', 'Ego Authority'],
      explanation:
          'Emotional Authority is the most common because anyone with a defined Solar Plexus center has Emotional Authority, regardless of other definitions. About 50% of the population has this authority.',
    ));

    // Additional beginner questions for each authority type

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText:
          'What should someone with Emotional Authority do before making important decisions?',
      correctAnswer: 'Wait for emotional clarity over time',
      wrongAnswers: [
        'Decide immediately when excited',
        'Ask others what to do',
        'Flip a coin',
      ],
      explanation:
          'Emotional Authority requires riding the emotional wave. The key phrase is "there is no truth in the now" - clarity comes from experiencing the full range of emotions over time, not from any single moment of feeling.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Splenic Authority decisions are characterized by:',
      correctAnswer: 'Instant, in-the-moment knowing',
      wrongAnswers: [
        'Waiting several days for clarity',
        'Strong emotional feelings',
        'Logical analysis of pros and cons',
      ],
      explanation:
          'Splenic Authority operates in the NOW. It speaks once, quietly, with immediate intuitive knowing. Unlike Emotional Authority, there is no wave to ride - the answer comes in the moment.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Ego/Heart Authority makes decisions based on:',
      correctAnswer: 'What the heart truly wants and can commit to',
      wrongAnswers: [
        'What makes logical sense',
        'What others expect',
        'Emotional highs and lows',
      ],
      explanation:
          'Ego Authority is about willpower and desire. The question to ask is "Do I want this? Can I commit to this?" When the heart is truly in it, the will is there to see it through.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How does Self-Projected Authority gain clarity?',
      correctAnswer: 'By talking through decisions out loud',
      wrongAnswers: [
        'By meditating in silence',
        'By waiting for gut feelings',
        'By analyzing data',
      ],
      explanation:
          'Self-Projected Authority works by hearing oneself speak. Talking about options with trusted others helps clarify what is true for the person - not seeking advice, but hearing their own voice.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What does Environmental/Mental Authority need for decision-making?',
      correctAnswer: 'The right physical environment and trusted sounding boards',
      wrongAnswers: [
        'Complete isolation',
        'Strong gut responses',
        'Emotional certainty',
      ],
      explanation:
          'Environmental Authority is unique in that there is no inner authority. Decisions come through environment - both the physical space and trusted people who serve as sounding boards (not advisors).',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Sacral Authority typically responds with:',
      correctAnswer: 'Sounds like "uh-huh" (yes) or "uhn-uhn" (no)',
      wrongAnswers: [
        'Written pros and cons lists',
        'Lengthy verbal explanations',
        'Dreams and visions',
      ],
      explanation:
          'Sacral Authority communicates through primal gut sounds - "uh-huh" for yes, "uhn-uhn" for no. These responses come in the moment when asked direct yes/no questions.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      statement: 'Authority tells you HOW to make correct decisions for yourself.',
      isTrue: true,
      explanation:
          'Authority is your personal decision-making guidance system. While Type tells you how to interact with the world (strategy), Authority tells you how to know what is correct specifically for you.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      statement: 'Everyone has the same type of authority.',
      isTrue: false,
      explanation:
          'There are 7 different authorities in Human Design. Your authority depends on which centers are defined in your chart and follows a specific hierarchy (Emotional > Sacral > Splenic > Ego > Self > Environmental > Lunar).',
    ));

    // Additional beginner questions
    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What should someone with Emotional Authority do before making a decision?',
      correctAnswer: 'Wait for emotional clarity over time',
      wrongAnswers: ['Decide immediately', 'Ask others for advice', 'Follow their first impulse'],
      explanation:
          'People with Emotional Authority need to ride their emotional wave and wait until they feel clear about a decision. There is no truth in the now for them - clarity comes over time.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Splenic Authority provides guidance through what means?',
      correctAnswer: 'Instant intuitive hits that come once and don\'t repeat',
      wrongAnswers: ['Emotional feelings', 'Logical analysis', 'Physical exhaustion'],
      explanation:
          'Splenic Authority provides instant, in-the-moment intuitive guidance. The Spleen speaks once, very quietly, and won\'t repeat itself. It\'s about survival and well-being.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      statement: 'Mental/Environmental Authority means you should make decisions based on logic.',
      isTrue: false,
      explanation:
          'Mental/Environmental Authority (also called Outer Authority) means the mind is not the decision-maker. These individuals need to talk things through with others and use their environment as a sounding board.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Self-Projected Authority uses which center for guidance?',
      correctAnswer: 'G Center (Identity)',
      wrongAnswers: ['Sacral Center', 'Head Center', 'Root Center'],
      explanation:
          'Self-Projected Authority relies on the G Center - hearing oneself speak about identity and direction. These individuals need to speak their truth out loud to find clarity.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateIntermediateQuestions() {
    final questions = <QuizQuestion>[];

    // Center-based authority questions
    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'If the Solar Plexus center is defined, what authority does a person have?',
      correctAnswer: 'Emotional Authority',
      wrongAnswers: ['Sacral Authority', 'Splenic Authority', 'Self-Projected Authority'],
      explanation:
          'A defined Solar Plexus center ALWAYS creates Emotional Authority, overriding all other potential authorities. This is because the emotional wave must be navigated before any decision can be made clearly.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Which authority is associated with Projectors who have no motors connected to the Throat?',
      correctAnswer: 'Self-Projected Authority',
      wrongAnswers: ['Ego Authority', 'Splenic Authority', 'Mental Authority'],
      explanation:
          'Self-Projected Authority occurs in Projectors who have the G Center connected to the Throat, but no motors. They make decisions by talking through their options and listening to what resonates as their truth.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.intermediate,
      statement: 'Splenic Authority makes decisions slowly over time.',
      isTrue: false,
      explanation:
          'Splenic Authority is instantaneous and operates in the NOW. The Spleen communicates once, in the moment, with a subtle intuitive hit. Unlike Emotional Authority, it does not require waiting.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.intermediate,
      statement: 'Emotional Authority requires waiting for clarity, even if you feel excited about something.',
      isTrue: true,
      explanation:
          'Emotional Authority operates in waves. Even positive excitement can be the high of the wave. True clarity comes from riding the complete wave over time and checking how you feel at different points.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Mental/Environmental Authority makes decisions by:',
      correctAnswer: 'Using environment and trusted others as sounding boards',
      wrongAnswers: [
        'Analyzing all options mentally',
        'Waiting for emotional clarity',
        'Following gut responses',
      ],
      explanation:
          'Mental (or Environmental) Authority is for Projectors with no inner authority below the Throat. They need to talk through decisions with trusted others and pay attention to the environment, not their own mental conclusions.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Ego/Heart Authority involves:',
      correctAnswer: 'Following what you want and can commit to willfully',
      wrongAnswers: [
        'Making logical decisions',
        'Waiting for invitations',
        'Trusting spontaneous intuition',
      ],
      explanation:
          'Ego/Heart Authority operates through willpower and desire. People with this authority make correct decisions by asking "Do I want this?" and "Can I commit to this?" - it\'s about following the heart\'s true desires.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateAdvancedQuestions() {
    final questions = <QuizQuestion>[];

    // Scenario-based questions
    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'A person has a defined Spleen but undefined Solar Plexus. What is their authority?',
      correctAnswer: 'Splenic Authority',
      wrongAnswers: ['Emotional Authority', 'Sacral Authority', 'Self-Projected Authority'],
      explanation:
          'Without a defined Solar Plexus, the next authority in the hierarchy is checked. With a defined Spleen, the person has Splenic Authority - they make decisions through in-the-moment intuitive awareness.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'What is the authority hierarchy in Human Design (from highest to lowest)?',
      correctAnswer: 'Emotional > Sacral > Splenic > Ego > Self > Environmental > Lunar',
      wrongAnswers: [
        'Sacral > Emotional > Splenic > Ego > Self > Lunar > Environmental',
        'Splenic > Emotional > Sacral > Self > Ego > Environmental > Lunar',
        'Emotional > Splenic > Sacral > Ego > Self > Environmental > Lunar',
      ],
      explanation:
          'The authority hierarchy determines which authority takes precedence. Emotional always comes first (defined Solar Plexus overrides all). Then Sacral for Generators, Splenic, Ego, Self-Projected, Environmental, and finally Lunar for Reflectors.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'A Manifestor with a defined Heart connected to the Throat and no defined Solar Plexus has which authority?',
      correctAnswer: 'Ego Authority',
      wrongAnswers: ['Emotional Authority', 'Splenic Authority', 'Self-Projected Authority'],
      explanation:
          'Without Emotional Authority (no defined Solar Plexus), this Manifestor\'s authority comes from the Heart/Ego center. They make decisions based on willpower and what they truly want and can commit to.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.advanced,
      statement:
          'Generators can have Emotional Authority if their Solar Plexus is defined.',
      isTrue: true,
      explanation:
          'Any type with a defined Solar Plexus has Emotional Authority. Even though Generators have a defined Sacral (which would give Sacral Authority), the Solar Plexus takes precedence in the authority hierarchy.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.advanced,
      statement:
          'Reflectors are the only type that can have Lunar Authority.',
      isTrue: true,
      explanation:
          'Lunar Authority is exclusive to Reflectors because they are the only type with no defined centers. Without any inner authority, they must use the Moon\'s cycle as their external guide for decision-making.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Why is "there is no truth in the now" the key phrase for Emotional Authority?',
      correctAnswer: 'Because the emotional wave distorts perception at any single moment',
      wrongAnswers: [
        'Because emotions are unreliable for decisions',
        'Because the Solar Plexus is not an awareness center',
        'Because emotional people cannot trust their feelings',
      ],
      explanation:
          'The Solar Plexus operates in waves - highs and lows over time. At any single moment, perception is colored by the current point on the wave. True clarity comes from experiencing the full wave and finding the average truth.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.authorities,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'A Projector has a defined Spleen and defined G Center connected to Throat, but no defined Solar Plexus or motors. What is their authority?',
      correctAnswer: 'Splenic Authority',
      wrongAnswers: ['Self-Projected Authority', 'Environmental Authority', 'Ego Authority'],
      explanation:
          'Following the authority hierarchy: no Solar Plexus rules out Emotional, no Sacral rules out Sacral Authority. The defined Spleen gives Splenic Authority, which takes precedence over Self-Projected (G-Throat connection).',
    ));

    return questions;
  }
}
