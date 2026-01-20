import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/notification_service.dart';

/// Provider for the NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService(supabaseClient: ref.watch(supabaseClientProvider));
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for notification initialization (call once on app start)
final notificationInitProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  await service.initialize();
});

/// Provider to check if notifications are enabled
final notificationsEnabledProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return service.areNotificationsEnabled();
});

/// Notifier for managing notification preferences
class NotificationPreferencesNotifier extends Notifier<NotificationPreferences> {
  @override
  NotificationPreferences build() => const NotificationPreferences();

  NotificationService get _service => ref.read(notificationServiceProvider);

  /// Toggle transit notifications
  Future<void> toggleTransitNotifications(bool enabled) async {
    if (enabled) {
      await _service.subscribeToTopic('daily_transits');
    } else {
      await _service.unsubscribeFromTopic('daily_transits');
    }
    state = state.copyWith(transitNotifications: enabled);
  }

  /// Toggle daily affirmation notifications
  Future<void> toggleAffirmationNotifications(bool enabled) async {
    if (enabled) {
      await _service.subscribeToTopic('daily_affirmations');
    } else {
      await _service.unsubscribeFromTopic('daily_affirmations');
    }
    state = state.copyWith(affirmationNotifications: enabled);
  }

  /// Toggle social notifications
  Future<void> toggleSocialNotifications(bool enabled) async {
    state = state.copyWith(socialNotifications: enabled);
    // Social notifications are handled per-user via FCM tokens
  }

  /// Toggle challenge notifications
  Future<void> toggleChallengeNotifications(bool enabled) async {
    if (enabled) {
      await _service.subscribeToTopic('challenges');
    } else {
      await _service.unsubscribeFromTopic('challenges');
    }
    state = state.copyWith(challengeNotifications: enabled);
  }

  /// Subscribe to user's HD type topic
  Future<void> subscribeToHDType(String hdType) async {
    await _service.subscribeToTopic('type_${hdType.toLowerCase()}');
  }
}

final notificationPreferencesProvider =
    NotifierProvider<NotificationPreferencesNotifier, NotificationPreferences>(() {
  return NotificationPreferencesNotifier();
});

/// Notification preferences state
class NotificationPreferences {
  const NotificationPreferences({
    this.transitNotifications = true,
    this.affirmationNotifications = true,
    this.socialNotifications = true,
    this.challengeNotifications = true,
  });

  final bool transitNotifications;
  final bool affirmationNotifications;
  final bool socialNotifications;
  final bool challengeNotifications;

  NotificationPreferences copyWith({
    bool? transitNotifications,
    bool? affirmationNotifications,
    bool? socialNotifications,
    bool? challengeNotifications,
  }) {
    return NotificationPreferences(
      transitNotifications: transitNotifications ?? this.transitNotifications,
      affirmationNotifications: affirmationNotifications ?? this.affirmationNotifications,
      socialNotifications: socialNotifications ?? this.socialNotifications,
      challengeNotifications: challengeNotifications ?? this.challengeNotifications,
    );
  }
}
