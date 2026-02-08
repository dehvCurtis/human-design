import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/journal_entry.dart';

/// Repository for dream journal / journaling entries
class DreamRepository {
  DreamRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('User not authenticated');
    return user.id;
  }

  /// Get all entries for the current user, optionally filtered by type.
  Future<List<JournalEntry>> getEntries({
    JournalEntryType? type,
    int limit = 50,
  }) async {
    var query = _client
        .from('journal_entries')
        .select()
        .eq('user_id', _currentUserId);

    if (type != null) {
      query = query.eq('entry_type', type.value);
    }

    final data = await query
        .order('created_at', ascending: false)
        .limit(limit);

    return data.map((json) => JournalEntry.fromJson(json)).toList();
  }

  /// Get a single entry by ID.
  Future<JournalEntry?> getEntry(String id) async {
    final data = await _client
        .from('journal_entries')
        .select()
        .eq('id', id)
        .eq('user_id', _currentUserId)
        .maybeSingle();

    if (data == null) return null;
    return JournalEntry.fromJson(data);
  }

  /// Create a new entry.
  Future<JournalEntry> createEntry({
    required String content,
    required JournalEntryType entryType,
    int? transitSunGate,
    String? prompt,
  }) async {
    final data = await _client
        .from('journal_entries')
        .insert({
          'user_id': _currentUserId,
          'content': content,
          'entry_type': entryType.value,
          'transit_sun_gate': transitSunGate,
          'prompt': prompt,
        })
        .select()
        .single();

    return JournalEntry.fromJson(data);
  }

  /// Update an entry with AI interpretation.
  Future<JournalEntry> updateInterpretation({
    required String entryId,
    required String aiInterpretation,
    String? conversationId,
  }) async {
    final data = await _client
        .from('journal_entries')
        .update({
          'ai_interpretation': aiInterpretation,
          if (conversationId != null) 'conversation_id': conversationId,
        })
        .eq('id', entryId)
        .eq('user_id', _currentUserId)
        .select()
        .single();

    return JournalEntry.fromJson(data);
  }

  /// Delete an entry.
  Future<void> deleteEntry(String id) async {
    await _client
        .from('journal_entries')
        .delete()
        .eq('id', id)
        .eq('user_id', _currentUserId);
  }
}
