import '../../../core/constants/human_design_constants.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';

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
