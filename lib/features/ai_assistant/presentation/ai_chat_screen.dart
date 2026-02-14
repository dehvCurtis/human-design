import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../home/domain/home_providers.dart';
import '../domain/ai_providers.dart';
import 'widgets/ai_premium_gate.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/suggested_questions.dart';

/// Full-screen AI chat assistant.
///
/// Accepts optional [conversationId] to resume an existing conversation,
/// or starts a new one. Chart context is automatically loaded from the
/// user's chart provider and sanitized before sending.
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({
    super.key,
    this.conversationId,
  });

  final String? conversationId;

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _scrollController = ScrollController();
  bool _dismissedGate = false;

  @override
  void initState() {
    super.initState();
    if (widget.conversationId != null) {
      // Load existing conversation after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(aiChatNotifierProvider.notifier)
            .loadConversation(widget.conversationId!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatNotifierProvider);
    final canUseAsync = ref.watch(canUseAiProvider);
    final usageAsync = ref.watch(aiUsageProvider);
    final chartAsync = ref.watch(userChartProvider);
    final l10n = AppLocalizations.of(context)!;

    // Auto-scroll when messages change
    ref.listen(aiChatNotifierProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ai_chatTitle),
        actions: [
          if (chatState.messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.ai_newConversation,
              onPressed: () {
                ref.read(aiChatNotifierProvider.notifier).clearChat();
              },
            ),
          // Show usage indicator for free users
          usageAsync.whenOrNull(
                data: (usage) => usage.limit < 999999
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: usage.canSendMessage
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${usage.remaining}/${usage.limit}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: usage.canSendMessage
                                        ? AppColors.primary
                                        : AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState(context, chartAsync)
                : _buildMessagesList(context, chatState),
          ),

          // Error display
          if (chatState.error != null && chatState.error != 'quota_exceeded')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.error.withValues(alpha: 0.1),
              child: Text(
                chatState.error!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                    ),
                textAlign: TextAlign.center,
              ),
            ),

          // Premium gate or input bar
          canUseAsync.when(
            data: (canUse) {
              if (!_dismissedGate && (!canUse || chatState.error == 'quota_exceeded')) {
                return usageAsync.when(
                  data: (usage) => AiPremiumGate(
                    usage: usage,
                    onDismiss: () => setState(() => _dismissedGate = true),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                );
              }

              final chart = chartAsync is AsyncData<HumanDesignChart?>
                  ? chartAsync.value
                  : null;

              return ChatInputBar(
                isLoading: chatState.isLoading,
                onSend: (message) {
                  ref.read(aiChatNotifierProvider.notifier).sendMessage(
                        message,
                        chart: chart,
                      );
                },
              );
            },
            loading: () => const ChatInputBar(
              isLoading: true,
              onSend: _noOp,
              enabled: false,
            ),
            error: (_, _) => ChatInputBar(
              onSend: (message) {
                final chart = chartAsync is AsyncData<HumanDesignChart?>
                    ? chartAsync.value
                    : null;
                ref.read(aiChatNotifierProvider.notifier).sendMessage(
                      message,
                      chart: chart,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AsyncValue<HumanDesignChart?> chartAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final chart =
        chartAsync is AsyncData<HumanDesignChart?> ? chartAsync.value : null;
    final questions = ref.watch(suggestedQuestionsProvider(chart));

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 48),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.8),
                  AppColors.primary,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.ai_welcomeTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l10n.ai_welcomeSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          SuggestedQuestions(
            questions: questions,
            onQuestionTap: (question) {
              ref.read(aiChatNotifierProvider.notifier).sendMessage(
                    question,
                    chart: chart,
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, AiChatState chatState) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount:
          chatState.messages.length + (chatState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == chatState.messages.length && chatState.isLoading) {
          return _buildTypingIndicator(context);
        }

        return ChatMessageBubble(message: chatState.messages[index]);
      },
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TypingDot(delay: 0),
            const SizedBox(width: 4),
            _TypingDot(delay: 150),
            const SizedBox(width: 4),
            _TypingDot(delay: 300),
          ],
        ),
      ),
    );
  }

  static void _noOp(String _) {}
}

class _TypingDot extends StatefulWidget {
  const _TypingDot({required this.delay});

  final int delay;

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.3 + (_animation.value * 0.5),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
