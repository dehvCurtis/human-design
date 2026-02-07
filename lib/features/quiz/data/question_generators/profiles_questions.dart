import '../../../../core/constants/human_design_constants.dart';
import '../../domain/models/quiz.dart';
import 'question_generator.dart';

/// Generator for Human Design Profile questions
class ProfilesQuestionGenerator extends QuestionGenerator {
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
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many profiles exist in Human Design?',
      correctAnswer: '12',
      wrongAnswers: ['6', '9', '64'],
      explanation:
          'There are 12 profiles in Human Design, created from combinations of 6 lines. Each profile combines a conscious (personality) line with an unconscious (design) line.',
    ));

    // Profile notation questions
    for (final profile in Profile.values) {
      final otherNames = Profile.values
          .where((p) => p != profile)
          .map((p) => p.name)
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.profiles,
        difficulty: QuizDifficulty.beginner,
        questionText: 'What profile has the notation "${profile.notation}"?',
        correctAnswer: profile.name,
        wrongAnswers: getRandomItems(otherNames, 3),
        explanation:
            'The ${profile.notation} profile is called ${profile.name}. The first number is the conscious (personality) line and the second is the unconscious (design) line.',
      ));
    }

    // Line theme questions
    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What is the 1st line theme in Human Design?',
      correctAnswer: 'Investigator - Foundation, introspection',
      wrongAnswers: [
        'Hermit - Natural talent, projection',
        'Martyr - Trial and error, adaptation',
        'Opportunist - Network, friendship',
      ],
      explanation:
          'The 1st line is the Investigator. People with this line need to deeply research and build a solid foundation of knowledge before feeling secure.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What is the 4th line theme in Human Design?',
      correctAnswer: 'Opportunist - Network, friendship',
      wrongAnswers: [
        'Heretic - Universalization, projection',
        'Martyr - Trial and error, adaptation',
        'Role Model - Administration, transition',
      ],
      explanation:
          'The 4th line is the Opportunist. This line is about networking, relationships, and opportunities that come through personal connections.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which line is called "The Hermit"?',
      correctAnswer: 'Line 2',
      wrongAnswers: ['Line 1', 'Line 3', 'Line 6'],
      explanation:
          'Line 2 is the Hermit. People with this line have natural talents they may not be aware of, and they need time alone. Others project onto them and call them out.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which line learns through trial and error?',
      correctAnswer: 'Line 3 - The Martyr',
      wrongAnswers: [
        'Line 1 - The Investigator',
        'Line 5 - The Heretic',
        'Line 6 - The Role Model',
      ],
      explanation:
          'Line 3, the Martyr, learns through experimentation and making mistakes. Their life path involves trying things, failing, adapting, and sharing what they learned.',
    ));

    // Additional beginner questions
    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What does the first number in a profile (e.g., the "1" in 1/3) represent?',
      correctAnswer: 'The conscious personality line',
      wrongAnswers: ['The unconscious design line', 'Your age', 'Your type'],
      explanation:
          'The first number in a profile represents the conscious line - the part of your profile you are aware of and identify with. This comes from your personality (black) calculation.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which line is known as the natural born teacher who attracts students?',
      correctAnswer: 'Line 4 - The Opportunist',
      wrongAnswers: ['Line 1 - The Investigator', 'Line 2 - The Hermit', 'Line 6 - The Role Model'],
      explanation:
          'Line 4, the Opportunist, builds influence through their network of relationships. They are natural networkers and teachers who attract opportunities through who they know.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      statement: 'Line 2 (The Hermit) loves being called out by others and enjoys being in the spotlight.',
      isTrue: false,
      explanation:
          'Line 2, the Hermit, prefers solitude and being left alone. While they have natural talents, they are often unaware of them and can feel uncomfortable when called out.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Line 6 goes through three distinct life phases. What is the final phase called?',
      correctAnswer: 'Role Model phase (after age 50)',
      wrongAnswers: ['Hermit phase', 'Investigator phase', 'Martyr phase'],
      explanation:
          'Line 6 (Role Model) goes through: 1) Trial and error phase (0-30), 2) Observer phase (30-50), and 3) Role Model phase (after 50) where they embody wisdom and become an example for others.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.beginner,
      questionText: 'Which line is associated with projection fields and being seen as a savior or problem-solver?',
      correctAnswer: 'Line 5 - The Heretic',
      wrongAnswers: ['Line 1 - The Investigator', 'Line 3 - The Martyr', 'Line 4 - The Opportunist'],
      explanation:
          'Line 5, the Heretic, carries a projection field where others project their expectations onto them. They are universalizers who can see practical solutions for the collective.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateIntermediateQuestions() {
    final questions = <QuizQuestion>[];

    // Which profiles share specific lines
    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Which profiles have the Hermit (2nd line) as the conscious line?',
      correctAnswer: '2/4 and 2/5',
      wrongAnswers: [
        '1/3 and 1/4',
        '3/5 and 3/6',
        '4/6 and 4/1',
      ],
      explanation:
          'The 2/4 (Hermit/Opportunist) and 2/5 (Hermit/Heretic) profiles both have the 2nd line as their conscious personality line.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Which profiles share the 5th line (Heretic) projection field?',
      correctAnswer: '2/5, 3/5, 5/1, and 5/2',
      wrongAnswers: [
        '1/4, 2/4, 4/1, and 4/6',
        '3/5, 3/6, 6/2, and 6/3',
        '1/3, 2/4, 3/5, and 4/6',
      ],
      explanation:
          'The 5th line appears in four profiles: 2/5 and 3/5 (as unconscious) and 5/1 and 5/2 (as conscious). All carry the heretic\'s projection field and universalizing quality.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      statement: 'The 6th line goes through three distinct phases in life.',
      isTrue: true,
      explanation:
          'The 6th line (Role Model) has three phases: 1) Living as a 3rd line until about age 28-30, learning through trial and error. 2) Withdrawing "onto the roof" to observe until around age 50. 3) Coming off the roof as an embodied role model.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      statement: 'In a profile notation like 3/5, the first number represents the unconscious design.',
      isTrue: false,
      explanation:
          'In profile notation, the first number is the CONSCIOUS (personality) line and the second number is the UNCONSCIOUS (design) line. So 3/5 means conscious Martyr, unconscious Heretic.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What makes the 5th line called "The Heretic"?',
      correctAnswer: 'They universalize and are projected upon as saviors or solutions',
      wrongAnswers: [
        'They reject traditional beliefs',
        'They prefer solitude over social interaction',
        'They investigate everything deeply',
      ],
      explanation:
          'The 5th line is the Heretic because they see universal truths and practical solutions. Others project savior qualities onto them, expecting them to solve problems. This projection field can be a burden if not managed.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Which profiles are considered "Right Angle" (personal destiny)?',
      correctAnswer: '1/3, 1/4, 2/4, 2/5, 3/5, 3/6, 4/6',
      wrongAnswers: [
        '4/1, 5/1, 5/2, 6/2, 6/3',
        '1/3, 2/4, 3/5, 4/6, 5/1, 6/2',
        '1/4, 2/5, 3/6, 4/1, 5/2, 6/3',
      ],
      explanation:
          'Right Angle profiles (1/3 through 4/6) are on a personal destiny path - their life is self-absorbed in the sense that they are here to work out their own karma. They are not designed to interact deeply with strangers.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'The 4/1 profile is unique because it:',
      correctAnswer: 'Is a fixed Juxtaposition profile with one geometry',
      wrongAnswers: [
        'Has the most powerful networking ability',
        'Can switch between Right Angle and Left Angle',
        'Is the most common profile',
      ],
      explanation:
          'The 4/1 (Opportunist/Investigator) is the Juxtaposition profile - neither Right Angle nor Left Angle. It represents a fixed fate, a very specific life path that acts as a bridge.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'Which profiles are "Left Angle" (transpersonal karma)?',
      correctAnswer: '5/1, 5/2, 6/2, 6/3',
      wrongAnswers: [
        '1/3, 1/4, 2/4, 2/5',
        '3/5, 3/6, 4/6, 4/1',
        '2/5, 3/5, 5/1, 6/2',
      ],
      explanation:
          'Left Angle profiles (5/1, 5/2, 6/2, 6/3) have transpersonal karma - they are here to interact with and impact others. Their destiny is fulfilled through relationships and meeting the right people.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateAdvancedQuestions() {
    final questions = <QuizQuestion>[];

    // Complex profile calculations
    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'If someone\'s conscious Sun is in Line 3 and unconscious Sun is in Line 6, what is their profile?',
      correctAnswer: '3/6 Martyr/Role Model',
      wrongAnswers: [
        '6/3 Role Model/Martyr',
        '3/5 Martyr/Heretic',
        '6/2 Role Model/Hermit',
      ],
      explanation:
          'The profile is determined by the conscious Sun line (first number) and unconscious Sun line (second number). Conscious Line 3 and unconscious Line 6 creates the 3/6 profile.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'What is the relationship between the 1st and 4th lines in the hexagram structure?',
      correctAnswer: 'They form the foundation of the lower and upper trigrams respectively',
      wrongAnswers: [
        'They are opposing forces in the hexagram',
        'They both represent investigative qualities',
        'They have no structural relationship',
      ],
      explanation:
          'The hexagram has 6 lines divided into two trigrams. Line 1 is the foundation of the lower trigram (personal/internal) and Line 4 is the foundation of the upper trigram (interpersonal/external). This is why 1-4 harmonics resonate.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Why do 5th line profiles often experience "burning of the witch" syndrome?',
      correctAnswer: 'Because projections create unrealistic expectations that cannot be met',
      wrongAnswers: [
        'Because they are naturally rebellious',
        'Because they often fail at their tasks',
        'Because they prefer isolation over community',
      ],
      explanation:
          'The 5th line carries a strong projection field - others see them as potential saviors or solutions. When these projections aren\'t met, disappointment turns to blame. The "hero to zero" experience requires 5th lines to manage their reputation carefully.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.advanced,
      statement:
          'A 6th line person experiences the trial and error of the 3rd line during their first 30 years.',
      isTrue: true,
      explanation:
          'The first phase of the 6th line (approximately birth to age 28-30) is lived as if they were a 3rd line - learning through trial and error, making mistakes, and experiencing life directly. This creates the foundation for their later role model phase.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.advanced,
      statement:
          'The conscious line in a profile is what others see about you.',
      isTrue: true,
      explanation:
          'The conscious (personality) line is what you identify with and what others can observe about you. The unconscious (design) line operates more subtly - you may not be aware of it, but it influences your behavior and is often more visible to others than to yourself.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'What is the significance of "harmony" and "disharmony" between profile lines?',
      correctAnswer: 'Harmonious lines (1-4, 2-5, 3-6) naturally support each other',
      wrongAnswers: [
        'Disharmonious profiles are inherently difficult',
        'Harmony means the lines are identical',
        'It determines which type you are',
      ],
      explanation:
          'Profile lines have harmonic relationships: 1-4, 2-5, and 3-6 naturally support each other (e.g., investigating supports networking). Disharmonious profiles (like 1/3 or 4/1) create internal tension that drives growth.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'A 2/4 profile is often described as someone who:',
      correctAnswer: 'Has natural talents (2) that are called out through their network (4)',
      wrongAnswers: [
        'Needs to deeply investigate (1) before networking (4)',
        'Learns through trial and error (3) then teaches (6)',
        'Projects solutions (5) after investigating foundations (1)',
      ],
      explanation:
          'The 2/4 Hermit/Opportunist has natural talents they may not recognize (2nd line) and a strong network that calls them out (4th line). Their gifts emerge through relationships, not from self-promotion.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.profiles,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Why is the 4/6 profile considered a bridge between the lower and upper trigrams?',
      correctAnswer: 'The 4th line is the foundation of the upper trigram while 6th line transcends both',
      wrongAnswers: [
        'Because 4+6=10, a complete cycle',
        'Because both lines are externally focused',
        'Because it\'s the last Right Angle profile',
      ],
      explanation:
          'The 4/6 (Opportunist/Role Model) bridges the trigrams: the 4th line grounds the upper/external trigram through networking, while the 6th line goes through all three phases (3rd line trial, roof observation, role model embodiment), transcending the hexagram structure.',
    ));

    return questions;
  }
}
