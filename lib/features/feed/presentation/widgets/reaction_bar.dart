import 'package:flutter/material.dart';

import '../../domain/models/post.dart';

class ReactionBar extends StatelessWidget {
  const ReactionBar({
    super.key,
    this.currentReaction,
    required this.onReaction,
    required this.onComment,
    required this.onShare,
  });

  final ReactionType? currentReaction;
  final void Function(ReactionType) onReaction;
  final VoidCallback onComment;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ReactionButton(
          currentReaction: currentReaction,
          onReaction: onReaction,
        ),
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: 'Comment',
          onTap: onComment,
        ),
        _ActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: onShare,
        ),
      ],
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    this.currentReaction,
    required this.onReaction,
  });

  final ReactionType? currentReaction;
  final void Function(ReactionType) onReaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasReaction = currentReaction != null;

    return GestureDetector(
      onTap: () => onReaction(currentReaction ?? ReactionType.like),
      onLongPress: () => _showReactionPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasReaction ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: hasReaction
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              hasReaction ? currentReaction!.label : 'React',
              style: TextStyle(
                color: hasReaction
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: hasReaction ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReactionPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReactionPicker(
        currentReaction: currentReaction,
        onReaction: (type) {
          Navigator.pop(context);
          onReaction(type);
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReactionPicker extends StatelessWidget {
  const ReactionPicker({
    super.key,
    this.currentReaction,
    required this.onReaction,
  });

  final ReactionType? currentReaction;
  final void Function(ReactionType) onReaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Group reactions by category
    const standardReactions = [
      ReactionType.like,
      ReactionType.love,
      ReactionType.insight,
      ReactionType.resonate,
    ];

    const hdReactions = [
      ReactionType.generatorSacral,
      ReactionType.projectorRecognition,
      ReactionType.manifestorPeace,
      ReactionType.reflectorSurprise,
      ReactionType.mgSatisfaction,
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'React',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          // Standard reactions
          Text(
            'Standard',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: standardReactions.map((type) {
              return _ReactionOption(
                type: type,
                isSelected: currentReaction == type,
                onTap: () => onReaction(type),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // HD-specific reactions
          Text(
            'Human Design',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hdReactions.map((type) {
              return _ReactionOption(
                type: type,
                isSelected: currentReaction == type,
                onTap: () => onReaction(type),
                showLabel: true,
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ReactionOption extends StatelessWidget {
  const _ReactionOption({
    required this.type,
    required this.isSelected,
    required this.onTap,
    this.showLabel = false,
  });

  final ReactionType type;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (showLabel) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: theme.colorScheme.primary)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(type.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            type.emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
