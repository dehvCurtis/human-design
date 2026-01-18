import 'package:uuid/uuid.dart';

import '../../../../core/constants/human_design_constants.dart';
import '../../../ephemeris/data/ephemeris_service.dart';
import '../../../ephemeris/mappers/degree_to_gate_mapper.dart';
import '../models/human_design_chart.dart';

/// Use case for calculating a complete Human Design chart
class CalculateChartUseCase {
  CalculateChartUseCase({
    required EphemerisService ephemerisService,
  }) : _ephemerisService = ephemerisService;

  final EphemerisService _ephemerisService;
  final _uuid = const Uuid();

  /// Calculate a complete chart from birth data
  Future<HumanDesignChart> execute({
    required String userId,
    required String name,
    required DateTime birthDateTime,
    required BirthLocation birthLocation,
    required String timezone,
  }) async {
    // Calculate planetary activations
    final activations = _ephemerisService.calculateChartActivations(birthDateTime);

    // Get active channels and defined centers
    final activeChannels = activations.activeChannels;
    final definedCenters = activations.definedCenters;
    final undefinedCenters = HumanDesignCenter.values.toSet().difference(definedCenters);

    // Calculate Type
    final type = _calculateType(definedCenters, activeChannels);

    // Calculate Authority
    final authority = _calculateAuthority(type, definedCenters);

    // Calculate Profile
    final profile = activations.profile ?? Profile.oneThree;

    // Calculate Definition
    final definition = _calculateDefinition(definedCenters, activeChannels);

    return HumanDesignChart(
      id: _uuid.v4(),
      userId: userId,
      name: name,
      birthDateTime: birthDateTime,
      birthLocation: birthLocation,
      timezone: timezone,
      type: type,
      strategy: type.strategy,
      authority: authority,
      profile: profile,
      definition: definition,
      definedCenters: definedCenters,
      undefinedCenters: undefinedCenters,
      activeChannels: activeChannels,
      consciousActivations: activations.consciousActivations,
      unconsciousActivations: activations.unconsciousActivations,
      createdAt: DateTime.now(),
    );
  }

  /// Determine the Human Design Type based on center definitions
  HumanDesignType _calculateType(
    Set<HumanDesignCenter> definedCenters,
    List<ChannelActivation> activeChannels,
  ) {
    final hasSacral = definedCenters.contains(HumanDesignCenter.sacral);

    // Check for motor-to-throat connection
    final hasMotorToThroat = _hasMotorToThroatConnection(
      definedCenters,
      activeChannels,
    );

    // Reflector: No defined centers
    if (definedCenters.isEmpty) {
      return HumanDesignType.reflector;
    }

    // Manifestor: Motor to Throat, no Sacral
    if (!hasSacral && hasMotorToThroat) {
      return HumanDesignType.manifestor;
    }

    // Generator or Manifesting Generator: Defined Sacral
    if (hasSacral) {
      // Manifesting Generator: Sacral defined AND motor to throat
      if (hasMotorToThroat) {
        return HumanDesignType.manifestingGenerator;
      }
      return HumanDesignType.generator;
    }

    // Projector: No Sacral, no Motor to Throat
    return HumanDesignType.projector;
  }

