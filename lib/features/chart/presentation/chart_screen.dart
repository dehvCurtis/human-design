import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/human_design_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../../shared/widgets/dialogs/detail_bottom_sheet.dart';
import '../../home/domain/home_providers.dart';
import '../domain/chart_providers.dart';
import '../domain/models/human_design_chart.dart';
import 'widgets/bodygraph/bodygraph_data.dart';
import 'widgets/bodygraph/bodygraph_widget.dart';
import 'widgets/bodygraph/planetary_panel.dart';
import 'widgets/chakra/chakra_chart_widget.dart';
import 'widgets/chakra/chakra_data.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key, this.chartId});

  /// Optional chart ID - when provided, loads that chart instead of user's chart
  final String? chartId;

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load chart based on chartId or fall back to user chart
    final chartAsync = widget.chartId != null
        ? ref.watch(chartByIdProvider(widget.chartId!))
        : ref.watch(userChartProvider);
    final l10n = AppLocalizations.of(context)!;
    final isViewingSavedChart = widget.chartId != null;

    // Get Sun activation for display in app bar
    final sunActivation = chartAsync.whenOrNull(
      data: (chart) => chart?.consciousActivations[HumanDesignPlanet.sun],
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: isViewingSavedChart ? null : 184,
        leading: isViewingSavedChart
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : Row(
                children: [
                  // Sun gate button - navigates to Transits screen
                  if (sunActivation != null)
                    InkWell(
                      onTap: () => context.go(AppRoutes.transits),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: AppColors.conscious.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sunActivation.notation,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.conscious,
                          ),
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.compare_arrows),
                    tooltip: l10n.chart_composite,
                    onPressed: () {
                      context.push(AppRoutes.composite);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.hub_outlined),
                    tooltip: l10n.penta_analysis,
                    onPressed: () {
                      context.push(AppRoutes.penta);
                    },
                  ),
                ],
              ),
        title: isViewingSavedChart
            ? chartAsync.whenOrNull(
                  data: (chart) => Text(chart?.name ?? l10n.chart_myChart),
                ) ??
                Text(l10n.chart_myChart)
            : Text(l10n.chart_myChart),
        actions: [
          if (!isViewingSavedChart) ...[
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              tooltip: l10n.chart_savedCharts,
              onPressed: () {
                context.push(AppRoutes.savedCharts);
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.chart_addChart,
              onPressed: () {
                context.push(AppRoutes.addChart);
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.chart_bodygraph),
            Tab(text: l10n.chart_planets),
            Tab(text: l10n.chart_properties),
            Tab(text: l10n.chart_gates),
            Tab(text: l10n.chart_channels),
            Tab(text: l10n.chart_chakras),
          ],
        ),
      ),
      body: chartAsync.when(
        data: (chart) {
          if (chart == null) {
            return _buildNoChartState(context);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Bodygraph Tab
              _BodygraphTab(chart: chart),

              // Planets Tab (Design & Personality)
              _PlanetsTab(chart: chart),

              // Properties Tab
              _PropertiesTab(chart: chart),

              // Gates Tab
              _GatesTab(chart: chart),

              // Channels Tab
              _ChannelsTab(chart: chart),

              // Chakras Tab
              _ChakrasTab(chart: chart),
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
              Text('${l10n.error_chartCalculation}: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (widget.chartId != null) {
                    ref.invalidate(chartByIdProvider(widget.chartId!));
                  } else {
                    ref.invalidate(userChartProvider);
                  }
                },
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoChartState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_graph,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.chart_noChartYet,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chart_addBirthDataPrompt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final isLoggedIn = ref.read(supabaseClientProvider).auth.currentUser != null;
                if (isLoggedIn) {
                  context.push(AppRoutes.birthData);
                } else {
                  // Show dialog to prompt login
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.auth_signInRequired),
                      content: Text(l10n.auth_signInToCalculateChart),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(l10n.common_cancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.go(AppRoutes.signIn);
                          },
                          child: Text(l10n.auth_signIn),
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.chart_addBirthData),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodygraphTab extends StatefulWidget {
  const _BodygraphTab({required this.chart});

  final HumanDesignChart chart;

  @override
  State<_BodygraphTab> createState() => _BodygraphTabState();
}

class _BodygraphTabState extends State<_BodygraphTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BodygraphWidget(
        chart: widget.chart,
        layoutType: BodygraphLayoutType.standard,
        onCenterTap: (center) => _showCenterDetail(context, center),
        onGateTap: (gate) => _showGateDetail(context, gate),
        onChannelTap: (channel) => _showChannelDetail(context, channel),
      ),
    );
  }

  void _showGateDetail(BuildContext context, int gateNumber) {
    final gateInfo = gates[gateNumber];
    if (gateInfo == null) return;

    DetailBottomSheet.show(
      context: context,
      title: 'Gate $gateNumber',
      subtitle: gateInfo.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            label: 'Center',
            value: gateInfo.center.displayName,
          ),
          const Divider(),
          _DetailRow(
            label: 'Keynote',
            value: gateInfo.keynote,
          ),
        ],
      ),
    );
  }

  void _showCenterDetail(BuildContext context, HumanDesignCenter center) {
    DetailBottomSheet.show(
      context: context,
      title: center.displayName,
      subtitle: widget.chart.isCenterDefined(center) ? 'Defined' : 'Undefined',
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.chart.isCenterDefined(center)
              ? AppColors.centerDefined
              : AppColors.centerUndefined,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.chart.isCenterDefined(center)
                ? AppColors.centerDefinedBorder
                : AppColors.centerUndefinedBorder,
            width: 2,
          ),
        ),
        child: const Icon(Icons.circle, size: 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            center.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'The ${center.displayName} center relates to ${center.description.toLowerCase()}.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
        ],
      ),
    );
  }

  void _showChannelDetail(BuildContext context, String channelId) {
    final parts = channelId.split('-');
    if (parts.length != 2) return;

    final gate1 = int.tryParse(parts[0]);
    final gate2 = int.tryParse(parts[1]);
    if (gate1 == null || gate2 == null) return;

    final gate1Info = gates[gate1];
    final gate2Info = gates[gate2];

    DetailBottomSheet.show(
      context: context,
      title: 'Channel $channelId',
      subtitle:
          '${gate1Info?.name ?? 'Gate $gate1'} - ${gate2Info?.name ?? 'Gate $gate2'}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChannelGateRow(gateNumber: gate1, gateInfo: gate1Info),
          const SizedBox(height: 16),
          const Center(
            child: Icon(Icons.swap_vert, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          _ChannelGateRow(gateNumber: gate2, gateInfo: gate2Info),
        ],
      ),
    );
  }
}

