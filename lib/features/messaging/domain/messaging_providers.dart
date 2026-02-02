import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/messaging_repository.dart';
import 'models/message.dart';

/// Provider for the MessagingRepository
final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for all conversations
final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final repository = ref.watch(messagingRepositoryProvider);
  return repository.getConversations();
});

/// Provider for a specific conversation
final conversationProvider = FutureProvider.family<Conversation?, String>((ref, conversationId) async {
  final repository = ref.watch(messagingRepositoryProvider);
  return repository.getConversation(conversationId);
});

/// Provider for messages in a conversation
final messagesProvider = FutureProvider.family<List<DirectMessage>, String>((ref, conversationId) async {
  final repository = ref.watch(messagingRepositoryProvider);
  return repository.getMessages(conversationId);
});

/// Provider for total unread count
final unreadCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(messagingRepositoryProvider);
  return repository.getTotalUnreadCount();
});

/// Notifier for managing messaging state and actions
class MessagingNotifier extends Notifier<MessagingState> {
  @override
  MessagingState build() => const MessagingState();

  MessagingRepository get _repository => ref.read(messagingRepositoryProvider);

  RealtimeChannel? _activeSubscription;

  /// Start a conversation with a user
  Future<Conversation> startConversation(String userId) async {
    final conversation = await _repository.getOrCreateConversation(userId);
    ref.invalidate(conversationsProvider);
    return conversation;
  }

  /// Send a message
  Future<DirectMessage> sendMessage({
    required String conversationId,
    required String content,
    MessageType messageType = MessageType.text,
    String? sharedChartId,
    String? mediaUrl,
  }) async {
    state = state.copyWith(isSending: true);

    try {
      final message = await _repository.sendMessage(
        conversationId: conversationId,
        content: content,
        messageType: messageType,
        sharedChartId: sharedChartId,
        mediaUrl: mediaUrl,
      );

      // Add to local state for immediate UI update
      final currentMessages = state.localMessages[conversationId] ?? [];
      state = state.copyWith(
        isSending: false,
        localMessages: {
          ...state.localMessages,
          conversationId: [...currentMessages, message],
        },
      );

      // Refresh conversations list
      ref.invalidate(conversationsProvider);

      return message;
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString());
      rethrow;
    }
  }

  /// Mark messages as read
  Future<void> markAsRead(String conversationId) async {
    await _repository.markMessagesAsRead(conversationId);
    ref.invalidate(conversationsProvider);
    ref.invalidate(unreadCountProvider);
  }

  /// Subscribe to real-time messages in a conversation
  void subscribeToConversation(String conversationId) {
    // Unsubscribe from previous if any
    _activeSubscription?.unsubscribe();

    _activeSubscription = _repository.subscribeToConversation(
      conversationId,
      (message) {
        // Add to local state
        final currentMessages = state.localMessages[conversationId] ?? [];
        state = state.copyWith(
          localMessages: {
            ...state.localMessages,
            conversationId: [...currentMessages, message],
          },
        );
      },
    );
  }

  /// Unsubscribe from conversation
  void unsubscribeFromConversation() {
    _activeSubscription?.unsubscribe();
    _activeSubscription = null;
  }

  /// Add a message to local state (for optimistic updates)
  void addLocalMessage(String conversationId, DirectMessage message) {
    final currentMessages = state.localMessages[conversationId] ?? [];
    state = state.copyWith(
      localMessages: {
        ...state.localMessages,
        conversationId: [...currentMessages, message],
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final messagingNotifierProvider = NotifierProvider<MessagingNotifier, MessagingState>(() {
  return MessagingNotifier();
});

/// State class for messaging operations
class MessagingState {
  const MessagingState({
    this.isSending = false,
    this.localMessages = const {},
    this.error,
  });

  final bool isSending;
  final Map<String, List<DirectMessage>> localMessages;
  final String? error;

  MessagingState copyWith({
    bool? isSending,
    Map<String, List<DirectMessage>>? localMessages,
    String? error,
  }) {
    return MessagingState(
      isSending: isSending ?? this.isSending,
      localMessages: localMessages ?? this.localMessages,
      error: error,
    );
  }
}

/// Provider for combined messages (fetched + local realtime)
final combinedMessagesProvider = Provider.family<List<DirectMessage>, String>((ref, conversationId) {
  final fetchedAsync = ref.watch(messagesProvider(conversationId));
  final localMessages = ref.watch(messagingNotifierProvider).localMessages[conversationId] ?? [];

  return fetchedAsync.when(
    data: (fetched) {
      // Combine and deduplicate
      final allMessages = <String, DirectMessage>{};
      for (final msg in fetched) {
        allMessages[msg.id] = msg;
      }
      for (final msg in localMessages) {
        allMessages[msg.id] = msg;
      }

      // Sort by created_at descending (newest first for list display)
      final combined = allMessages.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return combined;
    },
    loading: () => localMessages,
    error: (_, _) => localMessages,
  );
});
