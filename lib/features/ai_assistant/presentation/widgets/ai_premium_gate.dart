import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../subscription/domain/models/subscription.dart';
import '../../../subscription/domain/subscription_providers.dart';
import '../../domain/models/ai_usage.dart';

/// Paywall overlay shown when free AI messages are exhausted.
/// Shows message pack options and a subscription CTA.
class AiPremiumGate extends ConsumerWidget {
  const AiPremiumGate({
    super.key,
    required this.usage,
    this.onDismiss,
  });

  final AiUsage usage;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final packsAsync = ref.watch(messagePacksProvider);
    final subscriptionState = ref.watch(subscriptionNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dismiss button
          if (onDismiss != null)
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          // Title
          Text(
            l10n.ai_wantMoreInsights,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Message pack cards
          packsAsync.when(
            data: (packs) => _MessagePackRow(
              packs: packs,
              isLoading: subscriptionState.isLoading,
              onPurchase: (pack) => _purchasePack(ref, context, pack),
            ),
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => _MessagePackRow(
              packs: defaultMessagePacks.toList(),
              isLoading: subscriptionState.isLoading,
              onPurchase: (pack) => _purchasePack(ref, context, pack),
            ),
          ),

          const SizedBox(height: 16),

          // Divider with "or"
          Row(
            children: [
              Expanded(child: Divider(color: Theme.of(context).dividerColor)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l10n.ai_orSubscribe,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                ),
              ),
              Expanded(child: Divider(color: Theme.of(context).dividerColor)),
            ],
          ),

          const SizedBox(height: 16),

          // Subscribe button with "Best value" badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.premium),
                  icon: const Icon(Icons.star_rounded, size: 18),
                  label: Text(l10n.premium_upgrade),
                ),
              ),
              Positioned(
                top: -8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.ai_bestValue,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
            ],
          ),

          // Error message
          if (subscriptionState.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                subscriptionState.error!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
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
    }
  }
}

/// Row of message pack cards
class _MessagePackRow extends StatelessWidget {
  const _MessagePackRow({
    required this.packs,
    required this.isLoading,
    required this.onPurchase,
  });

  final List<MessagePack> packs;
  final bool isLoading;
  final void Function(MessagePack) onPurchase;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: packs.map((pack) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _MessagePackCard(
              pack: pack,
              isLoading: isLoading,
              onTap: () => onPurchase(pack),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Individual message pack card
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
