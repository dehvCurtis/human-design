import 'models/user_discovery.dart';

/// Service for calculating Human Design compatibility between users
class MatchingService {
  /// Calculate overall compatibility score between two users
  /// Returns a score from 0-100 based on type, profile, channels, and definition
  CompatibilityDetails calculateCompatibility({
    required String? userType,
    required String? userProfile,
    required List<int>? userGates,
    required List<String>? userDefinedCenters,
    required String? otherType,
    required String? otherProfile,
    required List<int>? otherGates,
    required List<String>? otherDefinedCenters,
  }) {
    final typeScore = _calculateTypeCompatibility(userType, otherType);
    final profileScore = _calculateProfileHarmonics(userProfile, otherProfile);
    final channelScore = _calculateChannelComplementarity(userGates, otherGates);
    final definitionScore = _calculateDefinitionBridging(
      userDefinedCenters,
      otherDefinedCenters,
    );

    return CompatibilityDetails(
      typeScore: typeScore.score,
      profileScore: profileScore.score,
      channelScore: channelScore.score,
      definitionScore: definitionScore.score,
      typeCompatibility: typeScore.description,
      profileHarmonics: profileScore.description,
      complementaryChannels: channelScore.channels,
      bridgingOpportunities: definitionScore.bridges,
    );
  }

  /// Type compatibility (0-25 points)
  /// Based on energy dynamics between types
  _TypeCompatibilityResult _calculateTypeCompatibility(
    String? userType,
    String? otherType,
  ) {
    if (userType == null || otherType == null) {
      return const _TypeCompatibilityResult(
        score: 12,
        description: 'Unknown compatibility',
      );
    }

    // Compatibility matrix based on HD principles
    final compatibility = _typeCompatibilityMatrix[userType]?[otherType];
    if (compatibility != null) return compatibility;

    // Default fallback
    return const _TypeCompatibilityResult(
      score: 15,
      description: 'Neutral energy dynamic',
    );
  }

  /// Profile harmonics (0-25 points)
  /// Based on profile line interactions
  _ProfileHarmonicsResult _calculateProfileHarmonics(
    String? userProfile,
    String? otherProfile,
  ) {
    if (userProfile == null || otherProfile == null) {
      return const _ProfileHarmonicsResult(
        score: 12,
        description: 'Unknown profile dynamic',
      );
    }

    // Extract lines from profiles (e.g., "1/3" -> [1, 3])
    final userLines = _parseProfile(userProfile);
    final otherLines = _parseProfile(otherProfile);

    if (userLines == null || otherLines == null) {
      return const _ProfileHarmonicsResult(
        score: 12,
        description: 'Could not determine profile lines',
      );
    }

    int score = 0;
    String description = '';

    // Harmonic resonance: matching lines create understanding
    final matchingLines = <int>{};
    for (final line in userLines) {
      if (otherLines.contains(line)) {
        matchingLines.add(line);
        score += 5;
      }
    }

    // Complementary dynamics
    final hasFirst = userLines.contains(1) || otherLines.contains(1);
    final hasSixth = userLines.contains(6) || otherLines.contains(6);
    final hasSecond = userLines.contains(2) || otherLines.contains(2);
    final hasFifth = userLines.contains(5) || otherLines.contains(5);
    final hasThird = userLines.contains(3) || otherLines.contains(3);
    final hasFourth = userLines.contains(4) || otherLines.contains(4);

    // 1-6 axis: Role model dynamic
    if (hasFirst && hasSixth) {
      score += 4;
      description = 'Role model dynamic - learning and wisdom exchange';
    }
    // 2-5 axis: Hermit and Heretic projection field
    else if (hasSecond && hasFifth) {
      score += 4;
      description = 'Projection field dynamic - natural calling and universalization';
    }
    // 3-4 axis: Transpersonal karma
    else if (hasThird && hasFourth) {
      score += 4;
      description = 'Transpersonal karma - trial and friendship bonds';
    }

    if (matchingLines.isNotEmpty && description.isEmpty) {
      description = 'Shared line ${matchingLines.join(", ")} resonance';
    }

    // Minimum baseline
    score = score.clamp(5, 25);

    return _ProfileHarmonicsResult(
      score: score,
      description: description.isEmpty ? 'Complementary profiles' : description,
    );
  }

