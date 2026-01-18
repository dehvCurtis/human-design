import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/sharing.dart';

/// Repository for sharing and export operations
class SharingRepository {
  SharingRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Share Links ====================

  /// Create a shareable link for a chart
  Future<SharedLink> createChartShareLink({
    required String chartId,
    Duration? expiresIn,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final token = _generateToken();
    final expiresAt = expiresIn != null
        ? DateTime.now().add(expiresIn).toIso8601String()
        : null;

    final response = await _client.from('shares').insert({
      'chart_id': chartId,
      'shared_by': userId,
      'share_type': 'link',
      'share_token': token,
      'expires_at': expiresAt,
    }).select().single();

    return SharedLink.fromJson(response);
  }

  /// Get chart by share token
  Future<ChartSummaryData?> getChartByShareToken(String token) async {
    final shareResponse = await _client
        .from('shares')
        .select('chart_id, expires_at')
        .eq('share_token', token)
        .maybeSingle();

    if (shareResponse == null) return null;

    // Check expiration
    if (shareResponse['expires_at'] != null) {
      final expiresAt = DateTime.parse(shareResponse['expires_at'] as String);
      if (DateTime.now().isAfter(expiresAt)) return null;
    }

    // Get chart data
    final chartId = shareResponse['chart_id'] as String;
    final chartResponse = await _client
        .from('charts')
        .select('*')
        .eq('id', chartId)
        .maybeSingle();

    if (chartResponse == null) return null;

    return ChartSummaryData(
      name: chartResponse['name'] as String,
      type: chartResponse['type'] as String,
      profile: chartResponse['profile'] as String,
      authority: chartResponse['authority'] as String,
      definition: chartResponse['definition'] as String,
      definedCenters: (chartResponse['defined_centers'] as List<dynamic>).cast<String>(),
      consciousGates: (chartResponse['conscious_gates'] as List<dynamic>).cast<int>(),
      unconsciousGates: (chartResponse['unconscious_gates'] as List<dynamic>).cast<int>(),
    );
  }

  /// Get user's share links
  Future<List<SharedLink>> getMyShareLinks() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('shares')
        .select('*')
        .eq('shared_by', userId)
        .eq('share_type', 'link')
        .order('created_at', ascending: false);

    return (response as List).map((json) => SharedLink.fromJson(json)).toList();
  }

  /// Revoke a share link
  Future<void> revokeShareLink(String shareId) async {
    await _client.from('shares').delete().eq('id', shareId);
  }

  /// Record share link view
  Future<void> recordShareView(String token) async {
    await _client.rpc('increment_share_view', params: {'share_token': token});
  }

  // ==================== Compatibility Reports ====================

  /// Generate compatibility report between two charts
  CompatibilityReport generateCompatibilityReport({
    required ChartSummaryData person1,
    required ChartSummaryData person2,
  }) {
    // Calculate type compatibility
    final typeCompat = _calculateTypeCompatibility(person1.type, person2.type);

    // Calculate profile harmonics
    final profileHarmonics = _calculateProfileHarmonics(
      person1.profile,
      person2.profile,
    );

    // Calculate channel interactions
    final channels = _calculateChannelInteractions(person1, person2);

    // Calculate center bridging
    final bridges = _calculateCenterBridging(person1, person2);

    // Calculate overall score
    final overallScore = (
      typeCompat.score +
      profileHarmonics.score +
      (channels.electromagnetic.length * 3).clamp(0, 25) +
      (bridges.where((b) => b.person1Defined != b.person2Defined).length * 2)
          .clamp(0, 25)
    ).clamp(0, 100);

    // Generate insights
    final insights = _generateInsights(person1, person2, channels, bridges);
    final challenges = _generateChallenges(person1, person2, channels);
    final strengths = _generateStrengths(person1, person2, channels);

    return CompatibilityReport(
      person1: person1,
      person2: person2,
      overallScore: overallScore,
      typeCompatibility: typeCompat,
      profileHarmonics: profileHarmonics,
      electromagneticChannels: channels.electromagnetic,
      companionshipChannels: channels.companionship,
      dominanceChannels: channels.dominance,
      compromiseChannels: channels.compromise,
      bridgingCenters: bridges,
      insights: insights,
      challenges: challenges,
      strengths: strengths,
    );
  }

  // ==================== Image Generation ====================

