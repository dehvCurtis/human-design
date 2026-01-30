import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/learning_path_repository.dart';
import 'models/learning_path.dart';

/// Repository provider
final learningPathRepositoryProvider = Provider<LearningPathRepository>((ref) {
  return LearningPathRepository(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

// ==================== Learning Paths ====================

/// Get all published learning paths
final publishedPathsProvider = FutureProvider<List<LearningPath>>((ref) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getPublishedPaths();
});

/// Get paths by difficulty
final pathsByDifficultyProvider = FutureProvider.family<List<LearningPath>, LearningPathDifficulty>((ref, difficulty) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getPublishedPaths(difficulty: difficulty);
});

/// Get featured learning paths
final featuredPathsProvider = FutureProvider<List<LearningPath>>((ref) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getFeaturedPaths();
});

/// Get a specific learning path
final learningPathProvider = FutureProvider.family<LearningPath?, String>((ref, pathId) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getPath(pathId);
});

/// Get learning path with steps
final learningPathWithStepsProvider = FutureProvider.family<LearningPath?, String>((ref, pathId) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getPathWithSteps(pathId);
});

/// Get user's enrolled paths (in progress)
final myEnrolledPathsProvider = FutureProvider<List<LearningPath>>((ref) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getMyEnrolledPaths();
});

/// Get user's completed paths
final myCompletedPathsProvider = FutureProvider<List<LearningPath>>((ref) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getMyCompletedPaths();
});

// ==================== Progress ====================

/// Get user's progress for a path
final pathProgressProvider = FutureProvider.family<LearningPathProgress?, String>((ref, pathId) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getProgress(pathId);
});

/// Check if user is enrolled in a path
final isEnrolledProvider = FutureProvider.family<bool, String>((ref, pathId) async {
  final progress = await ref.watch(pathProgressProvider(pathId).future);
  return progress != null;
});

// ==================== Steps ====================

/// Get steps for a path
final pathStepsProvider = FutureProvider.family<List<LearningPathStep>, String>((ref, pathId) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getPathSteps(pathId);
});

/// Get a specific step
final learningStepProvider = FutureProvider.family<LearningPathStep?, String>((ref, stepId) async {
  final repository = ref.watch(learningPathRepositoryProvider);
  return repository.getStep(stepId);
});

// ==================== Notifier ====================

/// Notifier for learning path mutations
class LearningPathNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  LearningPathRepository get _repository => ref.read(learningPathRepositoryProvider);

  /// Enroll in a learning path
  Future<LearningPathProgress?> enrollInPath(String pathId) async {
    state = const AsyncValue.loading();
    try {
      final progress = await _repository.enrollInPath(pathId);
      state = const AsyncValue.data(null);
      ref.invalidate(pathProgressProvider(pathId));
      ref.invalidate(isEnrolledProvider(pathId));
      ref.invalidate(myEnrolledPathsProvider);
      ref.invalidate(learningPathProvider(pathId));
      return progress;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Complete a step
  Future<bool> completeStep({
    required String pathId,
    required String stepId,
    String? notes,
    int? score,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.completeStep(
        pathId: pathId,
        stepId: stepId,
        notes: notes,
        score: score,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(pathProgressProvider(pathId));
      ref.invalidate(pathStepsProvider(pathId));
      ref.invalidate(learningPathWithStepsProvider(pathId));
      ref.invalidate(myEnrolledPathsProvider);
      ref.invalidate(myCompletedPathsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final learningPathNotifierProvider = NotifierProvider<LearningPathNotifier, AsyncValue<void>>(() {
  return LearningPathNotifier();
});
