import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/providers/supabase_provider.dart';
import '../../domain/services/chart_of_day_service.dart';

/// Provider for Chart of the Day service
final chartOfDayServiceProvider = Provider<ChartOfDayService>((ref) {
  return ChartOfDayService(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for today's featured chart
final chartOfDayProvider = FutureProvider<ChartOfDayEntry?>((ref) async {
  final service = ref.watch(chartOfDayServiceProvider);
  return service.getTodaysFeaturedChart();
});

/// Card displaying the Chart of the Day on the home screen
class ChartOfDayCard extends ConsumerWidget {
  const ChartOfDayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartOfDayAsync = ref.watch(chartOfDayProvider);
    final l10n = AppLocalizations.of(context)!;

    return chartOfDayAsync.when(
      data: (entry) {
        if (entry == null) return const SizedBox.shrink();

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push('/user/${entry.userId}'),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.05),
                    AppColors.secondary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                    backgroundImage: entry.avatarUrl != null
                        ? NetworkImage(entry.avatarUrl!)
                        : null,
                    child: entry.avatarUrl == null
                        ? const Icon(Icons.star, color: AppColors.secondary)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.chartOfDay_title,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.userName ?? 'Featured User',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (entry.reason != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            entry.reason!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