class _PlanetsTab extends StatelessWidget {
  const _PlanetsTab({required this.chart});

  final HumanDesignChart chart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showNames = constraints.maxWidth >= 500;
        final panelWidth = showNames ? 160.0 : 120.0;

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Design Panel (LEFT) - Unconscious
                SizedBox(
                  width: panelWidth,
                  child: PlanetaryPanel(
                    isPersonality: false,
                    activations: chart.unconsciousActivations,
                    showNames: showNames,
                    onGateTap: (gate) => _showGateDetail(context, gate),
                  ),
                ),
                const SizedBox(width: 24),
                // Personality Panel (RIGHT) - Conscious
                SizedBox(
                  width: panelWidth,
                  child: PlanetaryPanel(
                    isPersonality: true,
                    activations: chart.consciousActivations,
                    showNames: showNames,
                    onGateTap: (gate) => _showGateDetail(context, gate),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGateDetail(BuildContext context, int gateNumber) {
    final gateInfo = gates[gateNumber];
    if (gateInfo == null) return;

    DetailBottomSheet.show(
      context: context,
      title: 'Gate $gateNumber',
      subtitle: gateInfo.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            label: 'Center',
            value: gateInfo.center.displayName,
          ),
          const Divider(),
          _DetailRow(
            label: 'Keynote',
            value: gateInfo.keynote,
          ),
        ],
      ),
    );
  }
}

class _PropertiesTab extends StatelessWidget {
  const _PropertiesTab({required this.chart});

