import 'package:flutter/material.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../ephemeris/mappers/degree_to_gate_mapper.dart';
import 'planet_activation_row.dart';

/// HD standard order for displaying planets
const List<HumanDesignPlanet> hdPlanetOrder = [
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

/// Panel displaying planetary activations (either Personality or Design side).
///
/// Shows a vertical list of all 13 planets with their gate.line activations.
class PlanetaryPanel extends StatelessWidget {
  const PlanetaryPanel({
    super.key,
    required this.isPersonality,
    required this.activations,
    this.showNames = true,
    this.onGateTap,
  });

  /// True for Personality (conscious/birth), false for Design (unconscious/prenatal)
  final bool isPersonality;

  /// Map of planet to gate activation
  final Map<HumanDesignPlanet, GateActivation> activations;

  /// Whether to show planet names (false for compact mode)
  final bool showNames;

  /// Callback when a gate is tapped
  final void Function(int gate)? onGateTap;

  Color get _themeColor =>
      isPersonality ? AppColors.conscious : AppColors.unconscious;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _themeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(context, l10n),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 4),
          // Planet rows
          ...hdPlanetOrder.map((planet) => _buildPlanetRow(planet)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    final title = isPersonality
        ? l10n.planetary_personality
        : l10n.planetary_design;
    final subtitle = isPersonality
        ? l10n.planetary_consciousBirth
        : l10n.planetary_unconsciousPrenatal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: _themeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanetRow(HumanDesignPlanet planet) {
    final activation = activations[planet];
    if (activation == null) {
      return const SizedBox.shrink();
    }

    return PlanetActivationRow(
      planet: planet,
      activation: activation,
      color: _themeColor,
      showName: showNames,
      onTap: onGateTap != null ? () => onGateTap!(activation.gate) : null,
    );
  }
}

/// A collapsible version of the planetary panel for narrow screens.
class CollapsiblePlanetaryPanel extends StatefulWidget {
  const CollapsiblePlanetaryPanel({
    super.key,
    required this.isPersonality,
    required this.activations,
    this.initiallyExpanded = false,
    this.onGateTap,
  });

  final bool isPersonality;
  final Map<HumanDesignPlanet, GateActivation> activations;
  final bool initiallyExpanded;
  final void Function(int gate)? onGateTap;

  @override
  State<CollapsiblePlanetaryPanel> createState() =>
      _CollapsiblePlanetaryPanelState();
}

class _CollapsiblePlanetaryPanelState extends State<CollapsiblePlanetaryPanel> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  Color get _themeColor =>
      widget.isPersonality ? AppColors.conscious : AppColors.unconscious;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final title = widget.isPersonality
        ? l10n.planetary_personality
        : l10n.planetary_design;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _themeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tappable header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _themeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: _themeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _themeColor,
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 4),
                  ...hdPlanetOrder.map((planet) {
                    final activation = widget.activations[planet];
                    if (activation == null) return const SizedBox.shrink();

                    return PlanetActivationRow(
                      planet: planet,
                      activation: activation,
                      color: _themeColor,
                      showName: true,
                      onTap: widget.onGateTap != null
                          ? () => widget.onGateTap!(activation.gate)
                          : null,
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
