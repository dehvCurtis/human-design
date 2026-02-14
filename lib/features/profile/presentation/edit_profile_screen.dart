import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../home/domain/home_providers.dart';

/// Screen for editing user profile information
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imagePicker = ImagePicker();

  bool _isLoading = false;
  bool _isUploadingAvatar = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load current profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final profile = await ref.read(userProfileProvider.future);
    if (profile != null && mounted) {
      setState(() {
        _nameController.text = profile.name ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() => _isUploadingAvatar = true);

      final profileRepo = ref.read(profileRepositoryProvider);
      await profileRepo.uploadAvatar(pickedFile.path);

      // Refresh the profile provider to show new avatar
      ref.invalidate(userProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ErrorHandler.getUserMessage(e, context: 'upload avatar'),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentProfile = await ref.read(userProfileProvider.future);
      if (currentProfile == null) {
        throw Exception('No profile found');
      }

      final updatedProfile = currentProfile.copyWith(
        name: _nameController.text.trim(),
      );

      final profileRepo = ref.read(profileRepositoryProvider);
      await profileRepo.upsertProfile(updatedProfile);

      // Refresh the profile provider
      ref.invalidate(userProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ErrorHandler.getUserMessage(
            e,
            context: 'update profile',
          );
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile_editProfile),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.common_save),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Error message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withAlpha(128),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Avatar section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.primary.withAlpha(25),
                              backgroundImage: profile.avatarUrl != null
                                  ? NetworkImage(profile.avatarUrl!)
                                  : null,
                              child: profile.avatarUrl == null
                                  ? Text(
                                      _getInitials(profile.name ?? 'User'),
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(color: AppColors.primary),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.scaffoldBackgroundColor,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _isUploadingAvatar
                              ? null
                              : _pickAndUploadAvatar,
                          child: _isUploadingAvatar
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Change Photo'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name field
                  Text(
                    'Display Name',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Email (read-only)
                  Text(
                    'Email',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: profile.email,
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: AppColors.textSecondaryLight.withAlpha(25),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email cannot be changed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Birth Data Section
                  _SectionHeader(
                    title: l10n.profile_birthData,
                    action: TextButton(
                      onPressed: () => context.push('/birth-data?edit=true'),
                      child: Text(
                        profile.hasBirthData ? l10n.common_edit : 'Add',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (profile.hasBirthData) ...[
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: _formatDate(
                            profile.birthDate!,
                            profile.timezone,
                          ),
                        ),
                        _InfoRow(
                          icon: Icons.access_time,
                          label: 'Time',
                          value: _formatTime(
                            profile.birthDate!,
                            profile.timezone,
                          ),
                        ),
                        if (profile.birthLocation != null)
                          _InfoRow(
                            icon: Icons.location_on,
                            label: 'Location',
                            value: profile.birthLocation!.displayName,
                          ),
                        if (profile.timezone != null)
                          _InfoRow(
                            icon: Icons.schedule,
                            label: 'Timezone',
                            value: profile.timezone!,
                          ),
                      ],
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.info),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.profile_addBirthDataPrompt,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Language preference
                  _SectionHeader(title: 'Preferences'),
                  const SizedBox(height: 12),
                  _InfoCard(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Language'),
                        subtitle: Text(
                          _getLanguageName(profile.preferredLanguage),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/settings'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(ErrorHandler.getUserMessage(error, context: 'load profile')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userProfileProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  /// Convert UTC birth datetime to local time using the stored timezone
  DateTime _getLocalBirthDateTime(DateTime utcDate, String? timezone) {
    if (timezone == null) return utcDate;

    try {
      final location = tz.getLocation(timezone);
      return tz.TZDateTime.from(utcDate, location);
    } catch (e) {
      // Fallback to UTC if timezone lookup fails
      return utcDate;
    }
  }

  String _formatDate(DateTime date, String? timezone) {
    final localDate = _getLocalBirthDateTime(date, timezone);
    return '${localDate.month}/${localDate.day}/${localDate.year}';
  }

  String _formatTime(DateTime date, String? timezone) {
    final localDate = _getLocalBirthDateTime(date, timezone);
    final hour = localDate.hour > 12 ? localDate.hour - 12 : localDate.hour;
    final period = localDate.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:${localDate.minute.toString().padLeft(2, '0')} $period';
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'uk':
        return 'Українська';
      default:
        return code;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        ?action,
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: children),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondaryLight),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
