import 'package:flutter/material.dart';

import '../../domain/models/sharing.dart';

/// Shareable chart card widget for export as image
class ChartShareCard extends StatelessWidget {
  const ChartShareCard({
    super.key,
    required this.data,
    this.variant = CardVariant.summary,
    this.backgroundColor,
    this.primaryColor,
    this.showWatermark = true,
  });

  final ChartSummaryData data;
  final CardVariant variant;
  final Color? backgroundColor;
  final Color? primaryColor;
  final bool showWatermark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;
    final accent = primaryColor ?? _getTypeColor(data.type);

    return Container(
      width: 400,
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
          _buildHeader(theme, accent),
          const SizedBox(height: 20),
          _buildTypeSection(theme, accent),
          const SizedBox(height: 16),
          _buildProfileSection(theme),
          const SizedBox(height: 16),
          _buildAuthoritySection(theme),
          if (variant == CardVariant.summary) ...[
            const SizedBox(height: 16),
            _buildCentersSection(theme, accent),
          ],
          if (data.incarnationCross != null) ...[
            const SizedBox(height: 16),
            _buildCrossSection(theme),
          ],
          if (showWatermark) ...[
            const SizedBox(height: 20),
            _buildWatermark(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color accent) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getTypeIcon(data.type),
            color: accent,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Human Design Chart',
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

  Widget _buildTypeSection(ThemeData theme, Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TYPE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.type,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
          if (data.strategy != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STRATEGY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.strategy!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    return _buildInfoRow(
      theme,
      'PROFILE',
      data.profile,
      icon: Icons.person_outline,
    );
  }

  Widget _buildAuthoritySection(ThemeData theme) {
    return Column(
      children: [
        _buildInfoRow(
          theme,
          'AUTHORITY',
          data.authority,
          icon: Icons.psychology_outlined,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          theme,
          'DEFINITION',
          data.definition,
          icon: Icons.hub_outlined,
        ),
      ],
    );
  }

  Widget _buildCentersSection(ThemeData theme, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DEFINED CENTERS',
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
          children: data.definedCenters.map((center) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: accent,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCrossSection(ThemeData theme) {
    return _buildInfoRow(
      theme,
      'INCARNATION CROSS',
      data.incarnationCross!,
      icon: Icons.brightness_4_outlined,
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value, {
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'generator':
        return const Color(0xFFE57373); // Red
      case 'manifesting generator':
        return const Color(0xFFFF8A65); // Orange-red
      case 'projector':
        return const Color(0xFF64B5F6); // Blue
      case 'manifestor':
        return const Color(0xFFBA68C8); // Purple
      case 'reflector':
        return const Color(0xFF81C784); // Green
      default:
        return const Color(0xFF90A4AE); // Grey
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'generator':
        return Icons.battery_charging_full;
      case 'manifesting generator':
        return Icons.flash_on;
      case 'projector':
        return Icons.lightbulb_outline;
      case 'manifestor':
        return Icons.rocket_launch;
      case 'reflector':
        return Icons.brightness_5;
      default:
        return Icons.person;
    }
  }
}

/// Mini chart card for inline sharing
class MiniChartShareCard extends StatelessWidget {
  const MiniChartShareCard({
    super.key,
    required this.data,
    this.onTap,
  });

  final ChartSummaryData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(data.type);

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
                color: typeColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(data.type),
                color: typeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${data.type} • ${data.profile}',
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

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'generator':
        return const Color(0xFFE57373);
      case 'manifesting generator':
        return const Color(0xFFFF8A65);
      case 'projector':
        return const Color(0xFF64B5F6);
      case 'manifestor':
        return const Color(0xFFBA68C8);
      case 'reflector':
        return const Color(0xFF81C784);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'generator':
        return Icons.battery_charging_full;
      case 'manifesting generator':
        return Icons.flash_on;
      case 'projector':
        return Icons.lightbulb_outline;
      case 'manifestor':
        return Icons.rocket_launch;
      case 'reflector':
        return Icons.brightness_5;
      default:
        return Icons.person;
    }
  }
}
