import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/language_selector.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../gamification/domain/gamification_providers.dart';
import '../../lifestyle/domain/affirmation_service.dart';
import '../../lifestyle/domain/transit_service.dart';
import '../../notifications/domain/notification_providers.dart';
import '../domain/home_providers.dart';
import 'widgets/affirmation_card.dart';
import 'widgets/chart_preview_card.dart';
import 'widgets/gamification_summary_card.dart';
import 'widgets/transit_summary_card.dart';
import 'widgets/quick_actions_row.dart'; // QuickActionsGrid
import '../../ai_assistant/presentation/ai_mini_widget.dart';
import '../../discovery/presentation/widgets/chart_of_day_card.dart';

/// Main home screen with chart preview and daily insights
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userChartAsync = ref.watch(userChartProvider);
    final transits = ref.watch(todayTransitsProvider);

    // Initialize gamification (daily login, challenges) on home screen load
    ref.watch(gamificationInitProvider);

    // Initialize push notifications
    ref.watch(notificationInitProvider);

    return Scaffold(
      body: SafeArea(
        child: userChartAsync.when(
          data: (chart) => _buildContent(context, ref, chart, transits),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(context, error),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    HumanDesignChart? chart,
    TransitChart transits,
  ) {
    if (chart == null) {
      return _buildNoBirthDataState(context);
    }

    final transitImpactAsync = ref.watch(transitImpactProvider);
    final affirmationAsync = ref.watch(affirmationNotifierProvider(chart));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(userChartProvider);
        ref.invalidate(transitImpactProvider);
      },
      child: CustomScrollView(
        slivers: [
          // App bar with greeting
          SliverAppBar(
            floating: true,
            title: _buildGreeting(context, chart),
            actions: [
              const LanguageSelector(compact: true),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push(AppRoutes.activityFeed),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push(AppRoutes.settings),
              ),
            ],
          ),

          // Content with padding
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // AI Assistant Hero CTA
                const AiMiniWidget(),

                const SizedBox(height: 16),

                // Today's Transit Summary
                transitImpactAsync.when(
                  data: (impact) => TransitSummaryCard(
                    transits: transits,
                    impact: impact,
                    onTap: () => context.go(AppRoutes.transits),
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, _) => TransitSummaryCard(
                    transits: transits,
                    impact: null,
                    onTap: () => context.go(AppRoutes.transits),
                  ),
                ),

                const SizedBox(height: 16),

                // Gamification Progress
                const GamificationSummaryCard(),

                const SizedBox(height: 16),

                // Quick Actions (categorized)
                QuickActionsGrid(
                  // Charts
                  onChartTap: () => context.go(AppRoutes.chart),
                  onSavedChartsTap: () => context.push(AppRoutes.savedCharts),
                  onCompositeTap: () => context.push(AppRoutes.composite),
                  onPentaTap: () => context.push(AppRoutes.penta),
                  // AI & Insights
                  onTransitInsightTap: () => context.push(AppRoutes.aiTransitInsight),
                  onChartReadingTap: () => context.push(AppRoutes.aiChartReading),
                  onDreamJournalTap: () => context.push(AppRoutes.dreamJournal),
                  onJournalPromptsTap: () => context.push(AppRoutes.journalPrompts),
                  // Community
                  onSocialTap: () => context.go(AppRoutes.social),
                  onDiscoverTap: () => context.push(AppRoutes.discover),
                  onFeedTap: () => context.push(AppRoutes.feed),
                  onMessagesTap: () => context.push(AppRoutes.messages),
                  // Learn
                  onLearningTap: () => context.push(AppRoutes.learning),
                  onEventsTap: () => context.push(AppRoutes.events),
                ),

                const SizedBox(height: 16),

                // Chart of the Day
                const ChartOfDayCard(),

                const SizedBox(height: 16),

                // Daily Affirmation Card (moved below Quick Actions)
                affirmationAsync.when(
                  data: (affirmation) => affirmation != null
                      ? AffirmationCard(
                          affirmation: affirmation,
                          onRefresh: () {
                            ref.refreshAffirmation(chart.id);
                          },
                          onSave: () => _saveAffirmation(context, ref, affirmation),
                        )
                      : const SizedBox.shrink(),
                  loading: () => const _LoadingCard(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ]),
            ),
          ),

          // Chart Preview - full width, no padding
          SliverToBoxAdapter(
            child: ChartPreviewCard(
              chart: chart,
              onTap: () => context.go(AppRoutes.chart),
            ),
          ),

          // Chart Summary with padding
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildChartSummary(context, chart),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, HumanDesignChart chart) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = l10n.home_goodMorning;
    } else if (hour < 17) {
      greeting = l10n.home_goodAfternoon;
    } else {
      greeting = l10n.home_goodEvening;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
        ),
        Text(
          chart.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildChartSummary(BuildContext context, HumanDesignChart chart) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.home_yourDesign,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              context,
              l10n.common_type,
              chart.type.displayName,
              AppColors.primary,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              l10n.common_strategy,
              chart.strategy,
              AppColors.secondary,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              l10n.common_authority,
              chart.authority.displayName,
              AppColors.accent,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              l10n.common_profile,
              chart.profile.notation,
              AppColors.success,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              l10n.common_definition,
              chart.definition.displayName,
              AppColors.info,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoBirthDataState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.home_completeProfile,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.chart_addBirthDataPrompt,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.birthData),
              icon: const Icon(Icons.edit_calendar),
              label: Text(l10n.home_enterBirthData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.error_generic,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAffirmation(
    BuildContext context,
    WidgetRef ref,
    DailyAffirmation affirmation,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final saved = await ref
        .read(savedAffirmationsProvider.notifier)
        .saveAffirmation(affirmation);

    if (context.mounted) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            saved ? l10n.affirmation_savedSuccess : l10n.affirmation_alreadySaved,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
