import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../domain/models/hashtag.dart';

/// A widget that displays text with tappable hashtags
class HashtagText extends StatelessWidget {
  const HashtagText({
    super.key,
    required this.text,
    required this.onHashtagTap,
    this.style,
    this.hashtagStyle,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final void Function(String hashtag) onHashtagTap;
  final TextStyle? style;
  final TextStyle? hashtagStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = style ?? theme.textTheme.bodyMedium;
    final defaultHashtagStyle = hashtagStyle ??
        defaultStyle?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
        );

    final matches = HashtagParser.findHashtagMatches(text);

    if (matches.isEmpty) {
      return Text(
        text,
        style: defaultStyle,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in matches) {
      // Add text before this hashtag
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: defaultStyle,
        ));
      }

      // Add the hashtag
      spans.add(TextSpan(
        text: '#${match.tag}',
        style: defaultHashtagStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () => onHashtagTap(match.tag),
      ));

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: defaultStyle,
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A widget that displays hashtag chips
class HashtagChips extends StatelessWidget {
  const HashtagChips({
    super.key,
    required this.hashtags,
    required this.onHashtagTap,
    this.maxChips,
  });

  final List<String> hashtags;
  final void Function(String hashtag) onHashtagTap;
  final int? maxChips;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTags = maxChips != null
        ? hashtags.take(maxChips!).toList()
        : hashtags;
    final remaining = maxChips != null && hashtags.length > maxChips!
        ? hashtags.length - maxChips!
        : 0;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...displayTags.map((tag) => _HashtagChip(
          tag: tag,
          onTap: () => onHashtagTap(tag),
        )),
        if (remaining > 0)
          Chip(
            label: Text('+$remaining'),
            labelStyle: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.outline,
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            backgroundColor: theme.colorScheme.surfaceContainerHigh,
          ),
      ],
    );
  }
}

class _HashtagChip extends StatelessWidget {
  const _HashtagChip({
    required this.tag,
    required this.onTap,
  });

  final String tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '#$tag',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// A search field for hashtags with suggestions
class HashtagSearchField extends StatefulWidget {
  const HashtagSearchField({
    super.key,
    required this.onSearch,
    required this.suggestions,
    required this.onSuggestionTap,
    this.hintText,
  });

  final void Function(String query) onSearch;
  final List<Hashtag> suggestions;
  final void Function(Hashtag hashtag) onSuggestionTap;
  final String? hintText;

  @override
  State<HashtagSearchField> createState() => _HashtagSearchFieldState();
}

class _HashtagSearchFieldState extends State<HashtagSearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && widget.suggestions.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Search hashtags...',
            prefixIcon: const Icon(Icons.tag),
            border: const OutlineInputBorder(),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      widget.onSearch('');
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            widget.onSearch(value);
            setState(() {});
          },
        ),
        if (_showSuggestions && widget.suggestions.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.suggestions.length,
              itemBuilder: (context, index) {
                final hashtag = widget.suggestions[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.tag, size: 18),
                  title: Text('#${hashtag.name}'),
                  trailing: Text(
                    '${hashtag.postCount} posts',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  onTap: () {
                    widget.onSuggestionTap(hashtag);
                    _controller.clear();
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

/// A widget to show hashtag suggestions while typing
class HashtagSuggestionBar extends StatelessWidget {
  const HashtagSuggestionBar({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  final List<Hashtag> suggestions;
  final void Function(Hashtag hashtag) onTap;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final hashtag = suggestions[index];
          return _HashtagChip(
            tag: hashtag.name,
            onTap: () => onTap(hashtag),
          );
        },
      ),
    );
  }
}
