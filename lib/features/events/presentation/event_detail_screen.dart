import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../domain/event_providers.dart';

/// Event detail screen with RSVP and participant list
class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));
    final isRegisteredAsync = ref.watch(isRegisteredProvider(eventId));
    final participantsAsync = ref.watch(eventParticipantsProvider(eventId));
    final actionState = ref.watch(eventActionNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = ref.watch(currentUserIdProvider);
    final dateFormat = DateFormat('EEEE, MMM d, yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.events_title),
        actions: [
          eventAsync.whenOrNull(
                data: (event) => event.creatorId == currentUserId
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, ref),
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: eventAsync.when(
        data: (event) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Date and time
                _InfoRow(
                  icon: Icons.schedule,
                  label: l10n.events_startDate,
                  value: dateFormat.format(event.startsAt.toLocal()),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.schedule,
                  label: l10n.events_endDate,
                  value: dateFormat.format(event.endsAt.toLocal()),
                ),
                const SizedBox(height: 8),

                // Location
                if (event.location != null) ...[
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: l10n.events_location,
                    value: event.location!,
                  ),
                  const SizedBox(height: 8),
                ],

                // Virtual link (only show to registered users)
                if (event.virtualLink != null)
                  isRegisteredAsync.when(
                    data: (isRegistered) => isRegistered
                        ? _InfoRow(
                            icon: Icons.videocam_outlined,
                            label: l10n.events_virtualLink,
                            value: event.virtualLink!,
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),

                const SizedBox(height: 16),

                // Participants count
                _InfoRow(
                  icon: Icons.people_outline,
                  label: 'Participants',
                  value: event.maxParticipants != null
                      ? '${event.currentParticipants}/${event.maxParticipants}'
                      : '${event.currentParticipants}',
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 24),

                // RSVP button
                if (!event.isPast)
                  SizedBox(
                    width: double.infinity,
                    child: isRegisteredAsync.when(
                      data: (isRegistered) {
                        if (isRegistered) {
                          return OutlinedButton(
                            onPressed: actionState.isLoading
                                ? null
                                : () => ref
                                    .read(eventActionNotifierProvider.notifier)
                                    .cancelRegistration(eventId),
                            child: Text(l10n.events_cancelRegistration),
                          );
                        }

                        if (event.isFull) {
                          return FilledButton(
                            onPressed: null,
                            child: Text(l10n.events_registrationFull),
                          );
                        }

                        return FilledButton(
                          onPressed: actionState.isLoading
                              ? null
                              : () => ref
                                  .read(eventActionNotifierProvider.notifier)
                                  .register(eventId),
                          child: actionState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.events_register),
                        );
                      },
                      loading: () => const FilledButton(
                        onPressed: null,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                  ),

                const SizedBox(height: 24),

                // Participant list
                Text(
                  'Participants',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                participantsAsync.when(
                  data: (participants) {
                    if (participants.isEmpty) {
                      return Text(
                        'No participants yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      );
                    }

                    return Column(
                      children: participants.map((p) {
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(p.userName ?? 'User'),
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.events_notFound)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.common_delete),
        content: Text(l10n.common_deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(eventActionNotifierProvider.notifier)
                  .deleteEvent(eventId);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              l10n.common_delete,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
