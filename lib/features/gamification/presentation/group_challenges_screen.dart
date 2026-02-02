import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/group_challenge_providers.dart';
import '../domain/models/group_challenge.dart';

class GroupChallengesScreen extends ConsumerWidget {
  const GroupChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.groupChallenges_title),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.groupChallenges_myTeams),
              Tab(text: l10n.groupChallenges_challenges),
              Tab(text: l10n.groupChallenges_leaderboard),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showCreateTeamDialog(context, ref),
              tooltip: l10n.groupChallenges_createTeam,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _MyTeamsTab(),
            _ChallengesTab(),
            _LeaderboardTab(),
          ],
        ),
      ),
    );
  }

  void _showCreateTeamDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.groupChallenges_createTeam),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.groupChallenges_teamName,
                hintText: l10n.groupChallenges_teamNameHint,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: l10n.groupChallenges_teamDescription,
                hintText: l10n.groupChallenges_teamDescriptionHint,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;

              final notifier = ref.read(groupChallengeNotifierProvider.notifier);
              final team = await notifier.createTeam(
                name: nameController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
              );

              if (context.mounted) {
                Navigator.pop(context);
                if (team != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.groupChallenges_teamCreated)),
                  );
                }
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }
}

class _MyTeamsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final teamsAsync = ref.watch(myTeamsProvider);

    return teamsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
      data: (teams) {
        if (teams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.groups_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.groupChallenges_noTeams,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.groupChallenges_noTeamsDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(myTeamsProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return _TeamCard(team: team);
            },
          ),
        );
      },
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.team});

  final ChallengeTeam team;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/team/${team.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: team.avatarUrl != null
                    ? NetworkImage(team.avatarUrl!)
                    : null,
                child: team.avatarUrl == null
                    ? Text(team.name[0].toUpperCase())
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (team.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        team.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.groupChallenges_memberCount(team.memberCount),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.groupChallenges_points(team.totalPoints),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final challengesAsync = ref.watch(activeGroupChallengesProvider);

    return challengesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
      data: (challenges) {
        if (challenges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.groupChallenges_noChallenges,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(activeGroupChallengesProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return _GroupChallengeCard(challenge: challenge);
            },
          ),
        );
      },
    );
  }
}

class _GroupChallengeCard extends StatelessWidget {
  const _GroupChallengeCard({required this.challenge});

  final GroupChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/group-challenge/${challenge.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: challenge.isOngoing
                          ? Colors.green.withValues(alpha: 0.2)
                          : Theme.of(context).colorScheme.primaryContainer,
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
                  const Spacer(),
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.groupChallenges_reward(challenge.pointsReward),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                challenge.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                challenge.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.groups,
                    label: l10n.groupChallenges_teamsEnrolled(challenge.teamCount.toString()),
                  ),
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Icons.people,
                    label: l10n.groupChallenges_participants(challenge.totalParticipants.toString()),
                  ),
                ],
              ),
              if (challenge.endDate != null) ...[
                const SizedBox(height: 8),
                _InfoChip(
                  icon: Icons.timer,
                  label: l10n.groupChallenges_endsIn(_formatDuration(challenge.endDate!.difference(DateTime.now()))),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

class _LeaderboardTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends ConsumerState<_LeaderboardTab> {
  TeamLeaderboardType _selectedType = TeamLeaderboardType.allTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final leaderboardAsync = ref.watch(teamLeaderboardProvider(_selectedType));

    return Column(
      children: [
        // Type selector
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<TeamLeaderboardType>(
            segments: [
              ButtonSegment(
                value: TeamLeaderboardType.weekly,
                label: Text(l10n.groupChallenges_weekly),
              ),
              ButtonSegment(
                value: TeamLeaderboardType.monthly,
                label: Text(l10n.groupChallenges_monthly),
              ),
              ButtonSegment(
                value: TeamLeaderboardType.allTime,
                label: Text(l10n.groupChallenges_allTime),
              ),
            ],
            selected: {_selectedType},
            onSelectionChanged: (selected) {
              setState(() => _selectedType = selected.first);
            },
          ),
        ),

        // Leaderboard list
        Expanded(
          child: leaderboardAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
            data: (entries) {
              if (entries.isEmpty) {
                return Center(
                  child: Text(l10n.groupChallenges_noTeamsOnLeaderboard),
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.refresh(teamLeaderboardProvider(_selectedType).future),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _LeaderboardEntry(entry: entry, type: _selectedType);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LeaderboardEntry extends StatelessWidget {
  const _LeaderboardEntry({required this.entry, required this.type});

  final TeamLeaderboardEntry entry;
  final TeamLeaderboardType type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final points = switch (type) {
      TeamLeaderboardType.weekly => entry.weeklyPoints ?? entry.points,
      TeamLeaderboardType.monthly => entry.monthlyPoints ?? entry.points,
      _ => entry.points,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.push('/team/${entry.team.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Rank
              SizedBox(
                width: 40,
                child: _RankBadge(rank: entry.rank),
              ),
              const SizedBox(width: 12),
              // Team avatar
              CircleAvatar(
                radius: 20,
                backgroundImage: entry.team.avatarUrl != null
                    ? NetworkImage(entry.team.avatarUrl!)
                    : null,
                child: entry.team.avatarUrl == null
                    ? Text(entry.team.name[0].toUpperCase())
                    : null,
              ),
              const SizedBox(width: 12),
              // Team info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.team.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.groupChallenges_memberCount(entry.team.memberCount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              // Points
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    points.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    l10n.groupChallenges_pts,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
