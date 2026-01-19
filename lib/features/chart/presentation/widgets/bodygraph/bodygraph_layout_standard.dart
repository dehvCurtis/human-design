import 'dart:ui';

import '../../../../../core/constants/human_design_constants.dart';
import 'bodygraph_layout.dart';

/// Standard mybodygraph.com style layout
///
/// Gates are positioned ON THE EDGES of center shapes where channels connect.
/// Channels flow naturally between gates without crossing.
///
/// Canvas: 400x600 pixels
class StandardBodygraphLayout extends BodygraphLayout {
  const StandardBodygraphLayout();

  @override
  BodygraphLayoutType get layoutType => BodygraphLayoutType.standard;

  @override
  Map<HumanDesignCenter, CenterPosition> get centerPositions => _centerPositions;

  @override
  Map<int, GatePosition> get gatePositions => _gatePositions;

  @override
  List<Offset> getChannelPath(int gate1, int gate2) {
    // Get gate positions and draw path between them
    final pos1 = _gatePositions[gate1];
    final pos2 = _gatePositions[gate2];
    if (pos1 == null || pos2 == null) return [];

    // Check for custom routing paths
    final id = gate1 < gate2 ? '$gate1-$gate2' : '$gate2-$gate1';
    final customPath = _customChannelPaths[id];
    if (customPath != null) return customPath;

    // Default: straight line between gate positions
    return [pos1.position, pos2.position];
  }

  /// Get all channel paths including generated ones
  @override
  Map<String, List<Offset>> get allChannelPaths {
    final paths = <String, List<Offset>>{};
    for (final channel in channels) {
      final path = getChannelPath(channel.gate1, channel.gate2);
      if (path.isNotEmpty) {
        paths[channel.id] = path;
      }
    }
    return paths;
  }

  // ============================================================
  // CENTER POSITIONS - Equilateral triangles, equal-sided squares/diamonds
  // For triangles: width = side length, height is auto-calculated
  // ============================================================
  static const Map<HumanDesignCenter, CenterPosition> _centerPositions = {
    // HEAD - Equilateral triangle pointing UP
    HumanDesignCenter.head: CenterPosition(
      center: HumanDesignCenter.head,
      x: 200,
      y: 48,
      width: 70,  // base width
      height: 60, // equilateral height (width * 0.866)
      shape: CenterShape.triangle,
    ),
    // AJNA - Equilateral triangle pointing DOWN
    HumanDesignCenter.ajna: CenterPosition(
      center: HumanDesignCenter.ajna,
      x: 200,
      y: 125,
      width: 70,  // base width
      height: 60, // equilateral height (width * 0.866)
      shape: CenterShape.triangle,
    ),
    // THROAT - Square (equal sides)
    HumanDesignCenter.throat: CenterPosition(
      center: HumanDesignCenter.throat,
      x: 200,
      y: 210,
      width: 60,
      height: 60,
      shape: CenterShape.square,
    ),
    // G CENTER - Heart shape (Self/Identity center)
    HumanDesignCenter.g: CenterPosition(
      center: HumanDesignCenter.g,
      x: 200,
      y: 310,
      width: 70,
      height: 70,
      shape: CenterShape.heart,
    ),
    // HEART/EGO - Obtuse triangle pointing UP (wider base, non-equilateral)
    // Positioned closer to G center
    HumanDesignCenter.heart: CenterPosition(
      center: HumanDesignCenter.heart,
      x: 275,
      y: 330,
      width: 80,  // wider base (bottom)
      height: 30, // shorter height for obtuse triangle
      shape: CenterShape.triangle,
    ),
    // SPLEEN - Equilateral triangle pointing RIGHT
    HumanDesignCenter.spleen: CenterPosition(
      center: HumanDesignCenter.spleen,
      x: 90,
      y: 400,
      width: 56,  // equilateral width (height * 0.866)
      height: 65, // base height
      shape: CenterShape.triangle,
    ),
    // SACRAL - Square (equal sides)
    HumanDesignCenter.sacral: CenterPosition(
      center: HumanDesignCenter.sacral,
      x: 200,
      y: 430,
      width: 60,
      height: 60,
      shape: CenterShape.square,
    ),
    // SOLAR PLEXUS - Equilateral triangle pointing LEFT
    HumanDesignCenter.solarPlexus: CenterPosition(
      center: HumanDesignCenter.solarPlexus,
      x: 310,
      y: 400,
      width: 56,  // equilateral width (height * 0.866)
      height: 65, // base height
      shape: CenterShape.triangle,
    ),
    // ROOT - Square (equal sides)
    HumanDesignCenter.root: CenterPosition(
      center: HumanDesignCenter.root,
      x: 200,
      y: 545,
      width: 60,
      height: 60,
      shape: CenterShape.square,
    ),
  };

