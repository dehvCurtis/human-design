import '../../../core/constants/human_design_constants.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../ephemeris/data/ephemeris_service.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';

/// Service for calculating and analyzing daily transits
class TransitService {
  TransitService({required EphemerisService ephemerisService})
      : _ephemerisService = ephemerisService;

  final EphemerisService _ephemerisService;

  /// Calculate current transits
  TransitChart calculateCurrentTransits() {
    return calculateTransitsForDate(DateTime.now());
  }

  /// Calculate transits for a specific date and time
  TransitChart calculateTransitsForDate(DateTime dateTime) {
    final activations = _ephemerisService.calculateTransits(dateTime);

    final transitGates = activations.values.map((a) => a.gate).toSet();

    // Find channels formed by transits alone
    final transitChannels = DegreeToGateMapper.findActiveChannels(
      transitGates,
      <int>{}, // No unconscious for transits
    );

    // Find defined centers from transit channels
    final transitCenters = DegreeToGateMapper.findDefinedCenters(transitChannels);

    return TransitChart(
      dateTime: dateTime,
      activations: activations,
      activeGates: transitGates,
      activeChannels: transitChannels,
      definedCenters: transitCenters,
    );
  }

  /// Analyze how transits affect a personal chart
  TransitImpact analyzeTransitImpact(
    HumanDesignChart personalChart,
    TransitChart transits,
  ) {
    final List<TransitGateImpact> gateImpacts = [];
    final List<TransitChannelImpact> channelImpacts = [];

    // Check which transit gates connect with the personal chart
    for (final transitGate in transits.activeGates) {
      final hasGate = personalChart.allGates.contains(transitGate);

      // Check if this transit gate completes any channels
      for (final channel in channels) {
        final otherGate =
            channel.gate1 == transitGate ? channel.gate2 : channel.gate1;

        // Transit activates one gate, personal chart has the other
        if ((channel.gate1 == transitGate || channel.gate2 == transitGate) &&
            personalChart.allGates.contains(otherGate) &&
            !personalChart.allGates.contains(transitGate)) {
          final channelActivation = transits.activations.values
              .where((a) => a.gate == transitGate)
              .firstOrNull;
          if (channelActivation != null) {
            channelImpacts.add(TransitChannelImpact(
              channel: channel,
              transitGate: transitGate,
              personalGate: otherGate,
              activation: channelActivation,
            ));
          }
        }
      }

      // Record gate impact (skip if gate data is missing)
      final gateData = gates[transitGate];
      if (gateData == null) continue;

      final activation = transits.activations.values
          .where((a) => a.gate == transitGate)
          .firstOrNull;
      if (activation == null) continue;

      final planetEntry = transits.activations.entries
          .where((e) => e.value.gate == transitGate)
          .firstOrNull;
      if (planetEntry == null) continue;

      gateImpacts.add(TransitGateImpact(
        gateNumber: transitGate,
        gateData: gateData,
        activation: activation,
        isInPersonalChart: hasGate,
        planet: planetEntry.key,
      ));
    }

    // Sort impacts by planet importance (Sun, Earth, Moon first)
    gateImpacts.sort((a, b) {
      final order = [
        HumanDesignPlanet.sun,
        HumanDesignPlanet.earth,
        HumanDesignPlanet.moon,
        HumanDesignPlanet.northNode,
        HumanDesignPlanet.southNode,
        HumanDesignPlanet.mercury,
        HumanDesignPlanet.venus,
        HumanDesignPlanet.mars,
        HumanDesignPlanet.jupiter,
        HumanDesignPlanet.saturn,
        HumanDesignPlanet.uranus,
        HumanDesignPlanet.neptune,
        HumanDesignPlanet.pluto,
      ];
      return order.indexOf(a.planet).compareTo(order.indexOf(b.planet));
    });

    return TransitImpact(
      personalChart: personalChart,
      transits: transits,
      gateImpacts: gateImpacts,
      channelImpacts: channelImpacts,
    );
  }

