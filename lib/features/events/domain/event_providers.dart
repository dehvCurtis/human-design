import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/event_repository.dart';
import 'models/event.dart';

/// Provider for EventRepository
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for upcoming events
final upcomingEventsProvider = FutureProvider<List<CommunityEvent>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getUpcomingEvents();
});

/// Provider for past events
final pastEventsProvider = FutureProvider<List<CommunityEvent>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getPastEvents();
});

/// Provider for a single event
final eventDetailProvider =
    FutureProvider.family<CommunityEvent, String>((ref, eventId) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEvent(eventId);
});

/// Provider for event registration status
final isRegisteredProvider =
    FutureProvider.family<bool, String>((ref, eventId) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.isRegistered(eventId);
});

/// Provider for event participants
final eventParticipantsProvider =
    FutureProvider.family<List<EventParticipant>, String>((ref, eventId) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getParticipants(eventId);
});

/// State for event actions
class EventActionState {
  const EventActionState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  final bool isLoading;
  final String? error;
  final bool success;

  EventActionState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return EventActionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }
}

/// Notifier for event RSVP actions
class EventActionNotifier extends Notifier<EventActionState> {
  @override
  EventActionState build() => const EventActionState();

  EventRepository get _repository => ref.read(eventRepositoryProvider);

  Future<void> register(String eventId) async {
    state = state.copyWith(isLoading: true, error: null, success: false);
    try {
      await _repository.registerForEvent(eventId);
      ref.invalidate(isRegisteredProvider(eventId));
      ref.invalidate(eventDetailProvider(eventId));
      ref.invalidate(eventParticipantsProvider(eventId));
      ref.invalidate(upcomingEventsProvider);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to register. Please try again.',
      );
    }
  }

  Future<void> cancelRegistration(String eventId) async {
    state = state.copyWith(isLoading: true, error: null, success: false);
    try {
      await _repository.cancelRegistration(eventId);
      ref.invalidate(isRegisteredProvider(eventId));
      ref.invalidate(eventDetailProvider(eventId));
      ref.invalidate(eventParticipantsProvider(eventId));
      ref.invalidate(upcomingEventsProvider);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to cancel registration.',
      );
    }
  }

  Future<bool> createEvent({
    required String title,
    required String description,
    required EventType eventType,
    required DateTime startsAt,
    required DateTime endsAt,
    String? location,
    String? virtualLink,
    String? hdTypeFilter,
    int? maxParticipants,
  }) async {
    state = state.copyWith(isLoading: true, error: null, success: false);
    try {
      await _repository.createEvent(
        title: title,
        description: description,
        eventType: eventType,
        startsAt: startsAt,
        endsAt: endsAt,
        location: location,
        virtualLink: virtualLink,
        hdTypeFilter: hdTypeFilter,
        maxParticipants: maxParticipants,
      );
      ref.invalidate(upcomingEventsProvider);
      state = state.copyWith(isLoading: false, success: true);
      return true;
    } on ArgumentError catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create event.',
      );
      return false;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteEvent(eventId);
      ref.invalidate(upcomingEventsProvider);
      ref.invalidate(pastEventsProvider);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete event.',
      );
    }
  }
}

final eventActionNotifierProvider =
    NotifierProvider<EventActionNotifier, EventActionState>(() {
  return EventActionNotifier();
});
