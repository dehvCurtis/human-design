import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/learning_providers.dart';
import '../domain/models/learning.dart';

class LiveSessionsScreen extends ConsumerStatefulWidget {
  const LiveSessionsScreen({super.key});

  @override
  ConsumerState<LiveSessionsScreen> createState() => _LiveSessionsScreenState();
}

class _LiveSessionsScreenState extends ConsumerState<LiveSessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.liveSessions_title),
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
          tabs: [
            Tab(text: l10n.liveSessions_upcoming),
            Tab(text: l10n.liveSessions_mySessions),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _UpcomingSessionsTab(),
          _MySessionsTab(),
        ],
      ),
    );
  }
}

class _UpcomingSessionsTab extends ConsumerWidget {
  const _UpcomingSessionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final sessionsAsync = ref.watch(upcomingSessionsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(upcomingSessionsProvider);
      },
      child: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.quiz_noQuizzes,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.quiz_checkBackLater,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return _SessionCard(
                session: sessions[index],
                onRegister: () => _registerForSession(context, ref, sessions[index]),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(l10n.liveSessions_errorLoading),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(upcomingSessionsProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerForSession(
    BuildContext context,
    WidgetRef ref,
    LiveSession session,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref.read(learningNotifierProvider.notifier).registerForSession(session.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.liveSessions_registeredSuccessfully)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'session')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _MySessionsTab extends ConsumerWidget {
  const _MySessionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final sessionsAsync = ref.watch(myRegisteredSessionsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myRegisteredSessionsProvider);
      },
      child: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.quiz_noQuizzes,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.quiz_checkBackLater,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return _SessionCard(
                session: sessions[index],
                showCancelButton: true,
                onCancel: () => _cancelRegistration(context, ref, sessions[index]),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(l10n.liveSessions_errorLoading),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(myRegisteredSessionsProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cancelRegistration(
    BuildContext context,
    WidgetRef ref,
    LiveSession session,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.liveSessions_cancelRegistration),
        content: Text(l10n.liveSessions_cancelRegistrationConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.liveSessions_no),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.liveSessions_yesCancel),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(learningNotifierProvider.notifier).cancelRegistration(session.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.liveSessions_registrationCancelled)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'session')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    this.onRegister,
    this.onCancel,
    this.showCancelButton = false,
  });

  final LiveSession session;
  final VoidCallback? onRegister;
  final VoidCallback? onCancel;
  final bool showCancelButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRegistered = session.isRegistered ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with type badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(
                  _getSessionTypeIcon(session.sessionType),
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _getSessionTypeName(session.sessionType),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (session.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PRO',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onTertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (session.isRecorded) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.videocam,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (session.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    session.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),

                // Host
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: session.hostAvatarUrl != null
                          ? NetworkImage(session.hostAvatarUrl!)
                          : null,
                      child: session.hostAvatarUrl == null
                          ? Text((session.hostName ?? 'H')[0].toUpperCase())
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hosted by ${session.hostName ?? 'Unknown'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Date and time
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(session.scheduledAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(session.scheduledAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${session.durationMinutes} min)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Participants
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      session.maxParticipants != null
                          ? '${session.currentParticipants}/${session.maxParticipants} participants'
                          : '${session.currentParticipants} participants',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    if (session.isFull) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'FULL',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Action button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (showCancelButton)
                      TextButton(
                        onPressed: onCancel,
                        child: const Text('Cancel Registration'),
                      )
                    else if (isRegistered)
                      Chip(
                        label: const Text('Registered'),
                        avatar: Icon(
                          Icons.check_circle,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    else if (session.isFull)
                      OutlinedButton(
                        onPressed: null,
                        child: const Text('Session Full'),
                      )
                    else
                      FilledButton(
                        onPressed: onRegister,
                        child: const Text('Register'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSessionTypeIcon(SessionType type) {
    switch (type) {
      case SessionType.workshop:
        return Icons.build;
      case SessionType.qAndA:
        return Icons.question_answer;
      case SessionType.groupReading:
        return Icons.auto_graph;
      case SessionType.studyGroup:
        return Icons.groups;
      case SessionType.meditation:
        return Icons.self_improvement;
    }
  }

  String _getSessionTypeName(SessionType type) {
    switch (type) {
      case SessionType.workshop:
        return 'Workshop';
      case SessionType.qAndA:
        return 'Q&A';
      case SessionType.groupReading:
        return 'Group Reading';
      case SessionType.studyGroup:
        return 'Study Group';
      case SessionType.meditation:
        return 'Meditation';
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    }
    if (dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day) {
      return 'Tomorrow';
    }

    final weekday = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ][dateTime.weekday - 1];
    return '$weekday, ${dateTime.day}/${dateTime.month}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
