/// Models for the Learning feature (content library, study groups)

enum ContentType {
  article,
  guide,
  quiz,
  video,
  infographic,
}

enum ContentCategory {
  type,
  authority,
  profile,
  gate,
  channel,
  center,
  transit,
  general,
}

class LearningContent {
  const LearningContent({
    required this.id,
    required this.title,
    required this.content,
    required this.contentType,
    required this.category,
    this.subcategory,
    this.gateNumber,
    this.channelId,
    this.centerName,
    this.hdType,
    this.authorId,
    this.authorName,
    this.authorAvatarUrl,
    required this.isOfficial,
    required this.isPremium,
    required this.isPublished,
    required this.viewCount,
    required this.likeCount,
    this.tags,
    this.mediaUrl,
    this.estimatedReadTime,
    required this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.userProgress,
  });

  final String id;
  final String title;
  final String content;
  final ContentType contentType;
  final ContentCategory category;
  final String? subcategory;
  final int? gateNumber;
  final String? channelId;
  final String? centerName;
  final String? hdType;
  final String? authorId;
  final String? authorName;
  final String? authorAvatarUrl;
  final bool isOfficial;
  final bool isPremium;
  final bool isPublished;
  final int viewCount;
  final int likeCount;
  final List<String>? tags;
  final String? mediaUrl;
  final int? estimatedReadTime;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final ContentProgress? userProgress;

  factory LearningContent.fromJson(Map<String, dynamic> json, {ContentProgress? userProgress}) {
    final author = json['author'] as Map<String, dynamic>?;

    return LearningContent(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      contentType: _parseContentType(json['content_type'] as String),
      category: _parseCategory(json['category'] as String),
      subcategory: json['subcategory'] as String?,
      gateNumber: json['gate_number'] as int?,
      channelId: json['channel_id'] as String?,
      centerName: json['center_name'] as String?,
      hdType: json['hd_type'] as String?,
      authorId: json['author_id'] as String?,
      authorName: author?['name'] as String?,
      authorAvatarUrl: author?['avatar_url'] as String?,
      isOfficial: json['is_official'] as bool? ?? false,
      isPremium: json['is_premium'] as bool? ?? false,
      isPublished: json['is_published'] as bool? ?? false,
      viewCount: json['view_count'] as int? ?? 0,
      likeCount: json['like_count'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      mediaUrl: json['media_url'] as String?,
      estimatedReadTime: json['estimated_read_time'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      userProgress: userProgress,
    );
  }

  static ContentType _parseContentType(String value) {
    return ContentType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ContentType.article,
    );
  }

  static ContentCategory _parseCategory(String value) {
    return ContentCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ContentCategory.general,
    );
  }
}

class ContentProgress {
  const ContentProgress({
    required this.id,
    required this.userId,
    required this.contentId,
    required this.isCompleted,
    required this.progressPercent,
    this.quizScore,
    required this.lastAccessedAt,
    this.completedAt,
  });

  final String id;
  final String userId;
  final String contentId;
  final bool isCompleted;
  final int progressPercent;
  final int? quizScore;
  final DateTime lastAccessedAt;
  final DateTime? completedAt;

