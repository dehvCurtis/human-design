import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/domain/home_providers.dart';
import '../domain/models/human_design_chart.dart';

/// Screen for adding a chart for someone else
class AddChartScreen extends ConsumerStatefulWidget {
  const AddChartScreen({super.key});

  @override
  ConsumerState<AddChartScreen> createState() => _AddChartScreenState();
}

class _AddChartScreenState extends ConsumerState<AddChartScreen> {
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  LocationResult? _birthLocation;
  bool _unknownBirthTime = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isValid {
    return _nameController.text.trim().isNotEmpty &&
        _birthDate != null &&
        (_birthTime != null || _unknownBirthTime) &&
        _birthLocation != null;
  }

  Future<void> _calculateAndSave() async {
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

      final birthLocation = BirthLocation(
        city: _birthLocation!.name,
        country: _birthLocation!.country ?? '',
        latitude: _birthLocation!.latitude,
        longitude: _birthLocation!.longitude,
      );

      // Calculate the chart
      final userId = ref.read(supabaseClientProvider).auth.currentUser?.id ?? '';
      final calculateChart = ref.read(calculateChartUseCaseProvider);
      final chart = await calculateChart.execute(
        userId: userId,
        name: _nameController.text.trim(),
        birthDateTime: birthDateTime,
        birthLocation: birthLocation,
        timezone: _birthLocation!.timezone ?? 'UTC',
      );

      // Save the chart
      final profileRepo = ref.read(profileRepositoryProvider);
      await profileRepo.saveChart(chart);

      if (mounted) {
        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.chart_saved),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chart_addChart),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
                    Icons.person_add_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.chart_addChartDescription,
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
            const SizedBox(height: 24),

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

            // Name field
            Text(
              l10n.chart_personName,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: l10n.chart_enterPersonName,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

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
              onPressed: _isLoading || !_isValid ? null : _calculateAndSave,
              label: l10n.chart_calculateAndSave,
              icon: Icons.auto_graph,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
