import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/sharing.dart';

/// Transit share card widget for displaying current transits
class TransitShareCard extends StatelessWidget {
  const TransitShareCard({
    super.key,
    required this.transit,
    this.personalActivations = const [],
    this.insightText,
    this.backgroundColor,
    this.showPersonalOverlay = true,
    this.showWatermark = true,
  });

  final TransitSummaryData transit;
  final List<int> personalActivations;
  final String? insightText;
  final Color? backgroundColor;
  final bool showPersonalOverlay;
  final bool showWatermark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return Container(
      width: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 20),
          _buildMainTransits(theme),
          if (transit.allPlanetaryGates != null &&
              transit.allPlanetaryGates!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildPlanetaryGates(theme),
          ],
          if (showPersonalOverlay && personalActivations.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildPersonalActivations(theme),
          ],
          if (transit.activeTransitChannels != null &&
              transit.activeTransitChannels!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildActiveChannels(theme),
          ],
          if (insightText != null) ...[
            const SizedBox(height: 16),
            _buildInsight(theme),
          ],
          if (showWatermark) ...[
            const SizedBox(height: 20),
            _buildWatermark(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy');

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade300,
                Colors.amber.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.brightness_5,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Transit',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                dateFormatter.format(transit.date),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainTransits(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildPlanetCard(
            theme,
            'Sun',
            transit.sunGate,
            Icons.wb_sunny,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPlanetCard(
            theme,
            'Earth',
            transit.earthGate,
            Icons.public,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPlanetCard(
            theme,
            'Moon',
            transit.moonGate,
            Icons.nightlight_round,
            Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanetCard(
    ThemeData theme,
    String planet,
    int gate,
    IconData icon,
    Color color,
  ) {
    final keyword = transit.gateKeywords?[gate];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            planet,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gate $gate',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (keyword != null) ...[
            const SizedBox(height: 4),
            Text(
              keyword,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanetaryGates(ThemeData theme) {
    final planets = transit.allPlanetaryGates!.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALL PLANETARY GATES',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: planets.map((entry) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getPlanetIcon(entry.key),
                    size: 14,
                    color: _getPlanetColor(entry.key),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${entry.value}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPersonalActivations(ThemeData theme) {
    final activatedByTransit = personalActivations.where((gate) =>
        gate == transit.sunGate ||
        gate == transit.earthGate ||
        gate == transit.moonGate ||
        (transit.allPlanetaryGates?.values.contains(gate) ?? false)).toList();

    if (activatedByTransit.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Personal Activations Today',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activatedByTransit.map((gate) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Gate $gate',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            'Transit is activating gates in your chart, amplifying these themes.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChannels(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.link,
              size: 18,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Active Transit Channels',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: transit.activeTransitChannels!.map((channel) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                channel,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInsight(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.1),
            Colors.indigo.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                size: 20,
                color: Colors.purple,
              ),
              const SizedBox(width: 8),
              Text(
                'Transit Insight',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insightText!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatermark(ThemeData theme) {
    return Center(
      child: Text(
        'humandesign.app',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getPlanetIcon(String planet) {
    switch (planet.toLowerCase()) {
      case 'sun':
        return Icons.wb_sunny;
      case 'earth':
        return Icons.public;
      case 'moon':
        return Icons.nightlight_round;
      case 'mercury':
        return Icons.speed;
      case 'venus':
        return Icons.favorite;
      case 'mars':
        return Icons.flash_on;
      case 'jupiter':
        return Icons.expand;
      case 'saturn':
        return Icons.architecture;
      case 'uranus':
        return Icons.bolt;
      case 'neptune':
        return Icons.water;
      case 'pluto':
        return Icons.transform;
      case 'north node':
        return Icons.north;
      case 'south node':
        return Icons.south;
      default:
        return Icons.star;
    }
  }

  Color _getPlanetColor(String planet) {
    switch (planet.toLowerCase()) {
      case 'sun':
        return Colors.orange;
      case 'earth':
        return Colors.green;
      case 'moon':
        return Colors.blueGrey;
      case 'mercury':
        return Colors.amber;
      case 'venus':
        return Colors.pink;
      case 'mars':
        return Colors.red;
      case 'jupiter':
        return Colors.purple;
      case 'saturn':
        return Colors.brown;
      case 'uranus':
        return Colors.cyan;
      case 'neptune':
        return Colors.indigo;
      case 'pluto':
        return Colors.deepPurple;
      case 'north node':
        return Colors.teal;
      case 'south node':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}

/// Mini transit card for inline display
class MiniTransitCard extends StatelessWidget {
  const MiniTransitCard({
    super.key,
    required this.transit,
    this.onTap,
  });

  final TransitSummaryData transit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('MMM d');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade300,
                    Colors.amber.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.brightness_5,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormatter.format(transit.date),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Sun ${transit.sunGate} • Earth ${transit.earthGate} • Moon ${transit.moonGate}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gate of the day sharing card
class GateOfDayCard extends StatelessWidget {
  const GateOfDayCard({
    super.key,
    required this.gateNumber,
    required this.gateName,
    this.keyword,
    this.description,
    this.showWatermark = true,
  });

  final int gateNumber;
  final String gateName;
  final String? keyword;
  final String? description;
  final bool showWatermark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400,
            Colors.amber.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wb_sunny,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'GATE OF THE DAY',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gate $gateNumber',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            gateName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          if (keyword != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                keyword!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (description != null) ...[
            const SizedBox(height: 16),
            Text(
              description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (showWatermark) ...[
            const SizedBox(height: 20),
            Text(
              'humandesign.app',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
