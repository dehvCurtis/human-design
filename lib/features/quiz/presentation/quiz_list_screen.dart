import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/models/quiz.dart';
import '../domain/models/quiz_progress.dart';
import '../domain/quiz_providers.dart';
import 'widgets/quiz_card.dart';

/// Screen displaying list of available quizzes with filtering
class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(quizFiltersProvider);
    final quizzesAsync = ref.watch(quizzesWithStatusProvider);
    final progressAsync = ref.watch(quizProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showStatsSheet(context, ref),
            tooltip: 'Quiz Stats',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress summary card
          progressAsync.when(
            data: (progress) => _buildProgressCard(context, progress),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          // Category filter chips
          _buildCategoryFilters(context, ref, filters),
          // Difficulty filter
          _buildDifficultyFilter(context, ref, filters),
          // Quiz list
          Expanded(
            child: quizzesAsync.when(
              data: (quizzes) => _buildQuizList(context, quizzes),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _buildError(context, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, QuizProgress progress) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${progress.totalQuizzesCompleted} quizzes completed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          _buildStatItem(
            context,
            '${(progress.overallAccuracy * 100).toInt()}%',
            'Accuracy',
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            context,
            '${progress.currentStreak}',
            'Streak',
            icon: Icons.local_fire_department,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label, {
    IconData? icon,
  }) {
    return Column(
      children: [
        if (icon != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.accent, size: 18),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        else
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters(
    BuildContext context,
    WidgetRef ref,
    QuizFilters filters,
  ) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(
            context,
            label: 'All',
            isSelected: filters.category == null,
            onSelected: (_) => ref.read(quizFiltersProvider.notifier).setCategory(null),
          ),
          const SizedBox(width: 8),
          for (final category in QuizCategory.values) ...[
            _buildFilterChip(
              context,
              label: category.displayName,
              isSelected: filters.category == category,
              onSelected: (_) => ref.read(quizFiltersProvider.notifier).setCategory(category),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildDifficultyFilter(
    BuildContext context,
    WidgetRef ref,
    QuizFilters filters,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text(
              'Difficulty:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 12),
            _buildDifficultyChip(
              context,
              label: 'All',
              isSelected: filters.difficulty == null,
              onSelected: () => ref.read(quizFiltersProvider.notifier).setDifficulty(null),
            ),
            const SizedBox(width: 8),
            for (final difficulty in QuizDifficulty.values) ...[
              _buildDifficultyChip(
                context,
                label: difficulty.displayName,
                isSelected: filters.difficulty == difficulty,
                color: _getDifficultyColor(difficulty),
                onSelected: () => ref.read(quizFiltersProvider.notifier).setDifficulty(difficulty),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildDifficultyChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    Color? color,
  }) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppColors.primary).withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (color ?? AppColors.primary)
                : AppColors.dividerLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? (color ?? AppColors.primary)
                : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildQuizList(
    BuildContext context,
    List<({Quiz quiz, bool isCompleted, int? bestScore})> quizzes,
  ) {
    if (quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No quizzes available',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryLight.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final item = quizzes[index];
        return QuizCard(
          quiz: item.quiz,
          isCompleted: item.isCompleted,
          bestScore: item.bestScore,
          onTap: () => context.push('/quizzes/${item.quiz.id}'),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load quizzes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(color: AppColors.textSecondaryLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showStatsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _QuizStatsSheet(),
    );
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

class _QuizStatsSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(quizStatsProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: statsAsync.when(
        data: (stats) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Statistics',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.quiz,
                    value: '${stats.totalQuizzes}',
                    label: 'Quizzes',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.help_outline,
                    value: '${stats.totalQuestions}',
                    label: 'Questions',
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.percent,
                    value: '${(stats.overallAccuracy * 100).toInt()}%',
                    label: 'Accuracy',
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department,
                    value: '${stats.longestStreak}',
                    label: 'Best Streak',
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            if (stats.strongestCategory != null) ...[
              const SizedBox(height: 24),
              Text(
                'Strongest: ${stats.strongestCategory!.displayName}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
            if (stats.weakestCategory != null) ...[
              const SizedBox(height: 8),
              Text(
                'Needs work: ${stats.weakestCategory!.displayName}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Text('Failed to load stats'),
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
          Icon(icon, color: color, size: 24),
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
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
