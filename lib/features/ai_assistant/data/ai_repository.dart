import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../composite/domain/composite_calculator.dart';
import '../../lifestyle/domain/transit_service.dart';
import '../domain/models/ai_conversation.dart';
import '../domain/models/ai_message.dart';
import '../domain/models/ai_usage.dart';
import 'chart_context_builder.dart';

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
  /// [maxTokens] - optional max tokens override for long-form content
  ///
  /// Returns the assistant's response as an [AiMessage].
  Future<AiMessage> sendMessage({
    String? conversationId,
    required String message,
    Map<String, dynamic>? chartContext,
    AiContextType contextType = AiContextType.chart,
    int? maxTokens,
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
          if (maxTokens != null) 'max_tokens': maxTokens,
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
  ///
  /// Routes through an Edge Function that validates the purchase
  /// and uses service_role to grant bonus messages. The underlying
  /// RPC is not callable from the authenticated role (security hardening).
  Future<void> addBonusMessages(int count, {required String purchaseId}) async {
    try {
      final response = await _client.functions.invoke(
        'grant-bonus-messages',
        body: {
          'count': count,
          'purchase_id': purchaseId,
        },
      );

      if (response.status != 200) {
        final errorBody = response.data;
        final errorMessage = errorBody is Map
            ? errorBody['error'] as String? ?? 'Failed to add bonus messages'
            : 'Failed to add bonus messages';
        throw AiServiceException(errorMessage, statusCode: response.status);
      }
    } on FunctionException catch (e) {
      debugPrint('Grant bonus messages error: ${e.reasonPhrase}');
      throw AiServiceException(
        'Failed to add bonus messages. Please try again.',
        statusCode: e.status,
      );
    }
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

  /// Get AI transit insight for the user's chart and current transits.
  Future<AiMessage> getTransitInsight({
    required HumanDesignChart chart,
    required TransitChart transits,
    TransitImpact? impact,
  }) async {
    final context = ChartContextBuilder.buildTransitContext(chart, transits, impact);
    return sendMessage(
      message: 'Give me my personalized transit insight for today.',
      chartContext: context,
      contextType: AiContextType.transitInsight,
    );
  }

  /// Get a comprehensive AI chart reading.
  Future<AiMessage> getChartReading({
    required HumanDesignChart chart,
  }) async {
    final context = ChartContextBuilder.buildChartContext(chart);
    return sendMessage(
      message: 'Generate a comprehensive reading of my Human Design chart.',
      chartContext: context,
      contextType: AiContextType.chartReading,
      maxTokens: 4096,
    );
  }

  /// Get AI compatibility reading for two charts.
  Future<AiMessage> getCompatibilityReading({
    required HumanDesignChart person1,
    required HumanDesignChart person2,
    required CompositeResult report,
  }) async {
    final context = ChartContextBuilder.buildCompatibilityContext(
      person1,
      person2,
      report,
    );
    return sendMessage(
      message: 'Analyze the compatibility between these two people.',
      chartContext: context,
      contextType: AiContextType.compatibility,
      maxTokens: 2048,
    );
  }

  /// Interpret a dream through the HD lens.
  Future<AiMessage> interpretDream({
    required String dreamText,
    required HumanDesignChart chart,
    required TransitChart transits,
    TransitImpact? impact,
  }) async {
    final context = ChartContextBuilder.buildTransitContext(chart, transits, impact);
    return sendMessage(
      message: dreamText,
      chartContext: context,
      contextType: AiContextType.dream,
    );
  }

  /// Get personalized journaling prompts.
  Future<AiMessage> getJournalingPrompts({
    required HumanDesignChart chart,
    required TransitChart transits,
    TransitImpact? impact,
  }) async {
    final context = ChartContextBuilder.buildTransitContext(chart, transits, impact);
    return sendMessage(
      message: 'Generate personalized journaling prompts for me today.',
      chartContext: context,
      contextType: AiContextType.journal,
    );
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
