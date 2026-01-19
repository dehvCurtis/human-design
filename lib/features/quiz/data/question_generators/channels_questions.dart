import '../../../../core/constants/human_design_constants.dart';
import '../../domain/models/quiz.dart';
import 'question_generator.dart';

/// Generator for Human Design Channel questions
class ChannelsQuestionGenerator extends QuestionGenerator {
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

    // Basic channel count
    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.beginner,
      questionText: 'How many channels are there in the Human Design bodygraph?',
      correctAnswer: '36',
      wrongAnswers: ['32', '64', '48'],
      explanation:
          'There are 36 channels in the Human Design bodygraph. Each channel connects two centers and is formed when both gates at each end are defined.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.beginner,
      questionText: 'What creates a defined channel?',
      correctAnswer: 'Both gates on either end must be defined',
      wrongAnswers: [
        'Just one gate needs to be defined',
        'The centers must be defined',
        'The channel itself must be defined by transit',
      ],
      explanation:
          'A channel is only defined when BOTH gates that form it are activated. One gate from conscious activations and one from unconscious, or both from the same side.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.beginner,
      statement: 'A defined channel automatically defines both centers it connects.',
      isTrue: true,
      explanation:
          'When a channel is defined (both gates active), it creates a flow of energy that defines both centers at either end. This is how definition spreads in a chart.',
    ));

    // Channel name questions
    final selectedChannels = getRandomItems(channels, 10);
    for (final channel in selectedChannels) {
      final otherNames = channels
          .where((c) => c.id != channel.id)
          .map((c) => c.name)
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.channels,
        difficulty: QuizDifficulty.beginner,
        questionText: 'What is the Channel ${channel.gate1}-${channel.gate2} called?',
        correctAnswer: channel.name,
        wrongAnswers: getRandomItems(otherNames, 3),
        explanation:
            'The Channel ${channel.gate1}-${channel.gate2} is called the Channel of ${channel.name}. It is a ${channel.type} channel.',
      ));
    }

    return questions;
  }

  List<QuizQuestion> _generateIntermediateQuestions() {
    final questions = <QuizQuestion>[];

    // Channel gate identification
    final selectedChannels = getRandomItems(channels, 12);
    for (final channel in selectedChannels) {
      final otherChannelGates = channels
          .where((c) => c.id != channel.id)
          .map((c) => '${c.gate1}-${c.gate2}')
          .toList();

      questions.add(createMultipleChoice(
        category: QuizCategory.channels,
        difficulty: QuizDifficulty.intermediate,
        questionText: 'The Channel of ${channel.name} connects which gates?',
        correctAnswer: '${channel.gate1}-${channel.gate2}',
        wrongAnswers: getRandomItems(otherChannelGates, 3),
        explanation:
            'The Channel of ${channel.name} (${channel.gate1}-${channel.gate2}) is part of the ${channel.type} circuit.',
      ));
    }

    // Circuit type questions
    for (final circuitType in ['Individual', 'Collective', 'Tribal']) {
      final channelsInCircuit = channels.where((c) => c.type == circuitType).length;

      questions.add(createMultipleChoice(
        category: QuizCategory.channels,
        difficulty: QuizDifficulty.intermediate,
        questionText: 'Approximately how many channels belong to the $circuitType circuit?',
        correctAnswer: _getApproximateCount(channelsInCircuit),
        wrongAnswers: _getWrongApproximates(channelsInCircuit),
        explanation:
            'The $circuitType circuit contains $channelsInCircuit channels. Each circuit has a distinct theme and way of operating.',
      ));
    }

    // Circuit themes
    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What is the primary theme of Individual circuit channels?',
      correctAnswer: 'Mutation and unique individual expression',
      wrongAnswers: [
        'Sharing knowledge with others',
        'Supporting and nurturing family/tribe',
        'Survival of the community',
      ],
      explanation:
          'Individual circuit channels carry energy for mutation and unique self-expression. They bring new things into the world that weren\'t there before.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'What is the primary theme of Tribal circuit channels?',
      correctAnswer: 'Support, resources, and community bonds',
      wrongAnswers: [
        'Abstract thinking and experience',
        'Individual creativity and mutation',
        'Logical understanding and patterns',
      ],
      explanation:
          'Tribal circuit channels focus on support systems, resources, bargains, and maintaining community bonds. They\'re about taking care of "our people."',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.intermediate,
      questionText: 'The Collective circuit is divided into which two sub-circuits?',
      correctAnswer: 'Logic (Understanding) and Abstract (Sensing)',
      wrongAnswers: [
        'Thinking and Feeling',
        'Past and Future',
        'Inner and Outer',
      ],
      explanation:
          'The Collective circuit has two parts: Logic (Understanding) which works with patterns and the future, and Abstract (Sensing) which processes through experience and the past.',
    ));

    return questions;
  }

  List<QuizQuestion> _generateAdvancedQuestions() {
    final questions = <QuizQuestion>[];

    // Center connection questions
    final selectedChannels = getRandomItems(channels, 8);
    for (final channel in selectedChannels) {
      final centersKey = channel.id;
      final centersList = channelCenters[centersKey];
      if (centersList != null && centersList.length == 2) {
        final correctCenters = '${centersList[0].displayName} and ${centersList[1].displayName}';
        final otherCombos = <String>[
          'Throat and Sacral',
          'G Center and Root',
          'Head and Solar Plexus',
          'Spleen and Heart',
          'Ajna and Root',
          'Solar Plexus and Sacral',
        ].where((combo) => combo != correctCenters).toList();

        questions.add(createMultipleChoice(
          category: QuizCategory.channels,
          difficulty: QuizDifficulty.advanced,
          questionText:
              'The Channel of ${channel.name} (${channel.gate1}-${channel.gate2}) connects which centers?',
          correctAnswer: correctCenters,
          wrongAnswers: getRandomItems(otherCombos, 3),
          explanation:
              'Channel ${channel.gate1}-${channel.gate2} (${channel.name}) connects the ${centersList[0].displayName} to the ${centersList[1].displayName}.',
        ));
      }
    }

    // Integration channel questions
    final integrationChannels = channels.where((c) => c.type == 'Integration').toList();
    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.advanced,
      questionText: 'How many Integration channels are there?',
      correctAnswer: integrationChannels.length.toString(),
      wrongAnswers: ['2', '6', '8'],
      explanation:
          'There are ${integrationChannels.length} Integration channels. They connect to Gate 10 (Behavior of Self) and are about self-empowerment and survival.',
    ));

    questions.add(createTrueFalse(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.advanced,
      statement:
          'All Integration channels connect to Gate 10 (Behavior of Self).',
      isTrue: true,
      explanation:
          'The Integration channels (10-20, 10-34, 10-57, 20-34, 20-57, 34-57) all involve Gates 10, 20, 34, or 57, centered around self-empowerment and survival instincts.',
    ));

    // Format/manifestation channels
    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Which channel is called the "Channel of Charisma" and creates Manifesting Generator energy?',
      correctAnswer: '20-34',
      wrongAnswers: ['12-22', '1-8', '21-45'],
      explanation:
          'Channel 20-34 (Charisma) connects the Throat to the Sacral directly. When defined, it creates a Manifesting Generator who can respond and act in the moment.',
    ));

    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.advanced,
      questionText: 'Which channel connects the Head to the Ajna and is about logical questioning?',
      correctAnswer: '63-4 (Logic)',
      wrongAnswers: ['64-47 (Abstraction)', '61-24 (Awareness)', '11-56 (Curiosity)'],
      explanation:
          'Channel 63-4 is the Channel of Logic, connecting Head pressure (63: Doubt/After Completion) to Ajna conceptualization (4: Formulization/Mental Solutions).',
    ));

    // Electromagnetic connections
    questions.add(createTrueFalse(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.advanced,
      statement:
          'An electromagnetic connection occurs when two people each have one gate of a channel.',
      isTrue: true,
      explanation:
          'When person A has one gate and person B has the other gate of the same channel, they complete each other\'s channel. This creates attraction and a new defined channel in their composite.',
    ));

    // Compromise channels
    questions.add(createTrueFalse(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.advanced,
      statement:
          'A compromise (companionship) channel occurs when both people have the same channel defined.',
      isTrue: true,
      explanation:
          'When both people have the same channel defined, it\'s a compromise or companionship connection. They share the same energy but may have different expressions of it.',
    ));

    // Generator channels
    questions.add(createMultipleChoice(
      category: QuizCategory.channels,
      difficulty: QuizDifficulty.advanced,
      questionText:
          'Which Sacral channels, when defined alone, create a pure Generator (not Manifesting Generator)?',
      correctAnswer: 'Any Sacral channel NOT connecting to the Throat',
      wrongAnswers: [
        'Only channel 5-15 (Rhythm)',
        'Any channel connecting Sacral to Root',
        'The 20-34 Channel of Charisma',
      ],
      explanation:
          'A pure Generator has Sacral defined but no motor connected to Throat. Channels like 5-15, 2-14, 29-46 create Generator energy because they don\'t reach the Throat directly.',
    ));

    return questions;
  }

  String _getApproximateCount(int actual) {
    if (actual <= 5) return '3-5';
    if (actual <= 10) return '8-10';
    return '12-14';
  }

  List<String> _getWrongApproximates(int actual) {
    final options = ['2-4', '5-7', '8-10', '11-14', '15-18', '20-24'];
    final correct = _getApproximateCount(actual);
    return options.where((o) => o != correct).take(3).toList();
  }
}
