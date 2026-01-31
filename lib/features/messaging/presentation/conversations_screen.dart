import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../domain/messaging_providers.dart';
import '../domain/models/message.dart';
import '../../../shared/providers/supabase_provider.dart';
import 'widgets/new_conversation_sheet.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Conversation> _filterConversations(List<Conversation> conversations, String currentUserId) {
    if (_searchQuery.isEmpty) return conversations;

    final query = _searchQuery.toLowerCase();
    return conversations.where((conversation) {
      final otherParticipant = conversation.getOtherParticipant(currentUserId);
      final name = (otherParticipant?.name ?? '').toLowerCase();
      final preview = (conversation.lastMessagePreview ?? '').toLowerCase();
      final hdType = (otherParticipant?.hdType ?? '').toLowerCase();

      return name.contains(query) || preview.contains(query) || hdType.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('Messages'),
        leading: IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.arrow_back),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchQuery = '';
                _searchController.clear();
              });
            } else {
              context.pop();
            }
          },
        ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          if (_isSearching && _searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(conversationsProvider);
        },
        child: conversationsAsync.when(
          data: (conversations) {
            final filteredConversations = _filterConversations(
              conversations,
              currentUserId ?? '',
            );

            if (conversations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No conversations yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start a conversation with someone!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _showNewConversationSheet(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('New Message'),
                    ),
                  ],
                ),
              );
            }

            if (filteredConversations.isEmpty && _searchQuery.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No results found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try a different search term',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredConversations.length,
              itemBuilder: (context, index) {
                final conversation = filteredConversations[index];
                return _ConversationTile(
                  conversation: conversation,
                  currentUserId: currentUserId ?? '',
                  onTap: () {
                    context.push('${AppRoutes.messages}/${conversation.id}');
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text('Error loading conversations'),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(conversationsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewConversationSheet(context),
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showNewConversationSheet(BuildContext context) {
    final currentUser = ref.read(supabaseClientProvider).auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please sign in to send messages'),
          action: SnackBarAction(
            label: 'Sign In',
            onPressed: () => context.go(AppRoutes.signIn),
          ),
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const NewConversationSheet(),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
  });

  final Conversation conversation;
  final String currentUserId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final otherParticipant = conversation.getOtherParticipant(currentUserId);
    final hasUnread = conversation.unreadCount > 0;

    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: otherParticipant?.avatarUrl != null
                ? NetworkImage(otherParticipant!.avatarUrl!)
                : null,
            child: otherParticipant?.avatarUrl == null
                ? Text(
                    (otherParticipant?.name ?? 'U')[0].toUpperCase(),
                    style: theme.textTheme.titleLarge,
                  )
                : null,
          ),
          if (hasUnread)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  conversation.unreadCount > 99
                      ? '99+'
                      : conversation.unreadCount.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              otherParticipant?.name ?? 'Unknown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (conversation.lastMessageAt != null)
            Text(
              _formatTime(conversation.lastMessageAt!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasUnread
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          if (otherParticipant?.hdType != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                otherParticipant!.hdType!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
          Expanded(
            child: Text(
              conversation.lastMessagePreview ?? 'No messages yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasUnread
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.outline,
                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
