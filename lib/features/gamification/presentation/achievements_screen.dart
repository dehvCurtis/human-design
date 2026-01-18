import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/gamification_providers.dart';
import '../domain/models/gamification.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(userPointsProvider);
    final badgesAsync = ref.watch(badgesWithProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: CustomScrollView(
        slivers: [
          // Stats header
          SliverToBoxAdapter(
            child: pointsAsync.when(
              data: (points) => points != null
                  ? _StatsHeader(points: points)
                  : const SizedBox.shrink(),
              loading: () => const _LoadingHeader(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // Badges section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Badges',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),

          badgesAsync.when(
            data: (badges) => _BadgesGrid(badges: badges),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(child: Text('Error: $e')),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({required this.points});

  final UserPoints points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primary.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Level and points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                label: 'Level',
                value: points.currentLevel.toString(),
                icon: Icons.star,
              ),
              _StatItem(
                label: 'Total Points',
                value: _formatNumber(points.totalPoints),
                icon: Icons.diamond,
              ),
              _StatItem(
                label: 'Streak',
                value: '${points.currentStreak} days',
                icon: Icons.local_fire_department,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Level progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level ${points.currentLevel}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'Level ${points.currentLevel + 1}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: points.levelProgress,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_formatNumber(points.pointsForNextLevel - points.totalPoints)} points to next level',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 28, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _LoadingHeader extends StatelessWidget {
  const _LoadingHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _BadgesGrid extends StatelessWidget {
  const _BadgesGrid({required this.badges});

  final List<({Badge badge, UserBadge? userBadge})> badges;

  @override
  Widget build(BuildContext context) {
    // Group by category
    final byCategory = <BadgeCategory, List<({Badge badge, UserBadge? userBadge})>>{};
    for (final item in badges) {
      byCategory.putIfAbsent(item.badge.category, () => []).add(item);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final category = BadgeCategory.values[index];
          final categoryBadges = byCategory[category] ?? [];

          if (categoryBadges.isEmpty) return const SizedBox.shrink();

          return _BadgeCategorySection(
            category: category,
            badges: categoryBadges,
          );
        },
        childCount: BadgeCategory.values.length,
      ),
    );
  }
}

class _BadgeCategorySection extends StatelessWidget {
  const _BadgeCategorySection({
    required this.category,
    required this.badges,
  });

  final BadgeCategory category;
  final List<({Badge badge, UserBadge? userBadge})> badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            _getCategoryName(category),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final item = badges[index];
              return _BadgeCard(
                badge: item.badge,
                isEarned: item.userBadge != null,
                earnedAt: item.userBadge?.earnedAt,
              );
            },
          ),
        ),
      ],
    );
  }

  String _getCategoryName(BadgeCategory category) {
    switch (category) {
      case BadgeCategory.social:
        return 'Social';
      case BadgeCategory.learning:
        return 'Learning';
      case BadgeCategory.engagement:
        return 'Engagement';
      case BadgeCategory.transit:
        return 'Transit';
      case BadgeCategory.achievement:
        return 'Achievement';
    }
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.badge,
    required this.isEarned,
    this.earnedAt,
  });

  final Badge badge;
  final bool isEarned;
  final DateTime? earnedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: isEarned
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        child: InkWell(
          onTap: () => _showBadgeDetails(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconData(badge.iconName),
                  size: 36,
                  color: isEarned
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  badge.name.replaceAll('_', ' '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isEarned
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (badge.pointsAwarded > 0)
                  Text(
                    '+${badge.pointsAwarded}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getIconData(badge.iconName), color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(badge.name.replaceAll('_', ' '))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge.description),
            if (isEarned && earnedAt != null) ...[
              const SizedBox(height: 12),
              Text(
                'Earned on ${earnedAt!.day}/${earnedAt!.month}/${earnedAt!.year}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (badge.pointsAwarded > 0) ...[
              const SizedBox(height: 8),
              Text(
                '+${badge.pointsAwarded} points',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person_add':
        return Icons.person_add;
      case 'groups':
        return Icons.groups;
      case 'diversity_3':
        return Icons.diversity_3;
      case 'trending_up':
        return Icons.trending_up;
      case 'explore':
        return Icons.explore;
      case 'track_changes':
        return Icons.track_changes;
      case 'school':
        return Icons.school;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'event_available':
        return Icons.event_available;
      case 'edit_note':
        return Icons.edit_note;
      case 'article':
        return Icons.article;
      case 'autorenew':
        return Icons.autorenew;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'star':
        return Icons.star;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      default:
        return Icons.emoji_events;
    }
  }
}
