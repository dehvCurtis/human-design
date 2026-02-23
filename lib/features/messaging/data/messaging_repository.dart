import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/message.dart';

/// Repository for Direct Messaging operations
class MessagingRepository {
  MessagingRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  /// Maximum allowed message content length
  static const int maxMessageLength = 2000;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Conversations ====================

  /// Get all conversations for current user
  Future<List<Conversation>> getConversations() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('conversations')
        .select('*')
        .contains('participant_ids', [userId])
        .order('last_message_at', ascending: false, nullsFirst: false);

    final conversations = <Conversation>[];

    for (final json in response as List) {
      final participantIds =
          (json['participant_ids'] as List<dynamic>).cast<String>();

      // Get participant details
      final participantsResponse = await _client
          .from('profiles')
          .select('id, name, avatar_url, hd_type')
          .inFilter('id', participantIds);

      final participants = (participantsResponse as List)
          .map((p) => ConversationParticipant.fromJson(p))
          .toList();

      // Get unread count
      final unreadCount = await _getUnreadCount(json['id'] as String);

      conversations.add(Conversation.fromJson(
        json,
        participants: participants,
        unreadCount: unreadCount,
      ));
    }

    return conversations;
  }

  /// Get or create a conversation with a specific user
  Future<Conversation> getOrCreateConversation(String otherUserId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Check for existing conversation
    final existingResponse = await _client
        .from('conversations')
        .select('*')
        .contains('participant_ids', [userId])
        .contains('participant_ids', [otherUserId])
        .maybeSingle();

    if (existingResponse != null) {
      // Get participants
      final participantIds =
          (existingResponse['participant_ids'] as List<dynamic>).cast<String>();
      final participantsResponse = await _client
          .from('profiles')
          .select('id, name, avatar_url, hd_type')
          .inFilter('id', participantIds);

      final participants = (participantsResponse as List)
          .map((p) => ConversationParticipant.fromJson(p))
          .toList();

      return Conversation.fromJson(existingResponse, participants: participants);
    }

    // Create new conversation
    final newConversation = await _client.from('conversations').insert({
      'participant_ids': [userId, otherUserId],
    }).select().single();

    // Get participants
    final participantsResponse = await _client
        .from('profiles')
        .select('id, name, avatar_url, hd_type')
        .inFilter('id', [userId, otherUserId]);

    final participants = (participantsResponse as List)
        .map((p) => ConversationParticipant.fromJson(p))
        .toList();

    return Conversation.fromJson(newConversation, participants: participants);
  }

  /// Get a specific conversation
  Future<Conversation?> getConversation(String conversationId) async {
    final response = await _client
        .from('conversations')
        .select('*')
        .eq('id', conversationId)
        .maybeSingle();

    if (response == null) return null;

    final participantIds =
        (response['participant_ids'] as List<dynamic>).cast<String>();
    final participantsResponse = await _client
        .from('profiles')
        .select('id, name, avatar_url, hd_type')
        .inFilter('id', participantIds);

    final participants = (participantsResponse as List)
        .map((p) => ConversationParticipant.fromJson(p))
        .toList();

    return Conversation.fromJson(response, participants: participants);
  }

  // ==================== Messages ====================

  /// Get messages in a conversation
  Future<List<DirectMessage>> getMessages(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _client
        .from('direct_messages')
        .select('''
          *,
          sender:profiles!direct_messages_sender_id_fkey(id, name, avatar_url)
        ''')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => DirectMessage.fromJson(json))
        .toList();
  }

  /// Send a message
  ///
  /// Enforces content length limits to prevent abuse.
  Future<DirectMessage> sendMessage({
    required String conversationId,
    required String content,
    MessageType messageType = MessageType.text,
    String? sharedChartId,
    String? mediaUrl,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Enforce content length limit
    if (content.length > maxMessageLength) {
      throw ArgumentError('Message exceeds $maxMessageLength characters');
    }

    final response = await _client.from('direct_messages').insert({
      'conversation_id': conversationId,
      'sender_id': userId,
      'content': content,
      'message_type': messageType.dbValue,
      'shared_chart_id': sharedChartId,
      'media_url': mediaUrl,
    }).select('''
          *,
          sender:profiles!direct_messages_sender_id_fkey(id, name, avatar_url)
        ''').single();

    return DirectMessage.fromJson(response);
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String conversationId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _client
        .from('direct_messages')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toIso8601String(),
        })
        .eq('conversation_id', conversationId)
        .neq('sender_id', userId)
        .eq('is_read', false);
  }

  /// Get total unread message count
  Future<int> getTotalUnreadCount() async {
    final userId = _currentUserId;
    if (userId == null) return 0;

    // Get all conversation IDs user is part of
    final convResponse = await _client
        .from('conversations')
        .select('id')
        .contains('participant_ids', [userId]);

    final conversationIds =
        (convResponse as List).map((c) => c['id'] as String).toList();

    if (conversationIds.isEmpty) return 0;

    final response = await _client
        .from('direct_messages')
        .select('id')
        .inFilter('conversation_id', conversationIds)
        .neq('sender_id', userId)
        .eq('is_read', false);

    return (response as List).length;
  }

  // ==================== Realtime ====================

  /// Subscribe to messages in a conversation
  RealtimeChannel subscribeToConversation(
    String conversationId,
    void Function(DirectMessage message) onMessage,
  ) {
    return _client
        .channel('dm:$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'direct_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) async {
            // Fetch full message with sender info
            final response = await _client
                .from('direct_messages')
                .select('''
                  *,
                  sender:profiles!direct_messages_sender_id_fkey(id, name, avatar_url)
                ''')
                .eq('id', payload.newRecord['id'] as String)
                .single();

            onMessage(DirectMessage.fromJson(response));
          },
        )
        .subscribe();
  }

  /// Subscribe to new messages across all conversations.
  ///
  /// Security: Supabase Realtime respects RLS policies, so only messages
  /// the user has SELECT access to will trigger events. Client-side
  /// verification is kept as defense-in-depth.
  RealtimeChannel subscribeToAllMessages(
    void Function(DirectMessage message) onMessage,
  ) {
    final userId = _currentUserId;
    if (userId == null) {
      throw StateError('User not authenticated');
    }

    return _client
        .channel('all_dm:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'direct_messages',
          callback: (payload) async {
            final senderId = payload.newRecord['sender_id'] as String?;

            // Don't notify for our own messages
            if (senderId == null || senderId == userId) return;

            // Fetch full message via RLS-protected query (will return null
            // if user doesn't have SELECT access to this message)
            try {
              final response = await _client
                  .from('direct_messages')
                  .select('''
                    *,
                    sender:profiles!direct_messages_sender_id_fkey(id, name, avatar_url)
                  ''')
                  .eq('id', payload.newRecord['id'] as String)
                  .maybeSingle();

              if (response == null) return; // RLS filtered out — not our message

              onMessage(DirectMessage.fromJson(response));
            } catch (_) {
              // Silently ignore — likely not our message
            }
          },
        )
        .subscribe();
  }

  // ==================== Block & Delete ====================

  /// Block a user (prevents messaging and hides from discovery)
  Future<void> blockUser(String blockedUserId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client.from('blocked_users').upsert({
      'blocker_id': userId,
      'blocked_id': blockedUserId,
    });
  }

  /// Unblock a user
  Future<void> unblockUser(String blockedUserId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('blocked_users')
        .delete()
        .eq('blocker_id', userId)
        .eq('blocked_id', blockedUserId);
  }

  /// Delete a conversation (soft-delete: removes current user from participants)
  ///
  /// Note: This removes the conversation from the user's view. If both
  /// participants delete, the conversation and messages become orphaned
  /// and will be cleaned up by scheduled jobs.
  Future<void> deleteConversation(String conversationId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Verify participant membership before deleting
    final conversation = await _client
        .from('conversations')
        .select('participant_ids')
        .eq('id', conversationId)
        .contains('participant_ids', [userId])
        .maybeSingle();

    if (conversation == null) {
      throw StateError('Conversation not found or not a participant');
    }

    // Remove user from participants
    final participantIds =
        (conversation['participant_ids'] as List<dynamic>).cast<String>();
    participantIds.remove(userId);

    if (participantIds.isEmpty) {
      // Last participant — delete the conversation and messages
      await _client
          .from('direct_messages')
          .delete()
          .eq('conversation_id', conversationId);
      await _client.from('conversations').delete().eq('id', conversationId);
    } else {
      // Just remove this user from participants
      await _client
          .from('conversations')
          .update({'participant_ids': participantIds})
          .eq('id', conversationId);
    }
  }

  // ==================== Helper Methods ====================

  Future<int> _getUnreadCount(String conversationId) async {
    final userId = _currentUserId;
    if (userId == null) return 0;

    final response = await _client
        .from('direct_messages')
        .select('id')
        .eq('conversation_id', conversationId)
        .neq('sender_id', userId)
        .eq('is_read', false);

    return (response as List).length;
  }
}
