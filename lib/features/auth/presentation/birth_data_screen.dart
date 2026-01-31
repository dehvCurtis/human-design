import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../home/domain/home_providers.dart';

class BirthDataScreen extends ConsumerStatefulWidget {
  const BirthDataScreen({super.key, this.isEditMode = false});

  /// When true, skip the redirect check and allow editing existing data
  final bool isEditMode;

  @override
  ConsumerState<BirthDataScreen> createState() => _BirthDataScreenState();
}

class _BirthDataScreenState extends ConsumerState<BirthDataScreen> {
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  LocationResult? _birthLocation;
  bool _unknownBirthTime = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _checkedExistingData = false;

  bool get _isValid {
    return _birthDate != null &&
        (_birthTime != null || _unknownBirthTime) &&
        _birthLocation != null;
  }

  @override
  void initState() {
    super.initState();
    // Check if user already has birth data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExistingBirthData();
    });
  }

  Future<void> _checkExistingBirthData() async {
    if (_checkedExistingData) return;
    _checkedExistingData = true;

    try {
      final profile = await ref.read(userProfileProvider.future);
      if (profile?.hasBirthData == true && mounted) {
        if (widget.isEditMode) {
          // In edit mode, pre-populate the form with existing data
          setState(() {
            if (profile!.birthDate != null && profile.timezone != null) {
              // Convert UTC back to local time in birth timezone for display
              final location = tz.getLocation(profile.timezone!);
              final utcDateTime = profile.birthDate!;
              final localDateTime = tz.TZDateTime.from(utcDateTime, location);

              _birthDate = DateTime(
                localDateTime.year,
                localDateTime.month,
                localDateTime.day,
              );
              _birthTime = TimeOfDay(
                hour: localDateTime.hour,
                minute: localDateTime.minute,
              );
            } else if (profile.birthDate != null) {
              // Fallback if no timezone (shouldn't happen normally)
              _birthDate = profile.birthDate;
              _birthTime = TimeOfDay(
                hour: profile.birthDate!.hour,
                minute: profile.birthDate!.minute,
              );
            }
            if (profile.birthLocation != null) {
              _birthLocation = LocationResult(
                name: profile.birthLocation!.city,
                displayName: profile.birthLocation!.displayName,
                latitude: profile.birthLocation!.latitude,
                longitude: profile.birthLocation!.longitude,
                country: profile.birthLocation!.country,
                timezone: profile.timezone,
              );
            }
          });
        } else {
          // Not in edit mode, go to home
          context.go(AppRoutes.home);
        }
      }
    } catch (_) {
      // Ignore errors, let user enter data
    }
  }

  Future<void> _saveAndContinue() async {
    if (!_isValid) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.onboarding_fillAllFields;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Combine date and time
      final birthDateTime = DateTime(
        _birthDate!.year,
        _birthDate!.month,
        _birthDate!.day,
        _unknownBirthTime ? 12 : _birthTime!.hour,
        _unknownBirthTime ? 0 : _birthTime!.minute,
      );

      // Save birth data to profile
      final birthLocation = BirthLocation(
        city: _birthLocation!.name,
        country: _birthLocation!.country ?? '',
        latitude: _birthLocation!.latitude,
        longitude: _birthLocation!.longitude,
      );

      final profileRepo = ref.read(profileRepositoryProvider);
      await profileRepo.updateBirthData(
        birthDateTime: birthDateTime,
        birthLocation: birthLocation,
        timezone: _birthLocation!.timezone ?? 'UTC',
      );

      // Invalidate the user profile provider to reload
      ref.invalidate(userProfileProvider);
      // Also invalidate the chart provider to recalculate with new data
      ref.invalidate(userChartProvider);

      if (mounted) {
        if (widget.isEditMode) {
          // In edit mode, go back to previous screen
          context.pop();
        } else {
          // In onboarding, go to home
          context.go(AppRoutes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '${AppLocalizations.of(context)!.onboarding_saveFailed}: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  void _skipForNow() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auth_birthInformation),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _skipForNow,
            child: Text(l10n.common_skip),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.onboarding_birthDataExplanation,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Error message
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withAlpha(128)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 20),
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

            // Birth Date
            BirthDatePickerField(
              value: _birthDate,
              onChanged: (date) {
                setState(() {
                  _birthDate = date;
                  _errorMessage = null;
                });
              },
              enabled: !_isLoading,
              errorText:
                  _birthDate == null && _errorMessage != null ? '' : null,
            ),
            const SizedBox(height: 24),

            // Birth Time
            BirthTimePickerField(
              value: _birthTime,
              onChanged: (time) {
                setState(() {
                  _birthTime = time;
                  _unknownBirthTime = false;
                  _errorMessage = null;
                });
              },
              enabled: !_isLoading && !_unknownBirthTime,
              isUnknown: _unknownBirthTime,
              onUnknownSelected: () {
                setState(() {
                  _unknownBirthTime = true;
                  _birthTime = null;
                  _errorMessage = null;
                });
              },
            ),
            if (_unknownBirthTime) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.onboarding_noTimeWarning,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _unknownBirthTime = false;
                        });
                      },
                icon: const Icon(Icons.edit, size: 16),
                label: Text(l10n.onboarding_enterBirthTimeInstead),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Birth Location
            BirthLocationField(
              value: _birthLocation,
              onChanged: (location) {
                setState(() {
                  _birthLocation = location;
                  _errorMessage = null;
                });
              },
              enabled: !_isLoading,
            ),
            const SizedBox(height: 32),

            // Calculate button
            PrimaryButton(
              onPressed: _isLoading || !_isValid ? null : _saveAndContinue,
              label: l10n.auth_calculateMyChart,
              icon: Icons.auto_graph,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),

            // Privacy note
            Text(
              l10n.onboarding_birthDataPrivacy,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
