import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/error_handler.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/stories_providers.dart';
import '../../domain/models/story.dart';

class CreateStorySheet extends ConsumerStatefulWidget {
  const CreateStorySheet({super.key});

  @override
  ConsumerState<CreateStorySheet> createState() => _CreateStorySheetState();
}

class _CreateStorySheetState extends ConsumerState<CreateStorySheet> {
  final TextEditingController _contentController = TextEditingController();

  Color _backgroundColor = const Color(0xFF6366F1);
  Color _textColor = Colors.white;
  StoryVisibility _visibility = StoryVisibility.followers;
  int? _selectedTransitGate;
  String? _affirmationText;

  static const List<Color> _backgroundColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF43F5E), // Rose
    Color(0xFFF97316), // Orange
    Color(0xFFEAB308), // Yellow
    Color(0xFF22C55E), // Green
    Color(0xFF06B6D4), // Cyan
    Color(0xFF3B82F6), // Blue
    Color(0xFF1E293B), // Slate
  ];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final storiesState = ref.watch(storiesNotifierProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
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

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.common_cancel),
                    ),
                    Text(
                      'Create Story',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: storiesState.isCreating ? null : _createStory,
                      child: storiesState.isCreating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.common_share),
                    ),
                  ],
                ),
              ),

              // Preview
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Story preview
                      AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_selectedTransitGate != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      l10n.story_gateNumber(_selectedTransitGate!),
                                      style: TextStyle(
                                        color: _textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                TextField(
                                  controller: _contentController,
                                  style: TextStyle(
                                    color: _textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: l10n.story_typeYourStory,
                                    hintStyle: TextStyle(
                                      color: _textColor.withValues(alpha: 0.5),
                                      fontSize: 24,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                                if (_affirmationText != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _affirmationText!,
                                      style: TextStyle(
                                        color: _textColor,
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Background color picker
                      Text(
                        'Background',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 48,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _backgroundColors.length,
                          itemBuilder: (context, index) {
                            final color = _backgroundColors[index];
                            final isSelected = color == _backgroundColor;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _backgroundColor = color;
                                  // Auto-adjust text color for light backgrounds
                                  _textColor = color.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(
                                          color: theme.colorScheme.primary,
                                          width: 3,
                                        )
                                      : null,
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: _textColor,
                                        size: 20,
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Transit gate selector
                      Text(
                        'Attach Transit Gate (optional)',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(l10n.story_none),
                            selected: _selectedTransitGate == null,
                            onSelected: (_) {
                              setState(() => _selectedTransitGate = null);
                            },
                          ),
                          // Just show a few example gates - in real app this would be more dynamic
                          for (final gate in [1, 13, 25, 46, 64])
                            ChoiceChip(
                              label: Text(l10n.story_gateNumber(gate)),
                              selected: _selectedTransitGate == gate,
                              onSelected: (_) {
                                setState(() => _selectedTransitGate = gate);
                              },
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Visibility
                      Text(
                        'Who can see this?',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<StoryVisibility>(
                        segments: [
                          ButtonSegment(
                            value: StoryVisibility.followers,
                            label: Text(l10n.common_followers),
                            icon: const Icon(Icons.people),
                          ),
                          ButtonSegment(
                            value: StoryVisibility.public,
                            label: Text(l10n.story_everyone),
                            icon: const Icon(Icons.public),
                          ),
                        ],
                        selected: {_visibility},
                        onSelectionChanged: (selected) {
                          setState(() => _visibility = selected.first);
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createStory() async {
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedTransitGate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.story_addContent)),
      );
      return;
    }

    try {
      await ref.read(storiesNotifierProvider.notifier).createStory(
            content: content.isNotEmpty ? content : null,
            backgroundColor:
                '#${_backgroundColor.toARGB32().toRadixString(16).substring(2)}',
            textColor: '#${_textColor.toARGB32().toRadixString(16).substring(2)}',
            transitGate: _selectedTransitGate,
            affirmationText: _affirmationText,
            visibility: _visibility,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.story_created)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserMessage(e, context: 'create story')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