  /// Check if there's a direct motor-to-throat connection
  bool _hasMotorToThroatConnection(
    Set<HumanDesignCenter> definedCenters,
    List<ChannelActivation> activeChannels,
  ) {
    if (!definedCenters.contains(HumanDesignCenter.throat)) {
      return false;
    }

    // Motors are: Sacral, Heart, Solar Plexus, Root
    final motors = {HumanDesignCenter.sacral, HumanDesignCenter.heart, HumanDesignCenter.solarPlexus, HumanDesignCenter.root};

    // Build a graph of center connections
    final connections = <HumanDesignCenter, Set<HumanDesignCenter>>{};
    for (final center in HumanDesignCenter.values) {
      connections[center] = {};
    }

    for (final channelActivation in activeChannels) {
      final channelId = channelActivation.channel.id;
      final centersForChannel = channelCenters[channelId];
      if (centersForChannel != null && centersForChannel.length == 2) {
        connections[centersForChannel[0]]!.add(centersForChannel[1]);
        connections[centersForChannel[1]]!.add(centersForChannel[0]);
      }
    }

    // BFS from throat to see if we can reach any motor
    final visited = <HumanDesignCenter>{};
    final queue = <HumanDesignCenter>[HumanDesignCenter.throat];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      if (visited.contains(current)) continue;
      visited.add(current);

      // Check if we've reached a motor (other than through undefined centers)
      if (motors.contains(current) && definedCenters.contains(current)) {
        return true;
      }

      // Add connected centers
      for (final next in connections[current]!) {
        if (!visited.contains(next) && definedCenters.contains(next)) {
          queue.add(next);
        }
      }
    }

    return false;
  }

  /// Determine Authority based on Type and defined centers
  Authority _calculateAuthority(
    HumanDesignType type,
    Set<HumanDesignCenter> definedCenters,
  ) {
    // Reflectors have Lunar Authority
    if (type == HumanDesignType.reflector) {
      return Authority.lunar;
    }

    // Authority hierarchy (in order of precedence)
    // 1. Emotional (Solar Plexus)
    if (definedCenters.contains(HumanDesignCenter.solarPlexus)) {
      return Authority.emotional;
    }

    // 2. Sacral (for Generators/MGs only)
    if (definedCenters.contains(HumanDesignCenter.sacral) &&
        (type == HumanDesignType.generator ||
            type == HumanDesignType.manifestingGenerator)) {
      return Authority.sacral;
    }

    // 3. Splenic
    if (definedCenters.contains(HumanDesignCenter.spleen)) {
      return Authority.splenic;
    }

    // 4. Ego/Heart (Manifestors and Projectors)
    if (definedCenters.contains(HumanDesignCenter.heart)) {
      return Authority.ego;
    }

    // 5. Self-Projected (Projectors with G to Throat)
    if (type == HumanDesignType.projector &&
        definedCenters.contains(HumanDesignCenter.g) &&
        definedCenters.contains(HumanDesignCenter.throat)) {
      return Authority.self;
    }

    // 6. Mental/Environmental (Mental Projectors)
    if (type == HumanDesignType.projector) {
      return Authority.environment;
    }

    // Default fallback (shouldn't normally reach here)
    return Authority.environment;
  }

  /// Calculate Definition type based on how centers are connected
  Definition _calculateDefinition(
    Set<HumanDesignCenter> definedCenters,
    List<ChannelActivation> activeChannels,
  ) {
    if (definedCenters.isEmpty) {
      return Definition.none;
    }

    // Build adjacency graph
    final connections = <HumanDesignCenter, Set<HumanDesignCenter>>{};
    for (final center in definedCenters) {
      connections[center] = {};
    }

    for (final channelActivation in activeChannels) {
      final channelId = channelActivation.channel.id;
      final centersForChannel = channelCenters[channelId];
      if (centersForChannel != null && centersForChannel.length == 2) {
        final c1 = centersForChannel[0];
        final c2 = centersForChannel[1];
        if (definedCenters.contains(c1) && definedCenters.contains(c2)) {
          connections[c1]!.add(c2);
          connections[c2]!.add(c1);
        }
      }
    }

    // Count connected components using BFS
    final visited = <HumanDesignCenter>{};
    int componentCount = 0;

    for (final center in definedCenters) {
      if (visited.contains(center)) continue;

      // BFS from this center
      componentCount++;
      final queue = <HumanDesignCenter>[center];

      while (queue.isNotEmpty) {
        final current = queue.removeAt(0);
        if (visited.contains(current)) continue;
        visited.add(current);

        for (final neighbor in connections[current]!) {
          if (!visited.contains(neighbor)) {
            queue.add(neighbor);
          }
        }
      }
    }

    // Map component count to definition type
    switch (componentCount) {
      case 0:
        return Definition.none;
      case 1:
        return Definition.single;
      case 2:
        return Definition.split;
      case 3:
        return Definition.tripleSplit;
      default:
        return Definition.quadrupleSplit;
    }
  }
}

