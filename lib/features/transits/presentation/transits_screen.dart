import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../ephemeris/mappers/degree_to_gate_mapper.dart';
import '../../home/domain/home_providers.dart';
import '../../lifestyle/domain/transit_service.dart';

/// Provider for the selected transit date
final _selectedTransitDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Provider for transits on the selected date
final _transitsForDateProvider = Provider<TransitChart>((ref) {
  final date = ref.watch(_selectedTransitDateProvider);
  final transitService = ref.watch(transitServiceProvider);
  return transitService.calculateTransitsForDate(date);
});

/// Provider for transit impact on the selected date
final _transitImpactForDateProvider = FutureProvider<TransitImpact?>((ref) async {
  final chart = await ref.watch(userChartProvider.future);
  if (chart == null) return null;

  final transitService = ref.watch(transitServiceProvider);
  final transits = ref.watch(_transitsForDateProvider);

  return transitService.analyzeTransitImpact(chart, transits);
});

class TransitsScreen extends ConsumerWidget {
  const TransitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(_selectedTransitDateProvider);
    final transits = ref.watch(_transitsForDateProvider);
    final impactAsync = ref.watch(_transitImpactForDateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isToday(selectedDate) ? "Today's Transits" : 'Transits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: l10n.transit_selectDate,
            onPressed: () => _selectDate(context, ref, selectedDate),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(_transitsForDateProvider);
          ref.invalidate(_transitImpactForDateProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date header with navigation
            _DateHeader(
              date: transits.dateTime,
              onPreviousDay: () => _changeDate(ref, selectedDate.subtract(const Duration(days: 1))),
              onNextDay: () => _changeDate(ref, selectedDate.add(const Duration(days: 1))),
              onToday: _isToday(selectedDate) ? null : () => _changeDate(ref, DateTime.now()),
            ),
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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  void _changeDate(WidgetRef ref, DateTime newDate) {
    ref.read(_selectedTransitDateProvider.notifier).state = newDate;
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref, DateTime currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _changeDate(ref, picked);
    }
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({
    required this.date,
    required this.onPreviousDay,
    required this.onNextDay,
    this.onToday,
  });

  final DateTime date;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback? onToday;

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat('EEEE');
    final dateFormat = DateFormat('MMMM d, y');
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPreviousDay,
          tooltip: l10n.transit_previousDay,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                dayFormat.format(date),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              Text(
                dateFormat.format(date),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                textAlign: TextAlign.center,
              ),
              if (onToday != null) ...[
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: onToday,
                  icon: const Icon(Icons.today, size: 16),
                  label: Text(l10n.transit_backToToday),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onNextDay,
          tooltip: l10n.transit_nextDay,
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planet.displayName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'Gate ${activation.gate}.${activation.line} - ${gateInfo?.name ?? 'Unknown'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${activation.degree.toStringAsFixed(1)}°',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (gateInfo != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getPlanetColor(planet).withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  gateInfo.keynote,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondaryLight,
                      ),
                ),
              ),
            ],
          ],
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