  /// Channel complementarity (0-25 points)
  /// Based on electromagnetic channel potential
  _ChannelComplementarityResult _calculateChannelComplementarity(
    List<int>? userGates,
    List<int>? otherGates,
  ) {
    if (userGates == null || otherGates == null) {
      return const _ChannelComplementarityResult(
        score: 12,
        description: 'Unknown channel potential',
        channels: [],
      );
    }

    final complementaryChannels = <String>[];
    int score = 0;

    // Check for electromagnetic channels (one person has one gate, other has the other)
    for (final channel in _channelDefinitions) {
      final gate1 = channel.gate1;
      final gate2 = channel.gate2;

      final userHasGate1 = userGates.contains(gate1);
      final userHasGate2 = userGates.contains(gate2);
      final otherHasGate1 = otherGates.contains(gate1);
      final otherHasGate2 = otherGates.contains(gate2);

      // Electromagnetic: one has gate1, other has gate2
      if ((userHasGate1 && !userHasGate2 && otherHasGate2 && !otherHasGate1) ||
          (userHasGate2 && !userHasGate1 && otherHasGate1 && !otherHasGate2)) {
        complementaryChannels.add(channel.name);
        score += 3;
      }
    }

    // Cap the score at 25
    score = score.clamp(0, 25);

    String description;
    if (complementaryChannels.isEmpty) {
      description = 'No electromagnetic channels';
      score = 5; // Baseline score
    } else if (complementaryChannels.length == 1) {
      description = 'One electromagnetic channel - attraction potential';
    } else if (complementaryChannels.length <= 3) {
      description = 'Multiple electromagnetic channels - strong connection';
    } else {
      description = 'Many electromagnetic channels - deep energetic bond';
    }

    return _ChannelComplementarityResult(
      score: score,
      description: description,
      channels: complementaryChannels,
    );
  }

  /// Definition bridging (0-25 points)
  /// Based on how undefined centers can be bridged
  _DefinitionBridgingResult _calculateDefinitionBridging(
    List<String>? userDefinedCenters,
    List<String>? otherDefinedCenters,
  ) {
    if (userDefinedCenters == null || otherDefinedCenters == null) {
      return const _DefinitionBridgingResult(
        score: 12,
        description: 'Unknown definition potential',
        bridges: [],
      );
    }

    final allCenters = [
      'Head', 'Ajna', 'Throat', 'G', 'Heart', 'Sacral', 'Solar Plexus', 'Spleen', 'Root'
    ];

    final userDefined = userDefinedCenters.toSet();
    final otherDefined = otherDefinedCenters.toSet();

    final userUndefined = allCenters.where((c) => !userDefined.contains(c)).toSet();
    final otherUndefined = allCenters.where((c) => !otherDefined.contains(c)).toSet();

    final bridges = <String>[];
    int score = 0;

    // Centers user can bridge for other
    for (final center in userDefined) {
      if (otherUndefined.contains(center)) {
        bridges.add('You define their $center');
        score += 2;
      }
    }

    // Centers other can bridge for user
    for (final center in otherDefined) {
      if (userUndefined.contains(center)) {
        bridges.add('They define your $center');
        score += 2;
      }
    }

    // Check for compromise (both undefined in same center)
    final mutualUndefined = userUndefined.intersection(otherUndefined);
    if (mutualUndefined.isNotEmpty) {
      // Slight reduction for compromise potential
      score -= mutualUndefined.length;
    }

    score = score.clamp(5, 25);

    String description;
    if (bridges.isEmpty) {
      description = 'Similar definitions - independence maintained';
    } else if (bridges.length <= 4) {
      description = 'Some bridging potential - growth opportunities';
    } else {
      description = 'Strong bridging - significant mutual influence';
    }

    return _DefinitionBridgingResult(
      score: score,
      description: description,
      bridges: bridges,
    );
  }

