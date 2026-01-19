import 'dart:ui';

import '../../../../../core/constants/human_design_constants.dart';
import 'bodygraph_layout.dart';

/// Clean geometric layout with radically different positioning
///
/// This layout features:
/// - Strict vertical grid alignment for centers
/// - Gates arranged in horizontal rows
/// - Parallel vertical/diagonal channel lines
/// - Modern, symmetric aesthetic
///
/// Canvas: 400x600 pixels
class GeometricBodygraphLayout extends BodygraphLayout {
  const GeometricBodygraphLayout();

  @override
  BodygraphLayoutType get layoutType => BodygraphLayoutType.geometric;

  @override
  Map<HumanDesignCenter, CenterPosition> get centerPositions => _centerPositions;

  @override
  Map<int, GatePosition> get gatePositions => _gatePositions;

  @override
  List<Offset> getChannelPath(int gate1, int gate2) {
    final id = gate1 < gate2 ? '$gate1-$gate2' : '$gate2-$gate1';
    return _channelPaths[id] ?? [];
  }

  /// Center positions for geometric layout
  /// STRICT GRID SYSTEM - very different from standard
  ///
  /// Vertical columns at x = 70, 200, 330
  /// Horizontal rows spaced evenly
  static const Map<HumanDesignCenter, CenterPosition> _centerPositions = {
    // TOP SECTION - Head and Ajna centered
    HumanDesignCenter.head: CenterPosition(
      center: HumanDesignCenter.head,
      x: 200,
      y: 40,
      width: 50,
      height: 44,
      shape: CenterShape.triangle,
    ),
    HumanDesignCenter.ajna: CenterPosition(
      center: HumanDesignCenter.ajna,
      x: 200,
      y: 110,
      width: 50,
      height: 44,
      shape: CenterShape.triangle,
    ),
    // UPPER MIDDLE - Throat centered
    HumanDesignCenter.throat: CenterPosition(
      center: HumanDesignCenter.throat,
      x: 200,
      y: 185,
      width: 44,
      height: 44,
      shape: CenterShape.square,
    ),
    // MIDDLE SECTION - G center with Heart to right
    HumanDesignCenter.g: CenterPosition(
      center: HumanDesignCenter.g,
      x: 200,
      y: 280,
      width: 48,
      height: 48,
      shape: CenterShape.diamond,
    ),
    HumanDesignCenter.heart: CenterPosition(
      center: HumanDesignCenter.heart,
      x: 330,  // FAR RIGHT column
      y: 250,
      width: 32,
      height: 32,
      shape: CenterShape.triangle,
    ),
    // LOWER MIDDLE - Spleen left, Sacral center, Solar Plexus right
    HumanDesignCenter.spleen: CenterPosition(
      center: HumanDesignCenter.spleen,
      x: 70,   // FAR LEFT column
      y: 380,
      width: 44,
      height: 44,
      shape: CenterShape.triangle,
    ),
    HumanDesignCenter.sacral: CenterPosition(
      center: HumanDesignCenter.sacral,
      x: 200,
      y: 400,
      width: 44,
      height: 44,
      shape: CenterShape.square,
    ),
    HumanDesignCenter.solarPlexus: CenterPosition(
      center: HumanDesignCenter.solarPlexus,
      x: 330,  // FAR RIGHT column
      y: 380,
      width: 44,
      height: 44,
      shape: CenterShape.triangle,
    ),
    // BOTTOM - Root centered
    HumanDesignCenter.root: CenterPosition(
      center: HumanDesignCenter.root,
      x: 200,
      y: 530,
      width: 44,
      height: 44,
      shape: CenterShape.square,
    ),
  };

