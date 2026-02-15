import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../ai_assistant/domain/ai_providers.dart';
import '../domain/models/subscription.dart';
import '../domain/subscription_providers.dart';

/// Premium subscription screen with paywall
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  SubscriptionTier _selectedTier = SubscriptionTier.yearly;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final offersAsync = ref.watch(subscriptionOffersProvider);
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    final currentSubscriptionAsync = ref.watch(subscriptionProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      Color(0xFF8B5CF6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.premium_upgrade,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.premium_features,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Current subscription status
                currentSubscriptionAsync.when(
                  data: (sub) {
                    if (sub.isPremium) {
                      return _buildCurrentSubscription(context, l10n, sub);
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),

                // Features list
                _buildFeaturesSection(context, l10n),

                const SizedBox(height: 24),

                // Pricing options
                offersAsync.when(
                  data: (offers) => _buildPricingSection(context, l10n, offers),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Text(l10n.common_error),
                ),

                const SizedBox(height: 24),

                // AI Message Packs
                _buildMessagePacksSection(context, l10n, ref, subscriptionState),

                const SizedBox(height: 24),

                // Error message
                if (subscriptionState.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subscriptionState.error!,
                      style: TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Subscribe button
                _buildSubscribeButton(context, l10n, subscriptionState),

                const SizedBox(height: 16),

                // Restore purchases
                TextButton(
                  onPressed: subscriptionState.isLoading
                      ? null
                      : () => _restorePurchases(context),
                  child: Text(l10n.premium_restore),
                ),

                const SizedBox(height: 16),

                // Terms
                Text(
                  'Subscription will automatically renew unless cancelled at least 24 hours before the end of the current period.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSubscription(
    BuildContext context,
    AppLocalizations l10n,
    Subscription subscription,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.premium_features,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                ),
                if (subscription.daysRemaining != null)
                  Text(
                    '${subscription.daysRemaining} days remaining',
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

  Widget _buildFeaturesSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.premium_features,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...premiumFeatures.map((feature) => _buildFeatureItem(context, feature)),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, PremiumFeature feature) {
    IconData icon;
    switch (feature.icon) {
      case 'share':
        icon = Icons.share;
      case 'groups':
        icon = Icons.groups;
      case 'analytics':
        icon = Icons.analytics;
      case 'lightbulb':
        icon = Icons.lightbulb;
      case 'school':
        icon = Icons.school;
      case 'support_agent':
        icon = Icons.support_agent;
      default:
        icon = Icons.check;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  feature.description,
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

  Widget _buildPricingSection(
    BuildContext context,
    AppLocalizations l10n,
    List<SubscriptionOffer> offers,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.premium_subscribe,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...offers.map((offer) => _buildPricingOption(context, l10n, offer)),
      ],
    );
  }

  Widget _buildPricingOption(
    BuildContext context,
    AppLocalizations l10n,
    SubscriptionOffer offer,
  ) {
    final isSelected = _selectedTier == offer.tier;
    final isYearly = offer.tier == SubscriptionTier.yearly;

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = offer.tier),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.dividerLight,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
        ),
        child: Row(
          children: [
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        offer.tier == SubscriptionTier.yearly
                            ? l10n.premium_yearly
                            : l10n.premium_monthly,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (isYearly && offer.savings != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${l10n.premium_bestValue} -${offer.savings}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    offer.formattedPricePerMonth,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                  if (offer.trialDays != null)
                    Text(
                      '${offer.trialDays}-day free trial',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                ],
              ),
            ),
            Text(
              offer.formattedPrice,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : null,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeButton(
    BuildContext context,
    AppLocalizations l10n,
    SubscriptionState state,
  ) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: state.isLoading ? null : () => _subscribe(context),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(l10n.premium_subscribe),
      ),
    );
  }

  Future<void> _subscribe(BuildContext context) async {
    final success = await ref
        .read(subscriptionNotifierProvider.notifier)
        .purchase(_selectedTier);

    if (success && mounted && context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.premium_features)),
      );
      context.pop();
    }
  }

  Widget _buildMessagePacksSection(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    SubscriptionState state,
  ) {
    final packsAsync = ref.watch(messagePacksProvider);
    final usageAsync = ref.watch(aiUsageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider with "or"
        Row(
          children: [
            Expanded(child: Divider(color: Theme.of(context).dividerColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                l10n.ai_orSubscribe,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
            ),
            Expanded(child: Divider(color: Theme.of(context).dividerColor)),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'AI Message Packs',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        usageAsync.when(
          data: (usage) => Text(
            usage.limit >= 999999
                ? 'You have unlimited AI messages'
                : '${usage.remaining} of ${usage.effectiveLimit} messages remaining this month',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        packsAsync.when(
          data: (packs) => Row(
            children: packs.map((pack) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _MessagePackCard(
                    pack: pack,
                    isLoading: state.isLoading,
                    onTap: () => _purchasePack(ref, context, pack),
                  ),
                ),
              );
            }).toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Row(
            children: defaultMessagePacks.map((pack) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _MessagePackCard(
                    pack: pack,
                    isLoading: state.isLoading,
                    onTap: () => _purchasePack(ref, context, pack),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _purchasePack(
    WidgetRef ref,
    BuildContext context,
    MessagePack pack,
  ) async {
    final notifier = ref.read(subscriptionNotifierProvider.notifier);
    final success = await notifier.purchaseMessagePack(pack);
    if (success && context.mounted) {
      ref.invalidate(messagePacksProvider);
      ref.invalidate(aiUsageProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${pack.messageCount} messages added!')),
      );
    }
  }

  Future<void> _restorePurchases(BuildContext context) async {
    final success = await ref
        .read(subscriptionNotifierProvider.notifier)
        .restorePurchases();

    if (mounted && context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.premium_restore),
        ),
      );
      if (success) {
        context.pop();
      }
    }
  }
}

class _MessagePackCard extends StatelessWidget {
  const _MessagePackCard({
    required this.pack,
    required this.isLoading,
    required this.onTap,
  });

  final MessagePack pack;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
            color: AppColors.primary.withValues(alpha: 0.05),
          ),
          child: Column(
            children: [
              Text(
                l10n.ai_messagesPackTitle(pack.messageCount),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                pack.formattedPrice,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.ai_perMessage(
                  '\$${pack.pricePerMessage.toStringAsFixed(2)}',
                ),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
