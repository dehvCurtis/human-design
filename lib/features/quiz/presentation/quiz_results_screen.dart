import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/models/quiz.dart';
import '../domain/quiz_providers.dart';

/// Screen displaying quiz results after completion
class QuizResultsScreen extends ConsumerWidget {
  const QuizResultsScreen({
    super.key,
    required this.quizId,
    required this.attemptId,
    this.attempt,
    this.isNewBest = false,
    this.streakUpdated = false,
    this.pointsEarned = 0,
  });

  final String quizId;
  final String attemptId;
  final QuizAttempt? attempt;
  final bool isNewBest;
  final bool streakUpdated;
  final int pointsEarned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizByIdProvider(quizId));

    // Use passed attempt or fetch it
    final effectiveAttempt = attempt;
    if (effectiveAttempt == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: quizAsync.when(
        data: (quiz) {
          if (quiz == null) {
            return const Center(child: Text('Quiz not found'));
          }
          return _buildResults(context, ref, quiz, effectiveAttempt);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    WidgetRef ref,
    Quiz quiz,
    QuizAttempt attempt,
  ) {
    final theme = Theme.of(context);
    final isPerfect = attempt.isPerfect;
    final score = attempt.score;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Score display
            _buildScoreCircle(context, score, isPerfect),
            const SizedBox(height: 24),
            // Title based on performance
            Text(
              _getResultTitle(score),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getResultSubtitle(score),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Stats row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle,
                    value: '${attempt.correctCount}/${attempt.totalQuestions}',
                    label: 'Correct',
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.stars,
                    value: '+$pointsEarned',
                    label: 'Points',
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Achievement badges
            if (isPerfect || isNewBest || streakUpdated)
              _buildAchievements(context, isPerfect, isNewBest, streakUpdated),
            const SizedBox(height: 32),
            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _tryAgain(context, ref),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/quizzes'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back to Quizzes'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => _shareResults(context, quiz, attempt),
              icon: const Icon(Icons.share),
              label: const Text('Share Results'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCircle(BuildContext context, int score, bool isPerfect) {
    final color = score >= 80
        ? AppColors.success
        : score >= 60
            ? AppColors.warning
            : AppColors.error;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated ring
        SizedBox(
          width: 200,
          height: 200,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0, end: score / 100),
            builder: (context, value, _) => CircularProgressIndicator(
              value: value,
              strokeWidth: 12,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        // Score text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPerfect) ...[
              const Icon(
                Icons.emoji_events,
                color: AppColors.gold,
                size: 48,
              ),
              const SizedBox(height: 8),
            ],
            TweenAnimationBuilder<int>(
              duration: const Duration(milliseconds: 1000),
              tween: IntTween(begin: 0, end: score),
              builder: (context, value, _) => Text(
                '$value%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievements(
    BuildContext context,
    bool isPerfect,
    bool isNewBest,
    bool streakUpdated,
  ) {
    final achievements = <Widget>[];

    if (isPerfect) {
      achievements.add(_AchievementBadge(
        icon: Icons.emoji_events,
        label: 'Perfect Score!',
        color: AppColors.gold,
      ));
    }

    if (isNewBest && !isPerfect) {
      achievements.add(_AchievementBadge(
        icon: Icons.trending_up,
        label: 'New Best!',
        color: AppColors.success,
      ));
    }

    if (streakUpdated) {
      achievements.add(_AchievementBadge(
        icon: Icons.local_fire_department,
        label: 'Streak Extended!',
        color: AppColors.accent,
      ));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: achievements,
    );
  }

  String _getResultTitle(int score) {
    if (score == 100) return 'Perfect Score!';
    if (score >= 80) return 'Excellent!';
    if (score >= 60) return 'Good Job!';
    if (score >= 40) return 'Keep Learning!';
    return 'Keep Practicing!';
  }

  String _getResultSubtitle(int score) {
    if (score == 100) return 'You\'ve mastered this topic!';
    if (score >= 80) return 'You have a strong understanding.';
    if (score >= 60) return 'You\'re on the right track.';
    if (score >= 40) return 'Review the explanations to improve.';
    return 'Study the material and try again.';
  }

  void _tryAgain(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(quizSessionProvider.notifier).startQuiz(quizId);
      if (context.mounted) {
        context.pushReplacement('/quizzes/$quizId/take');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start quiz: $e')),
        );
      }
    }
  }

  Future<void> _shareResults(BuildContext context, Quiz quiz, QuizAttempt attempt) async {
    final l10n = AppLocalizations.of(context)!;

    final emoji = attempt.score == 100
        ? '🏆'
        : attempt.score >= 80
            ? '🌟'
            : attempt.score >= 60
                ? '✨'
                : '📚';

    final resultText = attempt.score == 100
        ? l10n.quiz_sharePerfect
        : attempt.score >= 80
            ? l10n.quiz_shareExcellent
            : l10n.quiz_shareGoodJob;

    final text = '''
$emoji Human Design Quiz Results $emoji

Quiz: ${quiz.title}
Score: ${attempt.score}%
Correct: ${attempt.correctCount}/${attempt.totalQuestions}

$resultText

Learn more about your Human Design at humandesign.app
#HumanDesign #Quiz #Learning
''';

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: l10n.quiz_shareSubject(quiz.title, attempt.score),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
