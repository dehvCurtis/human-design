import 'dart:math';

import '../../../core/constants/human_design_constants.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../data/affirmations_data.dart';
import 'transit_service.dart';

/// Service for generating personalized daily affirmations
class AffirmationService {
  AffirmationService({
    required TransitService transitService,
  }) : _transitService = transitService;

  final TransitService _transitService;
  final _random = Random();

  /// Get a daily affirmation based on the user's chart
  DailyAffirmation getDailyAffirmation(HumanDesignChart chart) {
    final today = DateTime.now();
    final seed = _getDailySeed(today, chart.id);
    final seededRandom = Random(seed);

    // Decide the type of affirmation (type-based, gate-based, or authority-based)
    final affirmationType = seededRandom.nextInt(3);

    switch (affirmationType) {
      case 0:
        return _getTypeBasedAffirmation(chart, seededRandom);
      case 1:
        return _getGateBasedAffirmation(chart, seededRandom);
      case 2:
        return _getAuthorityBasedAffirmation(chart, seededRandom);
      default:
        return _getTypeBasedAffirmation(chart, seededRandom);
    }
  }

  /// Get an affirmation based on current transits
  DailyAffirmation getTransitAffirmation(HumanDesignChart chart) {
    final transits = _transitService.calculateCurrentTransits();
    final sunGate = transits.sunGate.gate;

    final affirmations = gateAffirmations[sunGate] ?? [];
    if (affirmations.isEmpty) {
      return _getTypeBasedAffirmation(chart, _random);
    }

    final seed = _getDailySeed(DateTime.now(), chart.id);
    final seededRandom = Random(seed);
    final affirmation = affirmations[seededRandom.nextInt(affirmations.length)];

    return DailyAffirmation(
      text: affirmation,
      source: AffirmationSource.transit,
      gateNumber: sunGate,
      type: null,
      authority: null,
      date: DateTime.now(),
    );
  }

  /// Get a random affirmation for a specific gate
  DailyAffirmation getGateAffirmation(int gateNumber) {
    final affirmations = gateAffirmations[gateNumber] ?? [];
    if (affirmations.isEmpty) {
      return DailyAffirmation(
        text: 'I embrace the energy of Gate $gateNumber.',
        source: AffirmationSource.gate,
        gateNumber: gateNumber,
        type: null,
        authority: null,
        date: DateTime.now(),
      );
    }

    final affirmation = affirmations[_random.nextInt(affirmations.length)];

    return DailyAffirmation(
      text: affirmation,
      source: AffirmationSource.gate,
      gateNumber: gateNumber,
      type: null,
      authority: null,
      date: DateTime.now(),
    );
  }

  /// Get a new random affirmation (ignores daily seed)
  DailyAffirmation getRandomAffirmation(HumanDesignChart chart) {
    final affirmationType = _random.nextInt(3);

    switch (affirmationType) {
      case 0:
        return _getTypeBasedAffirmation(chart, _random);
      case 1:
        return _getGateBasedAffirmation(chart, _random);
      case 2:
        return _getAuthorityBasedAffirmation(chart, _random);
      default:
        return _getTypeBasedAffirmation(chart, _random);
    }
  }

  DailyAffirmation _getTypeBasedAffirmation(
      HumanDesignChart chart, Random random) {
    final affirmations = typeAffirmations[chart.type] ?? [];
    if (affirmations.isEmpty) {
      return DailyAffirmation(
        text: 'I honor my unique design today.',
        source: AffirmationSource.type,
        gateNumber: null,
        type: chart.type,
        authority: null,
        date: DateTime.now(),
      );
    }

    final affirmation = affirmations[random.nextInt(affirmations.length)];

    return DailyAffirmation(
      text: affirmation,
      source: AffirmationSource.type,
      gateNumber: null,
      type: chart.type,
      authority: null,
      date: DateTime.now(),
    );
  }

  DailyAffirmation _getGateBasedAffirmation(
      HumanDesignChart chart, Random random) {
    // Pick a random gate from the user's defined gates
    final gates = chart.allGates.toList();
    if (gates.isEmpty) {
      return _getTypeBasedAffirmation(chart, random);
    }

    final selectedGate = gates[random.nextInt(gates.length)];
    final affirmations = gateAffirmations[selectedGate] ?? [];

    if (affirmations.isEmpty) {
      return DailyAffirmation(
        text: 'I embrace the energy of Gate $selectedGate.',
        source: AffirmationSource.gate,
        gateNumber: selectedGate,
        type: null,
        authority: null,
        date: DateTime.now(),
      );
    }

    final affirmation = affirmations[random.nextInt(affirmations.length)];

    return DailyAffirmation(
      text: affirmation,
      source: AffirmationSource.gate,
      gateNumber: selectedGate,
      type: null,
      authority: null,
      date: DateTime.now(),
    );
  }

  DailyAffirmation _getAuthorityBasedAffirmation(
      HumanDesignChart chart, Random random) {
    final affirmations = authorityAffirmations[chart.authority] ?? [];
    if (affirmations.isEmpty) {
      return _getTypeBasedAffirmation(chart, random);
    }

    final affirmation = affirmations[random.nextInt(affirmations.length)];

    return DailyAffirmation(
      text: affirmation,
      source: AffirmationSource.authority,
      gateNumber: null,
      type: null,
      authority: chart.authority,
      date: DateTime.now(),
    );
  }

  /// Generate a consistent seed for a specific day and user
  int _getDailySeed(DateTime date, String chartId) {
    final dateStr = '${date.year}-${date.month}-${date.day}';
    return '$dateStr-$chartId'.hashCode;
  }
}

/// Represents a daily affirmation
class DailyAffirmation {
  const DailyAffirmation({
    required this.text,
    required this.source,
    required this.date,
    this.gateNumber,
    this.type,
    this.authority,
  });

  final String text;
  final AffirmationSource source;
  final int? gateNumber;
  final HumanDesignType? type;
  final Authority? authority;
  final DateTime date;

  /// Get a description of what this affirmation is based on
  String get sourceDescription {
    switch (source) {
      case AffirmationSource.type:
        return 'Based on your ${type?.displayName ?? "type"}';
      case AffirmationSource.gate:
        return 'Based on Gate $gateNumber';
      case AffirmationSource.authority:
        return 'Based on your ${authority?.displayName ?? "authority"}';
      case AffirmationSource.transit:
        return 'Based on today\'s Sun in Gate $gateNumber';
    }
  }
}

/// The source/basis for an affirmation
enum AffirmationSource {
  type,
  gate,
  authority,
  transit,
}
