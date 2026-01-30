import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../domain/activity_providers.dart';
import '../domain/models/activity.dart';

/// Screen showing friend activity feed
class ActivityFeedScreen extends ConsumerWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final activitiesAsync = ref.watch(friendActivityFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activity_title),
      ),
      body: activitiesAsync.when(
        data: (activities) {
          if (activities.isEmpty) {
            return _EmptyActivityFeed();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(friendActivityFeedProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _ActivityCard(activity: activity);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(friendActivityFeedProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends ConsumerWidget {
  const _ActivityCard({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasReactedAsync = ref.watch(hasReactedProvider(activity.id));
    final reactionCountAsync = ref.watch(activityReactionCountProvider(activity.id));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info and time
            Row(
              children: [
                // User avatar with HD type border
                GestureDetector(
                  onTap: () {
                    // Navigate to user profile
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getTypeColor(activity.userHdType),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: activity.userAvatarUrl != null
                          ? NetworkImage(activity.userAvatarUrl!)
                          : null,
                      child: activity.userAvatarUrl == null
                          ? Text(activity.userName.isNotEmpty
                              ? activity.userName[0].toUpperCase()
                              : '?')
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Activity type icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getActivityColor(activity.activityType).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      activity.activityType.emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // User name and activity description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: activity.userName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' ${activity.getDescription()}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimeAgo(activity.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Reaction section
            Row(
              children: [
                // Reaction count
                reactionCountAsync.when(
                  data: (count) => count > 0
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            '$count ${count == 1 ? 'celebration' : 'celebrations'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const Spacer(),

                // Celebrate button
                hasReactedAsync.when(
                  data: (hasReacted) => hasReacted
                      ? OutlinedButton.icon(
                          onPressed: () {
                            ref.read(activityNotifierProvider.notifier)
                                .removeReaction(activity.id);
                          },
                          icon: const Text('\u{1F389}'), // 🎉
                          label: Text(l10n.activity_celebrated),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _getActivityColor(activity.activityType),
                            side: BorderSide(
                              color: _getActivityColor(activity.activityType),
                            ),
                          ),
                        )
                      : TextButton.icon(
                          onPressed: () {
                            ref.read(activityNotifierProvider.notifier)
                                .reactToActivity(activity.id);
                          },
                          icon: const Text('\u{1F389}'), // 🎉
                          label: Text(l10n.activity_celebrate),
                        ),
                  loading: () => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${dateTime.day}/${dateTime.month}';
  }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'Generator':
        return Colors.orange;
      case 'Manifesting Generator':
        return Colors.deepOrange;
      case 'Projector':
        return Colors.blue;
      case 'Manifestor':
        return Colors.red;
      case 'Reflector':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.completedChallenge:
        return Colors.amber;
      case ActivityType.earnedBadge:
        return Colors.purple;
      case ActivityType.reachedLevel:
        return Colors.amber;
      case ActivityType.sharedChart:
        return Colors.indigo;
      case ActivityType.createdPost:
        return Colors.blue;
      case ActivityType.followedUser:
        return Colors.teal;
      case ActivityType.joinedGroup:
        return Colors.green;
      case ActivityType.completedQuiz:
        return Colors.orange;
      case ActivityType.achievedStreak:
        return Colors.red;
      case ActivityType.joinedTransitEvent:
        return Colors.cyan;
    }
  }
}

class _EmptyActivityFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.activity_noActivities,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.activity_followFriends,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push('/discover'),
              icon: const Icon(Icons.search),
              label: Text(l10n.activity_findFriends),
            ),
          ],
        ),
      ),
    );
  }
}
