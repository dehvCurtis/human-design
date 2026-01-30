import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/learning_path.dart';

/// Repository for Learning Paths operations
class LearningPathRepository {
  LearningPathRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Learning Paths ====================

  /// Get all published learning paths
  Future<List<LearningPath>> getPublishedPaths({
    LearningPathDifficulty? difficulty,
    int limit = 50,
  }) async {
    var query = _client
        .from('learning_paths')
        .select('''
          *,
          author:profiles!learning_paths_author_id_fkey(id, name)
        ''')
        .eq('is_published', true);

    if (difficulty != null) {
      query = query.eq('difficulty', difficulty.dbValue);
    }

    final response = await query
        .order('is_featured', ascending: false)
        .order('enrollment_count', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => LearningPath.fromJson(json))
        .toList();
  }

  /// Get featured learning paths
  Future<List<LearningPath>> getFeaturedPaths({int limit = 5}) async {
    final response = await _client
        .from('learning_paths')
        .select('''
          *,
          author:profiles!learning_paths_author_id_fkey(id, name)
        ''')
        .eq('is_published', true)
        .eq('is_featured', true)
        .order('enrollment_count', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => LearningPath.fromJson(json))
        .toList();
  }

  /// Get a learning path by ID
  Future<LearningPath?> getPath(String pathId) async {
    final response = await _client
        .from('learning_paths')
        .select('''
          *,
          author:profiles!learning_paths_author_id_fkey(id, name)
        ''')
        .eq('id', pathId)
        .maybeSingle();

    if (response == null) return null;
    return LearningPath.fromJson(response);
  }

  /// Get learning path with steps
  Future<LearningPath?> getPathWithSteps(String pathId) async {
    final pathResponse = await _client
        .from('learning_paths')
        .select('''
          *,
          author:profiles!learning_paths_author_id_fkey(id, name)
        ''')
        .eq('id', pathId)
        .maybeSingle();

    if (pathResponse == null) return null;

    final stepsResponse = await _client
        .from('learning_path_steps')
        .select()
        .eq('path_id', pathId)
        .order('order_index', ascending: true);

    // Get user's progress for this path
    final userId = _currentUserId;
    Map<String, dynamic>? userProgress;
    if (userId != null) {
      userProgress = await _client
          .from('learning_path_progress')
          .select()
          .eq('path_id', pathId)
          .eq('user_id', userId)
          .maybeSingle();
    }

    return LearningPath.fromJson({
      ...pathResponse,
      'steps': stepsResponse,
      'user_progress': userProgress,
    });
  }

  /// Get user's enrolled paths
  Future<List<LearningPath>> getMyEnrolledPaths() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('learning_path_progress')
        .select('''
          *,
          path:learning_paths(
            *,
            author:profiles!learning_paths_author_id_fkey(id, name)
          )
        ''')
        .eq('user_id', userId)
        .eq('is_completed', false)
        .order('last_activity_at', ascending: false);

