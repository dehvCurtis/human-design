// Models for Sharing & Export features

enum ShareFormat {
  png,
  pdf,
  link,
}

enum CardVariant {
  bodygraph,
  summary,
  transitOverlay,
  compatibility,
}

class ChartShareCard {
  const ChartShareCard({
    required this.variant,
    required this.title,
    required this.chartData,
    this.transitData,
    this.otherChartData,
    this.backgroundColor,
    this.primaryColor,
    this.showWatermark = true,
  });

  final CardVariant variant;
  final String title;
  final ChartSummaryData chartData;
  final TransitSummaryData? transitData;
  final ChartSummaryData? otherChartData; // For compatibility
  final String? backgroundColor;
  final String? primaryColor;
  final bool showWatermark;
}

class ChartSummaryData {
  const ChartSummaryData({
    required this.name,
    required this.type,
    required this.profile,
    required this.authority,
    required this.definition,
    required this.definedCenters,
    required this.consciousGates,
    required this.unconsciousGates,
    this.incarnationCross,
    this.strategy,
    this.notSelfTheme,
    this.signature,
  });

  final String name;
  final String type;
  final String profile;
  final String authority;
  final String definition;
  final List<String> definedCenters;
  final List<int> consciousGates;
  final List<int> unconsciousGates;
  final String? incarnationCross;
  final String? strategy;
  final String? notSelfTheme;
  final String? signature;

  List<int> get allGates =>
      {...consciousGates, ...unconsciousGates}.toList()..sort();

  factory ChartSummaryData.fromJson(Map<String, dynamic> json) {
    return ChartSummaryData(
      name: json['name'] as String,
      type: json['type'] as String,
      profile: json['profile'] as String,
      authority: json['authority'] as String,
      definition: json['definition'] as String,
      definedCenters: (json['defined_centers'] as List<dynamic>).cast<String>(),
      consciousGates: (json['conscious_gates'] as List<dynamic>).cast<int>(),
      unconsciousGates: (json['unconscious_gates'] as List<dynamic>).cast<int>(),
      incarnationCross: json['incarnation_cross'] as String?,
      strategy: json['strategy'] as String?,
      notSelfTheme: json['not_self_theme'] as String?,
      signature: json['signature'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'profile': profile,
      'authority': authority,
      'definition': definition,
      'defined_centers': definedCenters,
      'conscious_gates': consciousGates,
      'unconscious_gates': unconsciousGates,
      'incarnation_cross': incarnationCross,
      'strategy': strategy,
      'not_self_theme': notSelfTheme,
      'signature': signature,
    };
  }
}

class TransitSummaryData {
  const TransitSummaryData({
    required this.date,
    required this.sunGate,
    required this.earthGate,
    required this.moonGate,
    this.allPlanetaryGates,
    this.activeTransitChannels,
    this.gateKeywords,
  });

  final DateTime date;
  final int sunGate;
  final int earthGate;
  final int moonGate;
  final Map<String, int>? allPlanetaryGates;
  final List<String>? activeTransitChannels;
  final Map<int, String>? gateKeywords;

  factory TransitSummaryData.fromJson(Map<String, dynamic> json) {
    return TransitSummaryData(
      date: DateTime.parse(json['date'] as String),
      sunGate: json['sun_gate'] as int,
      earthGate: json['earth_gate'] as int,
      moonGate: json['moon_gate'] as int,
      allPlanetaryGates: (json['all_planetary_gates'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)),
      activeTransitChannels: (json['active_transit_channels'] as List<dynamic>?)
          ?.cast<String>(),
      gateKeywords: (json['gate_keywords'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(int.parse(k), v as String)),
    );
  }
}

class CompatibilityReport {
  const CompatibilityReport({
    required this.person1,
    required this.person2,
    required this.overallScore,
    required this.typeCompatibility,
    required this.profileHarmonics,
    required this.electromagneticChannels,
    required this.companionshipChannels,
    required this.dominanceChannels,
    required this.compromiseChannels,
    required this.bridgingCenters,
    required this.insights,
    required this.challenges,
    required this.strengths,
  });

  final ChartSummaryData person1;
  final ChartSummaryData person2;
  final int overallScore;
  final TypeCompatibilitySection typeCompatibility;
  final ProfileHarmonicsSection profileHarmonics;
  final List<String> electromagneticChannels;
  final List<String> companionshipChannels;
  final List<String> dominanceChannels;
  final List<String> compromiseChannels;
  final List<CenterBridge> bridgingCenters;
  final List<String> insights;
  final List<String> challenges;
  final List<String> strengths;
}

class TypeCompatibilitySection {
  const TypeCompatibilitySection({
    required this.score,
    required this.description,
    required this.dynamics,
  });

  final int score;
  final String description;
  final String dynamics;
}

class ProfileHarmonicsSection {
  const ProfileHarmonicsSection({
    required this.score,
    required this.description,
    required this.sharedLines,
    required this.complementaryLines,
  });

  final int score;
  final String description;
  final List<int> sharedLines;
  final List<int> complementaryLines;
}

class CenterBridge {
  const CenterBridge({
    required this.centerName,
    required this.person1Defined,
    required this.person2Defined,
    required this.impact,
  });

  final String centerName;
  final bool person1Defined;
  final bool person2Defined;
  final String impact;
}

class TransitShareCard {
  const TransitShareCard({
    required this.transit,
    required this.personalActivations,
    this.insightText,
    this.backgroundColor,
    this.showPersonalOverlay = true,
  });

  final TransitSummaryData transit;
  final List<int> personalActivations;
  final String? insightText;
  final String? backgroundColor;
  final bool showPersonalOverlay;
}

class SharedLink {
  const SharedLink({
    required this.id,
    required this.token,
    required this.url,
    required this.contentType,
    this.contentId,
    this.expiresAt,
    required this.createdAt,
    this.viewCount = 0,
  });

  final String id;
  final String token;
  final String url;
  final String contentType; // 'chart', 'transit', 'compatibility'
  final String? contentId;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final int viewCount;

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory SharedLink.fromJson(Map<String, dynamic> json) {
    return SharedLink(
      id: json['id'] as String,
      token: json['share_token'] as String,
      url: 'https://humandesign.app/share/${json['share_token']}',
      contentType: json['share_type'] as String,
      contentId: json['chart_id'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      viewCount: json['view_count'] as int? ?? 0,
    );
  }
}