  /// Capture widget as image bytes
  Future<Uint8List?> captureWidgetAsImage(GlobalKey key, {double pixelRatio = 3.0}) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  // ==================== Helper Methods ====================

  String _generateToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var token = '';
    for (var i = 0; i < 12; i++) {
      token += chars[(random + i * 7) % chars.length];
    }
    return token;
  }

  TypeCompatibilitySection _calculateTypeCompatibility(String type1, String type2) {
    final compatibilityMap = {
      'Generator-Generator': (20, 'Mutual satisfaction', 'Sustainable energy exchange'),
      'Generator-Manifesting Generator': (22, 'Sacral resonance', 'Energy with spark'),
      'Generator-Projector': (23, 'Guidance potential', 'Recognition and direction'),
      'Generator-Manifestor': (18, 'Energy support', 'Needs clear communication'),
      'Generator-Reflector': (20, 'Health indicator', 'Mirrors Generator state'),
      'Manifesting Generator-Projector': (22, 'Efficient guidance', 'Multi-tasking optimization'),
      'Manifesting Generator-Manifestor': (19, 'Shared manifestation', 'Coordination needed'),
      'Manifesting Generator-Reflector': (20, 'Efficiency mirror', 'Shows true efficiency'),
      'Projector-Projector': (18, 'Mutual recognition', 'Limited energy exchange'),
      'Projector-Manifestor': (20, 'Guided initiation', 'When invited'),
      'Projector-Reflector': (19, 'Wisdom mirror', 'Reflects Projector wisdom'),
      'Manifestor-Manifestor': (16, 'Two initiators', 'Needs boundaries'),
      'Manifestor-Reflector': (18, 'Impact mirror', 'Shows action impact'),
      'Reflector-Reflector': (15, 'Rare mirror', 'Unique connection'),
    };

    final key1 = '$type1-$type2';
    final key2 = '$type2-$type1';
    final result = compatibilityMap[key1] ?? compatibilityMap[key2] ?? (15, 'Neutral', 'Unknown dynamic');

    return TypeCompatibilitySection(
      score: result.$1,
      description: result.$2,
      dynamics: result.$3,
    );
  }

  ProfileHarmonicsSection _calculateProfileHarmonics(String profile1, String profile2) {
    final lines1 = profile1.split('/').map(int.parse).toList();
    final lines2 = profile2.split('/').map(int.parse).toList();

    final shared = lines1.where((l) => lines2.contains(l)).toList();
    final complementary = <int>[];

    // Check for complementary dynamics
    if ((lines1.contains(1) || lines2.contains(1)) &&
        (lines1.contains(6) || lines2.contains(6))) {
      complementary.addAll([1, 6]);
    }
    if ((lines1.contains(2) || lines2.contains(2)) &&
        (lines1.contains(5) || lines2.contains(5))) {
      complementary.addAll([2, 5]);
    }
    if ((lines1.contains(3) || lines2.contains(3)) &&
        (lines1.contains(4) || lines2.contains(4))) {
      complementary.addAll([3, 4]);
    }

    final score = (shared.length * 5 + complementary.length * 3).clamp(5, 25);

    String description;
    if (shared.isNotEmpty && complementary.isNotEmpty) {
      description = 'Strong resonance with complementary growth';
    } else if (shared.isNotEmpty) {
      description = 'Shared line understanding (${shared.join(", ")})';
    } else if (complementary.isNotEmpty) {
      description = 'Complementary profile dynamic';
    } else {
      description = 'Different perspectives - learning opportunity';
    }

    return ProfileHarmonicsSection(
      score: score,
      description: description,
      sharedLines: shared,
      complementaryLines: complementary.toSet().toList(),
    );
  }

  ({
    List<String> electromagnetic,
    List<String> companionship,
    List<String> dominance,
    List<String> compromise,
  }) _calculateChannelInteractions(
    ChartSummaryData person1,
    ChartSummaryData person2,
  ) {
    final electromagnetic = <String>[];
    final companionship = <String>[];
    final dominance = <String>[];
    final compromise = <String>[];

    // Simplified channel analysis
    final gates1 = {...person1.consciousGates, ...person1.unconsciousGates};
    final gates2 = {...person2.consciousGates, ...person2.unconsciousGates};

    // Example channels (would need full channel definitions)
    final channelPairs = [
      (64, 47, 'Abstraction'),
      (61, 24, 'Awareness'),
      (63, 4, 'Logic'),
      (20, 34, 'Charisma'),
      (59, 6, 'Intimacy'),
      (40, 37, 'Community'),
    ];

    for (final channel in channelPairs) {
      final has1Gate1 = gates1.contains(channel.$1);
      final has1Gate2 = gates1.contains(channel.$2);
      final has2Gate1 = gates2.contains(channel.$1);
      final has2Gate2 = gates2.contains(channel.$2);

      if ((has1Gate1 && !has1Gate2 && has2Gate2 && !has2Gate1) ||
          (has1Gate2 && !has1Gate1 && has2Gate1 && !has2Gate2)) {
        electromagnetic.add(channel.$3);
      } else if (has1Gate1 && has1Gate2 && has2Gate1 && has2Gate2) {
        companionship.add(channel.$3);
      } else if ((has1Gate1 && has1Gate2) && !(has2Gate1 && has2Gate2)) {
        dominance.add(channel.$3);
      } else if (!(has1Gate1 || has1Gate2) && !(has2Gate1 || has2Gate2) &&
          ((has1Gate1 || has2Gate1) || (has1Gate2 || has2Gate2))) {
        compromise.add(channel.$3);
      }
    }

    return (
      electromagnetic: electromagnetic,
      companionship: companionship,
      dominance: dominance,
      compromise: compromise,
    );
  }

  List<CenterBridge> _calculateCenterBridging(
    ChartSummaryData person1,
    ChartSummaryData person2,
  ) {
    final allCenters = [
      'Head', 'Ajna', 'Throat', 'G', 'Heart', 'Sacral', 'Solar Plexus', 'Spleen', 'Root'
    ];

    return allCenters.map((center) {
      final p1Defined = person1.definedCenters.contains(center);
      final p2Defined = person2.definedCenters.contains(center);

      String impact;
      if (p1Defined && p2Defined) {
        impact = 'Both defined - independence in this area';
      } else if (p1Defined && !p2Defined) {
        impact = '${person1.name} influences ${person2.name}\'s $center';
      } else if (!p1Defined && p2Defined) {
        impact = '${person2.name} influences ${person1.name}\'s $center';
      } else {
        impact = 'Both open - shared sensitivity and wisdom potential';
      }

      return CenterBridge(
        centerName: center,
        person1Defined: p1Defined,
        person2Defined: p2Defined,
        impact: impact,
      );
    }).toList();
  }

  List<String> _generateInsights(
    ChartSummaryData person1,
    ChartSummaryData person2,
    dynamic channels,
    List<CenterBridge> bridges,
  ) {
    final insights = <String>[];

    if (channels.electromagnetic.isNotEmpty) {
      insights.add(
        'You have ${channels.electromagnetic.length} electromagnetic channel(s), '
        'creating natural attraction and energy exchange.',
      );
    }

    final bridgingCenters = bridges
        .where((b) => b.person1Defined != b.person2Defined)
        .map((b) => b.centerName)
        .toList();

    if (bridgingCenters.isNotEmpty) {
      insights.add(
        'Centers being bridged: ${bridgingCenters.join(", ")}. '
        'These create growth opportunities but also conditioning.',
      );
    }

    return insights;
  }

  List<String> _generateChallenges(
    ChartSummaryData person1,
    ChartSummaryData person2,
    dynamic channels,
  ) {
    final challenges = <String>[];

    if (channels.dominance.isNotEmpty) {
      challenges.add(
        'Dominance channels may create one-way energy flow. '
        'Awareness of this dynamic helps maintain balance.',
      );
    }

    if (channels.compromise.isNotEmpty) {
      challenges.add(
        'Compromise channels require conscious attention '
        'as neither person fully defines them alone.',
      );
    }

    return challenges;
  }

  List<String> _generateStrengths(
    ChartSummaryData person1,
    ChartSummaryData person2,
    dynamic channels,
  ) {
    final strengths = <String>[];

    if (channels.companionship.isNotEmpty) {
      strengths.add(
        'Companionship channels (${channels.companionship.join(", ")}) '
        'create stable, supportive connection.',
      );
    }

    if (channels.electromagnetic.isNotEmpty) {
      strengths.add(
        'Electromagnetic attraction provides ongoing spark and interest.',
      );
    }

    return strengths;
  }
}
