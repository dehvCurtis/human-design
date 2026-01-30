import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Grid of quick action buttons for navigation
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    this.onChartTap,
    this.onSavedChartsTap,
    this.onCompositeTap,
    this.onPentaTap,
    this.onSocialTap,
    this.onDiscoverTap,
    this.onFeedTap,
    this.onLearningTap,
    this.onMessagesTap,
  });

  final VoidCallback? onChartTap;
  final VoidCallback? onSavedChartsTap;
  final VoidCallback? onCompositeTap;
  final VoidCallback? onPentaTap;
  final VoidCallback? onSocialTap;
  final VoidCallback? onDiscoverTap;
  final VoidCallback? onFeedTap;
  final VoidCallback? onLearningTap;
  final VoidCallback? onMessagesTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // First row: Chart features
        Row(
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
                icon: Icons.folder_outlined,
                label: l10n.home_savedCharts,
                color: AppColors.unconscious,
                onTap: onSavedChartsTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.compare_arrows,
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
          ],
        ),
        const SizedBox(height: 12),
        // Second row: Social features
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.people_outline,
                label: l10n.home_friends,
                color: AppColors.success,
                onTap: onSocialTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.explore_outlined,
                label: 'Discover',
                color: Colors.purple,
                onTap: onDiscoverTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.dynamic_feed_outlined,
                label: 'Feed',
                color: Colors.orange,
                onTap: onFeedTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.school_outlined,
                label: 'Learning',
                color: Colors.teal,
                onTap: onLearningTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Third row: Communication
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.chat_bubble_outline,
                label: 'Messages',
                color: Colors.blue,
                onTap: onMessagesTap,
              ),
            ),
            const Spacer(),
            const Spacer(),
            const Spacer(),
          ],
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
