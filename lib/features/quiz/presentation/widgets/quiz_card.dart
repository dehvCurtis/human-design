import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/question_generators/all_generators.dart';
import '../../domain/models/quiz.dart';

/// Card widget displaying a quiz in the list
class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.quiz,
    this.isCompleted = false,
    this.bestScore,
    this.onTap,
  });

  final Quiz quiz;
  final bool isCompleted;
  final int? bestScore;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCompleted
            ? BorderSide(color: AppColors.success.withValues(alpha: 0.3), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCategoryIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          quiz.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (quiz.isPremium) _buildPremiumBadge(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDifficultyChip(),
                  const SizedBox(width: 8),
                  _buildQuestionCountChip(),
                  const Spacer(),
                  if (isCompleted) ...[
                    _buildScoreBadge(),
                  ] else ...[
                    _buildPointsChip(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    final iconData = _getCategoryIcon(quiz.category);
    final color = _getCategoryColor(quiz.category);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildDifficultyChip() {
    final color = _getDifficultyColor(quiz.difficulty);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        quiz.difficulty.displayName,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuestionCountChip() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.help_outline,
          size: 14,
          color: AppColors.textSecondaryLight,
        ),
        const SizedBox(width: 4),
        Text(
          '${_getQuestionCount(quiz)} questions',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildPointsChip() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.stars,
          size: 16,
          color: AppColors.accent,
        ),
        const SizedBox(width: 4),
        Text(
          '+${quiz.pointsReward} pts',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBadge() {
    if (bestScore == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: 4),
          Text(
            'Completed',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      );
    }

    final color = bestScore! >= 80
        ? AppColors.success
        : bestScore! >= 60
            ? AppColors.warning
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (bestScore == 100)
            const Icon(
              Icons.emoji_events,
              size: 14,
              color: AppColors.gold,
            )
          else
            Icon(
              Icons.check_circle,
              size: 14,
              color: color,
            ),
          const SizedBox(width: 4),
          Text(
            '$bestScore%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.premiumGradientStart, AppColors.premiumGradientEnd],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium,
            size: 12,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            'PRO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  int _getQuestionCount(Quiz quiz) {
    if (quiz.questionCount > 0) return quiz.questionCount;
    final generator = CombinedQuestionGenerator();
    return generator
        .generateForCategoryAndDifficulty(quiz.category, quiz.difficulty)
        .length;
  }

  IconData _getCategoryIcon(QuizCategory category) {
    switch (category) {
      case QuizCategory.types:
        return Icons.person;
      case QuizCategory.centers:
        return Icons.radio_button_checked;
      case QuizCategory.authorities:
        return Icons.psychology;
      case QuizCategory.profiles:
        return Icons.account_circle;
      case QuizCategory.gates:
        return Icons.door_front_door;
      case QuizCategory.channels:
        return Icons.route;
      case QuizCategory.definitions:
        return Icons.connect_without_contact;
      case QuizCategory.general:
        return Icons.auto_graph;
    }
  }

  Color _getCategoryColor(QuizCategory category) {
    switch (category) {
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

  Color _getDifficultyColor(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.beginner:
        return AppColors.success;
      case QuizDifficulty.intermediate:
        return AppColors.warning;
      case QuizDifficulty.advanced:
        return AppColors.error;
    }
  }
}
