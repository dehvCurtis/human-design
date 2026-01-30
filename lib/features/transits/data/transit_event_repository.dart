import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/transit_event.dart';

/// Repository for transit event operations
class TransitEventRepository {
  TransitEventRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Event CRUD ====================

  /// Get all active and upcoming transit events
  Future<List<TransitEvent>> getActiveEvents() async {
    final now = DateTime.now().toIso8601String();

    final response = await _client
        .from('transit_events')
        .select()
        .gte('ends_at', now)
        .order('starts_at', ascending: true);

    return (response as List)
        .map((json) => TransitEvent.fromJson(json))
        .toList();
  }

  /// Get currently active events (happening now)
  Future<List<TransitEvent>> getCurrentEvents() async {
    final now = DateTime.now().toIso8601String();

    final response = await _client
        .from('transit_events')
        .select()
        .lte('starts_at', now)
        .gte('ends_at', now)
        .order('starts_at', ascending: true);

    return (response as List)
        .map((json) => TransitEvent.fromJson(json))
        .toList();
  }

  /// Get upcoming events
  Future<List<TransitEvent>> getUpcomingEvents({int limit = 10}) async {
    final now = DateTime.now().toIso8601String();

    final response = await _client
        .from('transit_events')
        .select()
        .gt('starts_at', now)
        .order('starts_at', ascending: true)
        .limit(limit);

    return (response as List)
        .map((json) => TransitEvent.fromJson(json))
        .toList();
  }

  /// Get past events
  Future<List<TransitEvent>> getPastEvents({int limit = 10}) async {
    final now = DateTime.now().toIso8601String();

    final response = await _client
        .from('transit_events')
        .select()
        .lt('ends_at', now)
        .order('ends_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => TransitEvent.fromJson(json))
        .toList();
  }

  /// Get a single event by ID
  Future<TransitEvent?> getEvent(String eventId) async {
    final response = await _client
        .from('transit_events')
        .select()
        .eq('id', eventId)
        .maybeSingle();

    if (response == null) return null;
    return TransitEvent.fromJson(response);
  }

  /// Get events by gate number
  Future<List<TransitEvent>> getEventsByGate(int gateNumber) async {
    final response = await _client
        .from('transit_events')
        .select()
        .eq('gate_number', gateNumber)
        .order('starts_at', ascending: false);

    return (response as List)
        .map((json) => TransitEvent.fromJson(json))
        .toList();
  }

  // ==================== Participation ====================

  /// Join a transit event
  Future<void> joinEvent(String eventId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client.from('transit_event_participants').upsert({
      'user_id': userId,
      'event_id': eventId,
      'joined_at': DateTime.now().toIso8601String(),
    });

    // Update participant count
    await _client.rpc('increment_event_participants', params: {
      'event_id': eventId,
    });
  }

  /// Leave a transit event
  Future<void> leaveEvent(String eventId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('transit_event_participants')
        .delete()
        .eq('user_id', userId)
        .eq('event_id', eventId);

    // Update participant count
    await _client.rpc('decrement_event_participants', params: {
      'event_id': eventId,
    });
  }

  /// Check if user is participating in an event
  Future<bool> isParticipating(String eventId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('transit_event_participants')
        .select('id')
        .eq('user_id', userId)
        .eq('event_id', eventId)
        .maybeSingle();

    return response != null;
  }

  /// Get user's participation data for an event
  Future<TransitEventParticipation?> getParticipation(String eventId) async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('transit_event_participants')
        .select()
        .eq('user_id', userId)
        .eq('event_id', eventId)
        .maybeSingle();

    if (response == null) return null;
    return TransitEventParticipation.fromJson(response);
  }

  /// Update participation (add reflection, mood)
  Future<void> updateParticipation({
    required String eventId,
    String? reflection,
    String? mood,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final updates = <String, dynamic>{};
    if (reflection != null) updates['reflection'] = reflection;
    if (mood != null) updates['mood'] = mood;

    await _client
        .from('transit_event_participants')
        .update(updates)
        .eq('user_id', userId)
        .eq('event_id', eventId);
  }

  /// Get participant count for an event
  Future<int> getParticipantCount(String eventId) async {
    final response = await _client
        .from('transit_event_participants')
        .select('id')
        .eq('event_id', eventId);

    return (response as List).length;
  }

  // ==================== Event Posts ====================

  /// Link a post to a transit event
  Future<void> linkPostToEvent(String postId, String eventId) async {
    await _client.from('transit_event_posts').insert({
      'post_id': postId,
      'event_id': eventId,
    });

    // Update post count
    await _client.rpc('increment_event_posts', params: {
      'event_id': eventId,
    });
  }

  /// Get post IDs linked to an event
  Future<List<String>> getEventPostIds(String eventId, {int limit = 50}) async {
    final response = await _client
        .from('transit_event_posts')
        .select('post_id')
        .eq('event_id', eventId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => json['post_id'] as String)
        .toList();
  }

  // ==================== Insights ====================

  /// Get collective insights for an event
  Future<TransitEventInsight?> getEventInsights(String eventId) async {
    final response = await _client.rpc('get_event_insights', params: {
      'target_event_id': eventId,
    });

    if (response == null) return null;
    return TransitEventInsight.fromJson(response);
  }

  // ==================== Realtime ====================

  /// Subscribe to event updates
  RealtimeChannel subscribeToEvent(
    String eventId,
    void Function(int participantCount, int postCount) onUpdate,
  ) {
    return _client
        .channel('transit_event:$eventId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'transit_events',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: eventId,
          ),
          callback: (payload) {
            final participantCount = payload.newRecord['participant_count'] as int;
            final postCount = payload.newRecord['post_count'] as int;
            onUpdate(participantCount, postCount);
          },
        )
        .subscribe();
  }

  /// Subscribe to new participants joining
  RealtimeChannel subscribeToParticipants(
    String eventId,
    void Function(TransitEventParticipation participation) onNewParticipant,
  ) {
    return _client
        .channel('transit_event_participants:$eventId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'transit_event_participants',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'event_id',
            value: eventId,
          ),
          callback: (payload) {
            final participation = TransitEventParticipation.fromJson(payload.newRecord);
            onNewParticipant(participation);
          },
        )
        .subscribe();
  }
}