/// Calculate a composite chart between two people
class CalculateCompositeChartUseCase {
  /// Calculate the composite (relationship) chart
  CompositeChart execute(HumanDesignChart chart1, HumanDesignChart chart2) {
    // Combine all gates from both charts
    final combinedGates = {...chart1.allGates, ...chart2.allGates};

    // Find electromagnetic channels (one gate from each person)
    final electromagneticChannels = <ChannelData>[];
    final companionshipChannels = <ChannelData>[];
    final dominanceChannels = <ChannelData>[];
    final compromiseChannels = <ChannelData>[];

    for (final channel in channels) {
      final person1HasGate1 = chart1.allGates.contains(channel.gate1);
      final person1HasGate2 = chart1.allGates.contains(channel.gate2);
      final person2HasGate1 = chart2.allGates.contains(channel.gate1);
      final person2HasGate2 = chart2.allGates.contains(channel.gate2);

      final gate1Active = person1HasGate1 || person2HasGate1;
      final gate2Active = person1HasGate2 || person2HasGate2;

      if (!gate1Active || !gate2Active) continue;

      // Electromagnetic: each person contributes one gate
      if ((person1HasGate1 && person2HasGate2 && !person1HasGate2 && !person2HasGate1) ||
          (person1HasGate2 && person2HasGate1 && !person1HasGate1 && !person2HasGate2)) {
        electromagneticChannels.add(channel);
      }
      // Companionship: both people have the complete channel
      else if (person1HasGate1 && person1HasGate2 && person2HasGate1 && person2HasGate2) {
        companionshipChannels.add(channel);
      }
      // Dominance: one person has complete channel, other doesn't
      else if ((person1HasGate1 && person1HasGate2 && !(person2HasGate1 && person2HasGate2)) ||
               (person2HasGate1 && person2HasGate2 && !(person1HasGate1 && person1HasGate2))) {
        dominanceChannels.add(channel);
      }
      // Compromise: partial overlap
      else {
        compromiseChannels.add(channel);
      }
    }

    // Calculate combined centers
    final combinedCenters = <HumanDesignCenter>{};
    for (final channel in [...electromagneticChannels, ...companionshipChannels,
                           ...dominanceChannels, ...compromiseChannels]) {
      final centersForChannel = channelCenters[channel.id];
      if (centersForChannel != null) {
        combinedCenters.addAll(centersForChannel);
      }
    }

    return CompositeChart(
      chart1: chart1,
      chart2: chart2,
      combinedGates: combinedGates,
      combinedCenters: combinedCenters,
      electromagneticChannels: electromagneticChannels,
      companionshipChannels: companionshipChannels,
      dominanceChannels: dominanceChannels,
      compromiseChannels: compromiseChannels,
    );
  }
}

/// Composite chart data for relationship analysis
class CompositeChart {
  const CompositeChart({
    required this.chart1,
    required this.chart2,
    required this.combinedGates,
    required this.combinedCenters,
    required this.electromagneticChannels,
    required this.companionshipChannels,
    required this.dominanceChannels,
    required this.compromiseChannels,
  });

  final HumanDesignChart chart1;
  final HumanDesignChart chart2;
  final Set<int> combinedGates;
  final Set<HumanDesignCenter> combinedCenters;
  final List<ChannelData> electromagneticChannels;
  final List<ChannelData> companionshipChannels;
  final List<ChannelData> dominanceChannels;
  final List<ChannelData> compromiseChannels;

  /// Total active channels in composite
  int get totalChannels =>
      electromagneticChannels.length +
      companionshipChannels.length +
      dominanceChannels.length +
      compromiseChannels.length;
}
