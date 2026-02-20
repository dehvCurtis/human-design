import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/models/transit_event.dart';
import '../domain/transit_event_providers.dart';

/// Screen showing transit events and community participation
class TransitEventsScreen extends ConsumerWidget {
  const TransitEventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.transit_events_title),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(text: l10n.transit_events_happening),
              Tab(text: l10n.transit_events_upcoming),
              Tab(text: l10n.transit_events_past),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CurrentEventsTab(),
            _UpcomingEventsTab(),
            _PastEventsTab(),
          ],
        ),
      ),
    );
  }
}

class _CurrentEventsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentAsync = ref.watch(currentEventsProvider);

    return currentAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return _EmptyState(
            icon: Icons.event_busy,
            message: l10n.transit_events_noCurrentEvents,
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(currentEventsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _TransitEventCard(
                event: events[index],
                showTimer: true,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(currentEventsProvider),
      ),
    );
  }
}

class _UpcomingEventsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final upcomingAsync = ref.watch(upcomingEventsProvider);

    return upcomingAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return _EmptyState(
            icon: Icons.event,
            message: l10n.transit_events_noUpcomingEvents,
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(upcomingEventsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _TransitEventCard(
                event: events[index],
                showCountdown: true,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(upcomingEventsProvider),
      ),
    );
  }
}

class _PastEventsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pastAsync = ref.watch(pastEventsProvider);

    return pastAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return _EmptyState(
            icon: Icons.history,
            message: l10n.transit_events_noPastEvents,
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(pastEventsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _TransitEventCard(event: events[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(pastEventsProvider),
      ),
    );
  }
}

class _TransitEventCard extends ConsumerWidget {
  const _TransitEventCard({
    required this.event,
    this.showTimer = false,
    this.showCountdown = false,
  });

  final TransitEvent event;
  final bool showTimer;
  final bool showCountdown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isParticipatingAsync = ref.watch(isParticipatingProvider(event.id));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/transit-event/${event.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getEventColor(event.eventType),
                    _getEventColor(event.eventType).withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Event type icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        event.eventType.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${event.eventType.displayName} \u00b7 Gate ${event.gateNumber}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Live indicator or countdown
                  if (event.isCurrentlyActive)
                    Container(
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
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    event.description,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Timer or Countdown
                  if (showTimer && event.isCurrentlyActive)
                    _EventTimer(event: event),
                  if (showCountdown && event.isUpcoming)
                    _EventCountdown(event: event),

                  // Stats
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.people_outline,
                        count: event.participantCount,
                        label: l10n.transit_events_participating,
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.chat_bubble_outline,
                        count: event.postCount,
                        label: l10n.transit_events_posts,
                      ),
                      const Spacer(),

                      // Join button
                      isParticipatingAsync.when(
                        data: (isParticipating) {
                          if (event.hasEnded) {
                            return TextButton(
                              onPressed: () => context.push('/transit-event/${event.id}'),
                              child: Text(l10n.transit_events_viewInsights),
                            );
                          }

                          return isParticipating
                              ? OutlinedButton.icon(
                                  onPressed: () => context.push('/transit-event/${event.id}'),
                                  icon: const Icon(Icons.check, size: 16),
                                  label: Text(l10n.transit_events_joined),
                                )
                              : FilledButton(
                                  onPressed: () async {
                                    await ref.read(transitEventNotifierProvider.notifier)
                                        .joinEvent(event.id);
                                  },
                                  child: Text(l10n.transit_events_join),
                                );
                        },
                        loading: () => const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

class _EventTimer extends StatelessWidget {
  const _EventTimer({required this.event});

  final TransitEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final remaining = event.timeUntilEnd;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 16,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.transit_events_endsIn(_formatDuration(remaining)),
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }
}

class _EventCountdown extends StatelessWidget {
  const _EventCountdown({required this.event});

  final TransitEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final timeUntil = event.timeUntilStart;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: 16,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.transit_events_startsIn(_formatDuration(timeUntil)),
            style: TextStyle(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.count,
    required this.label,
  });

  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.outline),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(ErrorHandler.getUserMessage(error)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }
}