  /// Get the Sun gate for a specific date (main energy of the day)
  GateActivation getSunGateForDate(DateTime date) {
    final transits = calculateTransitsForDate(date);
    return transits.sunGate;
  }

  /// Get upcoming gate changes for the Sun
  List<GateTransition> getUpcomingSunTransitions({int days = 7}) {
    final transitions = <GateTransition>[];
    var currentDate = DateTime.now();
    var currentGate = getSunGateForDate(currentDate).gate;

    for (int i = 0; i < days * 24; i++) {
      // Check hourly
      final checkDate = currentDate.add(Duration(hours: i));
      final gateAtTime = getSunGateForDate(checkDate).gate;

      if (gateAtTime != currentGate) {
        transitions.add(GateTransition(
          fromGate: currentGate,
          toGate: gateAtTime,
          transitionTime: checkDate,
          planet: HumanDesignPlanet.sun,
        ));
        currentGate = gateAtTime;
      }
    }

    return transitions;
  }
}

/// Represents current planetary transits
class TransitChart {
  const TransitChart({
    required this.dateTime,
    required this.activations,
    required this.activeGates,
    required this.activeChannels,
    required this.definedCenters,
  });

  final DateTime dateTime;
  final Map<HumanDesignPlanet, GateActivation> activations;
  final Set<int> activeGates;
  final List<ChannelActivation> activeChannels;
  final Set<HumanDesignCenter> definedCenters;

  /// Get the Sun gate (primary energy)
  GateActivation get sunGate =>
      activations[HumanDesignPlanet.sun] ??
      (throw StateError('Sun transit position unavailable'));

  /// Get the Earth gate (grounding energy)
  GateActivation get earthGate =>
      activations[HumanDesignPlanet.earth] ??
      (throw StateError('Earth transit position unavailable'));

  /// Get the Moon gate (emotional/intuitive energy)
  GateActivation get moonGate =>
      activations[HumanDesignPlanet.moon] ??
      (throw StateError('Moon transit position unavailable'));
}

/// Analysis of how transits affect a personal chart
class TransitImpact {
  const TransitImpact({
    required this.personalChart,
    required this.transits,
    required this.gateImpacts,
    required this.channelImpacts,
  });

  final HumanDesignChart personalChart;
  final TransitChart transits;
  final List<TransitGateImpact> gateImpacts;
  final List<TransitChannelImpact> channelImpacts;

  /// Gates that are temporarily activated by transit
  List<TransitGateImpact> get newGateActivations =>
      gateImpacts.where((g) => !g.isInPersonalChart).toList();

  /// Gates in personal chart that are being highlighted
  List<TransitGateImpact> get highlightedGates =>
      gateImpacts.where((g) => g.isInPersonalChart).toList();

  /// Number of new channels formed
  int get newChannelsCount => channelImpacts.length;

  /// Whether there's significant transit activity
  bool get hasSignificantImpact => channelImpacts.isNotEmpty;
}

/// Impact of a specific gate transit
class TransitGateImpact {
  const TransitGateImpact({
    required this.gateNumber,
    required this.gateData,
    required this.activation,
    required this.isInPersonalChart,
    required this.planet,
  });

  final int gateNumber;
  final GateData gateData;
  final GateActivation activation;
  final bool isInPersonalChart;
  final HumanDesignPlanet planet;

  String get gateName => gateData.name;
  HumanDesignCenter get center => gateData.center;
}

/// Impact of a channel being completed by transit
class TransitChannelImpact {
  const TransitChannelImpact({
    required this.channel,
    required this.transitGate,
    required this.personalGate,
    required this.activation,
  });

  final ChannelData channel;
  final int transitGate;
  final int personalGate;
  final GateActivation activation;

  String get channelName => channel.name;
  String get channelId => channel.id;
}

/// Represents when a planet moves from one gate to another
class GateTransition {
  const GateTransition({
    required this.fromGate,
    required this.toGate,
    required this.transitionTime,
    required this.planet,
  });

  final int fromGate;
  final int toGate;
  final DateTime transitionTime;
  final HumanDesignPlanet planet;
}
