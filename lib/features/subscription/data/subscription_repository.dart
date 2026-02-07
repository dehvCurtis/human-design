import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';
import '../../../main.dart' show revenueCatConfigured;
import '../domain/models/subscription.dart';

/// Repository for subscription operations using RevenueCat
class SubscriptionRepository {
  SubscriptionRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  /// Get current user's subscription status from RevenueCat
  Future<Subscription> getSubscription() async {
    final userId = _currentUserId;
    if (userId == null) return Subscription.free('');

    // Skip RevenueCat if not configured to avoid Swift-level fatal error
    if (!revenueCatConfigured) {
      return _getSubscriptionFromSupabase(userId);
    }

    try {
      // Get customer info from RevenueCat
      final customerInfo = await Purchases.getCustomerInfo();

      // Check for premium entitlement
      final hasPremium = customerInfo.entitlements.active
          .containsKey(AppConfig.premiumEntitlementId);

      if (hasPremium) {
        final entitlement =
            customerInfo.entitlements.active[AppConfig.premiumEntitlementId]!;

        // Determine tier from product identifier
        final tier = _getTierFromProductId(entitlement.productIdentifier);

        return Subscription(
          userId: userId,
          tier: tier,
          status: _getStatusFromEntitlement(entitlement),
          currentPeriodStart: DateTime.parse(entitlement.originalPurchaseDate),
          currentPeriodEnd: entitlement.expirationDate != null
              ? DateTime.parse(entitlement.expirationDate!)
              : null,
          isTrial: entitlement.periodType == PeriodType.trial,
          autoRenew: entitlement.willRenew,
        );
      }

      return Subscription.free(userId);
    } catch (e) {
      debugPrint('Failed to get subscription from RevenueCat: $e');
      // Fallback to checking Supabase
      return _getSubscriptionFromSupabase(userId);
    }
  }

