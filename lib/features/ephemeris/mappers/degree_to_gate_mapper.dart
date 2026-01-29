import 'package:human_design/core/constants/human_design_constants.dart';

/// Maps zodiac degrees to Human Design gates and lines.
///
/// The Human Design wheel maps the 360° zodiac to 64 gates,
/// with each gate spanning 5.625° and containing 6 lines.
///
/// IMPORTANT: The HD wheel is offset from the tropical zodiac.
/// Gate 41 starts at 2°00' Aquarius (302° tropical), not 0° Aries.
/// We apply a 58° offset to convert tropical longitude to HD wheel position.
class DegreeToGateMapper {
  DegreeToGateMapper._();

  /// Degrees per gate (360° / 64 gates)
  static const double _degreesPerGate = 5.625;

  /// Degrees per line (5.625° / 6 lines)
  static const double _degreesPerLine = 0.9375;

  /// HD wheel offset from tropical zodiac.
  /// Gate 41 starts at 302° tropical (2° Aquarius), so we add 58° to align.
  static const double _hdWheelOffset = 58.0;

  /// Enable verbose debug logging for gate mapping
  static bool debugLogging = false;

  /// Maps a zodiac degree to a gate and line.
  ///
  /// [degree] should be a tropical zodiac value from 0-360, where:
  /// - 0° = 0° Aries (Spring Equinox)
  /// - 30° = 0° Taurus
  /// - 90° = 0° Cancer
  /// - 180° = 0° Libra
  /// - 270° = 0° Capricorn
  ///
  /// The HD wheel is offset so that Gate 41 begins at 2° Aquarius (302° tropical).
  /// This means 0° Aries maps to Gate 25 (not Gate 41).
  ///
  /// Returns a [GateActivation] containing the gate number (1-64) and line (1-6).
  static GateActivation mapDegreeToGate(double degree) {
    // Normalize degree to 0-360 range
    double normalizedDegree = degree % 360;
    if (normalizedDegree < 0) {
      normalizedDegree += 360;
    }

    // Apply HD wheel offset: Gate 41 starts at 302° tropical, not 0°
    // Adding 58° shifts the wheel so 0° tropical → Gate 25 (correct)
    double hdWheelPosition = (normalizedDegree + _hdWheelOffset) % 360;

    // Calculate which gate index (0-63) based on position in wheel
    final int gateIndex = (hdWheelPosition / _degreesPerGate).floor();

    // Get the gate number from the wheel sequence
    final int gateNumber = gateWheelSequence[gateIndex];

    if (debugLogging) {
      print('  DEBUG mapDegreeToGate: ${degree.toStringAsFixed(4)}° tropical → ${hdWheelPosition.toStringAsFixed(4)}° HD wheel → index $gateIndex → Gate $gateNumber');
    }

    // Calculate position within the gate for line determination
    final double positionInGate = hdWheelPosition % _degreesPerGate;

    // Calculate line number (1-6)
    int lineNumber = (positionInGate / _degreesPerLine).floor() + 1;
    if (lineNumber > 6) lineNumber = 6; // Safety clamp

    // Calculate color and tone for advanced readings
    final double positionInLine = positionInGate % _degreesPerLine;
    final double degreesPerColor = _degreesPerLine / 6;
    int color = (positionInLine / degreesPerColor).floor() + 1;
    if (color > 6) color = 6;

    final double positionInColor = positionInLine % degreesPerColor;
    final double degreesPerTone = degreesPerColor / 6;
    int tone = (positionInColor / degreesPerTone).floor() + 1;
    if (tone > 6) tone = 6;

    final double positionInTone = positionInColor % degreesPerTone;
    final double degreesPerBase = degreesPerTone / 5;
    int base = (positionInTone / degreesPerBase).floor() + 1;
    if (base > 5) base = 5;

    return GateActivation(
      gate: gateNumber,
      line: lineNumber,
      color: color,
      tone: tone,
      base: base,
      degree: normalizedDegree,
    );
  }