  /// Gate positions - arranged in HORIZONTAL ROWS around centers
  static const Map<int, GatePosition> _gatePositions = {
    // ============================================
    // HEAD CENTER GATES (3 gates) - horizontal row above
    // ============================================
    64: GatePosition(gate: 64, center: HumanDesignCenter.head, x: 170, y: 18),
    61: GatePosition(gate: 61, center: HumanDesignCenter.head, x: 200, y: 15),
    63: GatePosition(gate: 63, center: HumanDesignCenter.head, x: 230, y: 18),

    // ============================================
    // AJNA CENTER GATES (6 gates) - two horizontal rows
    // ============================================
    // Top row (connecting to Head)
    47: GatePosition(gate: 47, center: HumanDesignCenter.ajna, x: 170, y: 85),
    24: GatePosition(gate: 24, center: HumanDesignCenter.ajna, x: 200, y: 82),
    4: GatePosition(gate: 4, center: HumanDesignCenter.ajna, x: 230, y: 85),
    // Bottom row (connecting to Throat)
    17: GatePosition(gate: 17, center: HumanDesignCenter.ajna, x: 170, y: 138),
    43: GatePosition(gate: 43, center: HumanDesignCenter.ajna, x: 200, y: 140),
    11: GatePosition(gate: 11, center: HumanDesignCenter.ajna, x: 230, y: 138),

    // ============================================
    // THROAT CENTER GATES (11 gates) - ring around center
    // ============================================
    // Top row
    62: GatePosition(gate: 62, center: HumanDesignCenter.throat, x: 160, y: 162),
    23: GatePosition(gate: 23, center: HumanDesignCenter.throat, x: 185, y: 160),
    56: GatePosition(gate: 56, center: HumanDesignCenter.throat, x: 215, y: 160),
    16: GatePosition(gate: 16, center: HumanDesignCenter.throat, x: 240, y: 162),
    // Left side
    20: GatePosition(gate: 20, center: HumanDesignCenter.throat, x: 150, y: 185),
    45: GatePosition(gate: 45, center: HumanDesignCenter.throat, x: 150, y: 205),
    // Right side
    35: GatePosition(gate: 35, center: HumanDesignCenter.throat, x: 250, y: 185),
    12: GatePosition(gate: 12, center: HumanDesignCenter.throat, x: 250, y: 205),
    // Bottom row
    31: GatePosition(gate: 31, center: HumanDesignCenter.throat, x: 165, y: 212),
    8: GatePosition(gate: 8, center: HumanDesignCenter.throat, x: 190, y: 215),
    33: GatePosition(gate: 33, center: HumanDesignCenter.throat, x: 215, y: 215),

    // ============================================
    // G CENTER GATES (8 gates) - diamond points
    // ============================================
    // Top
    1: GatePosition(gate: 1, center: HumanDesignCenter.g, x: 175, y: 252),
    13: GatePosition(gate: 13, center: HumanDesignCenter.g, x: 200, y: 248),
    25: GatePosition(gate: 25, center: HumanDesignCenter.g, x: 225, y: 252),
    // Left
    10: GatePosition(gate: 10, center: HumanDesignCenter.g, x: 165, y: 280),
    15: GatePosition(gate: 15, center: HumanDesignCenter.g, x: 165, y: 305),
    // Right
    7: GatePosition(gate: 7, center: HumanDesignCenter.g, x: 235, y: 280),
    2: GatePosition(gate: 2, center: HumanDesignCenter.g, x: 235, y: 305),
    // Bottom
    46: GatePosition(gate: 46, center: HumanDesignCenter.g, x: 200, y: 315),

    // ============================================
    // HEART/EGO CENTER GATES (4 gates) - FAR RIGHT
    // ============================================
    21: GatePosition(gate: 21, center: HumanDesignCenter.heart, x: 310, y: 228),
    51: GatePosition(gate: 51, center: HumanDesignCenter.heart, x: 305, y: 250),
    26: GatePosition(gate: 26, center: HumanDesignCenter.heart, x: 352, y: 242),
    40: GatePosition(gate: 40, center: HumanDesignCenter.heart, x: 355, y: 268),

    // ============================================
    // SPLEEN CENTER GATES (7 gates) - FAR LEFT
    // ============================================
    48: GatePosition(gate: 48, center: HumanDesignCenter.spleen, x: 45, y: 355),
    57: GatePosition(gate: 57, center: HumanDesignCenter.spleen, x: 40, y: 378),
    44: GatePosition(gate: 44, center: HumanDesignCenter.spleen, x: 55, y: 358),
    50: GatePosition(gate: 50, center: HumanDesignCenter.spleen, x: 100, y: 385),
    32: GatePosition(gate: 32, center: HumanDesignCenter.spleen, x: 48, y: 405),
    28: GatePosition(gate: 28, center: HumanDesignCenter.spleen, x: 40, y: 398),
    18: GatePosition(gate: 18, center: HumanDesignCenter.spleen, x: 75, y: 412),

    // ============================================
    // SACRAL CENTER GATES (9 gates) - center column
    // ============================================
    5: GatePosition(gate: 5, center: HumanDesignCenter.sacral, x: 168, y: 375),
    14: GatePosition(gate: 14, center: HumanDesignCenter.sacral, x: 185, y: 372),
    29: GatePosition(gate: 29, center: HumanDesignCenter.sacral, x: 215, y: 372),
    34: GatePosition(gate: 34, center: HumanDesignCenter.sacral, x: 152, y: 395),
    9: GatePosition(gate: 9, center: HumanDesignCenter.sacral, x: 168, y: 428),
    3: GatePosition(gate: 3, center: HumanDesignCenter.sacral, x: 232, y: 428),
    42: GatePosition(gate: 42, center: HumanDesignCenter.sacral, x: 238, y: 412),
    27: GatePosition(gate: 27, center: HumanDesignCenter.sacral, x: 130, y: 400),
    59: GatePosition(gate: 59, center: HumanDesignCenter.sacral, x: 268, y: 395),

    // ============================================
    // SOLAR PLEXUS CENTER GATES (7 gates) - FAR RIGHT
    // ============================================
    36: GatePosition(gate: 36, center: HumanDesignCenter.solarPlexus, x: 305, y: 358),
    22: GatePosition(gate: 22, center: HumanDesignCenter.solarPlexus, x: 355, y: 362),
    37: GatePosition(gate: 37, center: HumanDesignCenter.solarPlexus, x: 362, y: 378),
    6: GatePosition(gate: 6, center: HumanDesignCenter.solarPlexus, x: 295, y: 385),
    49: GatePosition(gate: 49, center: HumanDesignCenter.solarPlexus, x: 365, y: 398),
    55: GatePosition(gate: 55, center: HumanDesignCenter.solarPlexus, x: 358, y: 412),
    30: GatePosition(gate: 30, center: HumanDesignCenter.solarPlexus, x: 325, y: 415),

    // ============================================
    // ROOT CENTER GATES (9 gates) - horizontal spread at bottom
    // ============================================
    53: GatePosition(gate: 53, center: HumanDesignCenter.root, x: 158, y: 502),
    60: GatePosition(gate: 60, center: HumanDesignCenter.root, x: 178, y: 505),
    52: GatePosition(gate: 52, center: HumanDesignCenter.root, x: 170, y: 558),
    19: GatePosition(gate: 19, center: HumanDesignCenter.root, x: 242, y: 502),
    39: GatePosition(gate: 39, center: HumanDesignCenter.root, x: 262, y: 508),
    41: GatePosition(gate: 41, center: HumanDesignCenter.root, x: 252, y: 558),
    58: GatePosition(gate: 58, center: HumanDesignCenter.root, x: 145, y: 530),
    38: GatePosition(gate: 38, center: HumanDesignCenter.root, x: 132, y: 520),
    54: GatePosition(gate: 54, center: HumanDesignCenter.root, x: 152, y: 552),
  };

