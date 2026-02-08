import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';
import '../domain/models/ai_conversation.dart';
import '../domain/models/ai_message.dart';
import '../domain/models/ai_usage.dart';

/// Repository for AI chat operations via Supabase Edge Functions.
///
/// Security model:
/// - All AI API calls go through Edge Functions (API keys never in client)
/// - Server-side JWT validation on every request
/// - Server-side usage quota enforcement (client checks are defense-in-depth)
/// - Input length limits enforced both client and server side
/// - No raw user input passed to system prompts (chart context is enumerated)
class AiRepository {
  AiRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  /// Maximum message length allowed (enforced client-side; server also enforces)
  static const int maxMessageLength = 2000;

  /// Maximum conversation title length
  static const int maxTitleLength = 100;

  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('User not authenticated');
    }
    return user.id;
  }

  /// Send a message to the AI assistant via Edge Function.
  ///
  /// [conversationId] - existing conversation ID or null for new conversation
  /// [message] - user's message (validated for length)
  /// [chartContext] - sanitized chart context map (no user-controlled strings)
  /// [contextType] - type of context for the conversation
  ///
  /// Returns the assistant's response as an [AiMessage].
  Future<AiMessage> sendMessage({
    String? conversationId,
    required String message,
    Map<String, dynamic>? chartContext,
    AiContextType contextType = AiContextType.chart,
  }) async {
    // Client-side input validation (defense-in-depth; server also validates)
    final sanitizedMessage = _sanitizeInput(message);
    if (sanitizedMessage.isEmpty) {
      throw ArgumentError('Message cannot be empty');
    }
    if (sanitizedMessage.length > maxMessageLength) {
      throw ArgumentError(
        'Message exceeds maximum length of $maxMessageLength characters',
      );
    }

    try {
      final response = await _client.functions.invoke(
        AppConfig.aiChatFunctionName,
        body: {
          'conversation_id': conversationId,
          'message': sanitizedMessage,
          'chart_context': chartContext,
          'context_type': contextType.value,
        },
      );

      if (response.status != 200) {
        final errorBody = response.data;
        final errorMessage = errorBody is Map
            ? errorBody['error'] as String? ?? 'AI service error'
            : 'AI service returned status ${response.status}';
        throw AiServiceException(errorMessage, statusCode: response.status);
      }

      final data = response.data as Map<String, dynamic>;
      return AiMessage.fromJson(data['message'] as Map<String, dynamic>);
    } on FunctionException catch (e) {
      debugPrint('AI Edge Function error: ${e.reasonPhrase}');
      throw AiServiceException(
        'Failed to reach AI service. Please try again.',
        statusCode: e.status,
      );
    }
  }

  /// Get all conversations for the current user.
  Future<List<AiConversation>> getConversations() async {
    final data = await _client
        .from('ai_conversations')
        .select()
        .eq('user_id', _currentUserId)
        .order('last_message_at', ascending: false)
        .limit(50);

    return data
        .map((json) => AiConversation.fromJson(json))
        .toList();
  }

  /// Get messages for a specific conversation.
  ///
  /// Only returns messages belonging to the current user's conversation
  /// (enforced by RLS policy).
  Future<List<AiMessage>> getMessages(String conversationId) async {
    // Validate conversationId format (UUID)
    if (!_isValidUuid(conversationId)) {
      throw ArgumentError('Invalid conversation ID format');
    }

    final data = await _client
        .from('ai_messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .limit(200);

    return data
        .map((json) => AiMessage.fromJson(json))
        .toList();
  }

  /// Get AI usage for the current billing period.
  Future<AiUsage> getUsage({required bool isPremium}) async {
    if (isPremium) {
      return AiUsage.unlimited();
    }

    final now = DateTime.now();
    final periodStart = DateTime(now.year, now.month, 1);

    final data = await _client
        .from('ai_usage')
        .select()
        .eq('user_id', _currentUserId)
        .eq('period_start', periodStart.toIso8601String().split('T')[0])
        .maybeSingle();

    if (data == null) {
      return AiUsage.empty(limit: AppConfig.freeAiMessagesPerMonth);
    }

    return AiUsage.fromJson(
      data,
      limit: AppConfig.freeAiMessagesPerMonth,
    );
  }

  /// Add bonus messages from a purchased message pack.
  Future<void> addBonusMessages(int count) async {
    final now = DateTime.now();
    final periodStart = DateTime(now.year, now.month, 1);

    await _client.rpc('add_ai_bonus_messages', params: {
      'p_user_id': _currentUserId,
      'p_period_start': periodStart.toIso8601String().split('T')[0],
      'p_count': count,
    });
  }

  /// Delete a conversation and all its messages.
  ///
  /// RLS ensures only the owner can delete.
  Future<void> deleteConversation(String conversationId) async {
    if (!_isValidUuid(conversationId)) {
      throw ArgumentError('Invalid conversation ID format');
    }

    await _client
        .from('ai_conversations')
        .delete()
        .eq('id', conversationId)
        .eq('user_id', _currentUserId);
  }

  /// Update conversation title.
  Future<void> updateConversationTitle(
    String conversationId,
    String title,
  ) async {
    if (!_isValidUuid(conversationId)) {
      throw ArgumentError('Invalid conversation ID format');
    }

    final sanitizedTitle = _sanitizeInput(title);
    if (sanitizedTitle.length > maxTitleLength) {
      throw ArgumentError('Title exceeds maximum length');
    }

    await _client
        .from('ai_conversations')
        .update({'title': sanitizedTitle})
        .eq('id', conversationId)
        .eq('user_id', _currentUserId);
  }

  /// Sanitize user input by trimming whitespace.
  /// The actual content is passed to the AI as a user message,
  /// not interpolated into system prompts, so we only trim.
  String _sanitizeInput(String input) {
    return input.trim();
  }

  /// Validate UUID format to prevent injection in query parameters.
  bool _isValidUuid(String value) {
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(value);
  }
}

/// Exception for AI service errors
class AiServiceException implements Exception {
  const AiServiceException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  /// Whether this error indicates the user has exceeded their usage quota
  bool get isQuotaExceeded => statusCode == 429;

  @override
  String toString() => 'AiServiceException: $message (status: $statusCode)';
}
