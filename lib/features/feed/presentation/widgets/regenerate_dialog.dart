import 'package:flutter/material.dart';

import '../../domain/models/post.dart';

/// Dialog for confirming and customizing a regenerate (repost) action
class RegenerateDialog extends StatefulWidget {
  const RegenerateDialog({
    super.key,
    required this.originalPost,
    required this.onConfirm,
  });

  final Post originalPost;
  final void Function({
    String? comment,
    PostVisibility visibility,
  }) onConfirm;

  @override
  State<RegenerateDialog> createState() => _RegenerateDialogState();
}

class _RegenerateDialogState extends State<RegenerateDialog> {
  final _commentController = TextEditingController();
  PostVisibility _visibility = PostVisibility.public;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final originalPost = widget.originalPost;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.repeat,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Regenerate this thought?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'This will share this thought to your wall, crediting the original author.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),

              // Original post preview
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Original author
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _getTypeColor(originalPost.userHdType),
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundImage: originalPost.userAvatarUrl != null
                                ? NetworkImage(originalPost.userAvatarUrl!)
                                : null,
                            child: originalPost.userAvatarUrl == null
                                ? Text(
                                    originalPost.userName.isNotEmpty
                                        ? originalPost.userName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(fontSize: 12),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            originalPost.userName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Original content preview
                    Text(
                      originalPost.content,
                      style: theme.textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Optional comment
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 16),

              // Visibility selector
              Text(
                'Visibility',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _VisibilityChip(
                    label: 'Public',
                    icon: Icons.public,
                    isSelected: _visibility == PostVisibility.public,
                    onTap: () => setState(() => _visibility = PostVisibility.public),
                  ),
                  const SizedBox(width: 8),
                  _VisibilityChip(
                    label: 'Followers',
                    icon: Icons.people_outline,
                    isSelected: _visibility == PostVisibility.followers,
                    onTap: () => setState(() => _visibility = PostVisibility.followers),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onConfirm(
                        comment: _commentController.text.trim().isEmpty
                            ? null
                            : _commentController.text.trim(),
                        visibility: _visibility,
                      );
                    },
                    icon: const Icon(Icons.repeat, size: 18),
                    label: const Text('Regenerate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'Generator':
        return Colors.orange;
      case 'Manifesting Generator':
        return Colors.deepOrange;
      case 'Projector':
        return Colors.blue;
      case 'Manifestor':
        return Colors.red;
      case 'Reflector':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _VisibilityChip extends StatelessWidget {
  const _VisibilityChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the regenerate dialog and returns the result
Future<void> showRegenerateDialog({
  required BuildContext context,
  required Post originalPost,
  required void Function({String? comment, PostVisibility visibility}) onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (context) => RegenerateDialog(
      originalPost: originalPost,
      onConfirm: onConfirm,
    ),
  );
}
