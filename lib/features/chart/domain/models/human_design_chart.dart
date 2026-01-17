import 'package:equatable/equatable.dart';

import '../../../../core/constants/human_design_constants.dart';
import '../../../ephemeris/mappers/degree_to_gate_mapper.dart';

/// Complete Human Design chart with all calculated data
class HumanDesignChart extends Equatable {
  const HumanDesignChart({
    required this.id,
    required this.userId,
    required this.name,
    required this.birthDateTime,
    required this.birthLocation,
    required this.timezone,
    required this.type,
    required this.strategy,
    required this.authority,
    required this.profile,
    required this.definition,
    required this.definedCenters,
    required this.undefinedCenters,
    required this.activeChannels,
    required this.consciousActivations,
    required this.unconsciousActivations,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final DateTime birthDateTime;
  final BirthLocation birthLocation;
  final String timezone;
  final HumanDesignType type;
  final String strategy;
  final Authority authority;
  final Profile profile;
  final Definition definition;
  final Set<HumanDesignCenter> definedCenters;
  final Set<HumanDesignCenter> undefinedCenters;
  final List<ChannelActivation> activeChannels;
  final Map<HumanDesignPlanet, GateActivation> consciousActivations;
  final Map<HumanDesignPlanet, GateActivation> unconsciousActivations;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Get all conscious gates
  Set<int> get consciousGates =>
      consciousActivations.values.map((a) => a.gate).toSet();

  /// Get all unconscious gates
  Set<int> get unconsciousGates =>
      unconsciousActivations.values.map((a) => a.gate).toSet();

  /// Get all defined gates
  Set<int> get allGates => {...consciousGates, ...unconsciousGates};

  /// Check if a specific center is defined
  bool isCenterDefined(HumanDesignCenter center) => definedCenters.contains(center);

  /// Get activations for a specific gate
  GateActivationInfo? getGateInfo(int gateNumber) {
    GateActivation? conscious;
    GateActivation? unconscious;
    HumanDesignPlanet? consciousPlanet;
    HumanDesignPlanet? unconsciousPlanet;

    for (final entry in consciousActivations.entries) {
      if (entry.value.gate == gateNumber) {
        conscious = entry.value;
        consciousPlanet = entry.key;
        break;
      }
    }

    for (final entry in unconsciousActivations.entries) {
      if (entry.value.gate == gateNumber) {
        unconscious = entry.value;
        unconsciousPlanet = entry.key;
        break;
      }
    }

    if (conscious == null && unconscious == null) return null;

    return GateActivationInfo(
      gateNumber: gateNumber,
      gateData: gates[gateNumber]!,
      consciousActivation: conscious,
      unconsciousActivation: unconscious,
      consciousPlanet: consciousPlanet,
      unconsciousPlanet: unconsciousPlanet,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        birthDateTime,
        birthLocation,
        timezone,
        type,
        authority,
        profile,
        definition,
        definedCenters,
        activeChannels,
      ];

  /// Create a copy with optional changes
  HumanDesignChart copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? birthDateTime,
    BirthLocation? birthLocation,
    String? timezone,
    HumanDesignType? type,
    String? strategy,
    Authority? authority,
    Profile? profile,
    Definition? definition,
    Set<HumanDesignCenter>? definedCenters,
    Set<HumanDesignCenter>? undefinedCenters,
    List<ChannelActivation>? activeChannels,
    Map<HumanDesignPlanet, GateActivation>? consciousActivations,
    Map<HumanDesignPlanet, GateActivation>? unconsciousActivations,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HumanDesignChart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      birthDateTime: birthDateTime ?? this.birthDateTime,
      birthLocation: birthLocation ?? this.birthLocation,
      timezone: timezone ?? this.timezone,
      type: type ?? this.type,
      strategy: strategy ?? this.strategy,
      authority: authority ?? this.authority,
      profile: profile ?? this.profile,
      definition: definition ?? this.definition,
      definedCenters: definedCenters ?? this.definedCenters,
      undefinedCenters: undefinedCenters ?? this.undefinedCenters,
      activeChannels: activeChannels ?? this.activeChannels,
      consciousActivations: consciousActivations ?? this.consciousActivations,
      unconsciousActivations:
          unconsciousActivations ?? this.unconsciousActivations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Birth location data
class BirthLocation extends Equatable {
  const BirthLocation({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final String city;
  final String country;
  final double latitude;
  final double longitude;

  String get displayName => '$city, $country';

  @override
  List<Object?> get props => [city, country, latitude, longitude];

  Map<String, dynamic> toJson() => {
        'city': city,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory BirthLocation.fromJson(Map<String, dynamic> json) {
    return BirthLocation(
      city: json['city'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

/// Detailed info about a gate activation
class GateActivationInfo {
  const GateActivationInfo({
    required this.gateNumber,
    required this.gateData,
    this.consciousActivation,
    this.unconsciousActivation,
    this.consciousPlanet,
    this.unconsciousPlanet,
  });

  final int gateNumber;
  final GateData gateData;
  final GateActivation? consciousActivation;
  final GateActivation? unconsciousActivation;
  final HumanDesignPlanet? consciousPlanet;
  final HumanDesignPlanet? unconsciousPlanet;

  bool get isConscious => consciousActivation != null;
  bool get isUnconscious => unconsciousActivation != null;
  bool get isBoth => isConscious && isUnconscious;

  String get name => gateData.name;
  HumanDesignCenter get center => gateData.center;
  String get keynote => gateData.keynote;
}
