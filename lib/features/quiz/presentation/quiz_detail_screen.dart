import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/question_generators/all_generators.dart';
import '../domain/models/quiz.dart';
import '../domain/quiz_providers.dart';

/// Screen displaying quiz details and attempt history
class QuizDetailScreen extends ConsumerWidget {
  const QuizDetailScreen({
    super.key,
    required this.quizId,
  });

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizByIdProvider(quizId));
    final bestScoreAsync = ref.watch(quizBestScoreProvider(quizId));
    final attemptsAsync = ref.watch(quizAttemptsProvider(quizId));

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: quizAsync.when(
        data: (quiz) {
          if (quiz == null) {
            return Center(child: Text(l10n.quiz_quizNotFound));
          }
          return _buildContent(context, ref, quiz, bestScoreAsync, attemptsAsync);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(ErrorHandler.getUserMessage(error))),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Quiz quiz,
    AsyncValue<int?> bestScoreAsync,
    AsyncValue<List<QuizAttempt>> attemptsAsync,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              quiz.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColor(quiz.category),
                    _getCategoryColor(quiz.category).withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(quiz.category),
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  quiz.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 24),
                // Quiz info cards
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.help_outline,
                        value: '${_getQuestionCount(quiz)}',
                        label: l10n.quiz_questionsLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.stars,
                        value: '+${quiz.pointsReward}',
                        label: l10n.quiz_pointsLabel,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.speed,
                        value: quiz.difficulty.displayName,
                        label: l10n.quiz_difficultyLabel,
                        color: _getDifficultyColor(quiz.difficulty),
                      ),
                    ),
                  ],
                ),
                if (quiz.timeLimit != null) ...[
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.timer,
                    value: _formatTime(quiz.timeLimit!),
                    label: l10n.quiz_timeLimit,
                  ),
                ],
                const SizedBox(height: 24),
                // Best score
                bestScoreAsync.when(
                  data: (score) => score != null
                      ? _buildBestScoreCard(context, score)
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                // Start quiz button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _startQuiz(context, ref, quiz),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      switch (bestScoreAsync) {
                        AsyncData(:final value) when value != null => 'Try Again',
                        _ => 'Start Quiz',
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Attempt history
                attemptsAsync.when(
                  data: (attempts) => attempts.isNotEmpty
                      ? _buildAttemptHistory(context, attempts)
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBestScoreCard(BuildContext context, int score) {
    final theme = Theme.of(context);
    final isPerfect = score == 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isPerfect
            ? const LinearGradient(
                colors: [AppColors.gold, AppColors.accent],
              )
            : null,
        color: isPerfect ? null : AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: isPerfect
            ? null
            : Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isPerfect ? Icons.emoji_events : Icons.check_circle,
            color: isPerfect ? Colors.white : AppColors.success,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPerfect ? 'Perfect Score!' : 'Your Best',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isPerfect ? Colors.white : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$score%',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isPerfect ? Colors.white : AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isPerfect)
            const Icon(
              Icons.star,
              color: Colors.white,
              size: 24,
            ),
        ],
      ),
    );
  }

  Widget _buildAttemptHistory(BuildContext context, List<QuizAttempt> attempts) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attempt History',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: attempts.take(5).length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final attempt = attempts[index];
            return _AttemptCard(attempt: attempt);
          },
        ),
      ],
    );
  }

  Future<void> _startQuiz(BuildContext context, WidgetRef ref, Quiz quiz) async {
    try {
      await ref.read(quizSessionProvider.notifier).startQuiz(quizId);
      if (context.mounted) {
        context.push('/quizzes/$quizId/take');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'start quiz'))),
        );
      }
    }
  }

  /// Get the question count, falling back to generated questions if DB is empty
  int _getQuestionCount(Quiz quiz) {
    if (quiz.questionCount > 0) return quiz.questionCount;
    final generator = CombinedQuestionGenerator();
    return generator
        .generateForCategoryAndDifficulty(quiz.category, quiz.difficulty)
        .length;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (secs == 0) {
      return '$minutes min';
    }
    return '$minutes:${secs.toString().padLeft(2, '0')}';
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: effectiveColor, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttemptCard extends StatelessWidget {
  const _AttemptCard({required this.attempt});

  final QuizAttempt attempt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = attempt.score >= 80
        ? AppColors.success
        : attempt.score >= 60
            ? AppColors.warning
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${attempt.score}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${attempt.correctCount}/${attempt.totalQuestions} correct',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (attempt.completedAt != null)
                  Text(
                    _formatDate(attempt.completedAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.stars,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 4),
              Text(
                '+${attempt.pointsAwarded}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
