import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FileOptions;
import 'package:uuid/uuid.dart';

import '../../../../core/utils/error_handler.dart';
import '../../../../shared/providers/supabase_provider.dart';
import '../../../chart/domain/chart_providers.dart';
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
  String? _selectedChartId;
  String? _selectedChartName;

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

              // Selected chart tag
              if (_selectedChartId != null) ...[
                const SizedBox(height: 12),
                Chip(
                  avatar: const Icon(Icons.pie_chart_outline, size: 18),
                  label: Text(_selectedChartName ?? 'Chart'),
                  onDeleted: () => setState(() {
                    _selectedChartId = null;
                    _selectedChartName = null;
                  }),
                  deleteIcon: const Icon(Icons.close, size: 16),
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
                    icon: Icon(
                      Icons.pie_chart_outline,
                      color: _selectedChartId != null
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    onPressed: _showChartPicker,
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
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'pick image'))),
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

  void _showChartPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ChartPickerSheet(
        selectedChartId: _selectedChartId,
        onChartSelected: (chartId, chartName) {
          setState(() {
            _selectedChartId = chartId;
            _selectedChartName = chartName;
            _selectedType = PostType.chartShare;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Allowed MIME types for image uploads
  static const _allowedImageMimes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
  ];

  /// Validate MIME type by checking file header bytes
  String? _validateImageMimeType(Uint8List bytes, String filename) {
    // Check MIME type using file header bytes (magic numbers)
    final mimeType = lookupMimeType(
      filename,
      headerBytes: bytes.length >= 12 ? bytes.sublist(0, 12) : bytes,
    );

    if (mimeType == null || !_allowedImageMimes.contains(mimeType)) {
      return 'Invalid image type. Allowed: JPEG, PNG, GIF, WebP';
    }
    return null;
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

      // Validate file size (max 10 MB)
      const maxImageSizeBytes = 10 * 1024 * 1024;
      if (bytes.length > maxImageSizeBytes) {
        throw StateError('Image exceeds maximum size of 10 MB');
      }

      // Validate MIME type using header bytes (prevents extension spoofing)
      final validationError = _validateImageMimeType(bytes, image.path);
      if (validationError != null) {
        throw StateError(validationError);
      }

      // Get actual MIME type from header
      final mimeType = lookupMimeType(
        image.path,
        headerBytes: bytes.length >= 12 ? bytes.sublist(0, 12) : bytes,
      );
      final extension = mimeType?.split('/').last ?? 'jpg';
      final fileName = '${uuid.v4()}.$extension';
      final filePath = '$userId/posts/$fileName';

      await client.storage.from('post-images').uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(
          contentType: mimeType ?? 'image/jpeg',
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
      case PostType.dreamShare:
        return 'Share your dream and its interpretation...';
    }
  }

  Future<void> _submitPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedImages.isEmpty && _selectedChartId == null) {
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

      // Serialize chart data as JSON if a chart is attached
      Map<String, dynamic>? chartData;
      if (_selectedChartId != null) {
        final chart = await ref.read(chartByIdProvider(_selectedChartId!).future);
        if (chart != null) {
          chartData = chart.toShareJson();
        }
      }

      // Only send chart_id if it's a real UUID (not the 'user' placeholder)
      final chartIdForDb = _selectedChartId != null && _selectedChartId != 'user'
          ? _selectedChartId
          : null;

      await ref.read(feedNotifierProvider.notifier).createPost(
            content: content,
            postType: _selectedType,
            visibility: _visibility,
            mediaUrls: mediaUrls,
            chartId: chartIdForDb,
            chartData: chartData,
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
    } catch (e, stackTrace) {
      debugPrint('Create post error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'create post'))),
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
      case PostType.dreamShare:
        return (Icons.nights_stay, 'Dream', Colors.deepPurple);
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

class _ChartPickerSheet extends ConsumerWidget {
  const _ChartPickerSheet({
    required this.selectedChartId,
    required this.onChartSelected,
  });

  final String? selectedChartId;
  final void Function(String chartId, String chartName) onChartSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final chartsAsync = ref.watch(userSavedChartsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

          Text(
            'Select Chart to Share',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          chartsAsync.when(
            data: (charts) {
              if (charts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No charts available. Add your birth data to create a chart.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: charts.length,
                  itemBuilder: (context, index) {
                    final chart = charts[index];
                    final isSelected = chart.id == selectedChartId;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.pie_chart,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      title: Text(chart.name),
                      trailing: isSelected
                          ? Icon(Icons.check, color: theme.colorScheme.primary)
                          : null,
                      selected: isSelected,
                      onTap: () => onChartSelected(chart.id, chart.name),
                    );
                  },
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Failed to load charts',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
