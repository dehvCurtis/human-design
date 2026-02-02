import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../domain/messaging_providers.dart';

/// Screen that creates or gets an existing conversation with a user
/// and then navigates to the message detail screen.
class MessageWithUserScreen extends ConsumerStatefulWidget {
  const MessageWithUserScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<MessageWithUserScreen> createState() =>
      _MessageWithUserScreenState();
}

class _MessageWithUserScreenState extends ConsumerState<MessageWithUserScreen> {
  @override
  void initState() {
    super.initState();
    _initConversation();
  }

  Future<void> _initConversation() async {
    try {
      final repository = ref.read(messagingRepositoryProvider);
      final conversation = await repository.getOrCreateConversation(widget.userId);

      if (mounted) {
        // Replace the current route with the conversation detail
        context.go('/messages/${conversation.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'start conversation'))),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Starting conversation...'),
          ],
        ),
      ),
    );
  }
}
