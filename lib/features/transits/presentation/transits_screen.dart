import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';
import '../../home/domain/home_providers.dart';
import '../../lifestyle/domain/transit_service.dart';

class TransitsScreen extends ConsumerWidget {
  const TransitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transits = ref.watch(todayTransitsProvider);
    final impactAsync = ref.watch(transitImpactProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Transits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Allow date selection
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayTransitsProvider);
          ref.invalidate(transitImpactProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date header
            _DateHeader(date: transits.dateTime),
            const SizedBox(height: 24),

            // Transit impact summary
            impactAsync.when(
              data: (impact) {
                if (impact == null) return const SizedBox.shrink();
                return _ImpactSummaryCard(impact: impact);
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // Planetary positions
            Text(
              'Planetary Positions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...transits.activations.entries.map((entry) {
              final planet = entry.key;
              final activation = entry.value;
              return _PlanetPositionCard(
                planet: planet,
                activation: activation,
              );
            }),
            const SizedBox(height: 24),

            // Active transit gates
            Text(
              'Active Transit Gates',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: transits.activeGates.map((gate) {
                final gateInfo = gates[gate];
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: AppColors.transitActive,
                    child: Text(
                      '$gate',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  label: Text(
                    gateInfo?.name ?? 'Gate $gate',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  backgroundColor: AppColors.transitActive.withAlpha(25),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat('EEEE');
    final dateFormat = DateFormat('MMMM d, y');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dayFormat.format(date),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
              ),
        ),
        Text(
          dateFormat.format(date),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
      ],
    );
  }
}

class _ImpactSummaryCard extends StatelessWidget {
  const _ImpactSummaryCard({required this.impact});

  final TransitImpact impact;

  String _getSummary() {
    final newGates = impact.newGateActivations.length;
    final highlightedGates = impact.highlightedGates.length;
    final newChannels = impact.newChannelsCount;

    if (newChannels > 0) {
      return 'Today\'s transits are forming $newChannels new channel${newChannels > 1 ? 's' : ''} in your chart, creating temporary energy connections.';
    } else if (newGates > 0) {
      return 'Today\'s transits are activating $newGates gate${newGates > 1 ? 's' : ''} that you don\'t normally have defined.';
    } else if (highlightedGates > 0) {
      return 'Today\'s transits are highlighting $highlightedGates of your defined gates, amplifying their energy.';
    }
    return 'Today\'s transits are moving through your chart, bringing subtle influences.';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.transitActive.withAlpha(25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_graph,
                  color: AppColors.transitActive,
                ),
                const SizedBox(width: 8),
                Text(
                  'Transit Impact on Your Chart',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getSummary(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (impact.gateImpacts.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Impacted Gates: ${impact.gateImpacts.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
            ],
            if (impact.channelImpacts.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Activated Channels: ${impact.channelImpacts.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanetPositionCard extends StatelessWidget {
  const _PlanetPositionCard({
    required this.planet,
    required this.activation,
  });

  final HumanDesignPlanet planet;
  final GateActivation activation;

  @override
  Widget build(BuildContext context) {
    final gateInfo = gates[activation.gate];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getPlanetColor(planet).withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getPlanetIcon(planet),
            color: _getPlanetColor(planet),
            size: 20,
          ),
        ),
        title: Text(planet.displayName),
        subtitle: Text(
          'Gate ${activation.gate}.${activation.line} - ${gateInfo?.name ?? 'Unknown'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        trailing: Text(
          '${activation.degree.toStringAsFixed(1)}°',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  IconData _getPlanetIcon(HumanDesignPlanet planet) {
    switch (planet) {
      case HumanDesignPlanet.sun:
        return Icons.wb_sunny;
      case HumanDesignPlanet.moon:
        return Icons.nightlight_round;
      case HumanDesignPlanet.mercury:
        return Icons.message;
      case HumanDesignPlanet.venus:
        return Icons.favorite;
      case HumanDesignPlanet.mars:
        return Icons.flash_on;
      case HumanDesignPlanet.jupiter:
        return Icons.expand;
      case HumanDesignPlanet.saturn:
        return Icons.hourglass_bottom;
      case HumanDesignPlanet.uranus:
        return Icons.bolt;
      case HumanDesignPlanet.neptune:
        return Icons.water_drop;
      case HumanDesignPlanet.pluto:
        return Icons.transform;
      case HumanDesignPlanet.northNode:
        return Icons.north;
      case HumanDesignPlanet.southNode:
        return Icons.south;
      case HumanDesignPlanet.earth:
        return Icons.public;
    }
  }

  Color _getPlanetColor(HumanDesignPlanet planet) {
    switch (planet) {
      case HumanDesignPlanet.sun:
        return Colors.orange;
      case HumanDesignPlanet.moon:
        return Colors.blueGrey;
      case HumanDesignPlanet.mercury:
        return Colors.amber;
      case HumanDesignPlanet.venus:
        return Colors.pink;
      case HumanDesignPlanet.mars:
        return Colors.red;
      case HumanDesignPlanet.jupiter:
        return Colors.purple;
      case HumanDesignPlanet.saturn:
        return Colors.brown;
      case HumanDesignPlanet.uranus:
        return Colors.cyan;
      case HumanDesignPlanet.neptune:
        return Colors.blue;
      case HumanDesignPlanet.pluto:
        return Colors.deepPurple;
      case HumanDesignPlanet.northNode:
      case HumanDesignPlanet.southNode:
        return Colors.grey;
      case HumanDesignPlanet.earth:
        return Colors.green;
    }
  }
}
