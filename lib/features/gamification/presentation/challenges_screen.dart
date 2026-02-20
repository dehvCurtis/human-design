import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../domain/gamification_providers.dart';
import '../domain/models/gamification.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userChallengesAsync = ref.watch(userChallengesProvider);
    final pointsAsync = ref.watch(userPointsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Points summary
          pointsAsync.when(
            data: (points) => points != null
                ? _PointsSummary(points: points)
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),

          // Challenges tabs
          Expanded(
            child: userChallengesAsync.when(
              data: (challenges) => TabBarView(
                controller: _tabController,
                children: [
                  _ChallengesList(
                    challenges: challenges
                        .where((c) => c.challenge.challengeType == ChallengeType.daily)
                        .toList(),
                    emptyMessage: 'No daily challenges available',
                    onClaimReward: (challenge) => _claimReward(challenge),
                  ),
                  _ChallengesList(
                    challenges: challenges
                        .where((c) => c.challenge.challengeType == ChallengeType.weekly)
                        .toList(),
                    emptyMessage: 'No weekly challenges available',
                    onClaimReward: (challenge) => _claimReward(challenge),
                  ),
                  _ChallengesList(
                    challenges: challenges
                        .where((c) =>
                            c.challenge.challengeType == ChallengeType.monthly ||
                            c.challenge.challengeType == ChallengeType.special)
                        .toList(),
                    emptyMessage: 'No monthly challenges available',
                    onClaimReward: (challenge) => _claimReward(challenge),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text('Error loading challenges'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(userChallengesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _claimReward(UserChallenge challenge) async {
    // The reward is auto-claimed when challenge is completed
    // Show confirmation
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Claimed ${challenge.challenge.pointsReward} points!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _PointsSummary extends StatelessWidget {
  const _PointsSummary({required this.points});

  final UserPoints points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MiniStat(
            icon: Icons.diamond,
            label: 'Total Points',
            value: _formatNumber(points.totalPoints),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
          ),
          _MiniStat(
            icon: Icons.local_fire_department,
            label: 'Streak',
            value: '${points.currentStreak} days',
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
          ),
          _MiniStat(
            icon: Icons.star,
            label: 'Level',
            value: points.currentLevel.toString(),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
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

class _ChallengesList extends StatelessWidget {
  const _ChallengesList({
    required this.challenges,
    required this.emptyMessage,
    required this.onClaimReward,
  });

  final List<UserChallenge> challenges;
  final String emptyMessage;
  final Function(UserChallenge) onClaimReward;

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return _ChallengeCard(
          challenge: challenges[index],
          onClaimReward: () => onClaimReward(challenges[index]),
        );
      },
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.onClaimReward,
  });

  final UserChallenge challenge;
  final VoidCallback onClaimReward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = challenge.isCompleted;
    final progressPercent = challenge.progressPercent;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getActionIcon(challenge.challenge.actionType),
                    color: isCompleted
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.challenge.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        challenge.challenge.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Reward badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.diamond,
                        size: 14,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${challenge.challenge.pointsReward}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '${challenge.progress}/${challenge.challenge.targetValue}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressPercent,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      isCompleted ? theme.colorScheme.primary : theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),

            // Completed state
            if (isCompleted) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Completed!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (challenge.completedAt != null)
                    Text(
                      _formatDate(challenge.completedAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                ],
              ),
            ],

            // Type-specific filter info
            if ((challenge.challenge.hdTypeFilter?.isNotEmpty ?? false) ||
                (challenge.challenge.gateFilter?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  if (challenge.challenge.hdTypeFilter?.isNotEmpty ?? false)
                    Chip(
                      label: Text(challenge.challenge.hdTypeFilter!.join(', ')),
                      visualDensity: VisualDensity.compact,
                      labelStyle: theme.textTheme.labelSmall,
                    ),
                  if (challenge.challenge.gateFilter?.isNotEmpty ?? false)
                    Chip(
                      label: Text('Gates: ${challenge.challenge.gateFilter!.join(', ')}'),
                      visualDensity: VisualDensity.compact,
                      labelStyle: theme.textTheme.labelSmall,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  PointActionType _parseActionType(String value) {
    return PointActionType.values.firstWhere(
      (e) => e.dbValue == value,
      orElse: () => PointActionType.dailyLogin,
    );
  }

  IconData _getActionIcon(String actionTypeStr) {
    final actionType = _parseActionType(actionTypeStr);
    switch (actionType) {
      case PointActionType.dailyLogin:
        return Icons.login;
      case PointActionType.checkTransit:
        return Icons.wb_sunny;
      case PointActionType.saveAffirmation:
        return Icons.favorite;
      case PointActionType.journalEntry:
        return Icons.edit_note;
      case PointActionType.createPost:
        return Icons.post_add;
      case PointActionType.postReaction:
        return Icons.thumb_up;
      case PointActionType.comment:
        return Icons.comment;
      case PointActionType.friendAdded:
        return Icons.person_add;
      case PointActionType.shareChart:
        return Icons.share;
      case PointActionType.completeChallenge:
        return Icons.emoji_events;
      case PointActionType.streakBonus7:
      case PointActionType.streakBonus30:
        return Icons.local_fire_department;
      case PointActionType.badgeEarned:
        return Icons.military_tech;
      case PointActionType.referral:
        return Icons.group_add;
      case PointActionType.firstChart:
        return Icons.auto_graph;
      case PointActionType.premiumBonus:
        return Icons.workspace_premium;
      case PointActionType.quizComplete:
        return Icons.quiz;
      case PointActionType.quizPerfectScore:
        return Icons.star;
      case PointActionType.quizStreak7:
        return Icons.local_fire_department;
      case PointActionType.quizCategoryMastery:
        return Icons.school;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
