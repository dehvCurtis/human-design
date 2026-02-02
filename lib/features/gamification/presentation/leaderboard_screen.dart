import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/error_handler.dart';
import '../domain/gamification_providers.dart';
import '../domain/models/gamification.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
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
          tabs: const [
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'All Time'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _LeaderboardTab(type: LeaderboardType.weekly),
          _LeaderboardTab(type: LeaderboardType.monthly),
          _LeaderboardTab(type: LeaderboardType.allTime),
        ],
      ),
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  const _LeaderboardTab({required this.type});

  final LeaderboardType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider(type));
    final userRankAsync = ref.watch(userRankProvider(type));

    return leaderboardAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.leaderboard_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No rankings yet'),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Top 3 podium
            if (entries.length >= 3)
              _Podium(
                first: entries[0],
                second: entries[1],
                third: entries[2],
              ),

            // Your rank
            userRankAsync.when(
              data: (rank) => rank > 0
                  ? _YourRankCard(rank: rank, type: type)
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Rest of the list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: entries.length > 3 ? entries.length - 3 : 0,
                itemBuilder: (context, index) {
                  final entry = entries[index + 3];
                  return _RankingTile(entry: entry);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(ErrorHandler.getUserMessage(e)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(leaderboardProvider(type)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({
    required this.first,
    required this.second,
    required this.third,
  });

  final LeaderboardEntry first;
  final LeaderboardEntry second;
  final LeaderboardEntry third;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primary.withValues(alpha: 0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Second place
          _PodiumPlace(
            entry: second,
            rank: 2,
            height: 80,
            color: const Color(0xFFC0C0C0), // Silver
          ),
          const SizedBox(width: 8),
          // First place
          _PodiumPlace(
            entry: first,
            rank: 1,
            height: 100,
            color: const Color(0xFFFFD700), // Gold
          ),
          const SizedBox(width: 8),
          // Third place
          _PodiumPlace(
            entry: third,
            rank: 3,
            height: 60,
            color: const Color(0xFFCD7F32), // Bronze
          ),
        ],
      ),
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  const _PodiumPlace({
    required this.entry,
    required this.rank,
    required this.height,
    required this.color,
  });

  final LeaderboardEntry entry;
  final int rank;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: rank == 1 ? 36 : 28,
              backgroundColor: color,
              child: CircleAvatar(
                radius: rank == 1 ? 32 : 24,
                backgroundImage: entry.userAvatarUrl != null
                    ? NetworkImage(entry.userAvatarUrl!)
                    : null,
                child: entry.userAvatarUrl == null
                    ? Text(
                        entry.userName[0].toUpperCase(),
                        style: TextStyle(fontSize: rank == 1 ? 24 : 18),
                      )
                    : null,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$rank',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Name
        SizedBox(
          width: 80,
          child: Text(
            entry.userName,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Points
        Text(
          '${_formatPoints(entry.points)} pts',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        // Podium block
        Container(
          width: 70,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withValues(alpha: 0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              _getRankEmoji(rank),
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}K';
    }
    return points.toString();
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '1';
      case 2:
        return '2';
      case 3:
        return '3';
      default:
        return '$rank';
    }
  }
}

class _YourRankCard extends StatelessWidget {
  const _YourRankCard({
    required this.rank,
    required this.type,
  });

  final int rank;
  final LeaderboardType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 12),
          Text(
            'Your Rank:',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '#$rank',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Text(
            _getTypeName(type),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeName(LeaderboardType type) {
    switch (type) {
      case LeaderboardType.weekly:
        return 'This Week';
      case LeaderboardType.monthly:
        return 'This Month';
      case LeaderboardType.allTime:
        return 'All Time';
      case LeaderboardType.streak:
        return 'Streak';
    }
  }
}

class _RankingTile extends StatelessWidget {
  const _RankingTile({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '#${entry.rank}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundImage: entry.userAvatarUrl != null
                  ? NetworkImage(entry.userAvatarUrl!)
                  : null,
              child: entry.userAvatarUrl == null
                  ? Text(entry.userName[0].toUpperCase())
                  : null,
            ),
          ],
        ),
        title: Text(
          entry.userName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: entry.userHdType != null
            ? Text(
                entry.userHdType!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              )
            : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatPoints(entry.points),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'points',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}K';
    }
    return points.toString();
  }
}