  /// Fallback: Check Supabase for premium status
  Future<Subscription> _getSubscriptionFromSupabase(String userId) async {
    try {
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
        return Subscription(
          userId: userId,
          tier: SubscriptionTier.yearly,
          status: SubscriptionStatus.active,
        );
      }

      return Subscription.free(userId);
    } catch (e) {
      debugPrint('Failed to get subscription from Supabase: $e');
      return Subscription.free(userId);
    }
  }

  /// Check if user has premium access
  Future<bool> isPremium() async {
    final subscription = await getSubscription();
    return subscription.isPremium;
  }

  /// Get available subscription offers from RevenueCat
  Future<List<SubscriptionOffer>> getOffers() async {
    if (!revenueCatConfigured) return _getDefaultOffers();

    try {
      final offerings = await Purchases.getOfferings();

      if (offerings.current == null) {
        debugPrint('No current offering available');
        return _getDefaultOffers();
      }

      final packages = offerings.current!.availablePackages;
      final offers = <SubscriptionOffer>[];

      for (final package in packages) {
        final product = package.storeProduct;
        final tier = _getTierFromPackageType(package.packageType);

        if (tier == SubscriptionTier.free) continue;

        // Calculate price per month
        double pricePerMonth = product.price;
        if (tier == SubscriptionTier.yearly) {
          pricePerMonth = product.price / 12;
        }

        // Calculate savings for yearly
        int? savings;
        if (tier == SubscriptionTier.yearly) {
          final monthlyPackage = packages
              .where((p) => p.packageType == PackageType.monthly)
              .firstOrNull;
          if (monthlyPackage != null) {
            final yearlyEquivalent = monthlyPackage.storeProduct.price * 12;
            savings =
                ((yearlyEquivalent - product.price) / yearlyEquivalent * 100)
                    .round();
          }
        }

        // Get intro offer (trial) info
        int? trialDays;
        final introPrice = product.introductoryPrice;
        if (introPrice != null && introPrice.price == 0) {
          // Free trial - use periodUnit and periodNumberOfUnits
          final periodUnit = introPrice.periodUnit;
          final periodValue = introPrice.periodNumberOfUnits;
          if (periodUnit == PeriodUnit.day) {
            trialDays = periodValue;
          } else if (periodUnit == PeriodUnit.week) {
            trialDays = periodValue * 7;
          } else if (periodUnit == PeriodUnit.month) {
            trialDays = periodValue * 30;
          }
        }

        offers.add(SubscriptionOffer(
          tier: tier,
          price: product.price,
          pricePerMonth: double.parse(pricePerMonth.toStringAsFixed(2)),
          currency: product.currencyCode,
          trialDays: trialDays,
          savings: savings,
        ));
      }

      // Sort: yearly first
      offers.sort((a, b) => b.tier.index.compareTo(a.tier.index));

      return offers.isEmpty ? _getDefaultOffers() : offers;
    } catch (e) {
      debugPrint('Failed to get offerings from RevenueCat: $e');
      return _getDefaultOffers();
    }
  }

  /// Default offers when RevenueCat is unavailable
  List<SubscriptionOffer> _getDefaultOffers() {
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

  /// Purchase a subscription via RevenueCat
  Future<bool> purchaseSubscription(SubscriptionTier tier) async {
    final userId = _currentUserId;
    if (userId == null) return false;
    if (!revenueCatConfigured) return false;

    try {
      // Get offerings
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        debugPrint('No offerings available');
        return false;
      }

      // Find the package for the requested tier
      Package? package;
      for (final p in offerings.current!.availablePackages) {
        if (_getTierFromPackageType(p.packageType) == tier) {
          package = p;
          break;
        }
      }

      if (package == null) {
        debugPrint('Package not found for tier: $tier');
        return false;
      }

      // Make purchase using PurchaseParams (SDK v9.x+)
      final result = await Purchases.purchase(PurchaseParams.package(package));

      // Check if premium entitlement is now active
      final hasPremium = result.customerInfo.entitlements.active
          .containsKey(AppConfig.premiumEntitlementId);

      if (hasPremium) {
        // Update Supabase to sync premium status
        await updatePremiumStatus(true);
        return true;
      }

      return false;
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('Purchase cancelled by user');
      } else {
        debugPrint('Purchase error: $e');
      }
      return false;
    } catch (e) {
      debugPrint('Purchase failed: $e');
      return false;
    }
  }

  /// Restore previous purchases via RevenueCat
  Future<bool> restorePurchases() async {
    final userId = _currentUserId;
    if (userId == null) return false;
    if (!revenueCatConfigured) return false;

    try {
      final customerInfo = await Purchases.restorePurchases();

      // Check if premium entitlement is active
      final hasPremium = customerInfo.entitlements.active
          .containsKey(AppConfig.premiumEntitlementId);

      if (hasPremium) {
        // Sync to Supabase
        await updatePremiumStatus(true);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Restore purchases failed: $e');
      return false;
    }
  }

  /// Update premium status in Supabase database
  /// This keeps Supabase in sync with RevenueCat entitlements
  Future<void> updatePremiumStatus(bool isPremium) async {
    final userId = _currentUserId;
    if (userId == null) return;

    try {
      await _client
          .from('profiles')
          .update({'is_premium': isPremium}).eq('id', userId);
    } catch (e) {
      debugPrint('Failed to update premium status: $e');
    }
  }

  /// Check share limit for free users
  Future<({int used, int limit, bool canShare})> checkShareLimit() async {
    final userId = _currentUserId;
    if (userId == null) {
      return (used: 0, limit: AppConfig.freeSharesPerMonth, canShare: false);
    }

    final subscription = await getSubscription();
    if (subscription.isPremium) {
      return (used: 0, limit: -1, canShare: true); // Unlimited
    }

    // Count shares this month
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    try {
      final response = await _client
          .from('shares')
          .select('id')
          .eq('shared_by_user_id', userId)
          .gte('created_at', monthStart.toIso8601String());

      final shareCount = (response as List).length;

      return (
        used: shareCount,
        limit: AppConfig.freeSharesPerMonth,
        canShare: shareCount < AppConfig.freeSharesPerMonth,
      );
    } catch (e) {
      debugPrint('Failed to check share limit: $e');
      return (
        used: 0,
        limit: AppConfig.freeSharesPerMonth,
        canShare: true
      );
    }
  }

  /// Login user to RevenueCat (call after Supabase auth)
  Future<void> loginToRevenueCat(String userId) async {
    if (!revenueCatConfigured) return;
    try {
      await Purchases.logIn(userId);
      debugPrint('Logged into RevenueCat with user: $userId');
    } catch (e) {
      debugPrint('RevenueCat login failed: $e');
    }
  }

  /// Logout from RevenueCat (call on Supabase signout)
  Future<void> logoutFromRevenueCat() async {
    if (!revenueCatConfigured) return;
    try {
      await Purchases.logOut();
      debugPrint('Logged out of RevenueCat');
    } catch (e) {
      debugPrint('RevenueCat logout failed: $e');
    }
  }

  /// Convert RevenueCat package type to SubscriptionTier
  SubscriptionTier _getTierFromPackageType(PackageType type) {
    switch (type) {
      case PackageType.monthly:
        return SubscriptionTier.monthly;
      case PackageType.annual:
        return SubscriptionTier.yearly;
      default:
        return SubscriptionTier.free;
    }
  }

  /// Convert product ID to SubscriptionTier
  SubscriptionTier _getTierFromProductId(String productId) {
    if (productId.contains('yearly') || productId.contains('annual')) {
      return SubscriptionTier.yearly;
    }
    if (productId.contains('monthly')) {
      return SubscriptionTier.monthly;
    }
    return SubscriptionTier.yearly; // Default to yearly for premium
  }

  /// Convert RevenueCat entitlement to SubscriptionStatus
  SubscriptionStatus _getStatusFromEntitlement(EntitlementInfo entitlement) {
    if (!entitlement.isActive) {
      return SubscriptionStatus.expired;
    }
    if (entitlement.periodType == PeriodType.trial) {
      return SubscriptionStatus.trialing;
    }
    return SubscriptionStatus.active;
  }
}
