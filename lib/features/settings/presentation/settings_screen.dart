import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/domain/auth_providers.dart';
import '../../home/domain/home_providers.dart';
import '../../profile/data/profile_repository.dart';
import '../domain/settings_providers.dart';
import '../domain/settings_state.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.common_settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _SectionHeader(title: l10n.settings_appearance),
          _SettingsTile(
            icon: Icons.palette_outlined,
            title: l10n.settings_theme,
            subtitle: settings.themeMode.displayName,
            onTap: () => _showThemeSelector(context, ref, settings.themeMode),
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: l10n.settings_language,
            subtitle: settings.locale.displayName,
            onTap: () => _showLanguageSelector(context, ref, settings.locale),
          ),
          const Divider(),

          // Chart Display Section
          _SectionHeader(title: l10n.settings_chartDisplay),
          _SwitchTile(
            icon: Icons.numbers_outlined,
            title: l10n.settings_showGateNumbers,
            subtitle: l10n.settings_showGateNumbersSubtitle,
            value: settings.showGateNumbers,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setShowGateNumbers(value);
            },
          ),
          _SwitchTile(
            icon: Icons.access_time_outlined,
            title: l10n.settings_use24HourTime,
            subtitle: l10n.settings_use24HourTimeSubtitle,
            value: settings.use24HourTime,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setUse24HourTime(value);
            },
          ),
          const Divider(),

          // Notifications Section
          _SectionHeader(title: l10n.settings_notifications),
          _SwitchTile(
            icon: Icons.wb_sunny_outlined,
            title: l10n.settings_dailyTransits,
            subtitle: l10n.settings_dailyTransitsSubtitle,
            value: settings.notifications.dailyTransits,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .toggleNotification('dailyTransits', value);
            },
          ),
          _SwitchTile(
            icon: Icons.swap_horiz_outlined,
            title: l10n.settings_gateChanges,
            subtitle: l10n.settings_gateChangesSubtitle,
            value: settings.notifications.gateChanges,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .toggleNotification('gateChanges', value);
            },
          ),
          _SwitchTile(
            icon: Icons.people_outlined,
            title: l10n.settings_socialActivity,
            subtitle: l10n.settings_socialActivitySubtitle,
            value: settings.notifications.socialActivity,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .toggleNotification('socialActivity', value);
            },
          ),
          _SwitchTile(
            icon: Icons.emoji_events_outlined,
            title: l10n.settings_achievements,
            subtitle: l10n.settings_achievementsSubtitle,
            value: settings.notifications.achievements,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .toggleNotification('achievements', value);
            },
          ),
          const Divider(),

          // Privacy Section
          _SectionHeader(title: l10n.settings_privacy),
          _ChartVisibilityTile(),
          const Divider(),

          // Feedback Section
          _SectionHeader(title: l10n.settings_feedback),
          _SwitchTile(
            icon: Icons.vibration_outlined,
            title: l10n.settings_hapticFeedback,
            subtitle: l10n.settings_hapticFeedbackSubtitle,
            value: settings.hapticFeedback,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setHapticFeedback(value);
            },
          ),
          const Divider(),

          // Account Section
          _SectionHeader(title: l10n.settings_account),
          _SettingsTile(
            icon: Icons.lock_outlined,
            title: l10n.settings_changePassword,
            onTap: () => _showChangePasswordDialog(context, ref),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.settings_privacyPolicy,
            onTap: () => _openUrl('${AppConfig.appUrl}/privacy-policy'),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: l10n.settings_terms,
            onTap: () => _openUrl('${AppConfig.appUrl}/terms-of-service'),
          ),
          _SettingsTile(
            icon: Icons.download_outlined,
            title: l10n.settings_exportData,
            subtitle: l10n.settings_exportDataSubtitle,
            onTap: () => _exportUserData(context, ref),
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: l10n.settings_deleteAccount,
            textColor: AppColors.error,
            onTap: () => _showDeleteAccountDialog(context, ref),
          ),
          const Divider(),

          // About Section
          _SectionHeader(title: l10n.settings_about),
          _SettingsTile(
            icon: Icons.info_outlined,
            title: l10n.settings_appVersion,
            subtitle: '1.0.0',
          ),
          _SettingsTile(
            icon: Icons.star_outline,
            title: l10n.settings_rateApp,
            onTap: () => _rateApp(context),
          ),
          _SettingsTile(
            icon: Icons.feedback_outlined,
            title: l10n.settings_sendFeedback,
            onTap: () => _sendFeedback(context),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showThemeSelector(
      BuildContext context, WidgetRef ref, AppThemeMode currentMode) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.settings_selectTheme,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            ...AppThemeMode.values.map((mode) {
              return ListTile(
                leading: Icon(mode.icon),
                title: Text(mode.displayName),
                trailing: mode == currentMode
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(settingsProvider.notifier).setThemeMode(mode);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(
      BuildContext context, WidgetRef ref, AppLocale currentLocale) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.settings_selectLanguage,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            ...AppLocale.values.map((locale) {
              return ListTile(
                leading: Text(
                  locale.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(locale.displayName),
                trailing: locale == currentLocale
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(settingsProvider.notifier).setLocale(locale);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => _ChangePasswordDialog(l10n: l10n),
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    // TODO: Replace with actual App Store ID after publishing
    const iosAppId = '6450000000'; // Numeric App Store ID (placeholder)
    const androidPackage = 'com.insideme.humandesign';

    final Uri uri;
    if (Platform.isIOS) {
      // iOS App Store - use itms-apps for native app store opening
      uri = Uri.parse('itms-apps://itunes.apple.com/app/id$iosAppId?action=write-review');
    } else {
      // Google Play Store
      uri = Uri.parse('https://play.google.com/store/apps/details?id=$androidPackage');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendFeedback(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@humandesign.app',
      query: 'subject=${Uri.encodeComponent(l10n.settings_feedbackSubject)}'
          '&body=${Uri.encodeComponent(l10n.settings_feedbackBody)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _exportUserData(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(l10n.settings_exportingData)),
          ],
        ),
      ),
    );

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final jsonData = await authRepository.exportUserData();

      // Save to temp file
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/human_design_data_$timestamp.json');
      await file.writeAsString(jsonData);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      // Share file
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: l10n.settings_exportDataSubject,
        ),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settings_exportDataFailed)),
        );
      }
    }
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => _DeleteAccountDialog(l10n: l10n),
    );
  }
}

