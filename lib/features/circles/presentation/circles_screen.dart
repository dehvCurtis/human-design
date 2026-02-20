import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/compatibility_circle_providers.dart';
import '../domain/models/compatibility_circle.dart';

class CirclesScreen extends ConsumerWidget {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.circles_title),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(text: l10n.circles_myCircles),
              Tab(text: l10n.circles_invitations),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showCreateCircleDialog(context, ref),
              tooltip: l10n.circles_create,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _MyCirclesTab(),
            _InvitationsTab(),
          ],
        ),
      ),
    );
  }

  void _showCreateCircleDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedEmoji = '\u{1F3E0}'; // Default: 🏠

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.circles_create),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji selector
                Text(
                  l10n.circles_selectIcon,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    '\u{1F3E0}', // 🏠 Family
                    '\u{2764}', // ❤️ Partner
                    '\u{1F4BC}', // 💼 Work
                    '\u{1F91D}', // 🤝 Friends
                    '\u{1F3E1}', // 🏡 Roommates
                    '\u{2B50}', // ⭐ Custom
                  ].map((emoji) {
                    final isSelected = emoji == selectedEmoji;
                    return InkWell(
                      onTap: () => setState(() => selectedEmoji = emoji),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: Theme.of(context).colorScheme.primary)
                              : null,
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.circles_name,
                    hintText: l10n.circles_nameHint,
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.circles_description,
                    hintText: l10n.circles_descriptionHint,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;

                final notifier = ref.read(compatibilityCircleNotifierProvider.notifier);
                final circle = await notifier.createCircle(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                  iconEmoji: selectedEmoji,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  if (circle != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.circles_created)),
                    );
                    context.push('/circle/${circle.id}');
                  }
                }
              },
              child: Text(l10n.create),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyCirclesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final circlesAsync = ref.watch(myCirclesProvider);

    return circlesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
      data: (circles) {
        if (circles.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.circles_noCircles,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.circles_noCirclesDescription,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Template suggestions
                  Text(
                    l10n.circles_suggestions,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: CircleTemplates.templates.take(3).map((template) {
                      return ActionChip(
                        avatar: Text(template.iconEmoji),
                        label: Text(template.name),
                        onPressed: () {
                          // Show create dialog with template pre-filled
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(myCirclesProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: circles.length,
            itemBuilder: (context, index) {
              final circle = circles[index];
              return _CircleCard(circle: circle);
            },
          ),
        );
      },
    );
  }
}

class _CircleCard extends StatelessWidget {
  const _CircleCard({required this.circle});

  final CompatibilityCircle circle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/circle/${circle.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Circle icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    circle.iconEmoji ?? '\u{2B50}',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      circle.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (circle.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        circle.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.circles_memberCount(circle.memberCount),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (circle.isPrivate) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.lock_outline,
                            size: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            l10n.circles_private,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvitationsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final invitationsAsync = ref.watch(pendingCircleInvitationsProvider);

    return invitationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
      data: (invitations) {
        if (invitations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.circles_noInvitations,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.circles_noInvitationsDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(pendingCircleInvitationsProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: invitations.length,
            itemBuilder: (context, index) {
              final invitation = invitations[index];
              return _InvitationCard(invitation: invitation);
            },
          ),
        );
      },
    );
  }
}

class _InvitationCard extends ConsumerWidget {
  const _InvitationCard({required this.invitation});

  final Map<String, dynamic> invitation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final circle = invitation['circle'] as Map<String, dynamic>;
    final inviter = invitation['inviter'] as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      circle['icon_emoji'] as String? ?? '\u{2B50}',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        circle['name'] as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.circles_invitedBy(inviter['name'] as String? ?? 'Unknown'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    final notifier = ref.read(compatibilityCircleNotifierProvider.notifier);
                    final success = await notifier.declineInvitation(invitation['id'] as String);
                    if (context.mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.circles_invitationDeclined)),
                      );
                    }
                  },
                  child: Text(l10n.circles_decline),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    final notifier = ref.read(compatibilityCircleNotifierProvider.notifier);
                    final success = await notifier.acceptInvitation(invitation['id'] as String);
                    if (context.mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.circles_invitationAccepted)),
                      );
                    }
                  },
                  child: Text(l10n.circles_accept),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
