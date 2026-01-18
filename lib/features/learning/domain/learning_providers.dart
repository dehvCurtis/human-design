import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/learning_repository.dart';
import 'models/learning.dart';

/// Provider for the LearningRepository
final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  return LearningRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

// ==================== Content Library Providers ====================

/// Provider for content with filters
final contentLibraryProvider = FutureProvider.family<List<LearningContent>, ContentFilter>((ref, filter) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getContent(
    category: filter.category,
    type: filter.type,
    gateNumber: filter.gateNumber,
    hdType: filter.hdType,
    isPremium: filter.isPremium,
    searchQuery: filter.searchQuery,
  );
});

/// Provider for a specific content item
final contentDetailProvider = FutureProvider.family<LearningContent?, String>((ref, contentId) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getContentById(contentId);
});

/// Provider for content by gate number
final gateContentProvider = FutureProvider.family<List<LearningContent>, int>((ref, gateNumber) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getContent(gateNumber: gateNumber);
});

/// Provider for content by HD type
final typeContentProvider = FutureProvider.family<List<LearningContent>, String>((ref, hdType) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getContent(hdType: hdType);
});

// ==================== Mentorship Providers ====================

/// Provider for available mentors
final mentorsProvider = FutureProvider<List<MentorshipProfile>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getMentors();
});

/// Provider for verified mentors only
final verifiedMentorsProvider = FutureProvider<List<MentorshipProfile>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getMentors(isVerified: true);
});

/// Provider for current user's mentorship profile
final myMentorshipProfileProvider = FutureProvider<MentorshipProfile?>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getMyMentorshipProfile();
});

/// Provider for mentorship requests
final mentorshipRequestsProvider = FutureProvider<List<MentorshipRequest>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getMentorshipRequests();
});

/// Provider for pending mentorship requests
final pendingMentorshipRequestsProvider = FutureProvider<List<MentorshipRequest>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getMentorshipRequests(status: MentorshipRequestStatus.pending);
});

// ==================== Live Sessions Providers ====================

/// Provider for upcoming sessions
final upcomingSessionsProvider = FutureProvider<List<LiveSession>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getUpcomingSessions();
});

/// Provider for a specific session
final sessionDetailProvider = FutureProvider.family<LiveSession?, String>((ref, sessionId) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getSession(sessionId);
});

/// Provider for user's registered sessions
final myRegisteredSessionsProvider = FutureProvider<List<LiveSession>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getMyRegisteredSessions();
});

// ==================== Filter State ====================

class ContentFilter {
  const ContentFilter({
    this.category,
    this.type,
    this.gateNumber,
    this.hdType,
    this.isPremium,
    this.searchQuery,
  });

  final ContentCategory? category;
  final ContentType? type;
  final int? gateNumber;
  final String? hdType;
  final bool? isPremium;
  final String? searchQuery;

  ContentFilter copyWith({
    ContentCategory? category,
    ContentType? type,
    int? gateNumber,
    String? hdType,
    bool? isPremium,
    String? searchQuery,
  }) {
    return ContentFilter(
      category: category ?? this.category,
      type: type ?? this.type,
      gateNumber: gateNumber ?? this.gateNumber,
      hdType: hdType ?? this.hdType,
      isPremium: isPremium ?? this.isPremium,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContentFilter &&
        other.category == category &&
        other.type == type &&
        other.gateNumber == gateNumber &&
        other.hdType == hdType &&
        other.isPremium == isPremium &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode => Object.hash(category, type, gateNumber, hdType, isPremium, searchQuery);
}

final contentFilterProvider = StateProvider<ContentFilter>((ref) {
  return const ContentFilter();
});

// ==================== Notifiers ====================

/// Notifier for learning actions
class LearningNotifier extends Notifier<LearningState> {
  @override
  LearningState build() => const LearningState();

  LearningRepository get _repository => ref.read(learningRepositoryProvider);

  /// Update content progress
  Future<void> updateProgress({
    required String contentId,
    int? progressPercent,
    bool? isCompleted,
    int? quizScore,
  }) async {
    await _repository.updateProgress(
      contentId: contentId,
      progressPercent: progressPercent,
      isCompleted: isCompleted,
      quizScore: quizScore,
    );
    ref.invalidate(contentDetailProvider(contentId));
  }

  /// Record a view
  Future<void> recordView(String contentId) async {
    await _repository.recordView(contentId);
  }

  /// Create or update mentorship profile
  Future<void> updateMentorshipProfile({
    bool? isMentor,
    bool? isMentee,
    List<String>? expertiseAreas,
    int? experienceYears,
    String? bio,
    String? availability,
    int? maxMentees,
    double? sessionRate,
  }) async {
    await _repository.upsertMentorshipProfile(
      isMentor: isMentor,
      isMentee: isMentee,
      expertiseAreas: expertiseAreas,
      experienceYears: experienceYears,
      bio: bio,
      availability: availability,
      maxMentees: maxMentees,
      sessionRate: sessionRate,
    );
    ref.invalidate(myMentorshipProfileProvider);
    ref.invalidate(mentorsProvider);
  }

  /// Send mentorship request
  Future<void> sendMentorshipRequest({
    required String mentorId,
    String? message,
    List<String>? focusAreas,
  }) async {
    await _repository.sendMentorshipRequest(
      mentorId: mentorId,
      message: message,
      focusAreas: focusAreas,
    );
    ref.invalidate(mentorshipRequestsProvider);
    ref.invalidate(pendingMentorshipRequestsProvider);
  }

  /// Accept or decline mentorship request
  Future<void> respondToMentorshipRequest(
    String requestId,
    MentorshipRequestStatus status,
  ) async {
    await _repository.updateMentorshipRequestStatus(requestId, status);
    ref.invalidate(mentorshipRequestsProvider);
    ref.invalidate(pendingMentorshipRequestsProvider);
  }

  /// Register for a session
  Future<void> registerForSession(String sessionId) async {
    state = state.copyWith(isRegistering: true);
    try {
      await _repository.registerForSession(sessionId);
      ref.invalidate(sessionDetailProvider(sessionId));
      ref.invalidate(upcomingSessionsProvider);
      ref.invalidate(myRegisteredSessionsProvider);
      state = state.copyWith(isRegistering: false);
    } catch (e) {
      state = state.copyWith(isRegistering: false, error: e.toString());
      rethrow;
    }
  }

  /// Cancel session registration
  Future<void> cancelRegistration(String sessionId) async {
    await _repository.cancelRegistration(sessionId);
    ref.invalidate(sessionDetailProvider(sessionId));
    ref.invalidate(upcomingSessionsProvider);
    ref.invalidate(myRegisteredSessionsProvider);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final learningNotifierProvider = NotifierProvider<LearningNotifier, LearningState>(() {
  return LearningNotifier();
});

/// State class for learning operations
class LearningState {
  const LearningState({
    this.isRegistering = false,
    this.error,
  });

  final bool isRegistering;
  final String? error;

  LearningState copyWith({
    bool? isRegistering,
    String? error,
  }) {
    return LearningState(
      isRegistering: isRegistering ?? this.isRegistering,
      error: error,
    );
  }
}