  // ============================================================
  // GATE POSITIONS - On edges of centers where channels connect
  // ============================================================
  static const Map<int, GatePosition> _gatePositions = {
    // ============================================
    // HEAD CENTER GATES (3 gates on bottom edge)
    // Connects down to Ajna
    // ============================================
    64: GatePosition(gate: 64, center: HumanDesignCenter.head, x: 180, y: 78), // Left - to 47 (aligned with 17)
    61: GatePosition(gate: 61, center: HumanDesignCenter.head, x: 200, y: 78), // Center - to 24
    63: GatePosition(gate: 63, center: HumanDesignCenter.head, x: 220, y: 78), // Right - to 4 (aligned with 11)

    // ============================================
    // AJNA CENTER GATES (6 gates)
    // Triangle pointing DOWN - top edge to Head, slanted edges to Throat
    // ============================================
    // Top edge (connecting UP to Head)
    47: GatePosition(gate: 47, center: HumanDesignCenter.ajna, x: 180, y: 100), // to 64 (aligned)
    24: GatePosition(gate: 24, center: HumanDesignCenter.ajna, x: 200, y: 100), // to 61 (aligned)
    4: GatePosition(gate: 4, center: HumanDesignCenter.ajna, x: 220, y: 100),   // to 63 (aligned)
    // Left slanted edge (connecting DOWN-LEFT to Throat)
    17: GatePosition(gate: 17, center: HumanDesignCenter.ajna, x: 180, y: 125), // LEFT edge - to 62 (aligned with 64)
    // Bottom point (connecting DOWN to Throat center)
    43: GatePosition(gate: 43, center: HumanDesignCenter.ajna, x: 200, y: 148), // BOTTOM point - to 23
    // Right slanted edge (connecting DOWN-RIGHT to Throat)
    11: GatePosition(gate: 11, center: HumanDesignCenter.ajna, x: 220, y: 125), // RIGHT edge - to 56 (aligned with 63)

    // ============================================
    // THROAT CENTER GATES (11 gates around edges)
    // Connects to Ajna (top), G (bottom), Spleen (left), Heart (right), Solar Plexus (right)
    // ============================================
    // Top edge (connecting UP to Ajna)
    62: GatePosition(gate: 62, center: HumanDesignCenter.throat, x: 180, y: 180), // to 17 - aligned with 64
    23: GatePosition(gate: 23, center: HumanDesignCenter.throat, x: 200, y: 180), // to 43 (center)
    56: GatePosition(gate: 56, center: HumanDesignCenter.throat, x: 220, y: 180), // to 11 - aligned with 63
    // Left edge (connecting to Spleen/G)
    16: GatePosition(gate: 16, center: HumanDesignCenter.throat, x: 170, y: 195), // to 48 (Spleen)
    20: GatePosition(gate: 20, center: HumanDesignCenter.throat, x: 170, y: 210), // to 57 (Spleen), 34 (Sacral), 10 (G)
    // Right edge (connecting to Heart/Solar Plexus)
    35: GatePosition(gate: 35, center: HumanDesignCenter.throat, x: 230, y: 195), // to 36 (Solar Plexus)
    12: GatePosition(gate: 12, center: HumanDesignCenter.throat, x: 230, y: 210), // to 22 (Solar Plexus)
    // Bottom edge (connecting DOWN to G) - aligned with bottom of square y: 240
    31: GatePosition(gate: 31, center: HumanDesignCenter.throat, x: 180, y: 240), // to 7 (G)
    8: GatePosition(gate: 8, center: HumanDesignCenter.throat, x: 200, y: 240),   // to 1 (G)
    33: GatePosition(gate: 33, center: HumanDesignCenter.throat, x: 220, y: 240), // to 13 (G)
    45: GatePosition(gate: 45, center: HumanDesignCenter.throat, x: 230, y: 240), // to 21 (Heart) - bottom right

    // ============================================
    // G CENTER GATES (8 gates around diamond)
    // Connects to Throat (top), Heart (right), Spleen (left), Sacral (bottom)
    // ============================================
    // Top points (connecting UP to Throat)
    7: GatePosition(gate: 7, center: HumanDesignCenter.g, x: 180, y: 280),   // to 31
    1: GatePosition(gate: 1, center: HumanDesignCenter.g, x: 200, y: 278),   // to 8
    13: GatePosition(gate: 13, center: HumanDesignCenter.g, x: 220, y: 280), // to 33
    // Right side (connecting to Heart)
    25: GatePosition(gate: 25, center: HumanDesignCenter.g, x: 228, y: 300), // to 51 (Heart)
    // Left corner (connecting to Spleen)
    10: GatePosition(gate: 10, center: HumanDesignCenter.g, x: 165, y: 310), // to 57 (Spleen), 20 (Throat), 34 (Sacral) - left point of diamond
    // Bottom points (connecting DOWN to Sacral)
    15: GatePosition(gate: 15, center: HumanDesignCenter.g, x: 180, y: 328), // to 5 (Sacral)
    46: GatePosition(gate: 46, center: HumanDesignCenter.g, x: 200, y: 332), // to 29 (Sacral)
    2: GatePosition(gate: 2, center: HumanDesignCenter.g, x: 220, y: 328),   // to 14 (Sacral)

    // ============================================
    // HEART/EGO CENTER GATES (4 gates)
    // Heart at (275, 330), obtuse triangle pointing UP, width 80, height 30
    // 21 at top tip, 51 middle of left side, 26 bottom left, 40 bottom right
    // ============================================
    21: GatePosition(gate: 21, center: HumanDesignCenter.heart, x: 275, y: 315), // to 45 (Throat) - TOP TIP
    51: GatePosition(gate: 51, center: HumanDesignCenter.heart, x: 250, y: 330), // to 25 (G) - middle of left side
    26: GatePosition(gate: 26, center: HumanDesignCenter.heart, x: 235, y: 345), // to 44 (Spleen) - bottom left
    40: GatePosition(gate: 40, center: HumanDesignCenter.heart, x: 315, y: 345), // to 37 (Solar Plexus) - bottom right

    // ============================================
    // SPLEEN CENTER GATES (7 gates on triangle edges)
    // Spleen at (90, 400), triangle pointing RIGHT
    // Top edge (going down): 48, 57, 44 -> 50 at right tip
    // Bottom edge: 18, 28, 32 -> 50 at right tip
    // ============================================
    // Top edge: 48 (top-left) -> 57 -> 44 -> 50 (right tip)
    48: GatePosition(gate: 48, center: HumanDesignCenter.spleen, x: 62, y: 368),  // to 16 (Throat) - TOP LEFT
    57: GatePosition(gate: 57, center: HumanDesignCenter.spleen, x: 80, y: 379),  // to 20 (Throat), 10 (G), 34 (Sacral) - top edge middle
    44: GatePosition(gate: 44, center: HumanDesignCenter.spleen, x: 99, y: 389),  // to 26 (Heart) - top edge 2/3
    // Right tip
    50: GatePosition(gate: 50, center: HumanDesignCenter.spleen, x: 118, y: 400), // to 27 (Sacral) - RIGHT TIP
    // Bottom edge: 18 (bottom-left) -> 28 -> 32 -> 50 (right tip)
    18: GatePosition(gate: 18, center: HumanDesignCenter.spleen, x: 62, y: 432),  // to 58 (Root) - BOTTOM LEFT
    28: GatePosition(gate: 28, center: HumanDesignCenter.spleen, x: 80, y: 421),  // to 38 (Root) - bottom edge middle
    32: GatePosition(gate: 32, center: HumanDesignCenter.spleen, x: 99, y: 411),  // to 54 (Root) - bottom edge 2/3

    // ============================================
    // SACRAL CENTER GATES (9 gates around square)
    // Connects to G (top), Spleen (left), Solar Plexus (right), Root (bottom)
    // ============================================
    // Top edge (connecting UP to G)
    5: GatePosition(gate: 5, center: HumanDesignCenter.sacral, x: 180, y: 395),  // to 15 (G)
    14: GatePosition(gate: 14, center: HumanDesignCenter.sacral, x: 220, y: 395), // to 2 (G)
    29: GatePosition(gate: 29, center: HumanDesignCenter.sacral, x: 200, y: 395), // to 46 (G)
    // Left edge (connecting to Spleen)
    34: GatePosition(gate: 34, center: HumanDesignCenter.sacral, x: 165, y: 410), // to 57 (Spleen), 20 (Throat), 10 (G)
    27: GatePosition(gate: 27, center: HumanDesignCenter.sacral, x: 165, y: 430), // to 50 (Spleen)
    // Right edge (connecting to Solar Plexus) - 80% down right side
    59: GatePosition(gate: 59, center: HumanDesignCenter.sacral, x: 235, y: 435), // to 6 (Solar Plexus)
    // Bottom edge (connecting DOWN to Root) - left to right: 42, 3, 9
    42: GatePosition(gate: 42, center: HumanDesignCenter.sacral, x: 180, y: 445), // to 53 (Root)
    3: GatePosition(gate: 3, center: HumanDesignCenter.sacral, x: 200, y: 445),   // to 60 (Root)
    9: GatePosition(gate: 9, center: HumanDesignCenter.sacral, x: 220, y: 445),   // to 52 (Root)

    // ============================================
    // SOLAR PLEXUS CENTER GATES (7 gates on triangle)
    // Solar Plexus at (310, 400), triangle pointing LEFT
    // Bottom edge sequence (left tip to bottom corner): 6, 49, 55, 30
    // Right edge: 36, 22, 37
    // ============================================
    36: GatePosition(gate: 36, center: HumanDesignCenter.solarPlexus, x: 320, y: 368), // to 35 (Throat) - top right
    22: GatePosition(gate: 22, center: HumanDesignCenter.solarPlexus, x: 338, y: 378), // to 12 (Throat) - upper right
    37: GatePosition(gate: 37, center: HumanDesignCenter.solarPlexus, x: 338, y: 395), // to 40 (Heart) - right side
    // Bottom edge: 6 (left tip) -> 49 -> 55 -> 30 (bottom corner)
    6: GatePosition(gate: 6, center: HumanDesignCenter.solarPlexus, x: 282, y: 400),   // to 59 (Sacral) - LEFT TIP
    49: GatePosition(gate: 49, center: HumanDesignCenter.solarPlexus, x: 298, y: 410), // to 19 (Root) - bottom edge
    55: GatePosition(gate: 55, center: HumanDesignCenter.solarPlexus, x: 314, y: 420), // to 39 (Root) - bottom edge
    30: GatePosition(gate: 30, center: HumanDesignCenter.solarPlexus, x: 330, y: 430), // to 41 (Root) - BOTTOM CORNER

    // ============================================
    // ROOT CENTER GATES (9 gates)
    // Root at (200, 545), square 60x60, so x: 170-230, y: 515-575
    // Left side to Spleen, Top to Sacral, Right side to Solar Plexus
    // ============================================
    // Left side (connecting to Spleen)
    54: GatePosition(gate: 54, center: HumanDesignCenter.root, x: 170, y: 525), // to 32 (Spleen) - left side upper
    38: GatePosition(gate: 38, center: HumanDesignCenter.root, x: 170, y: 545), // to 28 (Spleen) - left side middle
    58: GatePosition(gate: 58, center: HumanDesignCenter.root, x: 170, y: 565), // to 18 (Spleen) - left side lower
    // Top edge (connecting to Sacral) - aligned with Sacral bottom: 42, 3, 9
    53: GatePosition(gate: 53, center: HumanDesignCenter.root, x: 180, y: 515), // to 42 (Sacral) - top left
    60: GatePosition(gate: 60, center: HumanDesignCenter.root, x: 200, y: 515), // to 3 (Sacral) - top center
    52: GatePosition(gate: 52, center: HumanDesignCenter.root, x: 220, y: 515), // to 9 (Sacral) - top right
    // Right side (connecting to Solar Plexus) - 19 second, 39 third, 41 bottom
    19: GatePosition(gate: 19, center: HumanDesignCenter.root, x: 230, y: 538), // to 49 (Solar Plexus) - right second
    39: GatePosition(gate: 39, center: HumanDesignCenter.root, x: 230, y: 556), // to 55 (Solar Plexus) - right third
    41: GatePosition(gate: 41, center: HumanDesignCenter.root, x: 230, y: 570), // to 30 (Solar Plexus) - RIGHT BOTTOM
  };