  List<int>? _parseProfile(String profile) {
    final parts = profile.split('/');
    if (parts.length != 2) return null;
    final line1 = int.tryParse(parts[0]);
    final line2 = int.tryParse(parts[1]);
    if (line1 == null || line2 == null) return null;
    return [line1, line2];
  }

  // Type compatibility matrix
  static const Map<String, Map<String, _TypeCompatibilityResult>> _typeCompatibilityMatrix = {
    'Generator': {
      'Generator': _TypeCompatibilityResult(
        score: 20,
        description: 'Mutual satisfaction - sustainable energy exchange',
      ),
      'Manifesting Generator': _TypeCompatibilityResult(
        score: 22,
        description: 'Sacral resonance with added manifestation spark',
      ),
      'Projector': _TypeCompatibilityResult(
        score: 23,
        description: 'Excellent guidance potential - recognition and direction',
      ),
      'Manifestor': _TypeCompatibilityResult(
        score: 18,
        description: 'Energy support for initiations - needs clear communication',
      ),
      'Reflector': _TypeCompatibilityResult(
        score: 20,
        description: 'Health indicator - Reflector mirrors Generator state',
      ),
    },
    'Manifesting Generator': {
      'Generator': _TypeCompatibilityResult(
        score: 22,
        description: 'Sacral resonance with added manifestation spark',
      ),
      'Manifesting Generator': _TypeCompatibilityResult(
        score: 21,
        description: 'Dynamic multi-tasking pair - need patience with each other',
      ),
      'Projector': _TypeCompatibilityResult(
        score: 22,
        description: 'Guidance for efficient multi-tasking',
      ),
      'Manifestor': _TypeCompatibilityResult(
        score: 19,
        description: 'Shared manifestation capacity - coordination needed',
      ),
      'Reflector': _TypeCompatibilityResult(
        score: 20,
        description: 'Reflector shows true efficiency of MG energy',
      ),
    },
    'Projector': {
      'Generator': _TypeCompatibilityResult(
        score: 23,
        description: 'Excellent guidance potential - recognition and direction',
      ),
      'Manifesting Generator': _TypeCompatibilityResult(
        score: 22,
        description: 'Guidance for efficient multi-tasking',
      ),
      'Projector': _TypeCompatibilityResult(
        score: 18,
        description: 'Mutual recognition but limited energy exchange',
      ),
      'Manifestor': _TypeCompatibilityResult(
        score: 20,
        description: 'Can guide manifestation when invited',
      ),
      'Reflector': _TypeCompatibilityResult(
        score: 19,
        description: 'Reflector mirrors Projector wisdom',
      ),
    },
    'Manifestor': {
      'Generator': _TypeCompatibilityResult(
        score: 18,
        description: 'Energy support for initiations - needs clear communication',
      ),
      'Manifesting Generator': _TypeCompatibilityResult(
        score: 19,
        description: 'Shared manifestation capacity - coordination needed',
      ),
      'Projector': _TypeCompatibilityResult(
        score: 20,
        description: 'Can receive guidance when willing to be seen',
      ),
      'Manifestor': _TypeCompatibilityResult(
        score: 16,
        description: 'Two initiators - needs clear boundaries and informing',
      ),
      'Reflector': _TypeCompatibilityResult(
        score: 18,
        description: 'Reflector shows impact of Manifestor actions',
      ),
    },
    'Reflector': {
      'Generator': _TypeCompatibilityResult(
        score: 20,
        description: 'Health indicator - Reflector mirrors Generator state',
      ),
      'Manifesting Generator': _TypeCompatibilityResult(
        score: 20,
        description: 'Reflector shows true efficiency of MG energy',
      ),
      'Projector': _TypeCompatibilityResult(
        score: 19,
        description: 'Reflector mirrors Projector wisdom',
      ),
      'Manifestor': _TypeCompatibilityResult(
        score: 18,
        description: 'Reflector shows impact of Manifestor actions',
      ),
      'Reflector': _TypeCompatibilityResult(
        score: 15,
        description: 'Two mirrors - unique and rare connection',
      ),
    },
  };
}

