import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../discovery/domain/discovery_providers.dart';
import '../../../discovery/domain/models/user_discovery.dart';
import '../../domain/messaging_providers.dart';

class NewConversationSheet extends ConsumerStatefulWidget {
  const NewConversationSheet({super.key});

  @override
  ConsumerState<NewConversationSheet> createState() => _NewConversationSheetState();
}

class _NewConversationSheetState extends ConsumerState<NewConversationSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final followingAsync = ref.watch(followingListProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)!.messages_title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.discovery_searchUsers,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Following list
              Expanded(
                child: followingAsync.when(
                  data: (following) {
                    final filteredUsers = _searchQuery.isEmpty
                        ? following
                        : following
                            .where((u) =>
                                u.name.toLowerCase().contains(_searchQuery))
                            .toList();

                    if (filteredUsers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? AppLocalizations.of(context)!.discovery_notFollowingAnyone
                                  : AppLocalizations.of(context)!.discovery_noUsersFound,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            if (_searchQuery.isEmpty) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.push(AppRoutes.discover);
                                },
                                child: Text(AppLocalizations.of(context)!.discovery_discoverPeople),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return _UserTile(
                          user: user,
                          isLoading: _isLoading,
                          onTap: () => _startConversation(user),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Text(ErrorHandler.getUserMessage(e, context: 'load users')),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startConversation(DiscoveredUser user) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final conversation = await ref
          .read(messagingNotifierProvider.notifier)
          .startConversation(user.id);

      if (mounted) {
        Navigator.pop(context);
        context.push('${AppRoutes.messages}/${conversation.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'start conversation')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.user,
    required this.isLoading,
    required this.onTap,
  });

  final DiscoveredUser user;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: isLoading ? null : onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundImage:
            user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        child: user.avatarUrl == null
            ? Text(
                user.name[0].toUpperCase(),
                style: theme.textTheme.titleMedium,
              )
            : null,
      ),
      title: Text(
        user.name,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: user.hdType != null ? Text(user.hdType!) : null,
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.outline,
      ),
    );
  }
}
