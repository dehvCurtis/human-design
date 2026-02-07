import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ai_message.dart';

/// Chat message bubble with markdown-like rendering.
///
/// Security: Content is rendered as plain text with basic formatting.
/// No HTML rendering or URL auto-linking to prevent phishing via AI responses.
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  final AiMessage message;

  bool get _isUser => message.role == AiMessageRole.user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: EdgeInsets.only(
          left: _isUser ? 48 : 8,
          right: _isUser ? 8 : 48,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment:
              _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Role label
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
              child: Text(
                _isUser ? 'You' : 'AI Assistant',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            // Message bubble
            Material(
              color: _isUser
                  ? AppColors.primary
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    _isUser ? const Radius.circular(16) : Radius.zero,
                bottomRight:
                    _isUser ? Radius.zero : const Radius.circular(16),
              ),
              child: InkWell(
                onLongPress: () => _copyToClipboard(context),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: _buildContent(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = _isUser ? Colors.white : theme.colorScheme.onSurface;

    // Render content as styled text with basic markdown-like formatting.
    // Using SelectableText for accessibility; no HTML to prevent XSS.
    return SelectableText(
      message.content,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        height: 1.5,
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message.content));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
