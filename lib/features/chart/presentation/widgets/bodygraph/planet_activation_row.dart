import 'package:flutter/material.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../../ephemeris/mappers/degree_to_gate_mapper.dart';

/// A single row displaying a planet's gate activation.
///
/// Shows the planet symbol, optionally the planet name, and the gate.line notation.
/// Can be tapped to show gate details.
class PlanetActivationRow extends StatelessWidget {
  const PlanetActivationRow({
    super.key,
    required this.planet,
    required this.activation,
    required this.color,
    this.showName = true,
    this.onTap,
  });

  /// The planet being displayed
  final HumanDesignPlanet planet;

  /// The gate activation for this planet
  final GateActivation activation;

  /// The color for the symbol and notation (conscious or unconscious)
  final Color color;

  /// Whether to show the planet name (false for compact mode)
  final bool showName;

  /// Callback when the row is tapped
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Planet symbol
            SizedBox(
              width: 20,
              child: Text(
                planet.symbol,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (showName) ...[
              const SizedBox(width: 6),
              // Planet name
              Expanded(
                child: Text(
                  planet.displayName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(width: 6),
            // Gate.Line notation
            Text(
              activation.notation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
