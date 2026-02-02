import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sweph/sweph.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/constants/human_design_constants.dart';
import '../mappers/degree_to_gate_mapper.dart';

/// Service for calculating planetary positions using Swiss Ephemeris.
///
/// This service handles:
/// - Loading ephemeris data files
/// - Calculating planetary positions at any given time
/// - Finding the 88-degree prenatal position
/// - Computing conscious and unconscious gate activations
class EphemerisService {
  EphemerisService._();

  static EphemerisService? _instance;
  static bool _initialized = false;

  /// Get the singleton instance of EphemerisService
  static EphemerisService get instance {
    _instance ??= EphemerisService._();
    return _instance!;
  }

  /// Initialize the Swiss Ephemeris library
  /// Must be called before any calculations
  Future<void> initialize() async {
    if (_initialized) return;

    // Copy ephemeris files from assets to a writable directory
    final directory = await getApplicationDocumentsDirectory();
    final ephePath = '${directory.path}/ephe';

    // Create directory if it doesn't exist
    final epheDir = Directory(ephePath);
    if (!await epheDir.exists()) {
      await epheDir.create(recursive: true);
    }

    // Copy required ephemeris files
    await _copyEphemerisFiles(ephePath);

    // Initialize sweph library first (required in v3)
    await Sweph.init(epheFilesPath: ephePath);

    _initialized = true;
  }

  /// Copy ephemeris data files from assets
  Future<void> _copyEphemerisFiles(String destPath) async {
    // List of ephemeris files needed
    // sepl*.se1 files contain planetary data
    // semo*.se1 files contain moon data
    final files = [
      'sepl_18.se1', // 1800-2400
      'semo_18.se1', // Moon 1800-2400
    ];

    for (final fileName in files) {
      final destFile = File('$destPath/$fileName');
      if (!await destFile.exists()) {
        try {
          final data = await rootBundle.load('assets/ephe/$fileName');
          await destFile.writeAsBytes(data.buffer.asUint8List());
        } catch (e) {
          // File might not exist in assets, which is okay for some files
          // sweph can still calculate with reduced accuracy
        }
      }
    }
  }

  /// Check if the service has been initialized
  bool get isInitialized => _initialized;

  /// Calculate planetary positions for a given Julian Day Number
  ///
  /// Returns a map of planet to longitude in degrees (0-360)
  /// Throws [StateError] if called before [initialize].
  Map<HumanDesignPlanet, double> calculatePlanetaryPositions(double julianDay) {
    if (!_initialized) {
      throw StateError(
        'EphemerisService.calculatePlanetaryPositions called before initialize(). '
        'Call await EphemerisService.instance.initialize() first.',
      );
    }
    final positions = <HumanDesignPlanet, double>{};

    // Map sweph HeavenlyBody to Human Design planets
    final planetMap = {
      HeavenlyBody.SE_SUN: HumanDesignPlanet.sun,
      HeavenlyBody.SE_MOON: HumanDesignPlanet.moon,
      HeavenlyBody.SE_MERCURY: HumanDesignPlanet.mercury,
      HeavenlyBody.SE_VENUS: HumanDesignPlanet.venus,
      HeavenlyBody.SE_MARS: HumanDesignPlanet.mars,
      HeavenlyBody.SE_JUPITER: HumanDesignPlanet.jupiter,
      HeavenlyBody.SE_SATURN: HumanDesignPlanet.saturn,
      HeavenlyBody.SE_URANUS: HumanDesignPlanet.uranus,
      HeavenlyBody.SE_NEPTUNE: HumanDesignPlanet.neptune,
      HeavenlyBody.SE_PLUTO: HumanDesignPlanet.pluto,
      HeavenlyBody.SE_TRUE_NODE: HumanDesignPlanet.northNode,
    };

    // Calculate positions for each planet
    for (final entry in planetMap.entries) {
      final heavenlyBody = entry.key;
      final hdPlanet = entry.value;

      try {
        final result = Sweph.swe_calc_ut(
          julianDay,
          heavenlyBody,
          SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_SPEED,
        );

        // Longitude is the first value in the result
        double longitude = result.longitude;

        // Normalize to 0-360
        if (longitude < 0) longitude += 360;
        if (longitude >= 360) longitude -= 360;

        positions[hdPlanet] = longitude;

        // For Earth, it's 180° opposite the Sun
        if (hdPlanet == HumanDesignPlanet.sun) {
          double earthLongitude = longitude + 180;
          if (earthLongitude >= 360) earthLongitude -= 360;
          positions[HumanDesignPlanet.earth] = earthLongitude;
        }

        // Calculate South Node as opposite of North Node
        if (hdPlanet == HumanDesignPlanet.northNode) {
          double southLongitude = longitude + 180;
          if (southLongitude >= 360) southLongitude -= 360;
          positions[HumanDesignPlanet.southNode] = southLongitude;
        }
      } catch (e) {
        // Skip planets that can't be calculated
        continue;
      }
    }

    return positions;
  }

