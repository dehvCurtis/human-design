import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Categorized grid of quick action buttons for navigation
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({
    super.key,
    this.onChartTap,
    this.onSavedChartsTap,
    this.onCompositeTap,
    this.onPentaTap,
    this.onTransitInsightTap,
    this.onChartReadingTap,
    this.onDreamJournalTap,
    this.onJournalPromptsTap,
    this.onSocialTap,
    this.onDiscoverTap,
    this.onFeedTap,
    this.onMessagesTap,
    this.onLearningTap,
    this.onEventsTap,
  });

  // Charts
  final VoidCallback? onChartTap;
  final VoidCallback? onSavedChartsTap;
  final VoidCallback? onCompositeTap;
  final VoidCallback? onPentaTap;

  // AI & Insights
  final VoidCallback? onTransitInsightTap;
  final VoidCallback? onChartReadingTap;
  final VoidCallback? onDreamJournalTap;
  final VoidCallback? onJournalPromptsTap;

  // Community
  final VoidCallback? onSocialTap;
  final VoidCallback? onDiscoverTap;
  final VoidCallback? onFeedTap;
  final VoidCallback? onMessagesTap;

  // Learn
  final VoidCallback? onLearningTap;
  final VoidCallback? onEventsTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Charts section
        const _SectionHeader(title: 'CHARTS'),
        const SizedBox(height: 8),
        _buildChartsSection(l10n),
        const SizedBox(height: 20),

        // AI & Insights section
        const _SectionHeader(title: 'AI & INSIGHTS'),
        const SizedBox(height: 8),
        _buildAiSection(l10n),
        const SizedBox(height: 20),

        // Community section
        const _SectionHeader(title: 'COMMUNITY'),
        const SizedBox(height: 8),
        _buildCommunitySection(l10n),
        const SizedBox(height: 20),

        // Learn section
        const _SectionHeader(title: 'LEARN'),
        const SizedBox(height: 8),
        _buildLearnSection(l10n),
      ],
    );
  }

  Widget _buildChartsSection(AppLocalizations l10n) {
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
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.folder_outlined,
            label: l10n.home_savedCharts,
            color: AppColors.unconscious,
            onTap: onSavedChartsTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.compare_arrows,
            label: l10n.home_composite,
            color: AppColors.person2,
            onTap: onCompositeTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.groups_outlined,
            label: l10n.home_penta,
            color: AppColors.secondary,
            onTap: onPentaTap,
          ),
        ),
      ],
    );
  }

  Widget _buildAiSection(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.auto_awesome,
            label: 'Transit',
            color: AppColors.primary,
            onTap: onTransitInsightTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.menu_book,
            label: 'Reading',
            color: AppColors.accent,
            onTap: onChartReadingTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.nights_stay_outlined,
            label: 'Dreams',
            color: Colors.indigo,
            onTap: onDreamJournalTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.edit_note_outlined,
            label: 'Journal',
            color: Colors.teal,
            onTap: onJournalPromptsTap,
          ),
        ),
      ],
    );
  }

  Widget _buildCommunitySection(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.people_outline,
            label: l10n.home_friends,
            color: AppColors.success,
            onTap: onSocialTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.explore_outlined,
            label: 'Discover',
            color: Colors.purple,
            onTap: onDiscoverTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.dynamic_feed_outlined,
            label: 'Feed',
            color: Colors.orange,
            onTap: onFeedTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.chat_bubble_outline,
            label: 'Messages',
            color: Colors.blue,
            onTap: onMessagesTap,
          ),
        ),
      ],
    );
  }

  Widget _buildLearnSection(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.school_outlined,
            label: 'Learning',
            color: Colors.teal,
            onTap: onLearningTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.event_outlined,
            label: 'Events',
            color: Colors.deepPurple,
            onTap: onEventsTap,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(child: SizedBox()),
        const SizedBox(width: 10),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
