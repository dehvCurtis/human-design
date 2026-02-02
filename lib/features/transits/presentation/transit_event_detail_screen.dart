import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../feed/domain/feed_providers.dart';
import '../../feed/presentation/widgets/post_card.dart';
import '../domain/models/transit_event.dart';
import '../domain/transit_event_providers.dart';

/// Detail screen for a transit event
class TransitEventDetailScreen extends ConsumerWidget {
  const TransitEventDetailScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final eventAsync = ref.watch(transitEventProvider(eventId));
    final isParticipatingAsync = ref.watch(isParticipatingProvider(eventId));
    final postsAsync = ref.watch(eventPostsProvider(eventId));

    return eventAsync.when(
      data: (event) {
        if (event == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.transit_events_title)),
            body: Center(child: Text(l10n.transit_events_notFound)),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App bar with event header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(event.title),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getEventColor(event.eventType),
                          _getEventColor(event.eventType).withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            event.eventType.emoji,
                            style: const TextStyle(fontSize: 64),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gate ${event.gateNumber}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  if (event.isCurrentlyActive)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.transit_events_live,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              // Event info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        event.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),

                      // Stats row
                      _StatsRow(event: event),
                      const SizedBox(height: 16),

                      // Participation section
                      isParticipatingAsync.when(
                        data: (isParticipating) => _ParticipationSection(
                          event: event,
                          isParticipating: isParticipating,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 24),

                      // Community posts section
                      Text(
                        l10n.transit_events_communityPosts,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Posts list
              postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.transit_events_noPosts,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => _showCreatePostForEvent(context, event),
                              icon: const Icon(Icons.add),
                              label: Text(l10n.transit_events_shareExperience),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = posts[index];
                        return PostCard(
                          post: post,
                          onTap: () => context.push('/feed/post/${post.id}'),
                          onReaction: (type) {
                            ref.read(feedNotifierProvider.notifier).reactToPost(post.id, type);
                          },
                          onComment: () => context.push('/feed/post/${post.id}'),
                          onShare: () {},
                          onUserTap: () {},
                          onHashtagTap: (hashtag) => context.push('/hashtag/$hashtag'),
                        );
                      },
                      childCount: posts.length,
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: Text(ErrorHandler.getUserMessage(error))),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: isParticipatingAsync.when(
            data: (isParticipating) {
              if (isParticipating && !event.hasEnded) {
                return FloatingActionButton.extended(
                  onPressed: () => _showCreatePostForEvent(context, event),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.transit_events_shareExperience),
                );
              }
              return null;
            },
            loading: () => null,
            error: (_, _) => null,
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.transit_events_title)),
        body: Center(child: Text(ErrorHandler.getUserMessage(error))),
      ),
    );
  }

  void _showCreatePostForEvent(BuildContext context, TransitEvent event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share about ${event.title}')),
    );
  }

  Color _getEventColor(TransitEventType type) {
    switch (type) {
      case TransitEventType.sunTransit:
        return Colors.amber.shade700;
      case TransitEventType.moonTransit:
        return Colors.indigo;
      case TransitEventType.newYear:
        return Colors.purple;
      case TransitEventType.fullMoon:
        return Colors.blue.shade300;
      case TransitEventType.newMoon:
        return Colors.blueGrey;
      case TransitEventType.planetaryReturn:
        return Colors.teal;
      case TransitEventType.channelActivation:
        return Colors.orange;
    }
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.event});

  final TransitEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people,
            value: '${event.participantCount}',
            label: l10n.transit_events_participants,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.chat_bubble,
            value: '${event.postCount}',
            label: l10n.transit_events_posts,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.access_time,
            value: _formatDuration(event.duration),
            label: l10n.transit_events_duration,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    return '${duration.inMinutes}m';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipationSection extends ConsumerWidget {
  const _ParticipationSection({
    required this.event,
    required this.isParticipating,
  });

  final TransitEvent event;
  final bool isParticipating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (event.hasEnded) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.transit_events_eventEnded,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (isParticipating) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.transit_events_youreParticipating,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.transit_events_experiencingWith(event.participantCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(transitEventNotifierProvider.notifier).leaveEvent(event.id);
              },
              child: Text(l10n.transit_events_leave),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.transit_events_joinCommunity,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.transit_events_shareYourExperience,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(transitEventNotifierProvider.notifier).joinEvent(event.id);
            },
            child: Text(l10n.transit_events_join),
          ),
        ],
      ),
    );
  }
}
