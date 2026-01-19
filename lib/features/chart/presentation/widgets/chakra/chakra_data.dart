import 'package:flutter/material.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../../../core/theme/app_colors.dart';

/// Represents a single chakra with its properties
class Chakra {
  const Chakra({
    required this.index,
    required this.name,
    required this.sanskritName,
    required this.color,
    required this.lightColor,
    required this.hdCenters,
    required this.description,
    required this.element,
    required this.location,
  });

  /// Index from 0 (Root) to 6 (Crown)
  final int index;

  /// English name
  final String name;

  /// Sanskrit name
  final String sanskritName;

  /// Primary color
  final Color color;

  /// Light/glow color
  final Color lightColor;

  /// Human Design centers that map to this chakra
  final List<HumanDesignCenter> hdCenters;

  /// Brief description
  final String description;

  /// Associated element
  final String element;

  /// Body location
  final String location;
}

/// All 7 chakras with their HD center mappings
/// Ordered from Root (bottom) to Crown (top)
const List<Chakra> chakras = [
  // 1st - Root Chakra (Muladhara)
  Chakra(
    index: 0,
    name: 'Root',
    sanskritName: 'Muladhara',
    color: AppColors.chakraRoot,
    lightColor: AppColors.chakraRootLight,
    hdCenters: [HumanDesignCenter.root],
    description: 'Grounding, survival, and stability',
    element: 'Earth',
    location: 'Base of spine',
  ),

  // 2nd - Sacral Chakra (Svadhisthana)
  Chakra(
    index: 1,
    name: 'Sacral',
    sanskritName: 'Svadhisthana',
    color: AppColors.chakraSacral,
    lightColor: AppColors.chakraSacralLight,
    hdCenters: [HumanDesignCenter.sacral],
    description: 'Creativity, sexuality, and emotions',
    element: 'Water',
    location: 'Lower abdomen',
  ),

  // 3rd - Solar Plexus Chakra (Manipura)
  Chakra(
    index: 2,
    name: 'Solar Plexus',
    sanskritName: 'Manipura',
    color: AppColors.chakraSolarPlexus,
    lightColor: AppColors.chakraSolarPlexusLight,
    hdCenters: [HumanDesignCenter.heart, HumanDesignCenter.solarPlexus],
    description: 'Personal power, confidence, and will',
    element: 'Fire',
    location: 'Upper abdomen',
  ),

  // 4th - Heart Chakra (Anahata)
  Chakra(
    index: 3,
    name: 'Heart',
    sanskritName: 'Anahata',
    color: AppColors.chakraHeart,
    lightColor: AppColors.chakraHeartLight,
    hdCenters: [HumanDesignCenter.g],
    description: 'Love, compassion, and connection',
    element: 'Air',
    location: 'Center of chest',
  ),

  // 5th - Throat Chakra (Vishuddha)
  Chakra(
    index: 4,
    name: 'Throat',
    sanskritName: 'Vishuddha',
    color: AppColors.chakraThroat,
    lightColor: AppColors.chakraThroatLight,
    hdCenters: [HumanDesignCenter.throat],
    description: 'Communication, expression, and truth',
    element: 'Ether',
    location: 'Throat',
  ),

  // 6th - Third Eye Chakra (Ajna)
  Chakra(
    index: 5,
    name: 'Third Eye',
    sanskritName: 'Ajna',
    color: AppColors.chakraThirdEye,
    lightColor: AppColors.chakraThirdEyeLight,
    hdCenters: [HumanDesignCenter.ajna],
    description: 'Intuition, insight, and imagination',
    element: 'Light',
    location: 'Between eyebrows',
  ),

  // 7th - Crown Chakra (Sahasrara)
  Chakra(
    index: 6,
    name: 'Crown',
    sanskritName: 'Sahasrara',
    color: AppColors.chakraCrown,
    lightColor: AppColors.chakraCrownLight,
    hdCenters: [HumanDesignCenter.head],
    description: 'Spiritual connection and consciousness',
    element: 'Thought',
    location: 'Top of head',
  ),
];

/// HD Centers that don't directly map to traditional chakras
/// (Spleen is associated with intuition but sits separately in HD)
const List<HumanDesignCenter> unmappedHdCenters = [
  HumanDesignCenter.spleen,
];

/// Helper to check if a chakra is activated based on defined HD centers
extension ChakraActivation on Chakra {
  /// Returns true if any of the HD centers mapped to this chakra are defined
  bool isActivated(Set<HumanDesignCenter> definedCenters) {
    return hdCenters.any((center) => definedCenters.contains(center));
  }

  /// Returns the activation level (0.0 to 1.0) based on how many mapped centers are defined
  double activationLevel(Set<HumanDesignCenter> definedCenters) {
    if (hdCenters.isEmpty) return 0.0;
    final definedCount =
        hdCenters.where((center) => definedCenters.contains(center)).length;
    return definedCount / hdCenters.length;
  }
}
