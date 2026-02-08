import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../../ai_assistant/domain/ai_providers.dart';
import '../data/subscription_repository.dart';
import 'models/subscription.dart';

/// Provider for the SubscriptionRepository
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for current subscription status
final subscriptionProvider = FutureProvider<Subscription>((ref) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.getSubscription();
});

/// Provider for checking if user is premium
final isPremiumProvider = FutureProvider<bool>((ref) async {
  final subscription = await ref.watch(subscriptionProvider.future);
  return subscription.isPremium;
});

/// Provider for available subscription offers
final subscriptionOffersProvider = FutureProvider<List<SubscriptionOffer>>((ref) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.getOffers();
});

/// Provider for share limit status
final shareLimitProvider = FutureProvider<({int used, int limit, bool canShare})>((ref) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.checkShareLimit();
});

/// Provider for available message packs
final messagePacksProvider = FutureProvider<List<MessagePack>>((ref) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.getMessagePacks();
});

/// Notifier for subscription actions
class SubscriptionNotifier extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() => const SubscriptionState();

  SubscriptionRepository get _repository => ref.read(subscriptionRepositoryProvider);

  /// Purchase a subscription
  Future<bool> purchase(SubscriptionTier tier) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _repository.purchaseSubscription(tier);

      if (success) {
        ref.invalidate(subscriptionProvider);
        ref.invalidate(isPremiumProvider);
        ref.invalidate(shareLimitProvider);
        state = state.copyWith(isLoading: false, purchaseSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Purchase failed. Please try again.',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
      return false;
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _repository.restorePurchases();

      if (success) {
        ref.invalidate(subscriptionProvider);
        ref.invalidate(isPremiumProvider);
        state = state.copyWith(isLoading: false, restoreSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'No previous purchases found.',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
      return false;
    }
  }

  /// Purchase a message pack (consumable)
  Future<bool> purchaseMessagePack(MessagePack pack) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _repository.purchaseMessagePack(pack);

      if (success) {
        // Credit bonus messages via AI repository
        final aiRepo = ref.read(aiRepositoryProvider);
        await aiRepo.addBonusMessages(pack.messageCount);

        // Refresh usage and packs
        ref.invalidate(aiUsageProvider);
        state = state.copyWith(isLoading: false, purchaseSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Purchase was not completed.',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
      return false;
    }
  }

  void clearState() {
    state = const SubscriptionState();
  }
}

final subscriptionNotifierProvider = NotifierProvider<SubscriptionNotifier, SubscriptionState>(() {
  return SubscriptionNotifier();
});

/// State class for subscription UI
class SubscriptionState {
  const SubscriptionState({
    this.isLoading = false,
    this.error,
    this.purchaseSuccess = false,
    this.restoreSuccess = false,
  });

  final bool isLoading;
  final String? error;
  final bool purchaseSuccess;
  final bool restoreSuccess;

  SubscriptionState copyWith({
    bool? isLoading,
    String? error,
    bool? purchaseSuccess,
    bool? restoreSuccess,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      purchaseSuccess: purchaseSuccess ?? this.purchaseSuccess,
      restoreSuccess: restoreSuccess ?? this.restoreSuccess,
    );
  }
}