  final HumanDesignChart chart;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _PropertyCard(
          title: 'Type',
          value: chart.type.displayName,
          icon: Icons.person_outline,
          description: _getTypeDescription(chart.type),
        ),
        const SizedBox(height: 12),
        _PropertyCard(
          title: 'Strategy',
          value: chart.strategy,
          icon: Icons.lightbulb_outline,
          description: 'Your strategy guides how you make decisions.',
        ),
        const SizedBox(height: 12),
        _PropertyCard(
          title: 'Authority',
          value: chart.authority.displayName,
          icon: Icons.favorite_outline,
          description: _getAuthorityDescription(chart.authority),
        ),
        const SizedBox(height: 12),
        _PropertyCard(
          title: 'Profile',
          value: chart.profile.notation,
          icon: Icons.face_outlined,
          description: chart.profile.name,
        ),
        const SizedBox(height: 12),
        _PropertyCard(
          title: 'Definition',
          value: chart.definition.displayName,
          icon: Icons.hub_outlined,
          description: _getDefinitionDescription(chart.definition),
        ),
      ],
    );
  }

  String _getTypeDescription(HumanDesignType type) {
    switch (type) {
      case HumanDesignType.manifestor:
        return 'Initiators who can make things happen. Strategy: Inform before acting.';
      case HumanDesignType.generator:
        return 'Builders with sustainable life force. Strategy: Wait to respond.';
      case HumanDesignType.manifestingGenerator:
        return 'Multi-passionate builders. Strategy: Wait to respond, then inform.';
      case HumanDesignType.projector:
        return 'Guides who see others clearly. Strategy: Wait for invitation.';
      case HumanDesignType.reflector:
        return 'Mirrors of community health. Strategy: Wait a lunar cycle.';
    }
  }

  String _getAuthorityDescription(Authority authority) {
    return authority.description;
  }

  String _getDefinitionDescription(Definition definition) {
    return definition.description;
  }
}

class _GatesTab extends StatelessWidget {
  const _GatesTab({required this.chart});

  final HumanDesignChart chart;

