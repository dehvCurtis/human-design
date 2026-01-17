import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../chart/domain/models/human_design_chart.dart';
import '../../../chart/presentation/widgets/bodygraph/bodygraph_widget.dart';

/// Card showing a preview of the user's bodygraph chart
class ChartPreviewCard extends StatelessWidget {
  const ChartPreviewCard({
    super.key,
    required this.chart,
    this.onTap,
  });

  final HumanDesignChart chart;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_graph,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Bodygraph',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          '${chart.type.displayName} • ${chart.profile.notation}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: onTap,
                    child: const Text('View Full'),
                  ),
                ],
              ),
            ),

            // Bodygraph preview
            Container(
              height: 350,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: BodygraphWidget(
                chart: chart,
                interactive: false, // Disable interaction in preview
                showGateNumbers: false, // Cleaner preview
              ),
            ),

            // Quick stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: 'Defined Centers',
                    value: '${chart.definedCenters.length}/9',
                    color: AppColors.centerDefined,
                  ),
                  _StatItem(
                    label: 'Active Channels',
                    value: '${chart.activeChannels.length}',
                    color: AppColors.channelConscious,
                  ),
                  _StatItem(
                    label: 'Active Gates',
                    value: '${chart.allGates.length}',
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
      ],
    );
  }
}
