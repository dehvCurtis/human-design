import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/quiz.dart';

/// Card widget displaying a quiz question with answer options
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    this.selectedAnswerId,
    this.showResult = false,
    this.onAnswerSelected,
  });

  final QuizQuestion question;
  final String? selectedAnswerId;
  final bool showResult;
  final ValueChanged<String>? onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(theme),
          const SizedBox(height: 24),
          _buildQuestionText(theme),
          const SizedBox(height: 24),
          _buildOptions(theme),
          if (showResult && selectedAnswerId != null) ...[
            const SizedBox(height: 24),
            _buildExplanation(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getCategoryColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            question.category.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getCategoryColor(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getDifficultyColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            question.difficulty.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getDifficultyColor(),
            ),
          ),
        ),
        const Spacer(),
        if (!showResult)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.stars,
                  size: 14,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  '+${question.points}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionText(ThemeData theme) {
    return Text(
      question.questionText,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    );
  }

  Widget _buildOptions(ThemeData theme) {
    final isTrueFalse = question.type == QuestionType.trueFalse;

    if (isTrueFalse) {
      return Row(
        children: question.options.map((option) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: option.id == 'true' ? 8 : 0,
                left: option.id == 'false' ? 8 : 0,
              ),
              child: _buildOptionButton(option, theme),
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: question.options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOptionButton(option, theme),
        );
      }).toList(),
    );
  }

  Widget _buildOptionButton(QuizOption option, ThemeData theme) {
    final isSelected = selectedAnswerId == option.id;
    final isCorrect = option.id == question.correctAnswerId;
    final showCorrectness = showResult && (isSelected || isCorrect);

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? trailingIcon;

    if (showCorrectness) {
      if (isCorrect) {
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
        textColor = AppColors.success;
        trailingIcon = Icons.check_circle;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        trailingIcon = Icons.cancel;
      } else {
        backgroundColor = theme.cardColor;
        borderColor = theme.dividerColor;
        textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
      }
    } else if (isSelected) {
      backgroundColor = AppColors.primary.withValues(alpha: 0.1);
      borderColor = AppColors.primary;
      textColor = AppColors.primary;
    } else {
      backgroundColor = theme.cardColor;
      borderColor = theme.dividerColor;
      textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: showResult
            ? null
            : () => onAnswerSelected?.call(option.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(
                  trailingIcon,
                  color: isCorrect ? AppColors.success : AppColors.error,
                  size: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanation(ThemeData theme) {
    final isCorrect = selectedAnswerId == question.correctAnswerId;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isCorrect ? AppColors.success : AppColors.info)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isCorrect ? AppColors.success : AppColors.info)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.lightbulb,
                color: isCorrect ? AppColors.success : AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct!' : 'Explanation',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? AppColors.success : AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    switch (question.category) {
      case QuizCategory.types:
        return AppColors.primary;
      case QuizCategory.centers:
        return AppColors.chakraSacral;
      case QuizCategory.authorities:
        return AppColors.secondary;
      case QuizCategory.profiles:
        return AppColors.chakraHeart;
      case QuizCategory.gates:
        return AppColors.chakraThroat;
      case QuizCategory.channels:
        return AppColors.chakraSolarPlexus;
      case QuizCategory.definitions:
        return AppColors.chakraRoot;
      case QuizCategory.general:
        return AppColors.accent;
    }
  }

  Color _getDifficultyColor() {
    switch (question.difficulty) {
      case QuizDifficulty.beginner:
        return AppColors.success;
      case QuizDifficulty.intermediate:
        return AppColors.warning;
      case QuizDifficulty.advanced:
        return AppColors.error;
    }
  }
}
