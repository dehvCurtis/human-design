import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/group_challenge_providers.dart';
import '../domain/models/group_challenge.dart';

class GroupChallengeDetailScreen extends ConsumerWidget {
  const GroupChallengeDetailScreen({super.key, required this.challengeId});

  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final challengeAsync = ref.watch(groupChallengeProvider(challengeId));
    final myTeamsAsync = ref.watch(myTeamsProvider);

    return challengeAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(ErrorHandler.getUserMessage(e))),
      ),
      data: (challenge) {
        if (challenge == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.groupChallenges_challengeNotFound)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.groupChallenges_challengeDetails),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Challenge header
                _ChallengeHeader(challenge: challenge),
                const SizedBox(height: 24),

                // Challenge details
                _ChallengeDetails(challenge: challenge),
                const SizedBox(height: 24),

                // Enroll team section
                myTeamsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text(ErrorHandler.getUserMessage(e)),
                  data: (teams) {
                    if (teams.isEmpty) {
                      return _NoTeamsCard();
                    }
                    return _EnrollTeamSection(
                      teams: teams,
                      challengeId: challengeId,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Leaderboard
                Text(
                  l10n.groupChallenges_leaderboard,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _ChallengeLeaderboard(challengeId: challengeId),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChallengeHeader extends StatelessWidget {
  const _ChallengeHeader({required this.challenge});

  final GroupChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getChallengeIcon(challenge.challengeType),
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: challenge.isOngoing
                              ? Colors.green.withValues(alpha: 0.2)
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          challenge.isOngoing
                              ? l10n.groupChallenges_active
                              : l10n.groupChallenges_upcoming,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: challenge.isOngoing ? Colors.green : null,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              challenge.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getChallengeIcon(GroupChallengeType type) {
    switch (type) {
      case GroupChallengeType.teamPosts:
        return Icons.post_add;
      case GroupChallengeType.teamReactions:
        return Icons.favorite;
      case GroupChallengeType.teamComments:
        return Icons.comment;
      case GroupChallengeType.teamQuizzes:
        return Icons.quiz;
      case GroupChallengeType.teamStreaks:
        return Icons.local_fire_department;
    }
  }
}

class _ChallengeDetails extends StatelessWidget {
  const _ChallengeDetails({required this.challenge});

  final GroupChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _DetailRow(
              icon: Icons.flag,
              label: l10n.groupChallenges_target,
              value: challenge.targetValue.toString(),
            ),
            const Divider(height: 24),
            _DetailRow(
              icon: Icons.star,
              label: l10n.groupChallenges_reward(challenge.pointsReward),
              value: '',
              valueColor: Colors.amber,
            ),
            const Divider(height: 24),
            _DetailRow(
              icon: Icons.groups,
              label: l10n.groupChallenges_teamsEnrolled(''),
              value: challenge.teamCount.toString(),
            ),
            const Divider(height: 24),
            _DetailRow(
              icon: Icons.people,
              label: l10n.groupChallenges_participants(''),
              value: challenge.totalParticipants.toString(),
            ),
            if (challenge.startDate != null) ...[
              const Divider(height: 24),
              _DetailRow(
                icon: Icons.event,
                label: l10n.groupChallenges_starts,
                value: _formatDate(challenge.startDate!),
              ),
            ],
            if (challenge.endDate != null) ...[
              const Divider(height: 24),
              _DetailRow(
                icon: Icons.event_busy,
                label: l10n.groupChallenges_ends,
                value: _formatDate(challenge.endDate!),
              ),
            ],
            if (challenge.hdTypeFilter != null && challenge.hdTypeFilter!.isNotEmpty) ...[
              const Divider(height: 24),
              _DetailRow(
                icon: Icons.filter_alt,
                label: l10n.groupChallenges_hdTypes,
                value: challenge.hdTypeFilter!.join(', '),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _NoTeamsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.groups_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.groupChallenges_noTeamsToEnroll,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.groupChallenges_createTeamToJoin,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.push('/group-challenges'),
              icon: const Icon(Icons.add),
              label: Text(l10n.groupChallenges_createTeam),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnrollTeamSection extends ConsumerWidget {
  const _EnrollTeamSection({
    required this.teams,
    required this.challengeId,
  });

  final List<ChallengeTeam> teams;
  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.groupChallenges_enrollTeam,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...teams.map((team) => _TeamEnrollTile(
              team: team,
              challengeId: challengeId,
            )),
          ],
        ),
      ),
    );
  }
}

class _TeamEnrollTile extends ConsumerWidget {
  const _TeamEnrollTile({
    required this.team,
    required this.challengeId,
  });

  final ChallengeTeam team;
  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final progressAsync = ref.watch(teamChallengeProgressProvider((
      teamId: team.id,
      challengeId: challengeId,
    )));

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: team.avatarUrl != null
            ? NetworkImage(team.avatarUrl!)
            : null,
        child: team.avatarUrl == null
            ? Text(team.name[0].toUpperCase())
            : null,
      ),
      title: Text(team.name),
      subtitle: Text(l10n.groupChallenges_memberCount(team.memberCount)),
      trailing: progressAsync.when(
        loading: () => const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (_, _) => const Icon(Icons.error_outline),
        data: (progress) {
          if (progress != null) {
            return Chip(
              label: Text(l10n.groupChallenges_enrolled),
              backgroundColor: Colors.green.withValues(alpha: 0.2),
            );
          }

          return FilledButton(
            onPressed: () => _enrollTeam(context, ref),
            child: Text(l10n.groupChallenges_enroll),
          );
        },
      ),
    );
  }

  Future<void> _enrollTeam(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(groupChallengeNotifierProvider.notifier);
    final success = await notifier.enrollTeamInChallenge(team.id, challengeId);

    if (context.mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.groupChallenges_teamEnrolled)),
      );
    }
  }
}

class _ChallengeLeaderboard extends ConsumerWidget {
  const _ChallengeLeaderboard({required this.challengeId});

  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final leaderboardAsync = ref.watch(challengeLeaderboardProvider(challengeId));

    return leaderboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text(ErrorHandler.getUserMessage(e)),
      data: (entries) {
        if (entries.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.leaderboard_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.groupChallenges_noTeamsEnrolled,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Card(
          child: Column(
            children: entries.take(10).map((entry) {
              return ListTile(
                leading: _RankBadge(rank: entry.rank),
                title: Text(entry.team.name),
                subtitle: Text(l10n.groupChallenges_memberCount(entry.team.memberCount)),
                trailing: Text(
                  entry.points.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () => context.push('/team/${entry.team.id}'),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    if (rank <= 3) {
      final color = switch (rank) {
        1 => Colors.amber,
        2 => Colors.grey.shade400,
        3 => Colors.brown.shade400,
        _ => Colors.grey,
      };

      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.emoji_events,
            size: 18,
            color: color,
          ),
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
