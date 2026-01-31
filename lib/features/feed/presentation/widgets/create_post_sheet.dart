import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FileOptions;
import 'package:uuid/uuid.dart';

import '../../../../shared/providers/supabase_provider.dart';
import '../../domain/feed_providers.dart';
import '../../domain/models/post.dart';
import 'gate_channel_picker_sheet.dart';

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
  final _imagePicker = ImagePicker();
  late PostType _selectedType;
  PostVisibility _visibility = PostVisibility.public;
  bool _isSubmitting = false;
  final List<XFile> _selectedImages = [];
  int? _selectedGate;
  String? _selectedChannelId;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialPostType ?? PostType.insight;
    if (widget.prefillContent != null) {
      _contentController.text = widget.prefillContent!;
    }
    _selectedGate = widget.gateNumber;
    _selectedChannelId = widget.channelId;
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

              // Selected images preview
              if (_selectedImages.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedImages[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: theme.colorScheme.onError,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],

              // Gate/Channel tags
              if (_selectedGate != null || _selectedChannelId != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    if (_selectedGate != null)
                      Chip(
                        label: Text('Gate $_selectedGate'),
                        onDeleted: () => setState(() => _selectedGate = null),
                        deleteIcon: const Icon(Icons.close, size: 16),
                      ),
                    if (_selectedChannelId != null)
                      Chip(
                        label: Text('Channel $_selectedChannelId'),
                        onDeleted: () => setState(() => _selectedChannelId = null),
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
                    onPressed: _pickImage,
                    tooltip: 'Add image',
                  ),
                  IconButton(
                    icon: const Icon(Icons.pie_chart_outline),
                    onPressed: () {
                      setState(() {
                        _selectedType = PostType.chartShare;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post type set to Chart Share')),
                      );
                    },
                    tooltip: 'Attach chart',
                  ),
                  IconButton(
                    icon: const Icon(Icons.tag),
                    onPressed: _showGateChannelPicker,
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

  Future<void> _pickImage() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          // Limit to 4 images total
          final remaining = 4 - _selectedImages.length;
          _selectedImages.addAll(pickedFiles.take(remaining));
        });

        if (pickedFiles.length > 4 - _selectedImages.length) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Maximum 4 images allowed')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showGateChannelPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => GateChannelPickerSheet(
        initialGate: _selectedGate,
        initialChannel: _selectedChannelId,
        onGateSelected: (gate) {
          setState(() {
            _selectedGate = gate;
          });
          Navigator.pop(context);
        },
        onChannelSelected: (channel) {
          setState(() {
            _selectedChannelId = channel;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<List<String>> _uploadImages() async {
    if (_selectedImages.isEmpty) return [];

    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    final uploadedUrls = <String>[];
    const uuid = Uuid();

    for (final image in _selectedImages) {
      final bytes = await image.readAsBytes();
      final extension = image.path.split('.').last.toLowerCase();
      final fileName = '${uuid.v4()}.$extension';
      final filePath = '$userId/posts/$fileName';

      await client.storage.from('post-images').uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(
          contentType: 'image/$extension',
          upsert: true,
        ),
      );

      final publicUrl = client.storage.from('post-images').getPublicUrl(filePath);
      uploadedUrls.add(publicUrl);
    }

    return uploadedUrls;
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
      case PostType.regenerate:
        return ''; // Regenerate type not used in create sheet
    }
  }

  Future<void> _submitPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content or add an image')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Upload images first
      List<String>? mediaUrls;
      if (_selectedImages.isNotEmpty) {
        mediaUrls = await _uploadImages();
      }

      await ref.read(feedNotifierProvider.notifier).createPost(
            content: content,
            postType: _selectedType,
            visibility: _visibility,
            mediaUrls: mediaUrls,
            gateNumber: _selectedGate,
            channelId: _selectedChannelId,
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
      case PostType.regenerate:
        return (Icons.repeat, 'Regenerate', Colors.green);
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
