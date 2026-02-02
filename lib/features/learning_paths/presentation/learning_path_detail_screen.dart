import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/learning_path_providers.dart';
import '../domain/models/learning_path.dart';

/// Detail screen for a learning path
class LearningPathDetailScreen extends ConsumerStatefulWidget {
  const LearningPathDetailScreen({
    super.key,
    required this.pathId,
  });

  final String pathId;

  @override
  ConsumerState<LearningPathDetailScreen> createState() =>
      _LearningPathDetailScreenState();
}

class _LearningPathDetailScreenState
    extends ConsumerState<LearningPathDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pathAsync = ref.watch(learningPathWithStepsProvider(widget.pathId));
    final notifierState = ref.watch(learningPathNotifierProvider);

    return Scaffold(
      body: pathAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(ErrorHandler.getUserMessage(error)),
        ),
        data: (path) {
          if (path == null) {
            return Center(
              child: Text(l10n.learningPathNotFound),
            );
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, path, l10n),
              SliverToBoxAdapter(
                child: _buildPathHeader(context, path, l10n, notifierState),
              ),
              if (path.steps != null && path.steps!.isNotEmpty)
                _buildStepsList(context, path, l10n),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    LearningPath path,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          path.title,
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
          ),
          child: Center(
            child: Text(
              path.iconEmoji ?? '\u{1F4DA}', // 📚
              style: const TextStyle(fontSize: 64),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPathHeader(
    BuildContext context,
    LearningPath path,
    AppLocalizations l10n,
    AsyncValue<void> notifierState,
  ) {
    final theme = Theme.of(context);
    final isEnrolled = path.userProgress != null;
    final progress = path.userProgress;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Difficulty and stats row
          Row(
            children: [
              _DifficultyBadge(difficulty: path.difficulty),
              const SizedBox(width: 12),
              Icon(
                Icons.timer_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                l10n.learningPathMinutes(path.estimatedMinutes),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.list_alt_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                l10n.learningPathSteps(path.stepCount),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            path.description,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),

          // Author
          if (path.authorName != null) ...[
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.learningPathBy(path.authorName!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Enrollment stats
          Row(
            children: [
              _StatChip(
                icon: Icons.people_outline,
                label: l10n.learningPathEnrolled(path.enrollmentCount),
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.check_circle_outline,
                label: l10n.learningPathCompleted(path.completionCount),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Progress or Enroll button
          if (isEnrolled) ...[
            _buildProgressCard(context, progress!, l10n),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: notifierState.isLoading
                    ? null
                    : () => _enrollInPath(path.id),
                icon: notifierState.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(l10n.learningPathEnroll),
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    LearningPathProgress progress,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.learningPathYourProgress,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (progress.isCompleted)
                  Chip(
                    label: Text(l10n.learningPathCompletedBadge),
                    backgroundColor: Colors.green.withValues(alpha: 0.2),
                    labelStyle: const TextStyle(color: Colors.green),
                    avatar: const Icon(Icons.check, color: Colors.green, size: 16),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.progressPercent,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.learningPathProgressText(
                progress.stepsCompleted,
                progress.totalSteps,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsList(
    BuildContext context,
    LearningPath path,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final steps = path.steps!;
    final isEnrolled = path.userProgress != null;
    final completedStepIds = path.userProgress?.completedStepIds ?? [];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                l10n.learningPathStepsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final step = steps[index - 1];
          final isCompleted = completedStepIds.contains(step.id);
          final isLocked = !isEnrolled && index > 1;

          return _StepCard(
            step: step,
            stepNumber: index,
            isCompleted: isCompleted,
            isLocked: isLocked,
            onTap: isLocked
                ? null
                : () => _onStepTapped(path, step, isCompleted),
          );
        },
        childCount: steps.length + 1,
      ),
    );
  }

  Future<void> _enrollInPath(String pathId) async {
    final notifier = ref.read(learningPathNotifierProvider.notifier);
    await notifier.enrollInPath(pathId);
  }

  void _onStepTapped(
    LearningPath path,
    LearningPathStep step,
    bool isCompleted,
  ) {
    if (path.userProgress == null) {
      // Not enrolled, prompt to enroll
      _showEnrollDialog(path);
      return;
    }

    if (isCompleted) {
      // Already completed, view content
      _navigateToStepContent(step);
    } else {
      // Mark as complete or view content
      _showStepOptionsDialog(path, step);
    }
  }

  void _showEnrollDialog(LearningPath path) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.learningPathEnrollTitle),
        content: Text(l10n.learningPathEnrollMessage(path.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _enrollInPath(path.id);
            },
            child: Text(l10n.learningPathEnroll),
          ),
        ],
      ),
    );
  }

  void _showStepOptionsDialog(LearningPath path, LearningPathStep step) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: Text(l10n.learningPathViewContent),
              onTap: () {
                Navigator.pop(context);
                _navigateToStepContent(step);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: Text(l10n.learningPathMarkComplete),
              onTap: () {
                Navigator.pop(context);
                _completeStep(path.id, step.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToStepContent(LearningPathStep step) {
    // Navigate based on step type
    switch (step.stepType) {
      case LearningStepType.quiz:
        // Navigate to quiz detail
        context.push('/quizzes/${step.contentId}');
        break;
      case LearningStepType.challenge:
        // Navigate to challenges screen
        context.push('/challenges');
        break;
      case LearningStepType.article:
      case LearningStepType.video:
      case LearningStepType.exercise:
      case LearningStepType.reflection:
        // Navigate to learning content detail
        context.push('/learning/${step.contentId}');
        break;
    }
  }

  Future<void> _completeStep(String pathId, String stepId) async {
    final notifier = ref.read(learningPathNotifierProvider.notifier);
    final success = await notifier.completeStep(
      pathId: pathId,
      stepId: stepId,
    );

    if (success && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.learningPathStepCompleted),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final LearningPathDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color badgeColor;
    switch (difficulty) {
      case LearningPathDifficulty.beginner:
        badgeColor = Colors.green;
        break;
      case LearningPathDifficulty.intermediate:
        badgeColor = Colors.orange;
        break;
      case LearningPathDifficulty.advanced:
        badgeColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            difficulty.emoji,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            difficulty.displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.stepNumber,
    required this.isCompleted,
    required this.isLocked,
    this.onTap,
  });

  final LearningPathStep step;
  final int stepNumber;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Opacity(
            opacity: isLocked ? 0.5 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Step number / status indicator
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green
                          : isLocked
                              ? theme.colorScheme.surfaceContainerHighest
                              : theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : isLocked
                              ? const Icon(Icons.lock, size: 16)
                              : Text(
                                  '$stepNumber',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Step info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              step.stepType.emoji,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              step.stepType.displayName,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            if (step.estimatedMinutes != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '${step.estimatedMinutes} min',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (step.description != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            step.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Arrow
                  if (!isLocked)
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
