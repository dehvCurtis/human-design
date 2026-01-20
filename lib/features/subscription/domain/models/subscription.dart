/// Subscription status enum
enum SubscriptionStatus {
  active,
  trialing,
  paused,
  expired,
  canceled,
  none;

  bool get isActive => this == active || this == trialing;
}

/// Subscription product tier
enum SubscriptionTier {
  free,
  monthly,
  yearly;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.monthly:
        return 'Monthly';
      case SubscriptionTier.yearly:
        return 'Yearly';
    }
  }

  String get productId {
    switch (this) {
      case SubscriptionTier.free:
        return '';
      case SubscriptionTier.monthly:
        return 'premium_monthly';
      case SubscriptionTier.yearly:
        return 'premium_yearly';
    }
  }
}

/// User subscription information
class Subscription {
  const Subscription({
    required this.userId,
    required this.tier,
    required this.status,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.isTrial = false,
    this.trialEndDate,
    this.autoRenew = true,
  });

  final String userId;
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final bool isTrial;
  final DateTime? trialEndDate;
  final bool autoRenew;

  bool get isPremium => status.isActive && tier != SubscriptionTier.free;

  int? get daysRemaining {
    if (currentPeriodEnd == null) return null;
    final diff = currentPeriodEnd!.difference(DateTime.now());
    return diff.isNegative ? 0 : diff.inDays;
  }

  factory Subscription.free(String userId) => Subscription(
        userId: userId,
        tier: SubscriptionTier.free,
        status: SubscriptionStatus.none,
      );

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      userId: json['user_id'] as String,
      tier: SubscriptionTier.values.firstWhere(
        (t) => t.productId == json['product_id'],
        orElse: () => SubscriptionTier.free,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => SubscriptionStatus.none,
      ),
      currentPeriodStart: json['current_period_start'] != null
          ? DateTime.parse(json['current_period_start'] as String)
          : null,
      currentPeriodEnd: json['current_period_end'] != null
          ? DateTime.parse(json['current_period_end'] as String)
          : null,
      isTrial: json['is_trial'] as bool? ?? false,
      trialEndDate: json['trial_end_date'] != null
          ? DateTime.parse(json['trial_end_date'] as String)
          : null,
      autoRenew: json['auto_renew_status'] as bool? ?? true,
    );
  }
}

/// Subscription offer/product for display
class SubscriptionOffer {
  const SubscriptionOffer({
    required this.tier,
    required this.price,
    required this.pricePerMonth,
    required this.currency,
    this.trialDays,
    this.savings,
  });

  final SubscriptionTier tier;
  final double price;
  final double pricePerMonth;
  final String currency;
  final int? trialDays;
  final int? savings; // Percentage savings compared to monthly

  String get formattedPrice => '\$$price';
  String get formattedPricePerMonth => '\$$pricePerMonth/mo';
}

/// Premium features list
class PremiumFeature {
  const PremiumFeature({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;
}

/// Predefined premium features
const premiumFeatures = [
  PremiumFeature(
    title: 'Unlimited Chart Sharing',
    description: 'Share your chart with unlimited friends and groups',
    icon: 'share',
  ),
  PremiumFeature(
    title: 'Group Charts',
    description: 'Create and analyze Penta charts for groups',
    icon: 'groups',
  ),
  PremiumFeature(
    title: 'Advanced Transit Analysis',
    description: 'Detailed transit impact predictions and insights',
    icon: 'analytics',
  ),
  PremiumFeature(
    title: 'Personalized Affirmations',
    description: 'Daily affirmations tailored to your specific design',
    icon: 'lightbulb',
  ),
  PremiumFeature(
    title: 'Premium Learning Content',
    description: 'Access exclusive Human Design courses and guides',
    icon: 'school',
  ),
  PremiumFeature(
    title: 'Priority Support',
    description: 'Get help faster with priority customer support',
    icon: 'support_agent',
  ),
];
