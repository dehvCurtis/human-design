import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Row of quick action buttons for navigation
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    this.onChartTap,
    this.onCompositeTap,
    this.onPentaTap,
    this.onSocialTap,
  });

  final VoidCallback? onChartTap;
  final VoidCallback? onCompositeTap;
  final VoidCallback? onPentaTap;
  final VoidCallback? onSocialTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.auto_graph,
            label: l10n.home_myChart,
            color: AppColors.primary,
            onTap: onChartTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.favorite_border,
            label: l10n.home_composite,
            color: AppColors.person2,
            onTap: onCompositeTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.groups_outlined,
            label: l10n.home_penta,
            color: AppColors.secondary,
            onTap: onPentaTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.people_outline,
            label: l10n.home_friends,
            color: AppColors.success,
            onTap: onSocialTap,
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
