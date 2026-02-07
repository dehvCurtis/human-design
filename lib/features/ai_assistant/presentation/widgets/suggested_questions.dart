import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Displays contextual suggested question chips for the AI chat.
class SuggestedQuestions extends StatelessWidget {
  const SuggestedQuestions({
    super.key,
    required this.questions,
    required this.onQuestionTap,
  });

  final List<String> questions;
  final void Function(String question) onQuestionTap;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested questions',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: questions.map((question) {
              return ActionChip(
                label: Text(
                  question,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                onPressed: () => onQuestionTap(question),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
