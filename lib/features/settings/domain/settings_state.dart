import 'package:flutter/material.dart';

/// Available theme modes
enum AppThemeMode {
  system,
  light,
  dark;

  ThemeMode toFlutterThemeMode() {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  static AppThemeMode fromString(String? value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  String get displayName {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}

/// Supported app locales
enum AppLocale {
  english('en', 'English', '🇺🇸'),
  russian('ru', 'Русский', '🇷🇺'),
  ukrainian('uk', 'Українська', '🇺🇦');

  const AppLocale(this.code, this.displayName, this.flag);

  final String code;
  final String displayName;
  final String flag;

  Locale toLocale() => Locale(code);

  static AppLocale fromCode(String? code) {
    switch (code) {
      case 'ru':
        return AppLocale.russian;
      case 'uk':
        return AppLocale.ukrainian;
      default:
        return AppLocale.english;
    }
  }
}

/// Notification settings
class NotificationSettings {
  const NotificationSettings({
    this.dailyTransits = true,
    this.gateChanges = true,
    this.socialActivity = true,
    this.achievements = true,
    this.marketing = false,
  });

  final bool dailyTransits;
  final bool gateChanges;
  final bool socialActivity;
  final bool achievements;
  final bool marketing;

  NotificationSettings copyWith({
    bool? dailyTransits,
    bool? gateChanges,
    bool? socialActivity,
    bool? achievements,
    bool? marketing,
  }) {
    return NotificationSettings(
      dailyTransits: dailyTransits ?? this.dailyTransits,
      gateChanges: gateChanges ?? this.gateChanges,
      socialActivity: socialActivity ?? this.socialActivity,
      achievements: achievements ?? this.achievements,
      marketing: marketing ?? this.marketing,
    );
  }

  Map<String, bool> toMap() {
    return {
      'dailyTransits': dailyTransits,
      'gateChanges': gateChanges,
      'socialActivity': socialActivity,
      'achievements': achievements,
      'marketing': marketing,
    };
  }

  factory NotificationSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const NotificationSettings();
    return NotificationSettings(
      dailyTransits: map['dailyTransits'] as bool? ?? true,
      gateChanges: map['gateChanges'] as bool? ?? true,
      socialActivity: map['socialActivity'] as bool? ?? true,
      achievements: map['achievements'] as bool? ?? true,
      marketing: map['marketing'] as bool? ?? false,
    );
  }
}

/// Complete app settings state
class SettingsState {
  const SettingsState({
    this.themeMode = AppThemeMode.system,
    this.locale = AppLocale.english,
    this.notifications = const NotificationSettings(),
    this.use24HourTime = false,
    this.showGateNumbers = true,
    this.hapticFeedback = true,
    this.isFirstLaunch = true,
    this.hasCompletedOnboarding = false,
  });

  final AppThemeMode themeMode;
  final AppLocale locale;
  final NotificationSettings notifications;
  final bool use24HourTime;
  final bool showGateNumbers;
  final bool hapticFeedback;
  final bool isFirstLaunch;
  final bool hasCompletedOnboarding;

  SettingsState copyWith({
    AppThemeMode? themeMode,
    AppLocale? locale,
    NotificationSettings? notifications,
    bool? use24HourTime,
    bool? showGateNumbers,
    bool? hapticFeedback,
    bool? isFirstLaunch,
    bool? hasCompletedOnboarding,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      notifications: notifications ?? this.notifications,
      use24HourTime: use24HourTime ?? this.use24HourTime,
      showGateNumbers: showGateNumbers ?? this.showGateNumbers,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState &&
        other.themeMode == themeMode &&
        other.locale == locale &&
        other.use24HourTime == use24HourTime &&
        other.showGateNumbers == showGateNumbers &&
        other.hapticFeedback == hapticFeedback &&
        other.isFirstLaunch == isFirstLaunch &&
        other.hasCompletedOnboarding == hasCompletedOnboarding;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      locale,
      use24HourTime,
      showGateNumbers,
      hapticFeedback,
      isFirstLaunch,
      hasCompletedOnboarding,
    );
  }
}