// Helper classes for results
class _TypeCompatibilityResult {
  const _TypeCompatibilityResult({
    required this.score,
    required this.description,
  });

  final int score;
  final String description;
}

class _ProfileHarmonicsResult {
  const _ProfileHarmonicsResult({
    required this.score,
    required this.description,
  });

  final int score;
  final String description;
}

class _ChannelComplementarityResult {
  const _ChannelComplementarityResult({
    required this.score,
    required this.description,
    required this.channels,
  });

  final int score;
  final String description;
  final List<String> channels;
}

class _DefinitionBridgingResult {
  const _DefinitionBridgingResult({
    required this.score,
    required this.description,
    required this.bridges,
  });

  final int score;
  final String description;
  final List<String> bridges;
}

// Channel definitions for electromagnetic calculation
class _ChannelDefinition {
  const _ChannelDefinition(this.gate1, this.gate2, this.name);
  final int gate1;
  final int gate2;
  final String name;
}

const _channelDefinitions = [
  _ChannelDefinition(64, 47, 'Abstraction'),
  _ChannelDefinition(61, 24, 'Awareness'),
  _ChannelDefinition(63, 4, 'Logic'),
  _ChannelDefinition(17, 62, 'Acceptance'),
  _ChannelDefinition(43, 23, 'Structuring'),
  _ChannelDefinition(11, 56, 'Curiosity'),
  _ChannelDefinition(16, 48, 'Wavelength'),
  _ChannelDefinition(20, 57, 'Brainwave'),
  _ChannelDefinition(20, 34, 'Charisma'),
  _ChannelDefinition(20, 10, 'Awakening'),
  _ChannelDefinition(31, 7, 'Alpha'),
  _ChannelDefinition(8, 1, 'Inspiration'),
  _ChannelDefinition(33, 13, 'Prodigal'),
  _ChannelDefinition(35, 36, 'Transitoriness'),
  _ChannelDefinition(12, 22, 'Openness'),
  _ChannelDefinition(45, 21, 'Money'),
  _ChannelDefinition(25, 51, 'Initiation'),
  _ChannelDefinition(26, 44, 'Surrender'),
  _ChannelDefinition(40, 37, 'Community'),
  _ChannelDefinition(10, 34, 'Exploration'),
  _ChannelDefinition(10, 57, 'Perfected Form'),
  _ChannelDefinition(15, 5, 'Rhythm'),
  _ChannelDefinition(2, 14, 'Beat'),
  _ChannelDefinition(46, 29, 'Discovery'),
  _ChannelDefinition(59, 6, 'Intimacy'),
  _ChannelDefinition(27, 50, 'Preservation'),
  _ChannelDefinition(34, 57, 'Power'),
  _ChannelDefinition(9, 52, 'Concentration'),
  _ChannelDefinition(3, 60, 'Mutation'),
  _ChannelDefinition(42, 53, 'Maturation'),
  _ChannelDefinition(32, 54, 'Transformation'),
  _ChannelDefinition(28, 38, 'Struggle'),
  _ChannelDefinition(18, 58, 'Judgment'),
  _ChannelDefinition(19, 49, 'Synthesis'),
  _ChannelDefinition(39, 55, 'Emoting'),
  _ChannelDefinition(41, 30, 'Recognition'),
];
