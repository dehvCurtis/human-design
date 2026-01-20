import '../../../core/constants/human_design_constants.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';

/// Connection types between two people's charts
enum ChannelConnectionType {
  /// Both people complete a channel together (Person A has gate1, Person B has gate2)
  /// Creates intense attraction and magnetism
  electromagnetic('Electromagnetic', 'Intense attraction - you complete each other'),

  /// Both people have the same full channel
  /// Creates comfort, stability, and shared understanding
  companionship('Companionship', 'Comfort and stability - shared understanding'),

  /// One person has the full channel, the other has neither gate
  /// One teaches/conditions the other in this energy
  dominance('Dominance', 'One teaches/conditions the other'),

  /// One person has the full channel, the other has only one gate
  /// Creates natural tension that requires awareness
  compromise('Compromise', 'Natural tension - requires awareness');

  const ChannelConnectionType(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Represents a channel connection between two people
class ChannelConnection {
  const ChannelConnection({
    required this.channelData,
    required this.connectionType,
    required this.person1Name,
    required this.person2Name,
    this.person1Gates = const {},
    this.person2Gates = const {},
  });

  final ChannelData channelData;
  final ChannelConnectionType connectionType;
  final String person1Name;
  final String person2Name;
  final Set<int> person1Gates; // Which gates person1 has for this channel
  final Set<int> person2Gates; // Which gates person2 has for this channel

  String get channelId => '${channelData.gate1}-${channelData.gate2}';
  String get channelName => channelData.name;
}

/// Result of a composite chart analysis
class CompositeResult {
  const CompositeResult({
    required this.person1,
    required this.person2,
    required this.electromagneticChannels,
    required this.companionshipChannels,
    required this.dominanceChannels,
    required this.compromiseChannels,
    required this.definedCentersCount,
    required this.undefinedCentersCount,
    required this.combinedDefinedCenters,
    required this.connectionTheme,
    required this.compatibilityScore,
  });

  final HumanDesignChart person1;
  final HumanDesignChart person2;
  final List<ChannelConnection> electromagneticChannels;
  final List<ChannelConnection> companionshipChannels;
  final List<ChannelConnection> dominanceChannels;
  final List<ChannelConnection> compromiseChannels;
  final int definedCentersCount;
  final int undefinedCentersCount;
  final Set<HumanDesignCenter> combinedDefinedCenters;
  final String connectionTheme; // e.g., "5-4"
  final int compatibilityScore; // 0-100

  /// Total number of channel connections
  int get totalConnections =>
      electromagneticChannels.length +
      companionshipChannels.length +
      dominanceChannels.length +
      compromiseChannels.length;

  /// Whether there are any connections
  bool get hasConnections => totalConnections > 0;
}

/// Calculator for composite (relationship) chart analysis
class CompositeCalculator {
  /// Calculate the composite chart for two people
  CompositeResult calculate(HumanDesignChart chart1, HumanDesignChart chart2) {
    // Get all gates from both charts
    final person1Gates = chart1.allGates;
    final person2Gates = chart2.allGates;

    // Categorize channel connections
    final electromagneticChannels = <ChannelConnection>[];
    final companionshipChannels = <ChannelConnection>[];
    final dominanceChannels = <ChannelConnection>[];
    final compromiseChannels = <ChannelConnection>[];

    for (final channel in channels) {
      final connectionType = _determineConnectionType(
        channel,
        person1Gates,
        person2Gates,
      );

      if (connectionType != null) {
        final connection = ChannelConnection(
          channelData: channel,
          connectionType: connectionType,
          person1Name: chart1.name,
          person2Name: chart2.name,
          person1Gates: _getChannelGates(channel, person1Gates),
          person2Gates: _getChannelGates(channel, person2Gates),
        );

        switch (connectionType) {
          case ChannelConnectionType.electromagnetic:
            electromagneticChannels.add(connection);
            break;
          case ChannelConnectionType.companionship:
            companionshipChannels.add(connection);
            break;
          case ChannelConnectionType.dominance:
            dominanceChannels.add(connection);
            break;
          case ChannelConnectionType.compromise:
            compromiseChannels.add(connection);
            break;
        }
      }
    }

    // Calculate combined defined centers
    final combinedGates = {...person1Gates, ...person2Gates};
    final combinedChannels = DegreeToGateMapper.findActiveChannels(
      combinedGates,
      <int>{},
    );
    final combinedDefinedCenters = DegreeToGateMapper.findDefinedCenters(combinedChannels);

    final definedCount = combinedDefinedCenters.length;
    final undefinedCount = 9 - definedCount;
    final connectionTheme = '$definedCount-$undefinedCount';

    // Calculate compatibility score
    final compatibilityScore = _calculateCompatibilityScore(
      electromagneticChannels.length,
      companionshipChannels.length,
      dominanceChannels.length,
      compromiseChannels.length,
      definedCount,
    );

    return CompositeResult(
      person1: chart1,
      person2: chart2,
      electromagneticChannels: electromagneticChannels,
      companionshipChannels: companionshipChannels,
      dominanceChannels: dominanceChannels,
      compromiseChannels: compromiseChannels,
      definedCentersCount: definedCount,
      undefinedCentersCount: undefinedCount,
      combinedDefinedCenters: combinedDefinedCenters,
      connectionTheme: connectionTheme,
      compatibilityScore: compatibilityScore,
    );
  }

  /// Determine the connection type for a channel between two people
  ChannelConnectionType? _determineConnectionType(
    ChannelData channel,
    Set<int> person1Gates,
    Set<int> person2Gates,
  ) {
    final p1HasGate1 = person1Gates.contains(channel.gate1);
    final p1HasGate2 = person1Gates.contains(channel.gate2);
    final p2HasGate1 = person2Gates.contains(channel.gate1);
    final p2HasGate2 = person2Gates.contains(channel.gate2);

    final p1HasChannel = p1HasGate1 && p1HasGate2;
    final p2HasChannel = p2HasGate1 && p2HasGate2;

    // Companionship: Both have the full channel
    if (p1HasChannel && p2HasChannel) {
      return ChannelConnectionType.companionship;
    }

    // Electromagnetic: Each person contributes exactly one gate to complete the channel
    // Person 1 has gate1 only, Person 2 has gate2 only (or vice versa)
    if ((p1HasGate1 && !p1HasGate2 && !p2HasGate1 && p2HasGate2) ||
        (p1HasGate2 && !p1HasGate1 && !p2HasGate2 && p2HasGate1)) {
      return ChannelConnectionType.electromagnetic;
    }

    // Dominance: One has full channel, other has neither gate
    if (p1HasChannel && !p2HasGate1 && !p2HasGate2) {
      return ChannelConnectionType.dominance;
    }
    if (p2HasChannel && !p1HasGate1 && !p1HasGate2) {
      return ChannelConnectionType.dominance;
    }

    // Compromise: One has full channel, other has only one gate
    if (p1HasChannel && (p2HasGate1 != p2HasGate2)) {
      return ChannelConnectionType.compromise;
    }
    if (p2HasChannel && (p1HasGate1 != p1HasGate2)) {
      return ChannelConnectionType.compromise;
    }

    // No significant connection
    return null;
  }

  /// Get which gates from a channel a person has
  Set<int> _getChannelGates(ChannelData channel, Set<int> personGates) {
    final result = <int>{};
    if (personGates.contains(channel.gate1)) result.add(channel.gate1);
    if (personGates.contains(channel.gate2)) result.add(channel.gate2);
    return result;
  }

  /// Calculate overall compatibility score (0-100)
  int _calculateCompatibilityScore(
    int electromagneticCount,
    int companionshipCount,
    int dominanceCount,
    int compromiseCount,
    int definedCentersCount,
  ) {
    int score = 0;

    // Electromagnetic channels are highly valued (attraction factor)
    // Max ~30 points from electromagnetic (5 channels * 6 points)
    score += electromagneticCount * 6;

    // Companionship channels show shared understanding
    // Max ~25 points from companionship (5 channels * 5 points)
    score += companionshipCount * 5;

    // Dominance channels can be positive (learning) but also challenging
    // Moderate points (3 channels * 3 points = 9 points typical)
    score += dominanceCount * 3;

    // Compromise channels add some value but indicate friction areas
    // Lower points (2 channels * 2 points = 4 points typical)
    score += compromiseCount * 2;

    // Defined centers together (bonding)
    // Higher defined center count means more bonded (good for intimacy)
    // But also can feel restricting - balance at 5-6 is often ideal
    // Award points for having 4-7 defined centers (the sweet spot)
    if (definedCentersCount >= 4 && definedCentersCount <= 7) {
      score += 15;
    } else if (definedCentersCount >= 3 && definedCentersCount <= 8) {
      score += 10;
    } else {
      score += 5;
    }

    // Base points for having any connection
    if (electromagneticCount + companionshipCount + dominanceCount + compromiseCount > 0) {
      score += 10;
    }

    return score.clamp(0, 100);
  }
}
