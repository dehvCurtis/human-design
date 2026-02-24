import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/learning.dart';

/// Repository for Learning & Mentorship operations
class LearningRepository {
  LearningRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  /// Escape ILIKE special characters to prevent wildcard injection
  static String _escapeIlike(String input) =>
      input.replaceAll('\\', '\\\\').replaceAll('%', '\\%').replaceAll('_', '\\_');

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Content Library ====================

  /// Get published content with optional filters
  Future<List<LearningContent>> getContent({
    ContentCategory? category,
    ContentType? type,
    int? gateNumber,
    String? hdType,
    bool? isPremium,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = _client
        .from('content_library')
        .select('''
          *,
          author:profiles!content_library_author_id_fkey(id, name, avatar_url)
        ''')
        .eq('is_published', true);

    if (category != null) {
      query = query.eq('category', category.name);
    }
    if (type != null) {
      query = query.eq('content_type', type.name);
    }
    if (gateNumber != null) {
      query = query.eq('gate_number', gateNumber);
    }
    if (hdType != null) {
      query = query.eq('hd_type', hdType);
    }
    if (isPremium != null) {
      query = query.eq('is_premium', isPremium);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final sanitized = _escapeIlike(searchQuery);
      query = query.or('title.ilike.%$sanitized%,content.ilike.%$sanitized%');
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    // Get user progress
    final progressMap = await _getUserProgressMap(
      (response as List).map((j) => j['id'] as String).toList(),
    );

    return response.map((json) {
      return LearningContent.fromJson(
        json,
        userProgress: progressMap[json['id'] as String],
      );
    }).toList();
  }

  /// Get content by ID
  Future<LearningContent?> getContentById(String contentId) async {
    final response = await _client
        .from('content_library')
        .select('''
          *,
          author:profiles!content_library_author_id_fkey(id, name, avatar_url)
        ''')
        .eq('id', contentId)
        .maybeSingle();

    if (response == null) return null;

    final progress = await _getUserProgress(contentId);
    return LearningContent.fromJson(response, userProgress: progress);
  }

  /// Update content progress
  Future<ContentProgress> updateProgress({
    required String contentId,
    int? progressPercent,
    bool? isCompleted,
    int? quizScore,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final updates = <String, dynamic>{
      'last_accessed_at': DateTime.now().toIso8601String(),
    };

    if (progressPercent != null) updates['progress_percent'] = progressPercent;
    if (isCompleted != null) {
      updates['is_completed'] = isCompleted;
      if (isCompleted) updates['completed_at'] = DateTime.now().toIso8601String();
    }
    if (quizScore != null) updates['quiz_score'] = quizScore;

    final response = await _client
        .from('content_progress')
        .upsert({
          'user_id': userId,
          'content_id': contentId,
          ...updates,
        }, onConflict: 'user_id,content_id')
        .select()
        .single();

    return ContentProgress.fromJson(response);
  }

  /// Increment view count
  Future<void> recordView(String contentId) async {
    await _client.rpc('increment', params: {
      'table_name': 'content_library',
      'row_id': contentId,
      'column_name': 'view_count',
    });
  }

  /// Toggle bookmark on content
  Future<bool> toggleBookmark(String contentId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Check if already bookmarked
    final existing = await _client
        .from('content_bookmarks')
        .select('id')
        .eq('user_id', userId)
        .eq('content_id', contentId)
        .maybeSingle();

    if (existing != null) {
      // Remove bookmark
      await _client
          .from('content_bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('content_id', contentId);
      return false;
    } else {
      // Add bookmark
      await _client.from('content_bookmarks').insert({
        'user_id': userId,
        'content_id': contentId,
      });
      return true;
    }
  }

  /// Check if content is bookmarked
  Future<bool> isBookmarked(String contentId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('content_bookmarks')
        .select('id')
        .eq('user_id', userId)
        .eq('content_id', contentId)
        .maybeSingle();

    return response != null;
  }

  /// Get bookmarked content
  Future<List<LearningContent>> getBookmarkedContent() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('content_bookmarks')
        .select('''
          content:content_library!content_bookmarks_content_id_fkey(
            *,
            author:profiles!content_library_author_id_fkey(id, name, avatar_url)
          )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .where((json) => json['content'] != null)
        .map((json) => LearningContent.fromJson(json['content']))
        .toList();
  }

  /// Toggle like on content
  Future<bool> toggleLike(String contentId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    // Check if already liked
    final existing = await _client
        .from('content_likes')
        .select('id')
        .eq('user_id', userId)
        .eq('content_id', contentId)
        .maybeSingle();

    if (existing != null) {
      // Remove like
      await _client
          .from('content_likes')
          .delete()
          .eq('user_id', userId)
          .eq('content_id', contentId);
      // Decrement like count
      await _client.rpc('decrement', params: {
        'table_name': 'content_library',
        'row_id': contentId,
        'column_name': 'like_count',
      });
      return false;
    } else {
      // Add like
      await _client.from('content_likes').insert({
        'user_id': userId,
        'content_id': contentId,
      });
      // Increment like count
      await _client.rpc('increment', params: {
        'table_name': 'content_library',
        'row_id': contentId,
        'column_name': 'like_count',
      });
      return true;
    }
  }

  /// Check if content is liked
  Future<bool> isLiked(String contentId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('content_likes')
        .select('id')
        .eq('user_id', userId)
        .eq('content_id', contentId)
        .maybeSingle();

    return response != null;
  }

  // ==================== Mentorship ====================

  /// Get available mentors
  Future<List<MentorshipProfile>> getMentors({
    List<String>? expertiseAreas,
    bool? isVerified,
    int limit = 20,
  }) async {
    var query = _client
        .from('mentorship_profiles')
        .select('''
          *,
          user:profiles!mentorship_profiles_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('is_mentor', true);

    if (isVerified != null) {
      query = query.eq('is_verified', isVerified);
    }

    final response = await query
        .order('rating', ascending: false, nullsFirst: false)
        .limit(limit);

    return (response as List)
        .map((json) => MentorshipProfile.fromJson(json))
        .toList();
  }

  /// Get current user's mentorship profile
  Future<MentorshipProfile?> getMyMentorshipProfile() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('mentorship_profiles')
        .select('''
          *,
          user:profiles!mentorship_profiles_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return MentorshipProfile.fromJson(response);
  }

  /// Create or update mentorship profile
  Future<MentorshipProfile> upsertMentorshipProfile({
    bool? isMentor,
    bool? isMentee,
    List<String>? expertiseAreas,
    int? experienceYears,
    String? bio,
    String? availability,
    int? maxMentees,
    double? sessionRate,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final data = <String, dynamic>{'user_id': userId};
    if (isMentor != null) data['is_mentor'] = isMentor;
    if (isMentee != null) data['is_mentee'] = isMentee;
    if (expertiseAreas != null) data['expertise_areas'] = expertiseAreas;
    if (experienceYears != null) data['experience_years'] = experienceYears;
    if (bio != null) data['bio'] = bio;
    if (availability != null) data['availability'] = availability;
    if (maxMentees != null) data['max_mentees'] = maxMentees;
    if (sessionRate != null) data['session_rate'] = sessionRate;

    final response = await _client
        .from('mentorship_profiles')
        .upsert(data, onConflict: 'user_id')
        .select('''
          *,
          user:profiles!mentorship_profiles_user_id_fkey(id, name, avatar_url, hd_type)
        ''')
        .single();

    return MentorshipProfile.fromJson(response);
  }

  /// Send mentorship request
  Future<MentorshipRequest> sendMentorshipRequest({
    required String mentorId,
    String? message,
    List<String>? focusAreas,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('mentorship_requests').insert({
      'mentor_id': mentorId,
      'mentee_id': userId,
      'message': message,
      'focus_areas': focusAreas,
    }).select('''
          *,
          mentor:profiles!mentorship_requests_mentor_id_fkey(id, name, avatar_url),
          mentee:profiles!mentorship_requests_mentee_id_fkey(id, name, avatar_url)
        ''').single();

    return MentorshipRequest.fromJson(response);
  }

  /// Get mentorship requests (as mentor or mentee)
  Future<List<MentorshipRequest>> getMentorshipRequests({
    MentorshipRequestStatus? status,
  }) async {
    final userId = _currentUserId;
    if (userId == null) return [];

    var query = _client
        .from('mentorship_requests')
        .select('''
          *,
          mentor:profiles!mentorship_requests_mentor_id_fkey(id, name, avatar_url),
          mentee:profiles!mentorship_requests_mentee_id_fkey(id, name, avatar_url)
        ''')
        .or('mentor_id.eq.$userId,mentee_id.eq.$userId');

    if (status != null) {
      query = query.eq('status', status.name);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List)
        .map((json) => MentorshipRequest.fromJson(json))
        .toList();
  }

  /// Update mentorship request status
  Future<void> updateMentorshipRequestStatus(
    String requestId,
    MentorshipRequestStatus status,
  ) async {
    await _client
        .from('mentorship_requests')
        .update({'status': status.name})
        .eq('id', requestId);
  }

  // ==================== Live Sessions ====================

  /// Get upcoming live sessions
  Future<List<LiveSession>> getUpcomingSessions({
    SessionType? type,
    bool? isPremium,
    int limit = 20,
  }) async {
    final userId = _currentUserId;

    var query = _client
        .from('live_sessions')
        .select('''
          *,
          host:profiles!live_sessions_host_id_fkey(id, name, avatar_url)
        ''')
        .eq('status', 'scheduled')
        .gt('scheduled_at', DateTime.now().toIso8601String());

    if (type != null) {
      query = query.eq('session_type', type.name);
    }
    if (isPremium != null) {
      query = query.eq('is_premium', isPremium);
    }

    final response = await query
        .order('scheduled_at', ascending: true)
        .limit(limit);

    // Check registration status
    Set<String> registeredIds = {};
    if (userId != null) {
      final regResponse = await _client
          .from('session_participants')
          .select('session_id')
          .eq('user_id', userId);
      registeredIds = (regResponse as List)
          .map((j) => j['session_id'] as String)
          .toSet();
    }

    return (response as List).map((json) {
      return LiveSession.fromJson(
        json,
        isRegistered: registeredIds.contains(json['id'] as String),
      );
    }).toList();
  }

  /// Get session by ID
  Future<LiveSession?> getSession(String sessionId) async {
    final userId = _currentUserId;

    final response = await _client
        .from('live_sessions')
        .select('''
          *,
          host:profiles!live_sessions_host_id_fkey(id, name, avatar_url)
        ''')
        .eq('id', sessionId)
        .maybeSingle();

    if (response == null) return null;

    bool? isRegistered;
    if (userId != null) {
      final regResponse = await _client
          .from('session_participants')
          .select('id')
          .eq('session_id', sessionId)
          .eq('user_id', userId)
          .maybeSingle();
      isRegistered = regResponse != null;
    }

    return LiveSession.fromJson(response, isRegistered: isRegistered);
  }

  /// Register for a session
  Future<void> registerForSession(String sessionId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client.from('session_participants').insert({
      'session_id': sessionId,
      'user_id': userId,
    });

    // Increment participant count
    await _client.rpc('increment', params: {
      'table_name': 'live_sessions',
      'row_id': sessionId,
      'column_name': 'current_participants',
    });
  }

  /// Cancel session registration
  Future<void> cancelRegistration(String sessionId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _client
        .from('session_participants')
        .delete()
        .eq('session_id', sessionId)
        .eq('user_id', userId);

    // Decrement participant count
    await _client.rpc('decrement', params: {
      'table_name': 'live_sessions',
      'row_id': sessionId,
      'column_name': 'current_participants',
    });
  }

  /// Get user's registered sessions
  Future<List<LiveSession>> getMyRegisteredSessions() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final regResponse = await _client
        .from('session_participants')
        .select('session_id')
        .eq('user_id', userId);

    final sessionIds = (regResponse as List)
        .map((j) => j['session_id'] as String)
        .toList();

    if (sessionIds.isEmpty) return [];

    final response = await _client
        .from('live_sessions')
        .select('''
          *,
          host:profiles!live_sessions_host_id_fkey(id, name, avatar_url)
        ''')
        .inFilter('id', sessionIds)
        .order('scheduled_at', ascending: true);

    return (response as List)
        .map((json) => LiveSession.fromJson(json, isRegistered: true))
        .toList();
  }

  // ==================== Helper Methods ====================

  Future<Map<String, ContentProgress>> _getUserProgressMap(List<String> contentIds) async {
    final userId = _currentUserId;
    if (userId == null || contentIds.isEmpty) return {};

    final response = await _client
        .from('content_progress')
        .select('*')
        .eq('user_id', userId)
        .inFilter('content_id', contentIds);

    final map = <String, ContentProgress>{};
    for (final json in response as List) {
      final progress = ContentProgress.fromJson(json);
      map[progress.contentId] = progress;
    }

    return map;
  }

  Future<ContentProgress?> _getUserProgress(String contentId) async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('content_progress')
        .select('*')
        .eq('user_id', userId)
        .eq('content_id', contentId)
        .maybeSingle();

    if (response == null) return null;
    return ContentProgress.fromJson(response);
  }
}
