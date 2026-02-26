import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FileOptions;
import 'package:uuid/uuid.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../chart/domain/chart_providers.dart';
import '../../home/domain/home_providers.dart';
import '../domain/messaging_providers.dart';
import '../domain/models/message.dart';
import '../../../shared/providers/supabase_provider.dart';

class MessageDetailScreen extends ConsumerStatefulWidget {
  const MessageDetailScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  MessagingNotifier? _messagingNotifier;

  @override
  void initState() {
    super.initState();
    // Mark messages as read when entering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _messagingNotifier = ref.read(messagingNotifierProvider.notifier);
      _messagingNotifier?.markAsRead(widget.conversationId);
      _messagingNotifier?.subscribeToConversation(widget.conversationId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    // Use stored reference to safely unsubscribe
    _messagingNotifier?.unsubscribeFromConversation();
    super.dispose();
  }

  void _handleMenuAction(BuildContext context, String action) {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case 'mute':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.messages_notificationsMuted)),
        );
        break;
      case 'block':
        _showBlockConfirmation(context);
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showBlockConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.messages_blockUser),
        content: Text(l10n.messages_blockUserConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                // Get the other user's ID from the conversation
                final conversation = ref.read(conversationProvider(widget.conversationId)).value;
                final currentUserId = ref.read(currentUserIdProvider);
                final otherUser = conversation?.participants
                    .where((p) => p.id != currentUserId)
                    .firstOrNull;

                if (otherUser != null) {
                  final repo = ref.read(messagingRepositoryProvider);
                  await repo.blockUser(otherUser.id);
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.messages_userBlocked)),
                  );
                  this.context.pop();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ErrorHandler.getUserMessage(e))),
                  );
                }
              }
            },
            child: Text(l10n.messages_block),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.messages_deleteConversation),
        content: Text(l10n.messages_deleteConversationConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final repo = ref.read(messagingRepositoryProvider);
                await repo.deleteConversation(widget.conversationId);

                if (mounted) {
                  this.context.pop();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text(l10n.messages_conversationDeleted)),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ErrorHandler.getUserMessage(e))),
                  );
                }
              }
            },
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversationAsync = ref.watch(conversationProvider(widget.conversationId));
    final messages = ref.watch(combinedMessagesProvider(widget.conversationId));
    final currentUserId = ref.watch(currentUserIdProvider);
    final messagingState = ref.watch(messagingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/messages');
            }
          },
        ),
        title: conversationAsync.when(
          data: (conversation) {
            if (conversation == null) return Text(AppLocalizations.of(context)!.messaging_conversation);
            final other = conversation.getOtherParticipant(currentUserId ?? '');
            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: other?.avatarUrl != null
                      ? NetworkImage(other!.avatarUrl!)
                      : null,
                  child: other?.avatarUrl == null
                      ? Text((other?.name ?? 'U')[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        other?.name ?? 'Unknown',
                        style: theme.textTheme.titleMedium,
                      ),
                      if (other?.hdType != null)
                        Text(
                          other!.hdType!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => Text(AppLocalizations.of(context)!.messages_loading),
          error: (_, _) => Text(AppLocalizations.of(context)!.messages_conversation),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return [
                PopupMenuItem(
                  value: 'mute',
                  child: ListTile(
                    leading: const Icon(Icons.notifications_off_outlined),
                    title: Text(l10n.messages_muteNotifications),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: ListTile(
                    leading: const Icon(Icons.block),
                    title: Text(l10n.messages_blockUser),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: const Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(l10n.messages_deleteConversation, style: const TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.messages_startConversation,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.isMine(currentUserId ?? '');
                      final showAvatar = !isMe &&
                          (index == messages.length - 1 ||
                              messages[index + 1].senderId != message.senderId);
                      final showTimestamp = index == messages.length - 1 ||
                          _shouldShowTimestamp(message, messages[index + 1]);

                      return _MessageBubble(
                        message: message,
                        isMe: isMe,
                        showAvatar: showAvatar,
                        showTimestamp: showTimestamp,
                      );
                    },
                  ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _showAttachmentOptions(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.messaging_typeMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: messagingState.isSending ? null : _sendMessage,
                    icon: messagingState.isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(DirectMessage current, DirectMessage previous) {
    final diff = current.createdAt.difference(previous.createdAt);
    return diff.inMinutes.abs() > 15;
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();

    try {
      await ref.read(messagingNotifierProvider.notifier).sendMessage(
            conversationId: widget.conversationId,
            content: content,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'send message')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showAttachmentOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.auto_graph),
              title: Text(l10n.messaging_shareChart),
              onTap: () {
                Navigator.pop(context);
                _shareChart();
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: Text(l10n.messaging_shareTransit),
              onTap: () {
                Navigator.pop(context);
                _shareTransit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(l10n.messaging_sendImage),
              onTap: () {
                Navigator.pop(context);
                _sendImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareChart() async {
    final savedChartsAsync = ref.read(userSavedChartsProvider);
    final userChartAsync = ref.read(userChartProvider);

    final charts = savedChartsAsync.hasValue ? (savedChartsAsync.value ?? []) : <ChartSummary>[];
    final userChart = userChartAsync.hasValue ? userChartAsync.value : null;

    if (charts.isEmpty && userChart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.messaging_noChartsAvailable)),
      );
      return;
    }

    // Show chart selector dialog
    final l10n = AppLocalizations.of(context)!;
    final selectedChart = await showDialog<ChartSummary>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.messaging_selectChart),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: charts.length,
            itemBuilder: (context, index) {
              final chart = charts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(chart.name[0].toUpperCase()),
                ),
                title: Text(chart.name),
                subtitle: Text('${chart.type.displayName} - ${chart.profile}'),
                trailing: chart.isCurrentUser
                    ? Chip(label: Text(l10n.messaging_you))
                    : null,
                onTap: () => Navigator.pop(context, chart),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.common_cancel),
          ),
        ],
      ),
    );

    if (selectedChart == null || !mounted) return;

    try {
      // Create chart share message
      final chartData = {
        'chartId': selectedChart.id,
        'name': selectedChart.name,
        'type': selectedChart.type.displayName,
        'profile': selectedChart.profile,
      };

      await ref.read(messagingNotifierProvider.notifier).sendMessage(
        conversationId: widget.conversationId,
        content: jsonEncode(chartData),
        messageType: MessageType.chartShare,
        sharedChartId: selectedChart.id,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'share chart')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _shareTransit() async {
    try {
      final transitService = ref.read(transitServiceProvider);
      final currentTransit = transitService.calculateCurrentTransits();

      // Get the main transit info (Sun gate)
      final sunGate = currentTransit.sunGate;
      final transitMessage = 'Current Transit: Sun in Gate ${sunGate.gate}.${sunGate.line}';

      await ref.read(messagingNotifierProvider.notifier).sendMessage(
        conversationId: widget.conversationId,
        content: transitMessage,
        messageType: MessageType.transitShare,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'share transit')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Allowed MIME types for image uploads
  static const _allowedImageMimes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
  ];

  Future<void> _sendImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw StateError('User not authenticated');
      }

      // Upload image to Supabase Storage
      final bytes = await File(pickedFile.path).readAsBytes();

      // Validate MIME type using header bytes (prevents extension spoofing)
      final mimeType = lookupMimeType(
        pickedFile.path,
        headerBytes: bytes.length >= 12 ? bytes.sublist(0, 12) : bytes,
      );

      if (mimeType == null || !_allowedImageMimes.contains(mimeType)) {
        throw StateError('Invalid image type. Allowed: JPEG, PNG, GIF, WebP');
      }

      final extension = mimeType.split('/').last;
      const uuid = Uuid();
      final fileName = '${uuid.v4()}.$extension';
      final filePath = '$userId/messages/$fileName';

      await client.storage.from('message-images').uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(
          contentType: mimeType,
          upsert: true,
        ),
      );

      final publicUrl = client.storage.from('message-images').getPublicUrl(filePath);

      // Send message with image
      await ref.read(messagingNotifierProvider.notifier).sendMessage(
        conversationId: widget.conversationId,
        content: 'Image',
        messageType: MessageType.image,
        mediaUrl: publicUrl,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'send image')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.showTimestamp,
  });

  final DirectMessage message;
  final bool isMe;
  final bool showAvatar;
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: showTimestamp ? 16 : 4,
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe && showAvatar)
                CircleAvatar(
                  radius: 16,
                  backgroundImage: message.senderAvatarUrl != null
                      ? NetworkImage(message.senderAvatarUrl!)
                      : null,
                  child: message.senderAvatarUrl == null
                      ? Text(
                          (message.senderName ?? 'U')[0].toUpperCase(),
                          style: theme.textTheme.labelSmall,
                        )
                      : null,
                )
              else if (!isMe)
                const SizedBox(width: 32),
              if (!isMe) const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: _buildMessageContent(context),
                ),
              ),
            ],
          ),
          if (showTimestamp)
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left: isMe ? 0 : 40,
              ),
              child: Text(
                _formatTimestamp(message.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final theme = Theme.of(context);

    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isMe
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        );

      case MessageType.chartShare:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_graph,
              size: 20,
              color: isMe
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Chart shared',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isMe
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        );

      case MessageType.transitShare:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wb_sunny,
              size: 20,
              color: isMe
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.tertiary,
            ),
            const SizedBox(width: 8),
            Text(
              message.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isMe
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        );

      case MessageType.image:
        if (message.mediaUrl != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              message.mediaUrl!,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
            ),
          );
        }
        return Text(
          message.content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isMe
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        );
    }
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (isToday) {
      return time;
    }

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;

    if (isYesterday) {
      return 'Yesterday $time';
    }

    return '${dateTime.day}/${dateTime.month} $time';
  }
}