  factory ContentProgress.fromJson(Map<String, dynamic> json) {
    return ContentProgress(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      contentId: json['content_id'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
      progressPercent: json['progress_percent'] as int? ?? 0,
      quizScore: json['quiz_score'] as int?,
      lastAccessedAt: DateTime.parse(json['last_accessed_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }
}

// ==================== Mentorship ====================

class MentorshipProfile {
  const MentorshipProfile({
    required this.id,
    required this.userId,
    this.userName,
    this.userAvatarUrl,
    this.userHdType,
    required this.isMentor,
    required this.isMentee,
    this.expertiseAreas,
    this.experienceYears,
    this.bio,
    this.availability,
    required this.maxMentees,
    required this.currentMenteeCount,
    this.sessionRate,
    required this.isVerified,
    this.rating,
    this.reviewCount,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String? userName;
  final String? userAvatarUrl;
  final String? userHdType;
  final bool isMentor;
  final bool isMentee;
  final List<String>? expertiseAreas;
  final int? experienceYears;
  final String? bio;
  final String? availability;
  final int maxMentees;
  final int currentMenteeCount;
  final double? sessionRate;
  final bool isVerified;
  final double? rating;
  final int? reviewCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get hasAvailability => currentMenteeCount < maxMentees;

  factory MentorshipProfile.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return MentorshipProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String?,
      userAvatarUrl: user?['avatar_url'] as String?,
      userHdType: user?['hd_type'] as String?,
      isMentor: json['is_mentor'] as bool? ?? false,
      isMentee: json['is_mentee'] as bool? ?? false,
      expertiseAreas: (json['expertise_areas'] as List<dynamic>?)?.cast<String>(),
      experienceYears: json['experience_years'] as int?,
      bio: json['bio'] as String?,
      availability: json['availability'] as String?,
      maxMentees: json['max_mentees'] as int? ?? 3,
      currentMenteeCount: json['current_mentee_count'] as int? ?? 0,
      sessionRate: (json['session_rate'] as num?)?.toDouble(),
      isVerified: json['is_verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

enum MentorshipRequestStatus {
  pending,
  accepted,
  declined,
  completed,
  cancelled,
}

class MentorshipRequest {
  const MentorshipRequest({
    required this.id,
    required this.mentorId,
    required this.menteeId,
    this.mentorName,
    this.mentorAvatarUrl,
    this.menteeName,
    this.menteeAvatarUrl,
    required this.status,
    this.message,
    this.focusAreas,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String mentorId;
  final String menteeId;
  final String? mentorName;
  final String? mentorAvatarUrl;
  final String? menteeName;
  final String? menteeAvatarUrl;
  final MentorshipRequestStatus status;
  final String? message;
  final List<String>? focusAreas;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory MentorshipRequest.fromJson(Map<String, dynamic> json) {
    final mentor = json['mentor'] as Map<String, dynamic>?;
    final mentee = json['mentee'] as Map<String, dynamic>?;

    return MentorshipRequest(
      id: json['id'] as String,
      mentorId: json['mentor_id'] as String,
      menteeId: json['mentee_id'] as String,
      mentorName: mentor?['name'] as String?,
      mentorAvatarUrl: mentor?['avatar_url'] as String?,
      menteeName: mentee?['name'] as String?,
      menteeAvatarUrl: mentee?['avatar_url'] as String?,
      status: _parseStatus(json['status'] as String),
      message: json['message'] as String?,
      focusAreas: (json['focus_areas'] as List<dynamic>?)?.cast<String>(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  static MentorshipRequestStatus _parseStatus(String value) {
    return MentorshipRequestStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MentorshipRequestStatus.pending,
    );
  }
}

// ==================== Live Sessions ====================

enum SessionType {
  workshop,
  qAndA,
  groupReading,
  studyGroup,
  meditation,
}

enum SessionStatus {
  scheduled,
  live,
  completed,
  cancelled,
}

class LiveSession {
  const LiveSession({
    required this.id,
    required this.hostId,
    this.hostName,
    this.hostAvatarUrl,
    required this.title,
    this.description,
    required this.sessionType,
    required this.scheduledAt,
    required this.durationMinutes,
    this.maxParticipants,
    required this.currentParticipants,
    this.meetingUrl,
    required this.isPremium,
    required this.isRecorded,
    this.recordingUrl,
    required this.status,
    this.tags,
    required this.createdAt,
    this.updatedAt,
    this.isRegistered,
  });

  final String id;
  final String hostId;
  final String? hostName;
  final String? hostAvatarUrl;
  final String title;
  final String? description;
  final SessionType sessionType;
  final DateTime scheduledAt;
  final int durationMinutes;
  final int? maxParticipants;
  final int currentParticipants;
  final String? meetingUrl;
  final bool isPremium;
  final bool isRecorded;
  final String? recordingUrl;
  final SessionStatus status;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool? isRegistered;

  bool get isUpcoming => scheduledAt.isAfter(DateTime.now());
  bool get isFull => maxParticipants != null && currentParticipants >= maxParticipants!;

  factory LiveSession.fromJson(Map<String, dynamic> json, {bool? isRegistered}) {
    final host = json['host'] as Map<String, dynamic>?;

    return LiveSession(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      hostName: host?['name'] as String?,
      hostAvatarUrl: host?['avatar_url'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      sessionType: _parseSessionType(json['session_type'] as String),
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      durationMinutes: json['duration_minutes'] as int? ?? 60,
      maxParticipants: json['max_participants'] as int?,
      currentParticipants: json['current_participants'] as int? ?? 0,
      meetingUrl: json['meeting_url'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      isRecorded: json['is_recorded'] as bool? ?? false,
      recordingUrl: json['recording_url'] as String?,
      status: _parseSessionStatus(json['status'] as String),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      isRegistered: isRegistered,
    );
  }

  static SessionType _parseSessionType(String value) {
    switch (value) {
      case 'workshop':
        return SessionType.workshop;
      case 'q_and_a':
        return SessionType.qAndA;
      case 'group_reading':
        return SessionType.groupReading;
      case 'study_group':
        return SessionType.studyGroup;
      case 'meditation':
        return SessionType.meditation;
      default:
        return SessionType.workshop;
    }
  }

  static SessionStatus _parseSessionStatus(String value) {
    return SessionStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SessionStatus.scheduled,
    );
  }
}