  @override
  Widget build(BuildContext context) {
    final consciousGates = chart.consciousGates.toList()..sort();
    final unconsciousGates = chart.unconsciousGates.toList()..sort();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Conscious Gates (${consciousGates.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Personality side - what you\'re aware of',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: consciousGates
              .map<Widget>((gate) => _GateChip(
                    gateNumber: gate,
                    isConscious: true,
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Unconscious Gates (${unconsciousGates.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Design side - what others see in you',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: unconsciousGates
              .map<Widget>((gate) => _GateChip(
                    gateNumber: gate,
                    isConscious: false,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ChannelsTab extends StatelessWidget {
  const _ChannelsTab({required this.chart});

  final HumanDesignChart chart;

  @override
  Widget build(BuildContext context) {
    final activeChannels = chart.activeChannels;

    if (activeChannels.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.link_off,
              size: 48,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No Active Channels',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Channels are formed when both gates are defined.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: activeChannels.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final channelActivation = activeChannels[index];
        final channel = channelActivation.channel;

        return _ChannelCard(
          channelId: channel.id,
          gate1: channel.gate1,
          gate2: channel.gate2,
          hasConscious: channelActivation.hasConscious,
          hasUnconscious: channelActivation.hasUnconscious,
        );
      },
    );
  }
}

class _ChakrasTab extends StatelessWidget {
  const _ChakrasTab({required this.chart});

  final HumanDesignChart chart;

  @override
  Widget build(BuildContext context) {
    final activatedCount = chakras
        .where((c) => c.isActivated(chart.definedCenters))
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.chakraCrown,
                          AppColors.chakraThirdEye,
                          AppColors.chakraThroat,
                          AppColors.chakraHeart,
                          AppColors.chakraSolarPlexus,
                          AppColors.chakraSacral,
                          AppColors.chakraRoot,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chakra Energy',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$activatedCount of 7 chakras activated',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Chakra visualization
          SizedBox(
            height: 500,
            child: ChakraChartWidget(
              chart: chart,
              onChakraTap: (chakra) => _showChakraDetail(context, chakra),
            ),
          ),
          const SizedBox(height: 16),

          // Chakra list
          Text(
            'Chakra Details',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...chakras.reversed.map((chakra) {
            final isActivated = chakra.isActivated(chart.definedCenters);
            return _ChakraListItem(
              chakra: chakra,
              isActivated: isActivated,
              onTap: () => _showChakraDetail(context, chakra),
            );
          }),
        ],
      ),
    );
  }

  void _showChakraDetail(BuildContext context, Chakra chakra) {
    final isActivated = chakra.isActivated(chart.definedCenters);

    DetailBottomSheet.show(
      context: context,
      title: chakra.name,
      subtitle: chakra.sanskritName,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActivated ? chakra.color : chakra.color.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          boxShadow: isActivated
              ? [
                  BoxShadow(
                    color: chakra.color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActivated
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.textSecondaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isActivated ? 'Activated' : 'Inactive',
              style: TextStyle(
                color: isActivated ? AppColors.success : AppColors.textSecondaryLight,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            chakra.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Divider(height: 24),
          _DetailRow(label: 'Element', value: chakra.element),
          _DetailRow(label: 'Location', value: chakra.location),
          _DetailRow(
            label: 'HD Centers',
            value: chakra.hdCenters.map((c) => c.displayName).join(', '),
          ),
        ],
      ),
    );
  }
}

class _ChakraListItem extends StatelessWidget {
  const _ChakraListItem({
    required this.chakra,
    required this.isActivated,
    this.onTap,
  });

  final Chakra chakra;
  final bool isActivated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActivated ? chakra.color : chakra.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActivated ? chakra.color : AppColors.dividerLight,
                    width: 2,
                  ),
                  boxShadow: isActivated
                      ? [
                          BoxShadow(
                            color: chakra.color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chakra.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isActivated
                                ? AppColors.textPrimaryLight
                                : AppColors.textSecondaryLight,
                          ),
                    ),
                    Text(
                      chakra.hdCenters.map((c) => c.displayName).join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                isActivated ? Icons.check_circle : Icons.circle_outlined,
                color: isActivated ? AppColors.success : AppColors.textSecondaryLight,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

class _ChannelGateRow extends StatelessWidget {
  const _ChannelGateRow({required this.gateNumber, this.gateInfo});

  final int gateNumber;
  final GateData? gateInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$gateNumber',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gateInfo?.name ?? 'Gate $gateNumber',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  gateInfo?.keynote ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.title,
    required this.value,
    required this.icon,
    this.description,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GateChip extends StatelessWidget {
  const _GateChip({
    required this.gateNumber,
    required this.isConscious,
  });

  final int gateNumber;
  final bool isConscious;

  @override
  Widget build(BuildContext context) {
    final gateInfo = gates[gateNumber];

    return Tooltip(
      message: gateInfo?.name ?? 'Gate $gateNumber',
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor:
              isConscious ? AppColors.conscious : AppColors.unconscious,
          child: Text(
            '$gateNumber',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        label: Text(
          gateInfo?.name ?? 'Gate $gateNumber',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        backgroundColor:
            (isConscious ? AppColors.conscious : AppColors.unconscious)
                .withAlpha(25),
      ),
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.channelId,
    required this.gate1,
    required this.gate2,
    required this.hasConscious,
    required this.hasUnconscious,
  });

  final String channelId;
  final int gate1;
  final int gate2;
  final bool hasConscious;
  final bool hasUnconscious;

  @override
  Widget build(BuildContext context) {
    final gate1Info = gates[gate1];
    final gate2Info = gates[gate2];

    Color channelColor;
    String activationType;

    if (hasConscious && hasUnconscious) {
      channelColor = AppColors.channelBoth;
      activationType = 'Both';
    } else if (hasConscious) {
      channelColor = AppColors.channelConscious;
      activationType = 'Conscious';
    } else {
      channelColor = AppColors.channelUnconscious;
      activationType = 'Unconscious';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: channelColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    channelId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: channelColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    activationType,
                    style: TextStyle(
                      color: channelColor,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${gate1Info?.name ?? 'Gate $gate1'} ↔ ${gate2Info?.name ?? 'Gate $gate2'}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Connects ${gate1Info?.center.displayName ?? 'Unknown'} to ${gate2Info?.center.displayName ?? 'Unknown'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
