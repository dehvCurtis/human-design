import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Progress bar widget for quiz taking screen
class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.correctAnswers,
    this.showCorrectCount = true,
  });

  final int currentQuestion;
  final int totalQuestions;
  final int correctAnswers;
  final bool showCorrectCount;

  double get progress =>
      totalQuestions > 0 ? currentQuestion / totalQuestions : 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentQuestion + 1} of $totalQuestions',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showCorrectCount)
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$correctAnswers correct',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.dividerLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

/// Animated progress indicator that shows individual question dots
class QuizProgressDots extends StatelessWidget {
  const QuizProgressDots({
    super.key,
    required this.totalQuestions,
    required this.currentQuestion,
    required this.answeredQuestions,
    this.maxDotsVisible = 10,
  });

  final int totalQuestions;
  final int currentQuestion;
  final List<bool> answeredQuestions; // true = correct, false = incorrect
  final int maxDotsVisible;

  @override
  Widget build(BuildContext context) {
    // If we have more questions than dots, show a subset centered on current
    int startIndex = 0;
    int endIndex = totalQuestions;

    if (totalQuestions > maxDotsVisible) {
      final halfVisible = maxDotsVisible ~/ 2;
      startIndex = (currentQuestion - halfVisible).clamp(0, totalQuestions - maxDotsVisible);
      endIndex = startIndex + maxDotsVisible;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (startIndex > 0)
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.more_horiz,
              size: 16,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ...List.generate(endIndex - startIndex, (index) {
          final questionIndex = startIndex + index;
          return _buildDot(questionIndex);
        }),
        if (endIndex < totalQuestions)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(
              Icons.more_horiz,
              size: 16,
              color: AppColors.textSecondaryLight,
            ),
          ),
      ],
    );
  }

  Widget _buildDot(int index) {
    final isCurrent = index == currentQuestion;
    final isAnswered = index < answeredQuestions.length;
    final isCorrect = isAnswered ? answeredQuestions[index] : null;

    Color color;
    double size;

    if (isCurrent) {
      color = AppColors.primary;
      size = 12;
    } else if (isCorrect == true) {
      color = AppColors.success;
      size = 8;
    } else if (isCorrect == false) {
      color = AppColors.error;
      size = 8;
    } else {
      color = AppColors.dividerLight;
      size = 8;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Timer widget for timed quizzes
class QuizTimer extends StatelessWidget {
  const QuizTimer({
    super.key,
    required this.remainingSeconds,
    this.totalSeconds,
    this.warningThreshold = 60,
  });

  final int remainingSeconds;
  final int? totalSeconds;
  final int warningThreshold;

  @override
  Widget build(BuildContext context) {
    final isWarning = remainingSeconds <= warningThreshold;
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isWarning
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.dividerLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 18,
            color: isWarning ? AppColors.error : AppColors.textSecondaryLight,
          ),
          const SizedBox(width: 6),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isWarning ? AppColors.error : AppColors.textPrimaryLight,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
