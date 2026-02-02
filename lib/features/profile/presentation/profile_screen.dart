import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/domain/auth_providers.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../chart/domain/pdf_export_service.dart';
import '../../home/domain/home_providers.dart';
import '../data/profile_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final chartAsync = ref.watch(userChartProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.common_profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Header
              _ProfileHeader(profile: profile),
              const SizedBox(height: 24),

              // Birth Data Card
              _BirthDataCard(profile: profile),
              const SizedBox(height: 16),

              // Chart Summary
              chartAsync.when(
                data: (chart) {
                  if (chart == null) return const SizedBox.shrink();
                  return _ChartSummaryCard(chart: chart);
                },
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              _ActionButton(
                icon: Icons.edit_outlined,
                label: l10n.profile_editProfile,
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              const SizedBox(height: 8),
              _ActionButton(
                icon: Icons.emoji_events_outlined,
                label: 'Achievements',
                onTap: () => context.push(AppRoutes.achievements),
              ),
              const SizedBox(height: 8),
              _ActionButton(
                icon: Icons.school_outlined,
                label: 'Learning',
                onTap: () => context.push(AppRoutes.learning),
              ),
              const SizedBox(height: 8),
              chartAsync.when(
                data: (chart) => _ActionButton(
                  icon: Icons.share_outlined,
                  label: l10n.profile_shareChart,
                  onTap: chart != null
                      ? () => context.push(AppRoutes.share)
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.profile_addBirthDataToShare),
                            ),
                          );
                        },
                ),
                loading: () => _ActionButton(
                  icon: Icons.share_outlined,
                  label: l10n.profile_shareChart,
                  onTap: () {},
                ),
                error: (_, _) => _ActionButton(
                  icon: Icons.share_outlined,
                  label: l10n.profile_shareChart,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              chartAsync.when(
                data: (chart) => _ActionButton(
                  icon: Icons.download_outlined,
                  label: l10n.profile_exportPdf,
                  onTap: chart != null
                      ? () async {
                          final pdfService = PdfExportService();
                          try {
                            await pdfService.sharePdf(chart);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.profile_exportFailed),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          }
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.profile_addBirthDataToExport),
                            ),
                          );
                        },
                ),
                loading: () => _ActionButton(
                  icon: Icons.download_outlined,
                  label: l10n.profile_exportPdf,
                  onTap: () {},
                ),
                error: (_, _) => _ActionButton(
                  icon: Icons.download_outlined,
                  label: l10n.profile_exportPdf,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              _ActionButton(
                icon: Icons.folder_outlined,
                label: l10n.chart_savedCharts,
                onTap: () => context.push(AppRoutes.savedCharts),
              ),
              const SizedBox(height: 8),
              _ActionButton(
                icon: Icons.workspace_premium_outlined,
                label: l10n.profile_upgradePremium,
                onTap: () => context.push(AppRoutes.premium),
                highlight: true,
              ),
              const SizedBox(height: 24),

              // Sign Out
              _SignOutButton(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(l10n.profile_loadFailed),
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
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary.withAlpha(25),
          backgroundImage:
              profile?.avatarUrl != null ? NetworkImage(profile!.avatarUrl!) : null,
          child: profile?.avatarUrl == null
              ? Text(
                  _getInitials(profile?.name ?? 'User'),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          profile?.name ?? AppLocalizations.of(context)!.profile_defaultUserName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          profile?.email ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }
}

class _BirthDataCard extends StatelessWidget {
  const _BirthDataCard({required this.profile});

  final UserProfile? profile;

  /// Convert UTC birth datetime to local time using the stored timezone
  DateTime _getLocalBirthDateTime() {
    if (profile?.birthDate == null) return DateTime.now();
    if (profile?.timezone == null) return profile!.birthDate!;

    try {
      final location = tz.getLocation(profile!.timezone!);
      return tz.TZDateTime.from(profile!.birthDate!, location);
    } catch (e) {
      // Fallback to UTC if timezone lookup fails
      return profile!.birthDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBirthData = profile?.birthDate != null;
    final l10n = AppLocalizations.of(context)!;
    final localBirthDateTime = _getLocalBirthDateTime();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.profile_birthData,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () {
                    // Use edit=true when user already has birth data
                    final route = hasBirthData
                        ? '${AppRoutes.birthData}?edit=true'
                        : AppRoutes.birthData;
                    context.push(route);
                  },
                  icon: Icon(hasBirthData ? Icons.edit : Icons.add, size: 16),
                  label: Text(hasBirthData ? l10n.common_edit : l10n.common_create),
                ),
              ],
            ),
            if (hasBirthData && profile != null && profile!.birthDate != null) ...[
              const Divider(),
              _DataRow(
                icon: Icons.calendar_today,
                label: l10n.profile_birthDate,
                value: DateFormat.yMMMMd().format(localBirthDateTime),
              ),
              _DataRow(
                icon: Icons.access_time,
                label: l10n.profile_birthTime,
                value: DateFormat.jm().format(localBirthDateTime),
              ),
              if (profile!.birthLocation != null)
                _DataRow(
                  icon: Icons.location_on,
                  label: l10n.profile_birthLocation,
                  value: profile!.birthLocation!.displayName,
                ),
              if (profile!.timezone != null)
                _DataRow(
                  icon: Icons.schedule,
                  label: l10n.profile_birthTimezone,
                  value: profile!.timezone ?? '',
                ),
            ] else ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.profile_addBirthDataPrompt,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondaryLight),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartSummaryCard extends StatelessWidget {
  const _ChartSummaryCard({required this.chart});

  final HumanDesignChart chart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profile_chartSummary,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            _SummaryRow(label: l10n.common_type, value: chart.type.displayName),
            _SummaryRow(label: l10n.common_strategy, value: chart.strategy),
            _SummaryRow(label: l10n.common_authority, value: chart.authority.displayName),
            _SummaryRow(label: l10n.section_profile, value: '${chart.profile.notation} ${chart.profile.name}'),
            _SummaryRow(label: l10n.common_definition, value: chart.definition.displayName),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go(AppRoutes.chart),
                child: Text(l10n.profile_viewFullChart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: highlight ? AppColors.primary.withAlpha(25) : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: highlight ? AppColors.primary : null,
        ),
        title: Text(
          label,
          style: highlight
              ? TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                )
              : null,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SignOutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return TextButton.icon(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.profile_signOutConfirmTitle),
            content: Text(l10n.profile_signOutConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.common_cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l10n.profile_signOut),
              ),
            ],
          ),
        );

        if (confirmed == true && context.mounted) {
          await ref.read(authNotifierProvider.notifier).signOut();
        }
      },
      icon: const Icon(Icons.logout, color: AppColors.error),
      label: Text(
        l10n.profile_signOut,
        style: const TextStyle(color: AppColors.error),
      ),
    );
  }
}