class _DeleteAccountDialog extends ConsumerStatefulWidget {
  const _DeleteAccountDialog({required this.l10n});

  final AppLocalizations l10n;

  @override
  ConsumerState<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<_DeleteAccountDialog> {
  bool _isDeleting = false;
  String? _errorMessage;

  Future<void> _deleteAccount() async {
    setState(() {
      _isDeleting = true;
      _errorMessage = null;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.deleteAccount();
      if (mounted) {
        Navigator.pop(context);
        // Navigate to sign in screen after successful deletion
        context.go(AppRoutes.signIn);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
          _errorMessage = widget.l10n.settings_deleteAccountFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.settings_deleteAccount),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.l10n.settings_deleteAccountConfirm),
          const SizedBox(height: 12),
          Text(
            widget.l10n.settings_deleteAccountWarning,
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: TextStyle(color: AppColors.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isDeleting ? null : () => Navigator.pop(context),
          child: Text(widget.l10n.common_cancel),
        ),
        ElevatedButton(
          onPressed: _isDeleting ? null : _deleteAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          child: _isDeleting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(widget.l10n.common_delete),
        ),
      ],
    );
  }
}

class _ChangePasswordDialog extends ConsumerStatefulWidget {
  const _ChangePasswordDialog({required this.l10n});

  final AppLocalizations l10n;

  @override
  ConsumerState<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.updatePassword(_passwordController.text);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.l10n.settings_passwordChanged)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = widget.l10n.settings_passwordChangeFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.settings_changePassword),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: widget.l10n.auth_newPassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.l10n.auth_passwordRequired;
                }
                if (value.length < 8) {
                  return widget.l10n.auth_passwordTooShort;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: widget.l10n.auth_confirmPassword,
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return widget.l10n.auth_passwordsDoNotMatch;
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(color: AppColors.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(widget.l10n.common_cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _changePassword,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.l10n.common_save),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _ChartVisibilityTile extends ConsumerWidget {
  const _ChartVisibilityTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final visibility = profile?.chartVisibility ?? ChartVisibility.private;
        return _SettingsTile(
          icon: Icons.visibility_outlined,
          title: l10n.settings_chartVisibility,
          subtitle: _getVisibilityLabel(context, visibility),
          onTap: () => _showVisibilitySelector(context, ref, visibility),
        );
      },
      loading: () => ListTile(
        leading: const Icon(Icons.visibility_outlined),
        title: Text(l10n.settings_chartVisibility),
        trailing: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  String _getVisibilityLabel(BuildContext context, ChartVisibility visibility) {
    final l10n = AppLocalizations.of(context)!;
    switch (visibility) {
      case ChartVisibility.private:
        return l10n.settings_chartPrivate;
      case ChartVisibility.friends:
        return l10n.settings_chartFriends;
      case ChartVisibility.public:
        return l10n.settings_chartPublic;
    }
  }

  void _showVisibilitySelector(
    BuildContext context,
    WidgetRef ref,
    ChartVisibility currentVisibility,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.settings_chartVisibility,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            _VisibilityOption(
              icon: Icons.lock_outlined,
              title: l10n.settings_chartPrivate,
              description: l10n.settings_chartPrivateDesc,
              isSelected: currentVisibility == ChartVisibility.private,
              onTap: () {
                _setVisibility(context, ref, ChartVisibility.private);
              },
            ),
            _VisibilityOption(
              icon: Icons.people_outlined,
              title: l10n.settings_chartFriends,
              description: l10n.settings_chartFriendsDesc,
              isSelected: currentVisibility == ChartVisibility.friends,
              onTap: () {
                _setVisibility(context, ref, ChartVisibility.friends);
              },
            ),
            _VisibilityOption(
              icon: Icons.public_outlined,
              title: l10n.settings_chartPublic,
              description: l10n.settings_chartPublicDesc,
              isSelected: currentVisibility == ChartVisibility.public,
              onTap: () {
                _setVisibility(context, ref, ChartVisibility.public);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _setVisibility(
    BuildContext context,
    WidgetRef ref,
    ChartVisibility visibility,
  ) async {
    Navigator.pop(context);
    try {
      await ref.read(profileRepositoryProvider).setChartVisibility(visibility);
      ref.invalidate(userProfileProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'update visibility'))),
        );
      }
    }
  }
}

class _VisibilityOption extends StatelessWidget {
  const _VisibilityOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      subtitle: Text(description),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
