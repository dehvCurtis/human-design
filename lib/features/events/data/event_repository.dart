import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/event.dart';

/// Repository for community events CRUD operations.
///
/// Security: All data access goes through Supabase RLS policies.
/// Input validation happens at the model/provider level.
class EventRepository {
  EventRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('User not authenticated');
    return user.id;
  }

  /// Get upcoming events
  Future<List<CommunityEvent>> getUpcomingEvents() async {
    final data = await _client
        .from('community_events')
        .select('*, creator:profiles!creator_id(display_name, full_name)')
        .gte('starts_at', DateTime.now().toIso8601String())
        .order('starts_at', ascending: true)
        .limit(50);

    return data
        .map((json) => CommunityEvent.fromJson(json))
        .toList();
  }

  /// Get past events
  Future<List<CommunityEvent>> getPastEvents() async {
    final data = await _client
        .from('community_events')
        .select('*, creator:profiles!creator_id(display_name, full_name)')
        .lt('ends_at', DateTime.now().toIso8601String())
        .order('starts_at', ascending: false)
        .limit(30);

    return data
        .map((json) => CommunityEvent.fromJson(json))
        .toList();
  }

  /// Get a single event by ID
  Future<CommunityEvent> getEvent(String eventId) async {
    final data = await _client
        .from('community_events')
        .select('*, creator:profiles!creator_id(display_name, full_name)')
        .eq('id', eventId)
        .single();

    return CommunityEvent.fromJson(data);
  }

  /// Create a new event.
  /// Input validation: title 1-200 chars, description <= 5000 chars (enforced by DB).
  Future<CommunityEvent> createEvent({
    required String title,
    required String description,
    required EventType eventType,
    required DateTime startsAt,
    required DateTime endsAt,
    String? location,
    String? virtualLink,
    String? hdTypeFilter,
    List<int>? gateThemes,
    int? maxParticipants,
  }) async {
    // Client-side validation (DB constraints also enforce)
    if (title.trim().isEmpty || title.trim().length > 200) {
      throw ArgumentError('Title must be 1-200 characters');
    }
    if (description.trim().length > 5000) {
      throw ArgumentError('Description exceeds 5000 characters');
    }
    if (endsAt.isBefore(startsAt)) {
      throw ArgumentError('End date must be after start date');
    }
    if (virtualLink != null && virtualLink.length > 500) {
      throw ArgumentError('Virtual link exceeds 500 characters');
    }

    final data = await _client
        .from('community_events')
        .insert({
          'creator_id': _currentUserId,
          'title': title.trim(),
          'description': description.trim(),
          'event_type': eventType.value,
          'starts_at': startsAt.toIso8601String(),
          'ends_at': endsAt.toIso8601String(),
          if (location != null) 'location': location.trim(),
          if (virtualLink != null) 'virtual_link': virtualLink.trim(),
          if (hdTypeFilter != null) 'hd_type_filter': hdTypeFilter,
          if (gateThemes != null && gateThemes.isNotEmpty)
            'gate_themes': gateThemes,
          if (maxParticipants != null) 'max_participants': maxParticipants,
        })
        .select('*, creator:profiles!creator_id(display_name, full_name)')
        .single();

    return CommunityEvent.fromJson(data);
  }

  /// Delete an event (RLS ensures only creator can delete)
  Future<void> deleteEvent(String eventId) async {
    await _client
        .from('community_events')
        .delete()
        .eq('id', eventId)
        .eq('creator_id', _currentUserId);
  }

  /// Register for an event
  Future<void> registerForEvent(String eventId) async {
    await _client.from('event_participants').upsert({
      'event_id': eventId,
      'user_id': _currentUserId,
      'status': 'registered',
    });
  }

  /// Cancel event registration
  Future<void> cancelRegistration(String eventId) async {
    await _client
        .from('event_participants')
        .update({'status': 'cancelled'})
        .eq('event_id', eventId)
        .eq('user_id', _currentUserId);
  }

  /// Check if current user is registered for an event
  Future<bool> isRegistered(String eventId) async {
    final data = await _client
        .from('event_participants')
        .select('status')
        .eq('event_id', eventId)
        .eq('user_id', _currentUserId)
        .maybeSingle();

    return data != null && data['status'] == 'registered';
  }

  /// Get participants for an event
  Future<List<EventParticipant>> getParticipants(String eventId) async {
    final data = await _client
        .from('event_participants')
        .select('*, user:profiles!user_id(display_name, full_name)')
        .eq('event_id', eventId)
        .eq('status', 'registered')
        .order('created_at', ascending: true);

    return data
        .map((json) => EventParticipant.fromJson(json))
        .toList();
  }
}
