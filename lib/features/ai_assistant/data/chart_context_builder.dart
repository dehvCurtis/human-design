import '../../../core/constants/human_design_constants.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../composite/domain/composite_calculator.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';
import '../../lifestyle/domain/transit_service.dart';

/// Builds a sanitized chart context JSON for AI prompt injection.
///
/// Security: Only includes enumerated HD data (type, gates, channels, etc.)
/// — never raw user input like names or locations. This prevents prompt
/// injection via birth location or chart name fields.
class ChartContextBuilder {
  ChartContextBuilder._();

  /// Maximum context size in characters to prevent excessive token usage
  static const int _maxContextLength = 4000;

  /// Build chart context as a Map suitable for JSON encoding.
  /// Only includes Human Design data — no PII or user-controlled strings.
  static Map<String, dynamic> buildChartContext(HumanDesignChart chart) {
    final context = <String, dynamic>{
      'type': chart.type.displayName,
      'strategy': chart.strategy,
      'authority': chart.authority.displayName,
      'profile': chart.profile.notation,
      'definition': chart.definition.displayName,
      'defined_centers': chart.definedCenters
          .map((c) => c.displayName)
          .toList(),
      'undefined_centers': chart.undefinedCenters
          .map((c) => c.displayName)
          .toList(),
      'conscious_gates': _buildGateList(chart.consciousActivations),
      'unconscious_gates': _buildGateList(chart.unconsciousActivations),
      'active_channels': chart.activeChannels
          .map((ch) => {
                'id': ch.channel.id,
                'gate1': ch.channel.gate1,
                'gate2': ch.channel.gate2,
                'has_conscious': ch.hasConscious,
                'has_unconscious': ch.hasUnconscious,
              })
          .toList(),
    };

    // Build incarnation cross from Sun/Earth gates
    final consciousSun = chart.consciousActivations[HumanDesignPlanet.sun];
    final consciousEarth = chart.consciousActivations[HumanDesignPlanet.earth];
    final unconsciousSun = chart.unconsciousActivations[HumanDesignPlanet.sun];
    final unconsciousEarth =
        chart.unconsciousActivations[HumanDesignPlanet.earth];

    if (consciousSun != null &&
        consciousEarth != null &&
        unconsciousSun != null &&
        unconsciousEarth != null) {
      context['incarnation_cross'] = {
        'conscious_sun_gate': consciousSun.gate,
        'conscious_earth_gate': consciousEarth.gate,
        'unconscious_sun_gate': unconsciousSun.gate,
        'unconscious_earth_gate': unconsciousEarth.gate,
      };
    }

    return context;
  }

  /// Build a compact string summary for the AI system prompt.
  /// Truncated to [_maxContextLength] to prevent token overflow.
  static String buildContextSummary(HumanDesignChart chart) {
    final buffer = StringBuffer();

    buffer.writeln('User\'s Human Design Chart:');
    buffer.writeln('- Type: ${chart.type.displayName}');
    buffer.writeln('- Strategy: ${chart.strategy}');
    buffer.writeln('- Authority: ${chart.authority.displayName}');
    buffer.writeln('- Profile: ${chart.profile.notation}');
    buffer.writeln('- Definition: ${chart.definition.displayName}');

    buffer.writeln(
      '- Defined Centers: ${chart.definedCenters.map((c) => c.displayName).join(', ')}',
    );
    buffer.writeln(
      '- Undefined Centers: ${chart.undefinedCenters.map((c) => c.displayName).join(', ')}',
    );

    // Conscious activations
    buffer.writeln('- Conscious Gates:');
    for (final entry in chart.consciousActivations.entries) {
      final gateName = gates[entry.value.gate]?.name ?? '';
      buffer.writeln(
        '  ${entry.key.symbol} ${entry.key.name}: Gate ${entry.value.gate}.${entry.value.line} ($gateName)',
      );
    }

    // Unconscious activations
    buffer.writeln('- Unconscious Gates:');
    for (final entry in chart.unconsciousActivations.entries) {
      final gateName = gates[entry.value.gate]?.name ?? '';
      buffer.writeln(
        '  ${entry.key.symbol} ${entry.key.name}: Gate ${entry.value.gate}.${entry.value.line} ($gateName)',
      );
    }

    // Active channels
    if (chart.activeChannels.isNotEmpty) {
      buffer.writeln('- Active Channels:');
      for (final ch in chart.activeChannels) {
        buffer.writeln('  Channel ${ch.channel.id}');
      }
    }

    final result = buffer.toString();
    if (result.length > _maxContextLength) {
      return '${result.substring(0, _maxContextLength)}\n[truncated]';
    }
    return result;
  }

