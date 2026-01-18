import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/feed_providers.dart';
import '../../domain/models/post.dart';

class CreatePostSheet extends ConsumerStatefulWidget {
  const CreatePostSheet({
    super.key,
    this.initialPostType,
    this.prefillContent,
    this.gateNumber,
    this.channelId,
    this.transitData,
  });

  final PostType? initialPostType;
  final String? prefillContent;
  final int? gateNumber;
  final String? channelId;
  final Map<String, dynamic>? transitData;

  @override
  ConsumerState<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends ConsumerState<CreatePostSheet> {
  final _contentController = TextEditingController();
  late PostType _selectedType;
  PostVisibility _visibility = PostVisibility.public;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialPostType ?? PostType.insight;
    if (widget.prefillContent != null) {
      _contentController.text = widget.prefillContent!;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  Text(
                    'Create Post',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submitPost,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Post'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Post type selector
              Text(
                'Post Type',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: PostType.values.map((type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _PostTypeChip(
                        type: type,
                        isSelected: _selectedType == type,
                        onTap: () => setState(() => _selectedType = type),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Content input
              TextField(
                controller: _contentController,
                maxLines: 6,
                minLines: 4,
                decoration: InputDecoration(
                  hintText: _getHintText(_selectedType),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
                textCapitalization: TextCapitalization.sentences,
              ),

              // Gate/Channel tags
              if (widget.gateNumber != null || widget.channelId != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    if (widget.gateNumber != null)
                      Chip(
                        label: Text('Gate ${widget.gateNumber}'),
                        onDeleted: () {},
                        deleteIcon: const Icon(Icons.close, size: 16),
                      ),
                    if (widget.channelId != null)
                      Chip(
                        label: Text('Channel ${widget.channelId}'),
                        onDeleted: () {},
                        deleteIcon: const Icon(Icons.close, size: 16),
                      ),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              // Visibility selector
              Text(
                'Who can see this?',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              _VisibilitySelector(
                visibility: _visibility,
                onChanged: (v) => setState(() => _visibility = v),
              ),

              const SizedBox(height: 16),

              // Attachments row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image_outlined),
                    onPressed: () {
                      // TODO: Add image picker
                    },
                    tooltip: 'Add image',
                  ),
                  IconButton(
                    icon: const Icon(Icons.pie_chart_outline),
                    onPressed: () {
                      // TODO: Attach chart
                    },
                    tooltip: 'Attach chart',
                  ),
                  IconButton(
                    icon: const Icon(Icons.tag),
                    onPressed: () {
                      // TODO: Add gate/channel tag
                    },
                    tooltip: 'Tag gate or channel',
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getHintText(PostType type) {
    switch (type) {
      case PostType.insight:
        return 'Share an insight about your Human Design...';
      case PostType.reflection:
        return 'Reflect on your day or experience...';
      case PostType.transitShare:
        return 'How is this transit affecting you?';
      case PostType.chartShare:
        return 'Share something about your chart...';
      case PostType.question:
        return 'Ask the community a question...';
      case PostType.achievement:
        return 'Celebrate your achievement!';
    }
  }

  Future<void> _submitPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(feedNotifierProvider.notifier).createPost(
            content: content,
            postType: _selectedType,
            visibility: _visibility,
            gateNumber: widget.gateNumber,
            channelId: widget.channelId,
            transitData: widget.transitData,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class _PostTypeChip extends StatelessWidget {
  const _PostTypeChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final PostType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, label, color) = _getPostTypeInfo(type);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? color : null),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      selectedColor: color.withValues(alpha: 0.2),
      onSelected: (_) => onTap(),
    );
  }

  (IconData, String, Color) _getPostTypeInfo(PostType type) {
    switch (type) {
      case PostType.insight:
        return (Icons.lightbulb_outline, 'Insight', Colors.amber);
      case PostType.reflection:
        return (Icons.psychology_outlined, 'Reflection', Colors.purple);
      case PostType.transitShare:
        return (Icons.autorenew, 'Transit', Colors.cyan);
      case PostType.chartShare:
        return (Icons.pie_chart_outline, 'Chart', Colors.indigo);
      case PostType.question:
        return (Icons.help_outline, 'Question', Colors.teal);
      case PostType.achievement:
        return (Icons.emoji_events_outlined, 'Achievement', Colors.orange);
    }
  }
}

class _VisibilitySelector extends StatelessWidget {
  const _VisibilitySelector({
    required this.visibility,
    required this.onChanged,
  });

  final PostVisibility visibility;
  final ValueChanged<PostVisibility> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PostVisibility>(
      segments: const [
        ButtonSegment(
          value: PostVisibility.public,
          icon: Icon(Icons.public, size: 18),
          label: Text('Public'),
        ),
        ButtonSegment(
          value: PostVisibility.followers,
          icon: Icon(Icons.group, size: 18),
          label: Text('Followers'),
        ),
        ButtonSegment(
          value: PostVisibility.private,
          icon: Icon(Icons.lock, size: 18),
          label: Text('Private'),
        ),
      ],
      selected: {visibility},
      onSelectionChanged: (selected) {
        if (selected.isNotEmpty) {
          onChanged(selected.first);
        }
      },
    );
  }
}