  // ============================================================
  // CUSTOM CHANNEL PATHS - For routes that need waypoints
  // ============================================================
  static const Map<String, List<Offset>> _customChannelPaths = {
    // Throat to Spleen - needs routing around G center
    '16-48': [
      Offset(170, 195),  // Gate 16 on Throat (left edge)
      Offset(116, 282),  // Waypoint left of G
      Offset(62, 368),   // Gate 48 on Spleen (top tip)
    ],

    // Throat to Heart - routes down to Heart top tip
    '21-45': [
      Offset(230, 240),  // Gate 45 on Throat (bottom right)
      Offset(252, 278),  // Waypoint
      Offset(275, 315),  // Gate 21 on Heart (TOP TIP)
    ],

    // Throat to Solar Plexus - diagonal routes
    '12-22': [
      Offset(230, 210),  // Gate 12 on Throat (right edge)
      Offset(272, 288),  // Waypoint
      Offset(315, 365),  // Gate 22 on Solar Plexus
    ],
    '35-36': [
      Offset(230, 195),  // Gate 35 on Throat (right edge)
      Offset(262, 280),  // Waypoint
      Offset(295, 365),  // Gate 36 on Solar Plexus
    ],

    // Integration channels (10-20-34-57) - vertical spine
    '10-20': [
      Offset(170, 210),  // Gate 20 on Throat (left edge)
      Offset(168, 260),  // Waypoint
      Offset(165, 310),  // Gate 10 on G (left corner)
    ],
    '10-34': [
      Offset(165, 310),  // Gate 10 on G (left corner)
      Offset(165, 360),  // Waypoint
      Offset(165, 410),  // Gate 34 on Sacral
    ],
    '10-57': [
      Offset(165, 310),  // Gate 10 on G (left corner)
      Offset(122, 345),  // Waypoint
      Offset(80, 379),   // Gate 57 on Spleen
    ],
    '20-34': [
      Offset(170, 210),  // Gate 20 on Throat (left edge)
      Offset(168, 310),  // Waypoint
      Offset(165, 410),  // Gate 34 on Sacral
    ],
    '20-57': [
      Offset(170, 210),  // Gate 20 on Throat (left edge)
      Offset(125, 295),  // Waypoint
      Offset(80, 379),   // Gate 57 on Spleen
    ],
    '34-57': [
      Offset(165, 410),  // Gate 34 on Sacral
      Offset(122, 395),  // Waypoint
      Offset(80, 379),   // Gate 57 on Spleen
    ],

    // G to Heart
    '25-51': [
      Offset(228, 300),  // Gate 25 on G
      Offset(239, 315),  // Waypoint
      Offset(250, 330),  // Gate 51 on Heart (middle of left side)
    ],

    // Heart to Spleen - crosses middle
    '26-44': [
      Offset(235, 345),  // Gate 26 on Heart (bottom left)
      Offset(167, 367),  // Waypoint below G
      Offset(99, 389),   // Gate 44 on Spleen
    ],

    // Heart to Solar Plexus
    '37-40': [
      Offset(315, 345),  // Gate 40 on Heart (bottom right)
      Offset(327, 368),  // Waypoint
      Offset(338, 390),  // Gate 37 on Solar Plexus
    ],
  };
}

/// Singleton instance for convenient access
const standardLayout = StandardBodygraphLayout();
