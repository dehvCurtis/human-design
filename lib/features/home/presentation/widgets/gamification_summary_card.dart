import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../gamification/domain/gamification_providers.dart';
import '../../../gamification/domain/models/gamification.dart';

/// Card showing user's gamification progress on the home screen
class GamificationSummaryCard extends ConsumerWidget {
  const GamificationSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userPointsAsync = ref.watch(userPointsProvider);
    final userChallengesAsync = ref.watch(userChallengesProvider);

    return Card(
      child: InkWell(
        onTap: () => context.push(AppRoutes.achievements),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.gamification_yourProgress,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Points & Level
              userPointsAsync.when(
                data: (points) => _buildPointsSection(context, l10n, points),
                loading: () => const _ShimmerRow(),
                error: (_, _) => _buildPointsSection(context, l10n, null),
              ),

              const Divider(height: 24),

              // Daily Challenges
              userChallengesAsync.when(
                data: (challenges) => _buildChallengesSection(context, l10n, challenges),
                loading: () => const _ShimmerRow(),
                error: (_, _) => _buildChallengesSection(context, l10n, []),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsSection(BuildContext context, AppLocalizations l10n, UserPoints? points) {
    final level = points?.currentLevel ?? 1;
    final totalPoints = points?.totalPoints ?? 0;
    final streak = points?.currentStreak ?? 0;
    final progress = points?.levelProgress ?? 0.0;

    return Column(
      children: [
        Row(
          children: [
            // Level badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.gamification_level} $level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Total points
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalPoints ${l10n.gamification_points}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Streak
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: streak > 0 ? AppColors.warning.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: streak > 0 ? AppColors.warning : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$streak',
                    style: TextStyle(
                      color: streak > 0 ? AppColors.warning : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChallengesSection(
    BuildContext context,
    AppLocalizations l10n,
    List<UserChallenge> challenges,
  ) {
    // Get daily challenges that are not yet completed
    final activeDailyChallenges = challenges
        .where((c) => c.challenge.challengeType == ChallengeType.daily && !c.isCompleted)
        .toList();

    if (activeDailyChallenges.isEmpty) {
      return InkWell(
        onTap: () => context.push(AppRoutes.challenges),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.check_circle, color: AppColors.success, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.gamification_allChallengesComplete,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.success,
                    ),
              ),
            ),
            Text(
              l10n.gamification_viewAll,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
      );
    }

    // Show the first active challenge
    final challenge = activeDailyChallenges.first;
    final progressPercent = challenge.progressPercent;

    return InkWell(
      onTap: () => context.push(AppRoutes.challenges),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.flag, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.challenge.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressPercent,
                          backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                          valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${challenge.progress}/${challenge.challenge.targetValue}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${challenge.challenge.pointsReward}',
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
