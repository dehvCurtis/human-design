import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/settings_state.dart';

/// Repository for persisting settings to SharedPreferences
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  // Keys
  static const _keyThemeMode = 'settings_theme_mode';
  static const _keyLocale = 'settings_locale';
  static const _keyNotifications = 'settings_notifications';
  static const _keyUse24HourTime = 'settings_use_24_hour_time';
  static const _keyShowGateNumbers = 'settings_show_gate_numbers';
  static const _keyHapticFeedback = 'settings_haptic_feedback';
  static const _keyIsFirstLaunch = 'settings_is_first_launch';
  static const _keyHasCompletedOnboarding = 'settings_has_completed_onboarding';

  /// Load settings from storage
  SettingsState load() {
    return SettingsState(
      themeMode: AppThemeMode.fromString(_prefs.getString(_keyThemeMode)),
      locale: AppLocale.fromCode(_prefs.getString(_keyLocale)),
      notifications: _loadNotifications(),
      use24HourTime: _prefs.getBool(_keyUse24HourTime) ?? false,
      showGateNumbers: _prefs.getBool(_keyShowGateNumbers) ?? true,
      hapticFeedback: _prefs.getBool(_keyHapticFeedback) ?? true,
      isFirstLaunch: _prefs.getBool(_keyIsFirstLaunch) ?? true,
      hasCompletedOnboarding:
          _prefs.getBool(_keyHasCompletedOnboarding) ?? false,
    );
  }

  NotificationSettings _loadNotifications() {
    final json = _prefs.getString(_keyNotifications);
    if (json == null) return const NotificationSettings();
    try {
      return NotificationSettings.fromMap(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } catch (_) {
      return const NotificationSettings();
    }
  }

  /// Save theme mode
  Future<void> saveThemeMode(AppThemeMode mode) async {
    await _prefs.setString(_keyThemeMode, mode.name);
  }

  /// Save locale
  Future<void> saveLocale(AppLocale locale) async {
    await _prefs.setString(_keyLocale, locale.code);
  }

  /// Save notification settings
  Future<void> saveNotifications(NotificationSettings notifications) async {
    await _prefs.setString(_keyNotifications, jsonEncode(notifications.toMap()));
  }

  /// Save 24-hour time preference
  Future<void> saveUse24HourTime(bool value) async {
    await _prefs.setBool(_keyUse24HourTime, value);
  }

  /// Save show gate numbers preference
  Future<void> saveShowGateNumbers(bool value) async {
    await _prefs.setBool(_keyShowGateNumbers, value);
  }

  /// Save haptic feedback preference
  Future<void> saveHapticFeedback(bool value) async {
    await _prefs.setBool(_keyHapticFeedback, value);
  }

  /// Mark first launch as complete
  Future<void> markFirstLaunchComplete() async {
    await _prefs.setBool(_keyIsFirstLaunch, false);
  }

  /// Mark onboarding as complete
  Future<void> markOnboardingComplete() async {
    await _prefs.setBool(_keyHasCompletedOnboarding, true);
  }

  /// Clear all settings (for testing or account deletion)
  Future<void> clearAll() async {
    await _prefs.remove(_keyThemeMode);
    await _prefs.remove(_keyLocale);
    await _prefs.remove(_keyNotifications);
    await _prefs.remove(_keyUse24HourTime);
    await _prefs.remove(_keyShowGateNumbers);
    await _prefs.remove(_keyHapticFeedback);
    await _prefs.remove(_keyIsFirstLaunch);
    await _prefs.remove(_keyHasCompletedOnboarding);
  }
}