  /// Channel paths - PARALLEL LINES where possible
  static const Map<String, List<Offset>> _channelPaths = {
    // ============================================
    // HEAD TO AJNA (3 PARALLEL VERTICAL channels)
    // ============================================
    '47-64': [Offset(170, 28), Offset(170, 85)],
    '24-61': [Offset(200, 25), Offset(200, 82)],
    '4-63': [Offset(230, 28), Offset(230, 85)],

    // ============================================
    // AJNA TO THROAT (3 PARALLEL channels)
    // ============================================
    '17-62': [Offset(170, 142), Offset(165, 162)],
    '23-43': [Offset(200, 145), Offset(190, 160)],
    '11-56': [Offset(230, 142), Offset(220, 160)],

    // ============================================
    // THROAT TO G CENTER (4 channels)
    // ============================================
    '7-31': [Offset(168, 215), Offset(200, 240), Offset(235, 280)],
    '1-8': [Offset(192, 218), Offset(180, 252)],
    '13-33': [Offset(218, 218), Offset(205, 248)],
    '10-20': [Offset(148, 190), Offset(148, 235), Offset(165, 280)],

    // ============================================
    // THROAT TO HEART (long diagonal to far right)
    // ============================================
    '21-45': [Offset(152, 208), Offset(230, 220), Offset(310, 228)],

    // ============================================
    // THROAT TO SPLEEN (long diagonal to far left)
    // ============================================
    '16-48': [Offset(242, 165), Offset(145, 260), Offset(45, 355)],

    // ============================================
    // THROAT TO SOLAR PLEXUS (diagonals to far right)
    // ============================================
    '12-22': [Offset(252, 208), Offset(305, 285), Offset(355, 362)],
    '35-36': [Offset(252, 188), Offset(280, 270), Offset(305, 358)],

    // ============================================
    // THROAT TO SACRAL (integration - down center)
    // ============================================
    '20-34': [Offset(148, 190), Offset(148, 290), Offset(152, 395)],

    // ============================================
    // G CENTER TO HEART (diagonal to far right)
    // ============================================
    '25-51': [Offset(228, 255), Offset(268, 252), Offset(305, 250)],

    // ============================================
    // G CENTER TO SPLEEN (diagonal to far left)
    // ============================================
    '10-57': [Offset(162, 285), Offset(100, 330), Offset(40, 378)],

    // ============================================
    // G CENTER TO SACRAL (4 channels down center)
    // ============================================
    '2-14': [Offset(235, 310), Offset(212, 340), Offset(185, 372)],
    '5-15': [Offset(165, 310), Offset(166, 342), Offset(168, 375)],
    '10-34': [Offset(162, 285), Offset(155, 340), Offset(152, 395)],
    '29-46': [Offset(200, 320), Offset(208, 345), Offset(215, 372)],

    // ============================================
    // HEART TO SPLEEN (far right to far left diagonal)
    // ============================================
    '26-44': [Offset(350, 245), Offset(200, 300), Offset(55, 358)],

    // ============================================
    // HEART TO SOLAR PLEXUS (right side)
    // ============================================
    '37-40': [Offset(358, 270), Offset(360, 325), Offset(362, 378)],

    // ============================================
    // SPLEEN TO SACRAL (left to center)
    // ============================================
    '27-50': [Offset(102, 388), Offset(118, 395), Offset(130, 400)],
    '34-57': [Offset(150, 398), Offset(95, 388), Offset(42, 380)],

    // ============================================
    // SPLEEN TO ROOT (left side diagonals)
    // ============================================
    '18-58': [Offset(78, 415), Offset(112, 472), Offset(145, 530)],
    '28-38': [Offset(42, 402), Offset(88, 460), Offset(132, 520)],
    '32-54': [Offset(50, 408), Offset(100, 480), Offset(152, 552)],

    // ============================================
    // SPLEEN TO THROAT (integration - left diagonal)
    // ============================================
    '20-57': [Offset(148, 190), Offset(92, 285), Offset(40, 378)],

    // ============================================
    // SACRAL TO SOLAR PLEXUS (center to right)
    // ============================================
    '6-59': [Offset(270, 398), Offset(282, 392), Offset(295, 385)],

    // ============================================
    // SACRAL TO ROOT (center column)
    // ============================================
    '3-60': [Offset(232, 432), Offset(205, 468), Offset(178, 505)],
    '9-52': [Offset(168, 432), Offset(169, 495), Offset(170, 558)],
    '42-53': [Offset(238, 415), Offset(198, 458), Offset(158, 502)],

    // ============================================
    // SOLAR PLEXUS TO ROOT (right diagonals)
    // ============================================
    '19-49': [Offset(365, 402), Offset(305, 452), Offset(242, 502)],
    '30-41': [Offset(328, 418), Offset(290, 488), Offset(252, 558)],
    '39-55': [Offset(360, 415), Offset(312, 462), Offset(262, 508)],
  };
}

/// Singleton instance for convenient access
const geometricLayout = GeometricBodygraphLayout();
