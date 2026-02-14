import 'package:flutter_test/flutter_test.dart';
import 'package:human_design/core/constants/human_design_constants.dart';
import 'package:human_design/features/ephemeris/mappers/degree_to_gate_mapper.dart';

void main() {
  group('Type Calculation Tests', () {
    test('Reflector: No defined centers', () {
      final definedCenters = <HumanDesignCenter>{};
      final activeChannels = <ChannelActivation>[];

      final type = calculateType(definedCenters, activeChannels);

      expect(type, HumanDesignType.reflector);
    });

    test('Manifestor: Motor-to-Throat (Heart→Throat via channel 21-45), no Sacral', () {
      // Channel 21-45 connects Heart to Throat
      final channel2145 = ChannelData(gate1: 21, gate2: 45, name: 'Money', type: 'Tribal');
      final channelActivation = ChannelActivation(
        channel: channel2145,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.heart,
        HumanDesignCenter.throat,
      };
      final activeChannels = [channelActivation];

      final type = calculateType(definedCenters, activeChannels);

      expect(type, HumanDesignType.manifestor);
    });

    test('Generator: Sacral defined (via channel 3-60), no motor-to-throat', () {
      // Channel 3-60 connects Sacral to Root
      final channel360 = ChannelData(gate1: 3, gate2: 60, name: 'Mutation', type: 'Individual');
      final channelActivation = ChannelActivation(
        channel: channel360,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.sacral,
        HumanDesignCenter.root,
      };
      final activeChannels = [channelActivation];

      final type = calculateType(definedCenters, activeChannels);

      expect(type, HumanDesignType.generator);
    });

    test('Manifesting Generator: Sacral defined AND motor-to-throat (Sacral→Throat via 34-20)', () {
      // Channel 34-20 connects Sacral to Throat
      final channel3420 = ChannelData(gate1: 20, gate2: 34, name: 'Charisma', type: 'Individual');
      final channelActivation = ChannelActivation(
        channel: channel3420,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.sacral,
        HumanDesignCenter.throat,
      };
      final activeChannels = [channelActivation];

      final type = calculateType(definedCenters, activeChannels);

      expect(type, HumanDesignType.manifestingGenerator);
    });

    test('Projector: No Sacral, no motor-to-throat, but has centers (G+Throat via 1-8)', () {
      // Channel 1-8 connects G to Throat (not a motor)
      final channel18 = ChannelData(gate1: 1, gate2: 8, name: 'Inspiration', type: 'Individual');
      final channelActivation = ChannelActivation(
        channel: channel18,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.g,
        HumanDesignCenter.throat,
      };
      final activeChannels = [channelActivation];

      final type = calculateType(definedCenters, activeChannels);

      expect(type, HumanDesignType.projector);
    });

    test('Manifestor: Root-to-Throat connection (indirect motor-to-throat)', () {
      // Root → Solar Plexus → Throat (motors: Root, Solar Plexus)
      final channel3955 = ChannelData(gate1: 39, gate2: 55, name: 'Emoting', type: 'Individual');
      final channel1222 = ChannelData(gate1: 12, gate2: 22, name: 'Openness', type: 'Individual');

      final channelActivation1 = ChannelActivation(
        channel: channel3955,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final channelActivation2 = ChannelActivation(
        channel: channel1222,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.root,
        HumanDesignCenter.solarPlexus,
        HumanDesignCenter.throat,
      };
      final activeChannels = [channelActivation1, channelActivation2];

      final type = calculateType(definedCenters, activeChannels);

      expect(type, HumanDesignType.manifestor);
    });
  });

  group('Authority Calculation Tests', () {
    test('Emotional: Solar Plexus defined (highest priority)', () {
      final definedCenters = {
        HumanDesignCenter.solarPlexus,
        HumanDesignCenter.sacral,
        HumanDesignCenter.spleen,
      };

      final authority = calculateAuthority(HumanDesignType.generator, definedCenters);

      expect(authority, Authority.emotional);
    });

    test('Sacral: Sacral defined (Generator/MG), no Solar Plexus', () {
      final definedCenters = {
        HumanDesignCenter.sacral,
        HumanDesignCenter.root,
      };

      final authority = calculateAuthority(HumanDesignType.generator, definedCenters);

      expect(authority, Authority.sacral);
    });

    test('Sacral authority only for Generators/MGs, not Projectors', () {
      final definedCenters = {
        HumanDesignCenter.sacral,
      };

      // Projector with defined Sacral (shouldn't happen in real charts, but tests logic)
      final authority = calculateAuthority(HumanDesignType.projector, definedCenters);

      expect(authority, isNot(Authority.sacral));
    });

    test('Splenic: Spleen defined, no Solar Plexus, no Sacral', () {
      final definedCenters = {
        HumanDesignCenter.spleen,
        HumanDesignCenter.throat,
      };

      final authority = calculateAuthority(HumanDesignType.projector, definedCenters);

      expect(authority, Authority.splenic);
    });

    test('Ego: Heart defined, no Solar Plexus, no Sacral, no Spleen', () {
      final definedCenters = {
        HumanDesignCenter.heart,
        HumanDesignCenter.throat,
      };

      final authority = calculateAuthority(HumanDesignType.manifestor, definedCenters);

      expect(authority, Authority.ego);
    });

    test('Self-Projected: Projector with G+Throat, no SP/Sacral/Spleen/Heart', () {
      final definedCenters = {
        HumanDesignCenter.g,
        HumanDesignCenter.throat,
      };

      final authority = calculateAuthority(HumanDesignType.projector, definedCenters);

      expect(authority, Authority.self);
    });

    test('Environmental: Mental Projector (only Head+Ajna)', () {
      final definedCenters = {
        HumanDesignCenter.head,
        HumanDesignCenter.ajna,
      };

      final authority = calculateAuthority(HumanDesignType.projector, definedCenters);

      expect(authority, Authority.environment);
    });

    test('Lunar: Reflector (no defined centers)', () {
      final definedCenters = <HumanDesignCenter>{};

      final authority = calculateAuthority(HumanDesignType.reflector, definedCenters);

      expect(authority, Authority.lunar);
    });

    test('Authority hierarchy: Emotional trumps Sacral', () {
      final definedCenters = {
        HumanDesignCenter.solarPlexus,
        HumanDesignCenter.sacral,
      };

      final authority = calculateAuthority(HumanDesignType.generator, definedCenters);

      expect(authority, Authority.emotional);
    });

    test('Authority hierarchy: Sacral trumps Splenic for Generators', () {
      final definedCenters = {
        HumanDesignCenter.sacral,
        HumanDesignCenter.spleen,
      };

      final authority = calculateAuthority(HumanDesignType.manifestingGenerator, definedCenters);

      expect(authority, Authority.sacral);
    });
  });

  group('Definition Calculation Tests', () {
    test('None: No defined centers', () {
      final definedCenters = <HumanDesignCenter>{};
      final activeChannels = <ChannelActivation>[];

      final definition = calculateDefinition(definedCenters, activeChannels);

      expect(definition, Definition.none);
    });

    test('Single: All defined centers are connected', () {
      // Channel 34-20 connects Sacral to Throat
      final channel3420 = ChannelData(gate1: 20, gate2: 34, name: 'Charisma', type: 'Individual');
      final channelActivation = ChannelActivation(
        channel: channel3420,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.sacral,
        HumanDesignCenter.throat,
      };
      final activeChannels = [channelActivation];

      final definition = calculateDefinition(definedCenters, activeChannels);

      expect(definition, Definition.single);
    });

    test('Split: Two separate groups of connected centers', () {
      // Group 1: G-Throat via 1-8
      final channel18 = ChannelData(gate1: 1, gate2: 8, name: 'Inspiration', type: 'Individual');
      final channelActivation1 = ChannelActivation(
        channel: channel18,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      // Group 2: Sacral-Root via 3-60
      final channel360 = ChannelData(gate1: 3, gate2: 60, name: 'Mutation', type: 'Individual');
      final channelActivation2 = ChannelActivation(
        channel: channel360,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.g,
        HumanDesignCenter.throat,
        HumanDesignCenter.sacral,
        HumanDesignCenter.root,
      };
      final activeChannels = [channelActivation1, channelActivation2];

      final definition = calculateDefinition(definedCenters, activeChannels);

      expect(definition, Definition.split);
    });

    test('Triple Split: Three separate groups', () {
      // Group 1: G-Throat via 1-8
      final channel18 = ChannelData(gate1: 1, gate2: 8, name: 'Inspiration', type: 'Individual');
      final channelActivation1 = ChannelActivation(
        channel: channel18,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      // Group 2: Sacral-Root via 3-60
      final channel360 = ChannelData(gate1: 3, gate2: 60, name: 'Mutation', type: 'Individual');
      final channelActivation2 = ChannelActivation(
        channel: channel360,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      // Group 3: Head-Ajna via 61-24
      final channel6124 = ChannelData(gate1: 24, gate2: 61, name: 'Awareness', type: 'Individual');
      final channelActivation3 = ChannelActivation(
        channel: channel6124,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.g,
        HumanDesignCenter.throat,
        HumanDesignCenter.sacral,
        HumanDesignCenter.root,
        HumanDesignCenter.head,
        HumanDesignCenter.ajna,
      };
      final activeChannels = [channelActivation1, channelActivation2, channelActivation3];

      final definition = calculateDefinition(definedCenters, activeChannels);

      expect(definition, Definition.tripleSplit);
    });

    test('Quadruple Split: Four separate groups', () {
      // Group 1: G-Throat via 1-8
      final channel18 = ChannelData(gate1: 1, gate2: 8, name: 'Inspiration', type: 'Individual');
      final channelActivation1 = ChannelActivation(
        channel: channel18,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      // Group 2: Sacral-Root via 3-60
      final channel360 = ChannelData(gate1: 3, gate2: 60, name: 'Mutation', type: 'Individual');
      final channelActivation2 = ChannelActivation(
        channel: channel360,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      // Group 3: Head-Ajna via 61-24
      final channel6124 = ChannelData(gate1: 24, gate2: 61, name: 'Awareness', type: 'Individual');
      final channelActivation3 = ChannelActivation(
        channel: channel6124,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      // Group 4: Heart-Spleen via 26-44
      final channel2644 = ChannelData(gate1: 26, gate2: 44, name: 'Surrender', type: 'Tribal');
      final channelActivation4 = ChannelActivation(
        channel: channel2644,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.g,
        HumanDesignCenter.throat,
        HumanDesignCenter.sacral,
        HumanDesignCenter.root,
        HumanDesignCenter.head,
        HumanDesignCenter.ajna,
        HumanDesignCenter.heart,
        HumanDesignCenter.spleen,
      };
      final activeChannels = [
        channelActivation1,
        channelActivation2,
        channelActivation3,
        channelActivation4,
      ];

      final definition = calculateDefinition(definedCenters, activeChannels);

      expect(definition, Definition.quadrupleSplit);
    });

    test('Single definition with multiple channels in same group', () {
      // Sacral-Throat via 34-20
      final channel3420 = ChannelData(gate1: 20, gate2: 34, name: 'Charisma', type: 'Individual');
      final channelActivation1 = ChannelActivation(
        channel: channel3420,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      // Sacral-Root via 3-60 (extends the same group)
      final channel360 = ChannelData(gate1: 3, gate2: 60, name: 'Mutation', type: 'Individual');
      final channelActivation2 = ChannelActivation(
        channel: channel360,
        gate1Conscious: true,
        gate1Unconscious: false,
        gate2Conscious: true,
        gate2Unconscious: false,
      );

      final definedCenters = {
        HumanDesignCenter.sacral,
        HumanDesignCenter.throat,
        HumanDesignCenter.root,
      };
      final activeChannels = [channelActivation1, channelActivation2];

      final definition = calculateDefinition(definedCenters, activeChannels);

      expect(definition, Definition.single);
    });
  });
}

// Helper functions that replicate the private calculation logic

/// Calculate Type based on defined centers and active channels
HumanDesignType calculateType(
  Set<HumanDesignCenter> definedCenters,
  List<ChannelActivation> activeChannels,
) {
  final hasSacral = definedCenters.contains(HumanDesignCenter.sacral);

  // Check for motor-to-throat connection
  final hasMotorToThroat = hasMotorToThroatConnection(
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

/// Check if there's a direct motor-to-throat connection using BFS
bool hasMotorToThroatConnection(
  Set<HumanDesignCenter> definedCenters,
  List<ChannelActivation> activeChannels,
) {
  if (!definedCenters.contains(HumanDesignCenter.throat)) {
    return false;
  }

  // Motors are: Sacral, Heart, Solar Plexus, Root
  final motors = {
    HumanDesignCenter.sacral,
    HumanDesignCenter.heart,
    HumanDesignCenter.solarPlexus,
    HumanDesignCenter.root,
  };

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

/// Calculate Authority based on Type and defined centers
Authority calculateAuthority(
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

/// Calculate Definition type based on how centers are connected using BFS
Definition calculateDefinition(
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