  /// Build context for transit insight, including chart summary + transit data + impact.
  static Map<String, dynamic> buildTransitContext(
    HumanDesignChart chart,
    TransitChart transits,
    TransitImpact? impact,
  ) {
    final context = buildChartContext(chart);

    // Add transit data
    final transitGates = <Map<String, dynamic>>[];
    for (final entry in transits.activations.entries) {
      final gateName = gates[entry.value.gate]?.name ?? '';
      transitGates.add({
        'planet': entry.key.name,
        'gate': entry.value.gate,
        'line': entry.value.line,
        'name': gateName,
      });
    }
    context['today_transits'] = transitGates;
    context['transit_sun_gate'] = transits.sunGate.gate;
    context['transit_earth_gate'] = transits.earthGate.gate;

    // Add impact analysis
    if (impact != null) {
      context['completed_channels'] = impact.channelImpacts.map((ch) => {
        'channel': ch.channelId,
        'name': ch.channelName,
        'transit_gate': ch.transitGate,
        'personal_gate': ch.personalGate,
      }).toList();

      context['highlighted_personal_gates'] = impact.highlightedGates
          .map((g) => {
            'gate': g.gateNumber,
            'name': g.gateName,
            'planet': g.planet.name,
          })
          .toList();

      context['new_gate_activations'] = impact.newGateActivations
          .map((g) => {
            'gate': g.gateNumber,
            'name': g.gateName,
            'center': g.center.displayName,
            'planet': g.planet.name,
          })
          .toList();
    }

    return context;
  }

  /// Build context for compatibility reading with both charts + composite analysis.
  static Map<String, dynamic> buildCompatibilityContext(
    HumanDesignChart person1,
    HumanDesignChart person2,
    CompositeResult report,
  ) {
    return {
      'person1': {
        'name': person1.type.displayName, // Use type as identifier, not PII
        'type': person1.type.displayName,
        'strategy': person1.strategy,
        'authority': person1.authority.displayName,
        'profile': person1.profile.notation,
        'definition': person1.definition.displayName,
        'defined_centers': person1.definedCenters
            .map((c) => c.displayName)
            .toList(),
        'conscious_gates': person1.consciousGates.toList(),
        'unconscious_gates': person1.unconsciousGates.toList(),
      },
      'person2': {
        'name': person2.type.displayName,
        'type': person2.type.displayName,
        'strategy': person2.strategy,
        'authority': person2.authority.displayName,
        'profile': person2.profile.notation,
        'definition': person2.definition.displayName,
        'defined_centers': person2.definedCenters
            .map((c) => c.displayName)
            .toList(),
        'conscious_gates': person2.consciousGates.toList(),
        'unconscious_gates': person2.unconsciousGates.toList(),
      },
      'compatibility_score': report.compatibilityScore,
      'connection_theme': report.connectionTheme,
      'combined_defined_centers': report.combinedDefinedCenters
          .map((c) => c.displayName)
          .toList(),
      'electromagnetic_channels': report.electromagneticChannels
          .map((c) => {
            'channel': c.channelId,
            'name': c.channelName,
          })
          .toList(),
      'companionship_channels': report.companionshipChannels
          .map((c) => {
            'channel': c.channelId,
            'name': c.channelName,
          })
          .toList(),
      'dominance_channels': report.dominanceChannels
          .map((c) => {
            'channel': c.channelId,
            'name': c.channelName,
          })
          .toList(),
      'compromise_channels': report.compromiseChannels
          .map((c) => {
            'channel': c.channelId,
            'name': c.channelName,
          })
          .toList(),
    };
  }

  /// Build a compact transit context summary string.
  static String buildTransitContextSummary(
    TransitChart transits,
    TransitImpact? impact,
  ) {
    final buffer = StringBuffer();
    buffer.writeln("Today's Transits:");
    for (final entry in transits.activations.entries) {
      final gateName = gates[entry.value.gate]?.name ?? '';
      buffer.writeln(
        '  ${entry.key.symbol} ${entry.key.name}: Gate ${entry.value.gate}.${entry.value.line} ($gateName)',
      );
    }

    if (impact != null && impact.channelImpacts.isNotEmpty) {
      buffer.writeln('Channels completed by transits:');
      for (final ch in impact.channelImpacts) {
        buffer.writeln('  ${ch.channelId}: ${ch.channelName}');
      }
    }

    return buffer.toString();
  }

  static List<Map<String, dynamic>> _buildGateList(
    Map<HumanDesignPlanet, GateActivation> activations,
  ) {
    return activations.entries.map((entry) {
      final gateName = gates[entry.value.gate]?.name;
      return {
        'planet': entry.key.name,
        'gate': entry.value.gate,
        'line': entry.value.line,
        if (gateName != null) 'name': gateName,
      };
    }).toList();
  }
}
