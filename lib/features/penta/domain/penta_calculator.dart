import '../../../core/constants/human_design_constants.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';

/// Penta roles that emerge in small group dynamics (3-5 people)
enum PentaRole {
  administrator('Administrator', 'Manages resources and logistics'),
  coordinator('Coordinator', 'Coordinates activities and communication'),
  guide('Guide', 'Provides direction and leadership'),
  provider('Provider', 'Ensures material needs are met'),
  evaluator('Evaluator', 'Assesses quality and value');

  const PentaRole(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Channels that define Penta roles
const Map<String, PentaRole> pentaChannels = {
  '45-21': PentaRole.provider,     // Money channel
  '26-44': PentaRole.administrator, // Surrender channel
  '7-31': PentaRole.guide,         // Alpha channel
  '1-8': PentaRole.coordinator,    // Inspiration channel
  '13-33': PentaRole.evaluator,    // Prodigal channel
};

/// Gates that contribute to Penta roles
const Map<int, PentaRole> pentaGates = {
  45: PentaRole.provider,
  21: PentaRole.provider,
  26: PentaRole.administrator,
  44: PentaRole.administrator,
  7: PentaRole.guide,
  31: PentaRole.guide,
  1: PentaRole.coordinator,
  8: PentaRole.coordinator,
  13: PentaRole.evaluator,
  33: PentaRole.evaluator,
};

/// Calculator for Penta (small group) dynamics
class PentaCalculator {
  /// Calculate Penta dynamics for a group of 3-5 people
  Penta calculate(List<HumanDesignChart> members) {
    if (members.length < 3) {
      throw ArgumentError('Penta requires at least 3 members');
    }
    if (members.length > 5) {
      throw ArgumentError('Penta supports a maximum of 5 members');
    }

    // Combine all gates from all members
    final combinedGates = <int>{};
    final memberGateContributions = <String, Set<int>>{};

    for (final member in members) {
      memberGateContributions[member.id] = member.allGates;
      combinedGates.addAll(member.allGates);
    }

    // Find all channels formed by the group
    final groupChannels = DegreeToGateMapper.findActiveChannels(
      combinedGates,
      <int>{},
    );

    // Find defined centers
    final definedCenters = DegreeToGateMapper.findDefinedCenters(groupChannels);

    // Determine filled and missing Penta roles
    final filledRoles = <PentaRole, PentaRoleInfo>{};
    final missingRoles = <PentaRole>[];

    for (final entry in pentaChannels.entries) {
      final channelId = entry.key;
      final role = entry.value;

      final gates = channelId.split('-').map(int.parse).toList();
      final gate1 = gates[0];
      final gate2 = gates[1];

      // Check if channel is complete
      final hasChannel = combinedGates.contains(gate1) &&
          combinedGates.contains(gate2);

      if (hasChannel) {
        // Find who contributes to this role
        final contributors = <HumanDesignChart>[];
        for (final member in members) {
          if (member.allGates.contains(gate1) ||
              member.allGates.contains(gate2)) {
            contributors.add(member);
          }
        }

        filledRoles[role] = PentaRoleInfo(
          role: role,
          channelId: channelId,
          contributors: contributors,
          isComplete: true,
        );
      } else {
        // Check for partial role (one gate only)
        final hasGate1 = combinedGates.contains(gate1);
        final hasGate2 = combinedGates.contains(gate2);

        if (hasGate1 || hasGate2) {
          final contributors = <HumanDesignChart>[];
          for (final member in members) {
            if ((hasGate1 && member.allGates.contains(gate1)) ||
                (hasGate2 && member.allGates.contains(gate2))) {
              contributors.add(member);
            }
          }

          filledRoles[role] = PentaRoleInfo(
            role: role,
            channelId: channelId,
            contributors: contributors,
            isComplete: false,
            missingGate: hasGate1 ? gate2 : gate1,
          );
        } else {
          missingRoles.add(role);
        }
      }
    }

    // Analyze group type composition
    final typeDistribution = <HumanDesignType, int>{};
    for (final member in members) {
      typeDistribution[member.type] = (typeDistribution[member.type] ?? 0) + 1;
    }

    // Calculate electromagnetic connections between members
    final electromagneticConnections = <ElectromagneticConnection>[];
    for (int i = 0; i < members.length; i++) {
      for (int j = i + 1; j < members.length; j++) {
        final connections = _findElectromagneticChannels(members[i], members[j]);
        if (connections.isNotEmpty) {
          electromagneticConnections.add(ElectromagneticConnection(
            member1: members[i],
            member2: members[j],
            channels: connections,
          ));
        }
      }
    }

    // Identify group strengths
    final strengths = _analyzeGroupStrengths(
      members,
      filledRoles,
      definedCenters,
      typeDistribution,
    );

    // Identify potential challenges
    final challenges = _analyzeGroupChallenges(
      members,
      missingRoles,
      typeDistribution,
    );

    return Penta(
      members: members,
      combinedGates: combinedGates,
      groupChannels: groupChannels,
      definedCenters: definedCenters,
      filledRoles: filledRoles,
      missingRoles: missingRoles,
      typeDistribution: typeDistribution,
      electromagneticConnections: electromagneticConnections,
      strengths: strengths,
      challenges: challenges,
    );
  }

  List<ChannelData> _findElectromagneticChannels(
    HumanDesignChart member1,
    HumanDesignChart member2,
  ) {
    final electromagneticChannels = <ChannelData>[];

    for (final channel in channels) {
      final m1HasGate1 = member1.allGates.contains(channel.gate1);
      final m1HasGate2 = member1.allGates.contains(channel.gate2);
      final m2HasGate1 = member2.allGates.contains(channel.gate1);
      final m2HasGate2 = member2.allGates.contains(channel.gate2);

      // Electromagnetic: each person contributes exactly one gate
      if ((m1HasGate1 && m2HasGate2 && !m1HasGate2 && !m2HasGate1) ||
          (m1HasGate2 && m2HasGate1 && !m1HasGate1 && !m2HasGate2)) {
        electromagneticChannels.add(channel);
      }
    }

    return electromagneticChannels;
  }

  List<String> _analyzeGroupStrengths(
    List<HumanDesignChart> members,
    Map<PentaRole, PentaRoleInfo> filledRoles,
    Set<HumanDesignCenter> definedCenters,
    Map<HumanDesignType, int> typeDistribution,
  ) {
    final strengths = <String>[];

    // Role-based strengths
    final completeRoles = filledRoles.values.where((r) => r.isComplete).toList();
    if (completeRoles.length >= 3) {
      strengths.add('Well-defined group structure with ${completeRoles.length} complete roles');
    }

    if (filledRoles.containsKey(PentaRole.guide) &&
        filledRoles[PentaRole.guide]!.isComplete) {
      strengths.add('Clear leadership through Guide role');
    }

    if (filledRoles.containsKey(PentaRole.provider) &&
        filledRoles[PentaRole.provider]!.isComplete) {
      strengths.add('Strong material foundation through Provider role');
    }

    // Center-based strengths
    if (definedCenters.contains(HumanDesignCenter.throat)) {
      strengths.add('Group can manifest and communicate effectively');
    }

    if (definedCenters.contains(HumanDesignCenter.sacral)) {
      strengths.add('Consistent work energy available to the group');
    }

    if (definedCenters.contains(HumanDesignCenter.g)) {
      strengths.add('Clear sense of group identity and direction');
    }

    // Type diversity
    if (typeDistribution.length >= 3) {
      strengths.add('Diverse energy types bring varied perspectives');
    }

    if (typeDistribution.containsKey(HumanDesignType.generator) ||
        typeDistribution.containsKey(HumanDesignType.manifestingGenerator)) {
      strengths.add('Generator energy provides sustainable work capacity');
    }

    if (typeDistribution.containsKey(HumanDesignType.projector)) {
      strengths.add('Projector wisdom available for guidance');
    }

    return strengths;
  }

  List<String> _analyzeGroupChallenges(
    List<HumanDesignChart> members,
    List<PentaRole> missingRoles,
    Map<HumanDesignType, int> typeDistribution,
  ) {
    final challenges = <String>[];

    // Missing roles
    for (final role in missingRoles) {
      switch (role) {
        case PentaRole.guide:
          challenges.add('No defined Guide - leadership may be unclear');
          break;
        case PentaRole.provider:
          challenges.add('No defined Provider - material resources may need attention');
          break;
        case PentaRole.administrator:
          challenges.add('No defined Administrator - logistics may need external help');
          break;
        case PentaRole.coordinator:
          challenges.add('No defined Coordinator - communication may need conscious effort');
          break;
        case PentaRole.evaluator:
          challenges.add('No defined Evaluator - quality assessment may be inconsistent');
          break;
      }
    }

    // Type imbalances
    final generatorCount = (typeDistribution[HumanDesignType.generator] ?? 0) +
        (typeDistribution[HumanDesignType.manifestingGenerator] ?? 0);

    if (generatorCount == 0) {
      challenges.add('No Generator energy - may lack sustained work capacity');
    }

    if (typeDistribution.length == 1) {
      challenges.add('All members are the same type - may lack perspective diversity');
    }

    return challenges;
  }
}

/// Represents a Penta (small group) analysis
class Penta {
  const Penta({
    required this.members,
    required this.combinedGates,
    required this.groupChannels,
    required this.definedCenters,
    required this.filledRoles,
    required this.missingRoles,
    required this.typeDistribution,
    required this.electromagneticConnections,
    required this.strengths,
    required this.challenges,
  });

  final List<HumanDesignChart> members;
  final Set<int> combinedGates;
  final List<ChannelActivation> groupChannels;
  final Set<HumanDesignCenter> definedCenters;
  final Map<PentaRole, PentaRoleInfo> filledRoles;
  final List<PentaRole> missingRoles;
  final Map<HumanDesignType, int> typeDistribution;
  final List<ElectromagneticConnection> electromagneticConnections;
  final List<String> strengths;
  final List<String> challenges;

  /// Number of complete Penta roles
  int get completeRoleCount =>
      filledRoles.values.where((r) => r.isComplete).length;

  /// Whether the Penta has a complete leadership structure
  bool get hasCompleteLeadership =>
      filledRoles.containsKey(PentaRole.guide) &&
      filledRoles[PentaRole.guide]!.isComplete;

  /// Overall group health score (0-100)
  int get healthScore {
    int score = 0;

    // Roles (40 points max)
    score += completeRoleCount * 8;

    // Defined centers (30 points max)
    score += (definedCenters.length * 3.33).round();

    // Electromagnetic connections (20 points max)
    score += (electromagneticConnections.length * 4).clamp(0, 20);

    // Type diversity (10 points max)
    score += (typeDistribution.length * 2.5).round();

    return score.clamp(0, 100);
  }
}

/// Information about a filled Penta role
class PentaRoleInfo {
  const PentaRoleInfo({
    required this.role,
    required this.channelId,
    required this.contributors,
    required this.isComplete,
    this.missingGate,
  });

  final PentaRole role;
  final String channelId;
  final List<HumanDesignChart> contributors;
  final bool isComplete;
  final int? missingGate;

  /// Names of contributors
  List<String> get contributorNames =>
      contributors.map((c) => c.name).toList();
}

/// Represents an electromagnetic connection between two members
class ElectromagneticConnection {
  const ElectromagneticConnection({
    required this.member1,
    required this.member2,
    required this.channels,
  });

  final HumanDesignChart member1;
  final HumanDesignChart member2;
  final List<ChannelData> channels;

  String get description =>
      '${member1.name} and ${member2.name}: ${channels.length} electromagnetic channels';
}
