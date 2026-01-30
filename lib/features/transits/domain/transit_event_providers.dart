import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../../feed/data/feed_repository.dart';
import '../../feed/domain/models/post.dart';
import '../data/transit_event_repository.dart';
import 'models/transit_event.dart';

/// Provider for the TransitEventRepository
final transitEventRepositoryProvider = Provider<TransitEventRepository>((ref) {
  return TransitEventRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for all active and upcoming events
final activeEventsProvider = FutureProvider<List<TransitEvent>>((ref) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.getActiveEvents();
});

/// Provider for currently happening events
final currentEventsProvider = FutureProvider<List<TransitEvent>>((ref) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.getCurrentEvents();
});

/// Provider for upcoming events
final upcomingEventsProvider = FutureProvider<List<TransitEvent>>((ref) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.getUpcomingEvents();
});

/// Provider for past events
final pastEventsProvider = FutureProvider<List<TransitEvent>>((ref) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.getPastEvents();
});

/// Provider for a single event
final transitEventProvider = FutureProvider.family<TransitEvent?, String>((ref, eventId) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.getEvent(eventId);
});

/// Provider for events by gate
final eventsByGateProvider = FutureProvider.family<List<TransitEvent>, int>((ref, gateNumber) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.getEventsByGate(gateNumber);
});

/// Provider for checking if user is participating
final isParticipatingProvider = FutureProvider.family<bool, String>((ref, eventId) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.isParticipating(eventId);
});

/// Provider for user's participation data
final participationProvider = FutureProvider.family<TransitEventParticipation?, String>((ref, eventId) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.getParticipation(eventId);
});

/// Provider for event posts
final eventPostsProvider = FutureProvider.family<List<Post>, String>((ref, eventId) async {
  final eventRepo = ref.watch(transitEventRepositoryProvider);
  final feedRepo = ref.watch(feedRepositoryProvider);

  // Get post IDs for this event
  final postIds = await eventRepo.getEventPostIds(eventId);

  if (postIds.isEmpty) return [];

  // Fetch the actual posts
  final posts = await Future.wait(
    postIds.map((id) => feedRepo.getPost(id)),
  );

  return posts.whereType<Post>().toList();
});

/// Provider for event insights
final eventInsightsProvider = FutureProvider.family<TransitEventInsight?, String>((ref, eventId) async {
  final repository = ref.watch(transitEventRepositoryProvider);
  return repository.getEventInsights(eventId);
});

/// Provider for the FeedRepository
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Notifier for managing transit event operations
class TransitEventNotifier extends Notifier<TransitEventState> {
  @override
  TransitEventState build() => const TransitEventState();

  TransitEventRepository get _repository => ref.read(transitEventRepositoryProvider);

  /// Join a transit event
  Future<void> joinEvent(String eventId) async {
    state = state.copyWith(isJoining: true);

    try {
      await _repository.joinEvent(eventId);
      ref.invalidate(isParticipatingProvider(eventId));
      ref.invalidate(transitEventProvider(eventId));
      state = state.copyWith(isJoining: false);
    } catch (e) {
      state = state.copyWith(isJoining: false, error: e.toString());
      rethrow;
    }
  }

  /// Leave a transit event
  Future<void> leaveEvent(String eventId) async {
    try {
      await _repository.leaveEvent(eventId);
      ref.invalidate(isParticipatingProvider(eventId));
      ref.invalidate(transitEventProvider(eventId));
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Update participation (reflection, mood)
  Future<void> updateParticipation({
    required String eventId,
    String? reflection,
    String? mood,
  }) async {
    try {
      await _repository.updateParticipation(
        eventId: eventId,
        reflection: reflection,
        mood: mood,
      );
      ref.invalidate(participationProvider(eventId));
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Link a post to an event
  Future<void> linkPostToEvent(String postId, String eventId) async {
    try {
      await _repository.linkPostToEvent(postId, eventId);
      ref.invalidate(eventPostsProvider(eventId));
      ref.invalidate(transitEventProvider(eventId));
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final transitEventNotifierProvider = NotifierProvider<TransitEventNotifier, TransitEventState>(() {
  return TransitEventNotifier();
});

/// State class for transit event operations
class TransitEventState {
  const TransitEventState({
    this.isJoining = false,
    this.error,
  });

  final bool isJoining;
  final String? error;

  TransitEventState copyWith({
    bool? isJoining,
    String? error,
  }) {
    return TransitEventState(
      isJoining: isJoining ?? this.isJoining,
      error: error,
    );
  }
}
