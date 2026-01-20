import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/subscription.dart';

/// Repository for subscription operations
/// Note: Full RevenueCat integration would require additional setup.
/// This provides the core data layer with mock functionality for development.
class SubscriptionRepository {
  SubscriptionRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  /// Get current user's subscription status
  Future<Subscription> getSubscription() async {
    final userId = _currentUserId;
    if (userId == null) return Subscription.free('');

    // Check profiles table for is_premium flag
    final response = await _client
        .from('profiles')
        .select('is_premium')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      return Subscription.free(userId);
    }

    final isPremium = response['is_premium'] as bool? ?? false;

    if (isPremium) {
      // For now, return a simple premium subscription
      // In production, this would query the subscriptions table
      return Subscription(
        userId: userId,
        tier: SubscriptionTier.yearly,
        status: SubscriptionStatus.active,
      );
    }

    return Subscription.free(userId);
  }

  /// Check if user has premium access
  Future<bool> isPremium() async {
    final subscription = await getSubscription();
    return subscription.isPremium;
  }

  /// Get available subscription offers
  /// In production, this would fetch from RevenueCat
  Future<List<SubscriptionOffer>> getOffers() async {
    // Mock offers - replace with RevenueCat offerings in production
    return const [
      SubscriptionOffer(
        tier: SubscriptionTier.monthly,
        price: 9.99,
        pricePerMonth: 9.99,
        currency: 'USD',
        trialDays: 7,
      ),
      SubscriptionOffer(
        tier: SubscriptionTier.yearly,
        price: 79.99,
        pricePerMonth: 6.67,
        currency: 'USD',
        trialDays: 7,
        savings: 33,
      ),
    ];
  }

  /// Purchase subscription (mock - would integrate with RevenueCat)
  Future<bool> purchaseSubscription(SubscriptionTier tier) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    // In production, this would:
    // 1. Call RevenueCat to initiate purchase
    // 2. RevenueCat webhook would update Supabase
    // 3. Return success/failure

    // For development, directly update the profile
    try {
      await _client
          .from('profiles')
          .update({'is_premium': true})
          .eq('id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Restore purchases (mock - would integrate with RevenueCat)
  Future<bool> restorePurchases() async {
    final userId = _currentUserId;
    if (userId == null) return false;

    // In production, this would:
    // 1. Call RevenueCat.restorePurchases()
    // 2. Check entitlements
    // 3. Update Supabase if premium found

    // For development, check if is_premium was previously set
    final response = await _client
        .from('profiles')
        .select('is_premium')
        .eq('id', userId)
        .maybeSingle();

    return response?['is_premium'] as bool? ?? false;
  }

  /// Update premium status in database
  Future<void> updatePremiumStatus(bool isPremium) async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _client
        .from('profiles')
        .update({'is_premium': isPremium})
        .eq('id', userId);
  }

  /// Check share limit for free users
  Future<({int used, int limit, bool canShare})> checkShareLimit() async {
    final userId = _currentUserId;
    if (userId == null) {
      return (used: 0, limit: 3, canShare: false);
    }

    final subscription = await getSubscription();
    if (subscription.isPremium) {
      return (used: 0, limit: -1, canShare: true); // Unlimited
    }

    // Count shares this month
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    final response = await _client
        .from('shares')
        .select('id')
        .eq('shared_by_user_id', userId)
        .gte('created_at', monthStart.toIso8601String());

    final shareCount = (response as List).length;
    const freeLimit = 3;

    return (
      used: shareCount,
      limit: freeLimit,
      canShare: shareCount < freeLimit,
    );
  }
}
