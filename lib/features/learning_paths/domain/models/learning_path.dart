// Models for Learning Paths feature
// Curated content journeys with progress tracking

/// Represents a learning path
class LearningPath {
  const LearningPath({
    required this.id,
    required this.title,
    required this.description,
    this.iconEmoji,
    this.coverImageUrl,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.stepCount,
    required this.enrollmentCount,
    required this.completionCount,
    this.authorId,
    this.authorName,
    required this.isPublished,
    required this.isFeatured,
    required this.createdAt,
    this.steps,
    this.userProgress,
  });

  final String id;
  final String title;
  final String description;
  final String? iconEmoji;
  final String? coverImageUrl;
  final LearningPathDifficulty difficulty;
  final int estimatedMinutes;
  final int stepCount;
  final int enrollmentCount;
  final int completionCount;
  final String? authorId;
  final String? authorName;
  final bool isPublished;
  final bool isFeatured;
  final DateTime createdAt;
  final List<LearningPathStep>? steps;
  final LearningPathProgress? userProgress;

  double get completionRate => enrollmentCount > 0
      ? completionCount / enrollmentCount
      : 0.0;

  factory LearningPath.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;

    return LearningPath(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconEmoji: json['icon_emoji'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      difficulty: _parseDifficulty(json['difficulty'] as String),
      estimatedMinutes: json['estimated_minutes'] as int? ?? 0,
      stepCount: json['step_count'] as int? ?? 0,
      enrollmentCount: json['enrollment_count'] as int? ?? 0,
      completionCount: json['completion_count'] as int? ?? 0,
      authorId: json['author_id'] as String?,
      authorName: author?['name'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      steps: json['steps'] != null
          ? (json['steps'] as List)
              .map((s) => LearningPathStep.fromJson(s as Map<String, dynamic>))
              .toList()
          : null,
      userProgress: json['user_progress'] != null
          ? LearningPathProgress.fromJson(json['user_progress'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon_emoji': iconEmoji,
      'cover_image_url': coverImageUrl,
      'difficulty': difficulty.dbValue,
      'estimated_minutes': estimatedMinutes,
      'is_published': isPublished,
      'is_featured': isFeatured,
    };
  }

  static LearningPathDifficulty _parseDifficulty(String value) {
    switch (value) {
      case 'beginner':
        return LearningPathDifficulty.beginner;
      case 'intermediate':
        return LearningPathDifficulty.intermediate;
      case 'advanced':
        return LearningPathDifficulty.advanced;
      default:
        return LearningPathDifficulty.beginner;
    }
  }
}

enum LearningPathDifficulty {
  beginner,
  intermediate,
  advanced,
}

extension LearningPathDifficultyExtension on LearningPathDifficulty {
  String get dbValue {
    switch (this) {
      case LearningPathDifficulty.beginner:
        return 'beginner';
      case LearningPathDifficulty.intermediate:
        return 'intermediate';
      case LearningPathDifficulty.advanced:
        return 'advanced';
    }
  }

  String get displayName {
    switch (this) {
      case LearningPathDifficulty.beginner:
        return 'Beginner';
      case LearningPathDifficulty.intermediate:
        return 'Intermediate';
      case LearningPathDifficulty.advanced:
        return 'Advanced';
    }
  }

  String get emoji {
    switch (this) {
      case LearningPathDifficulty.beginner:
        return '\u{1F331}'; // 🌱
      case LearningPathDifficulty.intermediate:
        return '\u{1F333}'; // 🌳
      case LearningPathDifficulty.advanced:
        return '\u{1F3C6}'; // 🏆
    }
  }
}

/// A step in a learning path
class LearningPathStep {
  const LearningPathStep({
    required this.id,
    required this.pathId,
    required this.orderIndex,
    required this.title,
    this.description,
    required this.stepType,
    required this.contentId,
    this.contentTitle,
    this.estimatedMinutes,
    required this.isRequired,
    this.isCompleted,
  });

  final String id;
  final String pathId;
  final int orderIndex;
  final String title;
  final String? description;
  final LearningStepType stepType;
  final String contentId;
  final String? contentTitle;
  final int? estimatedMinutes;
  final bool isRequired;
  final bool? isCompleted;

  factory LearningPathStep.fromJson(Map<String, dynamic> json) {
    return LearningPathStep(
      id: json['id'] as String,
      pathId: json['path_id'] as String,
      orderIndex: json['order_index'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      stepType: _parseStepType(json['step_type'] as String),
      contentId: json['content_id'] as String,
      contentTitle: json['content_title'] as String?,
      estimatedMinutes: json['estimated_minutes'] as int?,
      isRequired: json['is_required'] as bool? ?? true,
      isCompleted: json['is_completed'] as bool?,
    );
  }

  static LearningStepType _parseStepType(String value) {
    switch (value) {
      case 'article':
        return LearningStepType.article;
      case 'video':
        return LearningStepType.video;
      case 'quiz':
        return LearningStepType.quiz;
      case 'challenge':
        return LearningStepType.challenge;
      case 'exercise':
        return LearningStepType.exercise;
      case 'reflection':
        return LearningStepType.reflection;
      default:
        return LearningStepType.article;
    }
  }
}

enum LearningStepType {
  article,
  video,
  quiz,
  challenge,
  exercise,
  reflection,
}

extension LearningStepTypeExtension on LearningStepType {
  String get dbValue {
    switch (this) {
      case LearningStepType.article:
        return 'article';
      case LearningStepType.video:
        return 'video';
      case LearningStepType.quiz:
        return 'quiz';
      case LearningStepType.challenge:
        return 'challenge';
      case LearningStepType.exercise:
        return 'exercise';
      case LearningStepType.reflection:
        return 'reflection';
    }
  }

  String get displayName {
    switch (this) {
      case LearningStepType.article:
        return 'Article';
      case LearningStepType.video:
        return 'Video';
      case LearningStepType.quiz:
        return 'Quiz';
      case LearningStepType.challenge:
        return 'Challenge';
      case LearningStepType.exercise:
        return 'Exercise';
      case LearningStepType.reflection:
        return 'Reflection';
    }
  }

  String get emoji {
    switch (this) {
      case LearningStepType.article:
        return '\u{1F4D6}'; // 📖
      case LearningStepType.video:
        return '\u{1F3AC}'; // 🎬
      case LearningStepType.quiz:
        return '\u{2753}'; // ❓
      case LearningStepType.challenge:
        return '\u{1F3AF}'; // 🎯
      case LearningStepType.exercise:
        return '\u{270D}'; // ✍️
      case LearningStepType.reflection:
        return '\u{1F4AD}'; // 💭
    }
  }
}

/// User's progress in a learning path
class LearningPathProgress {
  const LearningPathProgress({
    required this.id,
    required this.userId,
    required this.pathId,
    required this.stepsCompleted,
    required this.totalSteps,
    required this.isCompleted,
    this.completedAt,
    required this.startedAt,
    required this.lastActivityAt,
    this.currentStepId,
    this.completedStepIds,
  });

  final String id;
  final String userId;
  final String pathId;
  final int stepsCompleted;
  final int totalSteps;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime startedAt;
  final DateTime lastActivityAt;
  final String? currentStepId;
  final List<String>? completedStepIds;

  double get progressPercent => totalSteps > 0
      ? stepsCompleted / totalSteps
      : 0.0;

  factory LearningPathProgress.fromJson(Map<String, dynamic> json) {
    return LearningPathProgress(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      pathId: json['path_id'] as String,
      stepsCompleted: json['steps_completed'] as int? ?? 0,
      totalSteps: json['total_steps'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      startedAt: DateTime.parse(json['started_at'] as String),
      lastActivityAt: DateTime.parse(json['last_activity_at'] as String),
      currentStepId: json['current_step_id'] as String?,
      completedStepIds: (json['completed_step_ids'] as List?)?.cast<String>(),
    );
  }
}

/// Step completion record
class StepCompletion {
  const StepCompletion({
    required this.id,
    required this.progressId,
    required this.stepId,
    required this.completedAt,
    this.notes,
    this.score,
  });

  final String id;
  final String progressId;
  final String stepId;
  final DateTime completedAt;
  final String? notes;
  final int? score;

  factory StepCompletion.fromJson(Map<String, dynamic> json) {
    return StepCompletion(
      id: json['id'] as String,
      progressId: json['progress_id'] as String,
      stepId: json['step_id'] as String,
      completedAt: DateTime.parse(json['completed_at'] as String),
      notes: json['notes'] as String?,
      score: json['score'] as int?,
    );
  }
}

/// Pre-defined learning path templates
class LearningPathTemplates {
  static const List<LearningPathTemplate> templates = [
    LearningPathTemplate(
      id: 'understand_your_type',
      title: 'Understanding Your Type',
      description: 'Discover what it means to be your Human Design type and how to live in alignment',
      iconEmoji: '\u{2728}', // ✨
      difficulty: LearningPathDifficulty.beginner,
      topics: ['Types', 'Strategy', 'Signature & Not-Self'],
    ),
    LearningPathTemplate(
      id: 'master_your_authority',
      title: 'Mastering Your Authority',
      description: 'Learn to make decisions that are correct for you using your inner authority',
      iconEmoji: '\u{1F9ED}', // 🧭
      difficulty: LearningPathDifficulty.beginner,
      topics: ['Authority', 'Decision Making', 'Waiting'],
    ),
    LearningPathTemplate(
      id: 'living_your_profile',
      title: 'Living Your Profile',
      description: 'Understand your profile and how it shapes your life purpose and interactions',
      iconEmoji: '\u{1F465}', // 👥
      difficulty: LearningPathDifficulty.intermediate,
      topics: ['Profile', 'Lines', 'Life Themes'],
    ),
    LearningPathTemplate(
      id: 'center_wisdom',
      title: 'Center Wisdom',
      description: 'Deep dive into your defined and undefined centers for self-understanding',
      iconEmoji: '\u{1F4A0}', // 💠
      difficulty: LearningPathDifficulty.intermediate,
      topics: ['Centers', 'Conditioning', 'Wisdom'],
    ),
    LearningPathTemplate(
      id: 'gates_channels_mastery',
      title: 'Gates & Channels Mastery',
      description: 'Explore your gates and channels to unlock your unique gifts',
      iconEmoji: '\u{1F511}', // 🔑
      difficulty: LearningPathDifficulty.advanced,
      topics: ['Gates', 'Channels', 'I Ching'],
    ),
    LearningPathTemplate(
      id: 'relationship_dynamics',
      title: 'Relationship Dynamics',
      description: 'Understand how you connect and interact with others through Human Design',
      iconEmoji: '\u{1F91D}', // 🤝
      difficulty: LearningPathDifficulty.intermediate,
      topics: ['Composite Charts', 'Electromagnetic', 'Connection'],
    ),
  ];
}

class LearningPathTemplate {
  const LearningPathTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.difficulty,
    required this.topics,
  });

  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final LearningPathDifficulty difficulty;
  final List<String> topics;
}
