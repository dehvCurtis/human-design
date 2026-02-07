import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/event_providers.dart';
import '../domain/models/event.dart';

/// Screen to create a new community event.
///
/// Security: Input validation both client-side (form validation)
/// and server-side (DB constraints + RLS).
class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _virtualLinkController = TextEditingController();
  final _maxParticipantsController = TextEditingController();

  EventType _eventType = EventType.online;
  DateTime _startsAt = DateTime.now().add(const Duration(days: 1));
  DateTime _endsAt = DateTime.now().add(const Duration(days: 1, hours: 1));
  String? _hdTypeFilter;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _virtualLinkController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final actionState = ref.watch(eventActionNotifierProvider);
    final dateFormat = DateFormat('MMM d, yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.events_create),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: l10n.events_eventTitle,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLength: 5000,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.events_eventDescription,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Event type
            Text(
              l10n.events_eventType,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SegmentedButton<EventType>(
              segments: [
                ButtonSegment(
                  value: EventType.online,
                  label: Text(l10n.events_online),
                  icon: const Icon(Icons.videocam_outlined),
                ),
                ButtonSegment(
                  value: EventType.inPerson,
                  label: Text(l10n.events_inPerson),
                  icon: const Icon(Icons.location_on_outlined),
                ),
                ButtonSegment(
                  value: EventType.hybrid,
                  label: Text(l10n.events_hybrid),
                  icon: const Icon(Icons.devices),
                ),
              ],
              selected: {_eventType},
              onSelectionChanged: (selected) {
                setState(() => _eventType = selected.first);
              },
            ),
            const SizedBox(height: 16),

            // Start date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(l10n.events_startDate),
              subtitle: Text(dateFormat.format(_startsAt)),
              onTap: () => _pickDateTime(isStart: true),
            ),

            // End date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(l10n.events_endDate),
              subtitle: Text(dateFormat.format(_endsAt)),
              onTap: () => _pickDateTime(isStart: false),
            ),
            const SizedBox(height: 16),

            // Location (for in-person/hybrid)
            if (_eventType != EventType.online)
              TextFormField(
                controller: _locationController,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: l10n.events_location,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
              ),

            // Virtual link (for online/hybrid)
            if (_eventType != EventType.inPerson) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _virtualLinkController,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: l10n.events_virtualLink,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.videocam_outlined),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Max participants (optional)
            TextFormField(
              controller: _maxParticipantsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.events_maxParticipants,
                border: const OutlineInputBorder(),
                helperText: 'Leave empty for unlimited',
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Must be a positive number';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // HD Type filter (optional)
            DropdownButtonFormField<String?>(
              initialValue: _hdTypeFilter,
              decoration: InputDecoration(
                labelText: l10n.events_hdTypeFilter,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.events_allTypes),
                ),
                ...['Manifestor', 'Generator', 'Manifesting Generator', 'Projector', 'Reflector']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        )),
              ],
              onChanged: (value) => setState(() => _hdTypeFilter = value),
            ),

            const SizedBox(height: 32),

            // Error message
            if (actionState.error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  actionState.error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: actionState.isLoading ? null : _submit,
                child: actionState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.events_create),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final initialDate = isStart ? _startsAt : _endsAt;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (time == null || !mounted) return;

    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      if (isStart) {
        _startsAt = dateTime;
        if (_endsAt.isBefore(_startsAt)) {
          _endsAt = _startsAt.add(const Duration(hours: 1));
        }
      } else {
        _endsAt = dateTime;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_endsAt.isBefore(_startsAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }

    final maxParticipants = _maxParticipantsController.text.isNotEmpty
        ? int.tryParse(_maxParticipantsController.text)
        : null;

    final success =
        await ref.read(eventActionNotifierProvider.notifier).createEvent(
              title: _titleController.text,
              description: _descriptionController.text,
              eventType: _eventType,
              startsAt: _startsAt,
              endsAt: _endsAt,
              location: _locationController.text.isNotEmpty
                  ? _locationController.text
                  : null,
              virtualLink: _virtualLinkController.text.isNotEmpty
                  ? _virtualLinkController.text
                  : null,
              hdTypeFilter: _hdTypeFilter,
              maxParticipants: maxParticipants,
            );

    if (success && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.events_created)),
      );
      Navigator.pop(context);
    }
  }
}