    return (response as List).map((json) {
      final path = json['path'] as Map<String, dynamic>;
      path['user_progress'] = {
        'id': json['id'],
        'user_id': json['user_id'],
        'path_id': json['path_id'],
        'steps_completed': json['steps_completed'],
        'total_steps': json['total_steps'],
        'is_completed': json['is_completed'],
        'completed_at': json['completed_at'],
        'started_at': json['started_at'],
        'last_activity_at': json['last_activity_at'],
        'current_step_id': json['current_step_id'],
        'completed_step_ids': json['completed_step_ids'],
      };
      return LearningPath.fromJson(path);
    }).toList();
  }

  /// Get user's completed paths
  Future<List<LearningPath>> getMyCompletedPaths() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('learning_path_progress')
        .select('''
          *,
          path:learning_paths(
            *,
            author:profiles!learning_paths_author_id_fkey(id, name)
          )
        ''')
        .eq('user_id', userId)
        .eq('is_completed', true)
        .order('completed_at', ascending: false);

    return (response as List).map((json) {
      final path = json['path'] as Map<String, dynamic>;
      path['user_progress'] = {
        'id': json['id'],
        'user_id': json['user_id'],
        'path_id': json['path_id'],
        'steps_completed': json['steps_completed'],
        'total_steps': json['total_steps'],
        'is_completed': json['is_completed'],
        'completed_at': json['completed_at'],
        'started_at': json['started_at'],
        'last_activity_at': json['last_activity_at'],
      };
      return LearningPath.fromJson(path);
    }).toList();
  }

  // ==================== Progress ====================

  /// Enroll in a learning path
  Future<LearningPathProgress> enrollInPath(String pathId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Get path step count
    final path = await getPath(pathId);
    if (path == null) throw Exception('Path not found');

    final response = await _client.from('learning_path_progress').insert({
      'user_id': userId,
      'path_id': pathId,
      'total_steps': path.stepCount,
      'steps_completed': 0,
      'is_completed': false,
      'started_at': DateTime.now().toIso8601String(),
      'last_activity_at': DateTime.now().toIso8601String(),
      'completed_step_ids': [],
    }).select().single();

    // Increment enrollment count
    await _client.rpc('increment_path_enrollment_count', params: {
      'target_path_id': pathId,
    });

    return LearningPathProgress.fromJson(response);
  }

  /// Get user's progress for a path
  Future<LearningPathProgress?> getProgress(String pathId) async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('learning_path_progress')
        .select()
        .eq('path_id', pathId)
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return LearningPathProgress.fromJson(response);
  }

  /// Complete a step
  Future<void> completeStep({
    required String pathId,
    required String stepId,
    String? notes,
    int? score,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Get current progress
    final progress = await getProgress(pathId);
    if (progress == null) throw Exception('Not enrolled in this path');

    // Check if step already completed
    if (progress.completedStepIds?.contains(stepId) == true) return;

    // Record step completion
    await _client.from('step_completions').insert({
      'progress_id': progress.id,
      'step_id': stepId,
      'notes': notes,
      'score': score,
    });

    // Update progress
    final newCompletedSteps = [...(progress.completedStepIds ?? []), stepId];
    final newStepsCompleted = newCompletedSteps.length;
    final isCompleted = newStepsCompleted >= progress.totalSteps;

    await _client.from('learning_path_progress').update({
      'steps_completed': newStepsCompleted,
      'completed_step_ids': newCompletedSteps,
      'is_completed': isCompleted,
      'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
      'current_step_id': isCompleted ? null : stepId,
      'last_activity_at': DateTime.now().toIso8601String(),
    }).eq('id', progress.id);

    // If completed, increment completion count
    if (isCompleted) {
      await _client.rpc('increment_path_completion_count', params: {
        'target_path_id': pathId,
      });
    }
  }

  /// Check if a step is completed
  Future<bool> isStepCompleted(String pathId, String stepId) async {
    final progress = await getProgress(pathId);
    return progress?.completedStepIds?.contains(stepId) == true;
  }

  // ==================== Steps ====================

  /// Get steps for a path
  Future<List<LearningPathStep>> getPathSteps(String pathId) async {
    final userId = _currentUserId;

    final response = await _client
        .from('learning_path_steps')
        .select()
        .eq('path_id', pathId)
        .order('order_index', ascending: true);

    // Get user's completed steps if logged in
    List<String> completedStepIds = [];
    if (userId != null) {
      final progress = await getProgress(pathId);
      completedStepIds = progress?.completedStepIds ?? [];
    }

    return (response as List).map((json) {
      json['is_completed'] = completedStepIds.contains(json['id']);
      return LearningPathStep.fromJson(json);
    }).toList();
  }

  /// Get a specific step
  Future<LearningPathStep?> getStep(String stepId) async {
    final response = await _client
        .from('learning_path_steps')
        .select()
        .eq('id', stepId)
        .maybeSingle();

    if (response == null) return null;
    return LearningPathStep.fromJson(response);
  }
}