  /// Convert a DateTime to Julian Day Number
  ///
  /// [dateTime] - A DateTime representing the LOCAL birth time (naive, no timezone info)
  /// [timezone] - IANA timezone string (e.g., 'America/Denver') for the birth location
  ///
  /// If timezone is provided, the dateTime is interpreted as local time in that
  /// timezone and converted to UTC. If not provided, falls back to device timezone.
  double dateTimeToJulianDay(DateTime dateTime, {String? timezone}) {
    DateTime utcDateTime;

    if (timezone != null && !dateTime.isUtc) {
      // Only convert if the DateTime is NOT already UTC
      // If it's UTC, the timezone offset was already applied when storing
      try {
        // Convert local birth time to UTC using the birth location's timezone
        final location = tz.getLocation(timezone);
        final localTime = tz.TZDateTime(
          location,
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
        );
        utcDateTime = localTime.toUtc();
      } catch (e) {
        // Fallback to device timezone if timezone lookup fails
        utcDateTime = dateTime.toUtc();
      }
    } else if (dateTime.isUtc) {
      // Already UTC - the time was properly converted at storage time
      utcDateTime = dateTime;
    } else {
      // No timezone provided and not UTC - assume device timezone (legacy behavior)
      utcDateTime = dateTime.toUtc();
    }

    // Calculate decimal hours
    final hours = utcDateTime.hour +
        (utcDateTime.minute / 60.0) +
        (utcDateTime.second / 3600.0) +
        (utcDateTime.millisecond / 3600000.0);

    return Sweph.swe_julday(
      utcDateTime.year,
      utcDateTime.month,
      utcDateTime.day,
      hours,
      CalendarType.SE_GREG_CAL,
    );
  }

  /// Find the Julian Day when the Sun was 88 degrees earlier
  /// This is the "Design" or "Unconscious" calculation point
  double findPrenatalSunPosition(double birthJulianDay) {
    // Get sun position at birth
    final birthPositions = calculatePlanetaryPositions(birthJulianDay);
    final birthSunLongitude = birthPositions[HumanDesignPlanet.sun]!;

    // Calculate target longitude (88 degrees before birth)
    double targetLongitude = birthSunLongitude - 88.0;
    if (targetLongitude < 0) targetLongitude += 360;

    // Sun moves approximately 1 degree per day
    // 88 degrees ≈ 88 days, but we need to search precisely
    double searchJd = birthJulianDay - 88;

    // Binary search to find exact position
    for (int iteration = 0; iteration < 50; iteration++) {
      final positions = calculatePlanetaryPositions(searchJd);
      final sunLongitude = positions[HumanDesignPlanet.sun]!;

      // Calculate difference (accounting for 360° wraparound)
      double diff = targetLongitude - sunLongitude;
      if (diff > 180) diff -= 360;
      if (diff < -180) diff += 360;

      // If close enough (within 0.0001 degrees), we're done
      if (diff.abs() < 0.0001) break;

      // Adjust search position
      // Sun moves ~1 degree per day, so adjust proportionally
      searchJd += diff;
    }

    return searchJd;
  }

