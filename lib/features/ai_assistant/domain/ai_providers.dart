import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../../home/domain/home_providers.dart';
import '../../subscription/domain/subscription_providers.dart';
import '../data/ai_repository.dart';
import '../data/chart_context_builder.dart';
import '../../chart/domain/models/human_design_chart.dart';
import 'models/ai_conversation.dart';
import 'models/ai_message.dart';
import 'models/ai_usage.dart';

/// Provider for the AI repository
final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for AI usage in the current billing period
final aiUsageProvider = FutureProvider<AiUsage>((ref) async {
  final isPremium = await ref.watch(isPremiumProvider.future);
  final repository = ref.watch(aiRepositoryProvider);
  return repository.getUsage(isPremium: isPremium);
});

/// Provider that checks if the user can send an AI message.
/// Defense-in-depth: server also enforces this quota.
final canUseAiProvider = FutureProvider<bool>((ref) async {
  final isPremium = await ref.watch(isPremiumProvider.future);
  if (isPremium) return true;

  final usage = await ref.watch(aiUsageProvider.future);
  return usage.canSendMessage;
});

/// Provider for all AI conversations
final aiConversationsProvider = FutureProvider<List<AiConversation>>((ref) async {
  final repository = ref.watch(aiRepositoryProvider);
  return repository.getConversations();
});

/// Provider for messages in a specific conversation
final aiMessagesProvider =
    FutureProvider.family<List<AiMessage>, String>((ref, conversationId) async {
  final repository = ref.watch(aiRepositoryProvider);
  return repository.getMessages(conversationId);
});

/// State for the AI chat notifier
class AiChatState {
  const AiChatState({
    this.messages = const [],
    this.conversationId,
    this.isLoading = false,
    this.error,
  });

  final List<AiMessage> messages;
  final String? conversationId;
  final bool isLoading;
  final String? error;

  AiChatState copyWith({
    List<AiMessage>? messages,
    String? conversationId,
    bool? isLoading,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      conversationId: conversationId ?? this.conversationId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing an active AI chat session
class AiChatNotifier extends Notifier<AiChatState> {
  @override
  AiChatState build() => const AiChatState();

  AiRepository get _repository => ref.read(aiRepositoryProvider);

  /// Load an existing conversation
  Future<void> loadConversation(String conversationId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final messages = await _repository.getMessages(conversationId);
      state = state.copyWith(
        messages: messages,
        conversationId: conversationId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load conversation',
      );
    }
  }

  /// Send a message to the AI assistant.
  ///
  /// Security: Quota checked client-side (defense-in-depth) and server-side
  /// (authoritative). Chart context is sanitized via ChartContextBuilder.
  Future<void> sendMessage(
    String message, {
    HumanDesignChart? chart,
    AiContextType contextType = AiContextType.chart,
  }) async {
    // Client-side quota check (defense-in-depth)
    final canUse = await ref.read(canUseAiProvider.future);
    if (!canUse) {
      state = state.copyWith(error: 'quota_exceeded');
      return;
    }

    // Build optimistic user message for immediate UI feedback
    final optimisticMessage = AiMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: state.conversationId ?? '',
      role: AiMessageRole.user,
      content: message,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, optimisticMessage],
      isLoading: true,
      error: null,
    );

    try {
      // Build sanitized chart context (no PII)
      final chartContext =
          chart != null ? ChartContextBuilder.buildChartContext(chart) : null;

      final response = await _repository.sendMessage(
        conversationId: state.conversationId,
        message: message,
        chartContext: chartContext,
        contextType: contextType,
      );

      // Update conversation ID if this was a new conversation
      final newConversationId = response.conversationId;

      state = state.copyWith(
        messages: [...state.messages, response],
        conversationId: newConversationId,
        isLoading: false,
      );

      // Refresh usage and conversations
      ref.invalidate(aiUsageProvider);
      ref.invalidate(canUseAiProvider);
      ref.invalidate(aiConversationsProvider);
    } on AiServiceException catch (e) {
      // Remove optimistic message on error
      final messagesWithoutOptimistic = state.messages
          .where((m) => m.id != optimisticMessage.id)
          .toList();

      state = state.copyWith(
        messages: messagesWithoutOptimistic,
        isLoading: false,
        error: e.isQuotaExceeded ? 'quota_exceeded' : e.message,
      );

      if (e.isQuotaExceeded) {
        ref.invalidate(aiUsageProvider);
      }
    } catch (e) {
      final messagesWithoutOptimistic = state.messages
          .where((m) => m.id != optimisticMessage.id)
          .toList();

      state = state.copyWith(
        messages: messagesWithoutOptimistic,
        isLoading: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Clear the current chat session
  void clearChat() {
    state = const AiChatState();
  }

  /// Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _repository.deleteConversation(conversationId);
      ref.invalidate(aiConversationsProvider);
      if (state.conversationId == conversationId) {
        state = const AiChatState();
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete conversation');
    }
  }
}

final aiChatNotifierProvider =
    NotifierProvider<AiChatNotifier, AiChatState>(() {
  return AiChatNotifier();
});

/// Provider for suggested questions based on the user's chart
final suggestedQuestionsProvider =
    Provider.family<List<String>, HumanDesignChart?>((ref, chart) {
  if (chart == null) return _generalQuestions;

  return [
    'What does it mean to be a ${chart.type.displayName}?',
    'How should I use my ${chart.authority.displayName} authority?',
    'Tell me about my ${chart.profile.notation} profile.',
    'What are my defined centers telling me?',
    'How do my channels work together?',
  ];
});

const _generalQuestions = [
  'What is Human Design?',
  'What are the 5 Types in Human Design?',
  'How do I read a bodygraph?',
  'What is the significance of gates and channels?',
  'How does authority work in decision-making?',
];

// ============================================================================
// Feature-specific AI providers
// ============================================================================

/// Provider for today's AI transit insight.
/// Auto-fetches once per session; cached until invalidated.
final transitInsightProvider = FutureProvider<AiMessage?>((ref) async {
  final chart = await ref.watch(userChartProvider.future);
  if (chart == null) return null;

  final transits = ref.watch(todayTransitsProvider);
  final impact = await ref.watch(transitImpactProvider.future);
  final repository = ref.watch(aiRepositoryProvider);

  return repository.getTransitInsight(
    chart: chart,
    transits: transits,
    impact: impact,
  );
});

/// Provider for AI chart reading. Takes a chart ID.
/// This is an autoDispose family provider so each chart gets its own reading.
final chartReadingProvider =
    FutureProvider.autoDispose<AiMessage?>((ref) async {
  final chart = await ref.watch(userChartProvider.future);
  if (chart == null) return null;

  final repository = ref.watch(aiRepositoryProvider);
  return repository.getChartReading(chart: chart);
});

/// Provider for today's AI journaling prompts.
final journalingPromptsProvider = FutureProvider<AiMessage?>((ref) async {
  final chart = await ref.watch(userChartProvider.future);
  if (chart == null) return null;

  final transits = ref.watch(todayTransitsProvider);
  final impact = await ref.watch(transitImpactProvider.future);
  final repository = ref.watch(aiRepositoryProvider);

  return repository.getJournalingPrompts(
    chart: chart,
    transits: transits,
    impact: impact,
  );
});
