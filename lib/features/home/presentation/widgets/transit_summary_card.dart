import 'package:flutter/material.dart';

import '../../../../core/constants/human_design_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../ephemeris/mappers/degree_to_gate_mapper.dart';
import '../../../lifestyle/domain/transit_service.dart';

/// Card showing today's transit summary
class TransitSummaryCard extends StatelessWidget {
  const TransitSummaryCard({
    super.key,
    required this.transits,
    this.impact,
    this.onTap,
  });

  final TransitChart transits;
  final TransitImpact? impact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.transitActive.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.wb_sunny_outlined,
                      color: AppColors.transitActive,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Today's Transits",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Main transit gates (Sun, Earth, Moon)
              Row(
                children: [
                  Expanded(
                    child: _TransitGateChip(
                      planet: 'Sun',
                      icon: Icons.wb_sunny,
                      gate: transits.sunGate,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TransitGateChip(
                      planet: 'Earth',
                      icon: Icons.public,
                      gate: transits.earthGate,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TransitGateChip(
                      planet: 'Moon',
                      icon: Icons.nightlight_round,
                      gate: transits.moonGate,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),

              // Personal impact summary
              if (impact != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                if (impact!.hasSignificantImpact) ...[
                  _buildImpactRow(
                    context,
                    Icons.bolt,
                    '${impact!.newChannelsCount} new channel${impact!.newChannelsCount > 1 ? 's' : ''} activated',
                    AppColors.electromagneticConnection,
                  ),
                  const SizedBox(height: 8),
                ],

                if (impact!.highlightedGates.isNotEmpty) ...[
                  _buildImpactRow(
                    context,
                    Icons.highlight,
                    '${impact!.highlightedGates.length} gate${impact!.highlightedGates.length > 1 ? 's' : ''} highlighted',
                    AppColors.accent,
                  ),
                ],

                if (!impact!.hasSignificantImpact &&
                    impact!.highlightedGates.isEmpty)
                  _buildImpactRow(
                    context,
                    Icons.check_circle_outline,
                    'No direct transit connections today',
                    AppColors.success,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactRow(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

class _TransitGateChip extends StatelessWidget {
  const _TransitGateChip({
    required this.planet,
    required this.icon,
    required this.gate,
    required this.color,
  });

  final String planet;
  final IconData icon;
  final GateActivation gate;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final gateData = gates[gate.gate];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                planet,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Gate ${gate.gate}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (gateData != null)
            Text(
              gateData.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