  /// Calculate complete gate activations for a birth chart
  ///
  /// [birthDateTime] - Local birth time (naive DateTime)
  /// [timezone] - IANA timezone string for the birth location
  ///
  /// Returns both conscious (birth) and unconscious (88° prenatal) activations
  ChartActivations calculateChartActivations(
    DateTime birthDateTime, {
    String? timezone,
  }) {
    // Convert birth time to Julian Day using the birth location's timezone
    final birthJd = dateTimeToJulianDay(birthDateTime, timezone: timezone);

    // Calculate conscious (birth) positions
    final consciousPositions = calculatePlanetaryPositions(birthJd);

    // Find prenatal position and calculate unconscious positions
    final prenatalJd = findPrenatalSunPosition(birthJd);
    final unconsciousPositions = calculatePlanetaryPositions(prenatalJd);

    // Map positions to gate activations
    final consciousActivations = <HumanDesignPlanet, GateActivation>{};
    final unconsciousActivations = <HumanDesignPlanet, GateActivation>{};

    for (final planet in HumanDesignPlanet.values) {
      if (consciousPositions.containsKey(planet)) {
        consciousActivations[planet] = DegreeToGateMapper.mapDegreeToGate(
          consciousPositions[planet]!,
        );
      }
      if (unconsciousPositions.containsKey(planet)) {
        unconsciousActivations[planet] = DegreeToGateMapper.mapDegreeToGate(
          unconsciousPositions[planet]!,
        );
      }
    }

    return ChartActivations(
      birthDateTime: birthDateTime,
      birthJulianDay: birthJd,
      prenatalJulianDay: prenatalJd,
      consciousActivations: consciousActivations,
      unconsciousActivations: unconsciousActivations,
    );
  }

  /// Calculate transit positions for a given time
  Map<HumanDesignPlanet, GateActivation> calculateTransits(DateTime dateTime) {
    final jd = dateTimeToJulianDay(dateTime);
    final positions = calculatePlanetaryPositions(jd);

    final activations = <HumanDesignPlanet, GateActivation>{};
    for (final entry in positions.entries) {
      activations[entry.key] = DegreeToGateMapper.mapDegreeToGate(entry.value);
    }

    return activations;
  }

  /// Dispose of resources
  void dispose() {
    if (_initialized) {
      Sweph.swe_close();
      _initialized = false;
    }
  }
}

/// Holds all gate activations for a complete chart
class ChartActivations {
  const ChartActivations({
    required this.birthDateTime,
    required this.birthJulianDay,
    required this.prenatalJulianDay,
    required this.consciousActivations,
    required this.unconsciousActivations,
  });

  final DateTime birthDateTime;
  final double birthJulianDay;
  final double prenatalJulianDay;
  final Map<HumanDesignPlanet, GateActivation> consciousActivations;
  final Map<HumanDesignPlanet, GateActivation> unconsciousActivations;

  /// Get all unique conscious gates
  Set<int> get consciousGates =>
      consciousActivations.values.map((a) => a.gate).toSet();

  /// Get all unique unconscious gates
  Set<int> get unconsciousGates =>
      unconsciousActivations.values.map((a) => a.gate).toSet();

  /// Get all defined gates (both conscious and unconscious)
  Set<int> get allGates => {...consciousGates, ...unconsciousGates};

  /// Get channels activated by these gates
  List<ChannelActivation> get activeChannels =>
      DegreeToGateMapper.findActiveChannels(consciousGates, unconsciousGates);

  /// Get defined centers based on active channels
  Set<HumanDesignCenter> get definedCenters =>
      DegreeToGateMapper.findDefinedCenters(activeChannels);

  /// Get the profile from Sun/Earth lines
  Profile? get profile {
    final consciousSun = consciousActivations[HumanDesignPlanet.sun];
    final unconsciousSun = unconsciousActivations[HumanDesignPlanet.sun];

    if (consciousSun == null || unconsciousSun == null) return null;

    final consciousLine = consciousSun.line;
    final unconsciousLine = unconsciousSun.line;

    // Find matching profile
    for (final p in Profile.values) {
      final parts = p.notation.split('/');
      if (parts.length == 2) {
        final c = int.tryParse(parts[0]);
        final u = int.tryParse(parts[1]);
        if (c == consciousLine && u == unconsciousLine) {
          return p;
        }
      }
    }

    return null;
  }
}
