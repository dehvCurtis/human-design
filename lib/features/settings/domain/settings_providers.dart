import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/settings_repository.dart';
import 'settings_state.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// Provider for settings repository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});

/// Main settings provider
final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

/// Settings notifier for managing app settings
class SettingsNotifier extends Notifier<SettingsState> {
  late SettingsRepository _repository;

  @override
  SettingsState build() {
    _repository = ref.watch(settingsRepositoryProvider);
    return _repository.load();
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repository.saveThemeMode(mode);
  }

  /// Set locale
  Future<void> setLocale(AppLocale locale) async {
    state = state.copyWith(locale: locale);
    await _repository.saveLocale(locale);
  }

  /// Update notification settings
  Future<void> updateNotifications(NotificationSettings notifications) async {
    state = state.copyWith(notifications: notifications);
    await _repository.saveNotifications(notifications);
  }

  /// Toggle specific notification type
  Future<void> toggleNotification(String type, bool value) async {
    final current = state.notifications;
    NotificationSettings updated;

    switch (type) {
      case 'dailyTransits':
        updated = current.copyWith(dailyTransits: value);
        break;
      case 'gateChanges':
        updated = current.copyWith(gateChanges: value);
        break;
      case 'socialActivity':
        updated = current.copyWith(socialActivity: value);
        break;
      case 'achievements':
        updated = current.copyWith(achievements: value);
        break;
      case 'marketing':
        updated = current.copyWith(marketing: value);
        break;
      default:
        return;
    }

    state = state.copyWith(notifications: updated);
    await _repository.saveNotifications(updated);
  }

  /// Set 24-hour time preference
  Future<void> setUse24HourTime(bool value) async {
    state = state.copyWith(use24HourTime: value);
    await _repository.saveUse24HourTime(value);
  }

  /// Set show gate numbers preference
  Future<void> setShowGateNumbers(bool value) async {
    state = state.copyWith(showGateNumbers: value);
    await _repository.saveShowGateNumbers(value);
  }

  /// Set haptic feedback preference
  Future<void> setHapticFeedback(bool value) async {
    state = state.copyWith(hapticFeedback: value);
    await _repository.saveHapticFeedback(value);
  }

  /// Mark first launch as complete
  Future<void> completeFirstLaunch() async {
    state = state.copyWith(isFirstLaunch: false);
    await _repository.markFirstLaunchComplete();
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    state = state.copyWith(hasCompletedOnboarding: true);
    await _repository.markOnboardingComplete();
  }

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    await _repository.clearAll();
    state = const SettingsState(
      isFirstLaunch: false,
      hasCompletedOnboarding: true,
    );
  }
}

/// Convenience provider for theme mode
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider.select((s) => s.themeMode.toFlutterThemeMode()));
});

/// Convenience provider for locale
final localeProvider = Provider<Locale>((ref) {
  return ref.watch(settingsProvider.select((s) => s.locale.toLocale()));
});

/// Convenience provider for notification settings
final notificationSettingsProvider = Provider<NotificationSettings>((ref) {
  return ref.watch(settingsProvider.select((s) => s.notifications));
});

/// Provider for checking if onboarding is needed
final needsOnboardingProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.isFirstLaunch || !settings.hasCompletedOnboarding;
});
