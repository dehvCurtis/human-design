import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../chart/presentation/widgets/bodygraph/bodygraph_widget.dart';
import '../../lifestyle/domain/affirmation_service.dart';
import '../../lifestyle/domain/transit_service.dart';
import '../domain/home_providers.dart';
import 'widgets/affirmation_card.dart';
import 'widgets/chart_preview_card.dart';
import 'widgets/transit_summary_card.dart';
import 'widgets/quick_actions_row.dart';

/// Main home screen with chart preview and daily insights
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userChartAsync = ref.watch(userChartProvider);
    final transits = ref.watch(todayTransitsProvider);

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
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Show notifications
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push(AppRoutes.settings),
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Daily Affirmation Card
                affirmationAsync.when(
                  data: (affirmation) => affirmation != null
                      ? AffirmationCard(
                          affirmation: affirmation,
                          onRefresh: () {
                            ref.refreshAffirmation(chart.id);
                          },
                        )
                      : const SizedBox.shrink(),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 16),

                // Today's Transit Summary
                transitImpactAsync.when(
                  data: (impact) => TransitSummaryCard(
                    transits: transits,
                    impact: impact,
                    onTap: () => context.go(AppRoutes.transits),
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => TransitSummaryCard(
                    transits: transits,
                    impact: null,
                    onTap: () => context.go(AppRoutes.transits),
                  ),
                ),

                const SizedBox(height: 16),

                // Quick Actions
                QuickActionsRow(
                  onChartTap: () => context.go(AppRoutes.chart),
                  onCompositeTap: () => context.go(AppRoutes.composite),
                  onPentaTap: () => context.go(AppRoutes.penta),
                  onSocialTap: () => context.go(AppRoutes.social),
                ),

                const SizedBox(height: 24),

                // Chart Preview
                ChartPreviewCard(
                  chart: chart,
                  onTap: () => context.go(AppRoutes.chart),
                ),

                const SizedBox(height: 24),

                // Chart Summary
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
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Design',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              context,
              'Type',
              chart.type.displayName,
              AppColors.primary,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              'Strategy',
              chart.strategy,
              AppColors.secondary,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              'Authority',
              chart.authority.displayName,
              AppColors.accent,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              'Profile',
              chart.profile.notation,
              AppColors.success,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              'Definition',
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Complete Your Profile',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your birth data to generate your unique Human Design chart.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.birthData),
              icon: const Icon(Icons.edit_calendar),
              label: const Text('Enter Birth Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
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
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
