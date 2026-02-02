import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/group_challenge_providers.dart';
import '../domain/models/group_challenge.dart';

class TeamDetailScreen extends ConsumerWidget {
  const TeamDetailScreen({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final teamAsync = ref.watch(teamProvider(teamId));
    final isMemberAsync = ref.watch(isTeamMemberProvider(teamId));

    return teamAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(ErrorHandler.getUserMessage(e))),
      ),
      data: (team) {
        if (team == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.groupChallenges_teamNotFound)),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App bar with team header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(team.name),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: team.avatarUrl != null
                            ? NetworkImage(team.avatarUrl!)
                            : null,
                        child: team.avatarUrl == null
                            ? Text(
                                team.name[0].toUpperCase(),
                                style: const TextStyle(fontSize: 32),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              // Team stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Icons.people,
                        value: team.memberCount.toString(),
                        label: l10n.groupChallenges_members,
                      ),
                      _StatItem(
                        icon: Icons.star,
                        value: team.totalPoints.toString(),
                        label: l10n.groupChallenges_totalPoints,
                      ),
                      isMemberAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (isMember) => _StatItem(
                          icon: isMember ? Icons.check_circle : Icons.add_circle_outline,
                          value: isMember ? l10n.groupChallenges_joined : l10n.groupChallenges_join,
                          label: l10n.groupChallenges_status,
                          onTap: isMember ? null : () => _joinTeam(context, ref),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Description
              if (team.description != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.groupChallenges_about,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(team.description!),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Members section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    l10n.groupChallenges_members,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Members list
              _TeamMembersList(teamId: teamId),

              // Leave team button (if member)
              isMemberAsync.when(
                loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                data: (isMember) {
                  if (!isMember) return const SliverToBoxAdapter(child: SizedBox.shrink());

                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: OutlinedButton(
                        onPressed: () => _showLeaveConfirmation(context, ref),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: Text(l10n.groupChallenges_leaveTeam),
                      ),
                    ),
                  );
                },
              ),

              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          ),
        );
      },
    );
  }

  void _joinTeam(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(groupChallengeNotifierProvider.notifier);
    final success = await notifier.joinTeam(teamId);

    if (context.mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.groupChallenges_joinedTeam)),
      );
    }
  }

  void _showLeaveConfirmation(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.groupChallenges_leaveTeam),
        content: Text(l10n.groupChallenges_leaveConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final notifier = ref.read(groupChallengeNotifierProvider.notifier);
              final success = await notifier.leaveTeam(teamId);

              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.groupChallenges_leftTeam)),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.groupChallenges_leave),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: onTap != null
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: onTap != null ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: content,
        ),
      );
    }

    return content;
  }
}

class _TeamMembersList extends ConsumerWidget {
  const _TeamMembersList({required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(teamMembersProvider(teamId));

    return membersAsync.when(
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: Center(child: Text(ErrorHandler.getUserMessage(e))),
      ),
      data: (members) {
        if (members.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text(l10n.groupChallenges_noMembers)),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final member = members[index];
              return _MemberTile(member: member);
            },
            childCount: members.length,
          ),
        );
      },
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: member.userAvatarUrl != null
            ? NetworkImage(member.userAvatarUrl!)
            : null,
        child: member.userAvatarUrl == null
            ? Text(member.userName[0].toUpperCase())
            : null,
      ),
      title: Row(
        children: [
          Text(member.userName),
          if (member.role == TeamRole.admin) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.groupChallenges_admin,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ],
      ),
      subtitle: Row(
        children: [
          if (member.userHdType != null) ...[
            Text(member.userHdType!),
            const SizedBox(width: 8),
            const Text('\u{2022}'),
            const SizedBox(width: 8),
          ],
          Text(l10n.groupChallenges_contributed(member.pointsContributed)),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            member.pointsContributed.toString(),
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
    );
  }
}