  /// Converts a gate number to its starting degree in tropical zodiac.
  ///
  /// Returns the tropical longitude where this gate begins.
  static double gateToDegree(int gateNumber) {
    final index = gateWheelSequence.indexOf(gateNumber);
    if (index == -1) {
      throw ArgumentError('Invalid gate number: $gateNumber');
    }
    // Convert HD wheel position back to tropical longitude
    final hdWheelPosition = index * _degreesPerGate;
    return (hdWheelPosition - _hdWheelOffset + 360) % 360;
  }

  /// Gets the center associated with a gate.
  static HumanDesignCenter getGateCenter(int gateNumber) {
    final gateData = gates[gateNumber];
    if (gateData == null) {
      throw ArgumentError('Invalid gate number: $gateNumber');
    }
    return gateData.center;
  }

  /// Finds channels activated by a set of gates.
  static List<ChannelActivation> findActiveChannels(
    Set<int> consciousGates,
    Set<int> unconsciousGates,
  ) {
    final List<ChannelActivation> activeChannels = [];

    for (final channel in channels) {
      final bool gate1Conscious = consciousGates.contains(channel.gate1);
      final bool gate1Unconscious = unconsciousGates.contains(channel.gate1);
      final bool gate2Conscious = consciousGates.contains(channel.gate2);
      final bool gate2Unconscious = unconsciousGates.contains(channel.gate2);

      // Channel is active if both gates are defined (either conscious or unconscious)
      final bool gate1Active = gate1Conscious || gate1Unconscious;
      final bool gate2Active = gate2Conscious || gate2Unconscious;

      if (gate1Active && gate2Active) {
        activeChannels.add(ChannelActivation(
          channel: channel,
          gate1Conscious: gate1Conscious,
          gate1Unconscious: gate1Unconscious,
          gate2Conscious: gate2Conscious,
          gate2Unconscious: gate2Unconscious,
        ));
      }
    }

    return activeChannels;
  }

  /// Finds defined centers based on active channels.
  static Set<HumanDesignCenter> findDefinedCenters(List<ChannelActivation> activeChannels) {
    final Set<HumanDesignCenter> definedCenters = {};

    for (final channelActivation in activeChannels) {
      final channelId = channelActivation.channel.id;
      final centers = channelCenters[channelId];
      if (centers != null) {
        definedCenters.addAll(centers);
      }
    }

    return definedCenters;
  }
}

/// Represents a gate activation with line, color, tone, and base.
class GateActivation {
  const GateActivation({
    required this.gate,
    required this.line,
    required this.color,
    required this.tone,
    required this.base,
    required this.degree,
  });

  /// Gate number (1-64)
  final int gate;

  /// Line number (1-6)
  final int line;

  /// Color number (1-6) - deeper level
  final int color;

  /// Tone number (1-6) - even deeper
  final int tone;

  /// Base number (1-5) - deepest level
  final int base;

  /// Original zodiac degree
  final double degree;

  /// Returns notation like "41.3" (Gate 41, Line 3)
  String get notation => '$gate.$line';

  /// Returns full notation like "41.3.2.4.1" (Gate.Line.Color.Tone.Base)
  String get fullNotation => '$gate.$line.$color.$tone.$base';

  @override
  String toString() => 'Gate $notation';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GateActivation &&
          runtimeType == other.runtimeType &&
          gate == other.gate &&
          line == other.line;

  @override
  int get hashCode => gate.hashCode ^ line.hashCode;
}

/// Represents a channel activation with information about which gates are
/// conscious or unconscious.
class ChannelActivation {
  const ChannelActivation({
    required this.channel,
    required this.gate1Conscious,
    required this.gate1Unconscious,
    required this.gate2Conscious,
    required this.gate2Unconscious,
  });

  final ChannelData channel;
  final bool gate1Conscious;
  final bool gate1Unconscious;
  final bool gate2Conscious;
  final bool gate2Unconscious;

  /// Whether the channel has any conscious activation
  bool get hasConscious => gate1Conscious || gate2Conscious;

  /// Whether the channel has any unconscious activation
  bool get hasUnconscious => gate1Unconscious || gate2Unconscious;

  /// Whether the channel has both conscious and unconscious activations
  bool get hasBoth => hasConscious && hasUnconscious;

  String get id => channel.id;
  String get name => channel.name;

  @override
  String toString() => 'Channel ${channel.gate1}-${channel.gate2} ($name)';
}
