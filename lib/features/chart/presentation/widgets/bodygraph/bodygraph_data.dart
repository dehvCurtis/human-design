import 'dart:ui';

import '../../../../../core/constants/human_design_constants.dart';

/// Visual positioning data for the bodygraph
/// All coordinates are relative to a 400x600 canvas

/// Center positions on the bodygraph
const Map<HumanDesignCenter, CenterPosition> centerPositions = {
  HumanDesignCenter.head: CenterPosition(
    center: HumanDesignCenter.head,
    x: 200,
    y: 45,
    width: 60,
    height: 50,
    shape: CenterShape.triangle,
  ),
  HumanDesignCenter.ajna: CenterPosition(
    center: HumanDesignCenter.ajna,
    x: 200,
    y: 115,
    width: 60,
    height: 50,
    shape: CenterShape.triangle,
  ),
  HumanDesignCenter.throat: CenterPosition(
    center: HumanDesignCenter.throat,
    x: 200,
    y: 195,
    width: 50,
    height: 50,
    shape: CenterShape.square,
  ),
  HumanDesignCenter.g: CenterPosition(
    center: HumanDesignCenter.g,
    x: 200,
    y: 295,
    width: 55,
    height: 55,
    shape: CenterShape.diamond,
  ),
  HumanDesignCenter.heart: CenterPosition(
    center: HumanDesignCenter.heart,
    x: 115,
    y: 280,
    width: 40,
    height: 40,
    shape: CenterShape.triangle,
  ),
  HumanDesignCenter.spleen: CenterPosition(
    center: HumanDesignCenter.spleen,
    x: 85,
    y: 380,
    width: 50,
    height: 50,
    shape: CenterShape.triangle,
  ),
  HumanDesignCenter.sacral: CenterPosition(
    center: HumanDesignCenter.sacral,
    x: 200,
    y: 400,
    width: 50,
    height: 50,
    shape: CenterShape.square,
  ),
  HumanDesignCenter.solarPlexus: CenterPosition(
    center: HumanDesignCenter.solarPlexus,
    x: 315,
    y: 380,
    width: 50,
    height: 50,
    shape: CenterShape.triangle,
  ),
  HumanDesignCenter.root: CenterPosition(
    center: HumanDesignCenter.root,
    x: 200,
    y: 520,
    width: 50,
    height: 50,
    shape: CenterShape.square,
  ),
};

/// Gate positions around each center
/// Gates are positioned as small circles around their parent center
const Map<int, GatePosition> gatePositions = {
  // Head Center gates
  64: GatePosition(gate: 64, center: HumanDesignCenter.head, x: 180, y: 20),
  61: GatePosition(gate: 61, center: HumanDesignCenter.head, x: 200, y: 20),
  63: GatePosition(gate: 63, center: HumanDesignCenter.head, x: 220, y: 20),

  // Ajna Center gates
  47: GatePosition(gate: 47, center: HumanDesignCenter.ajna, x: 175, y: 95),
  24: GatePosition(gate: 24, center: HumanDesignCenter.ajna, x: 195, y: 90),
  4: GatePosition(gate: 4, center: HumanDesignCenter.ajna, x: 215, y: 95),
  17: GatePosition(gate: 17, center: HumanDesignCenter.ajna, x: 175, y: 140),
  43: GatePosition(gate: 43, center: HumanDesignCenter.ajna, x: 195, y: 145),
  11: GatePosition(gate: 11, center: HumanDesignCenter.ajna, x: 215, y: 140),

  // Throat Center gates
  62: GatePosition(gate: 62, center: HumanDesignCenter.throat, x: 165, y: 175),
  23: GatePosition(gate: 23, center: HumanDesignCenter.throat, x: 180, y: 170),
  56: GatePosition(gate: 56, center: HumanDesignCenter.throat, x: 220, y: 170),
  16: GatePosition(gate: 16, center: HumanDesignCenter.throat, x: 235, y: 175),
  20: GatePosition(gate: 20, center: HumanDesignCenter.throat, x: 165, y: 195),
  35: GatePosition(gate: 35, center: HumanDesignCenter.throat, x: 235, y: 195),
  12: GatePosition(gate: 12, center: HumanDesignCenter.throat, x: 250, y: 205),
  45: GatePosition(gate: 45, center: HumanDesignCenter.throat, x: 150, y: 205),
  31: GatePosition(gate: 31, center: HumanDesignCenter.throat, x: 165, y: 220),
  8: GatePosition(gate: 8, center: HumanDesignCenter.throat, x: 185, y: 225),
  33: GatePosition(gate: 33, center: HumanDesignCenter.throat, x: 215, y: 225),
  7: GatePosition(gate: 7, center: HumanDesignCenter.throat, x: 235, y: 220),

  // G Center gates
  1: GatePosition(gate: 1, center: HumanDesignCenter.g, x: 180, y: 265),
  13: GatePosition(gate: 13, center: HumanDesignCenter.g, x: 200, y: 260),
  25: GatePosition(gate: 25, center: HumanDesignCenter.g, x: 220, y: 265),
  10: GatePosition(gate: 10, center: HumanDesignCenter.g, x: 160, y: 285),
  2: GatePosition(gate: 2, center: HumanDesignCenter.g, x: 240, y: 285),
  15: GatePosition(gate: 15, center: HumanDesignCenter.g, x: 160, y: 310),
  46: GatePosition(gate: 46, center: HumanDesignCenter.g, x: 200, y: 330),

  // Heart/Ego Center gates
  21: GatePosition(gate: 21, center: HumanDesignCenter.heart, x: 130, y: 255),
  26: GatePosition(gate: 26, center: HumanDesignCenter.heart, x: 100, y: 270),
  51: GatePosition(gate: 51, center: HumanDesignCenter.heart, x: 130, y: 295),
  40: GatePosition(gate: 40, center: HumanDesignCenter.heart, x: 100, y: 295),

  // Spleen Center gates
  48: GatePosition(gate: 48, center: HumanDesignCenter.spleen, x: 65, y: 355),
  57: GatePosition(gate: 57, center: HumanDesignCenter.spleen, x: 55, y: 380),
  44: GatePosition(gate: 44, center: HumanDesignCenter.spleen, x: 70, y: 350),
  50: GatePosition(gate: 50, center: HumanDesignCenter.spleen, x: 110, y: 395),
  32: GatePosition(gate: 32, center: HumanDesignCenter.spleen, x: 65, y: 410),
  28: GatePosition(gate: 28, center: HumanDesignCenter.spleen, x: 55, y: 405),
  18: GatePosition(gate: 18, center: HumanDesignCenter.spleen, x: 90, y: 420),

  // Sacral Center gates
  5: GatePosition(gate: 5, center: HumanDesignCenter.sacral, x: 175, y: 380),
  14: GatePosition(gate: 14, center: HumanDesignCenter.sacral, x: 185, y: 375),
  29: GatePosition(gate: 29, center: HumanDesignCenter.sacral, x: 215, y: 375),
  34: GatePosition(gate: 34, center: HumanDesignCenter.sacral, x: 160, y: 395),
  9: GatePosition(gate: 9, center: HumanDesignCenter.sacral, x: 175, y: 420),
  3: GatePosition(gate: 3, center: HumanDesignCenter.sacral, x: 225, y: 420),
  42: GatePosition(gate: 42, center: HumanDesignCenter.sacral, x: 235, y: 405),
  27: GatePosition(gate: 27, center: HumanDesignCenter.sacral, x: 140, y: 410),
  59: GatePosition(gate: 59, center: HumanDesignCenter.sacral, x: 260, y: 395),

  // Solar Plexus Center gates
  36: GatePosition(gate: 36, center: HumanDesignCenter.solarPlexus, x: 290, y: 355),
  22: GatePosition(gate: 22, center: HumanDesignCenter.solarPlexus, x: 320, y: 355),
  37: GatePosition(gate: 37, center: HumanDesignCenter.solarPlexus, x: 340, y: 375),
  6: GatePosition(gate: 6, center: HumanDesignCenter.solarPlexus, x: 280, y: 380),
  49: GatePosition(gate: 49, center: HumanDesignCenter.solarPlexus, x: 340, y: 395),
  55: GatePosition(gate: 55, center: HumanDesignCenter.solarPlexus, x: 330, y: 410),
  30: GatePosition(gate: 30, center: HumanDesignCenter.solarPlexus, x: 300, y: 415),

  // Root Center gates
  53: GatePosition(gate: 53, center: HumanDesignCenter.root, x: 160, y: 495),
  60: GatePosition(gate: 60, center: HumanDesignCenter.root, x: 180, y: 500),
  52: GatePosition(gate: 52, center: HumanDesignCenter.root, x: 175, y: 545),
  19: GatePosition(gate: 19, center: HumanDesignCenter.root, x: 240, y: 495),
  39: GatePosition(gate: 39, center: HumanDesignCenter.root, x: 260, y: 505),
  41: GatePosition(gate: 41, center: HumanDesignCenter.root, x: 250, y: 545),
  58: GatePosition(gate: 58, center: HumanDesignCenter.root, x: 145, y: 520),
  38: GatePosition(gate: 38, center: HumanDesignCenter.root, x: 135, y: 510),
  54: GatePosition(gate: 54, center: HumanDesignCenter.root, x: 155, y: 540),
};

/// Channel path data for drawing connections between gates
/// Each channel has a list of points defining its path
const Map<String, List<Offset>> channelPaths = {
  // Head to Ajna
  '64-47': [Offset(180, 35), Offset(175, 95)],
  '61-24': [Offset(200, 35), Offset(195, 90)],
  '63-4': [Offset(220, 35), Offset(215, 95)],

  // Ajna to Throat
  '17-62': [Offset(175, 145), Offset(165, 175)],
  '43-23': [Offset(195, 150), Offset(180, 170)],
  '11-56': [Offset(215, 145), Offset(220, 170)],

  // Throat to G
  '31-7': [Offset(165, 225), Offset(180, 260), Offset(200, 265)],
  '8-1': [Offset(185, 230), Offset(180, 265)],
  '33-13': [Offset(215, 230), Offset(200, 265)],

  // G to Sacral
  '2-14': [Offset(220, 310), Offset(215, 375)],
  '46-29': [Offset(200, 335), Offset(215, 375)],
  '15-5': [Offset(160, 315), Offset(175, 380)],
  '10-34': [Offset(160, 290), Offset(160, 395)],
  '10-20': [Offset(160, 285), Offset(165, 200)],
  '10-57': [Offset(155, 290), Offset(55, 385)],

  // Throat connections
  '20-34': [Offset(165, 200), Offset(160, 395)],
  '20-57': [Offset(160, 200), Offset(55, 385)],
  '35-36': [Offset(240, 200), Offset(290, 360)],
  '12-22': [Offset(255, 210), Offset(320, 360)],
  '45-21': [Offset(148, 210), Offset(130, 260)],
  '16-48': [Offset(240, 180), Offset(65, 360)],

  // Heart connections
  '26-44': [Offset(100, 275), Offset(70, 355)],
  '51-25': [Offset(135, 300), Offset(180, 270)],
  '21-45': [Offset(130, 260), Offset(148, 210)],
  '40-37': [Offset(100, 300), Offset(340, 380)],

  // Spleen connections
  '57-34': [Offset(60, 390), Offset(160, 400)],
  '57-10': [Offset(55, 385), Offset(155, 290)],
  '44-26': [Offset(70, 355), Offset(100, 275)],
  '48-16': [Offset(65, 360), Offset(240, 180)],
  '50-27': [Offset(115, 400), Offset(140, 415)],
  '32-54': [Offset(65, 415), Offset(155, 545)],
  '28-38': [Offset(55, 410), Offset(135, 515)],
  '18-58': [Offset(90, 425), Offset(145, 525)],

  // Sacral connections
  '27-50': [Offset(140, 415), Offset(115, 400)],
  '59-6': [Offset(265, 400), Offset(285, 385)],
  '9-52': [Offset(175, 425), Offset(175, 550)],
  '3-60': [Offset(225, 425), Offset(180, 505)],
  '42-53': [Offset(235, 410), Offset(160, 500)],

  // Solar Plexus connections
  '37-40': [Offset(345, 380), Offset(100, 300)],
  '6-59': [Offset(285, 385), Offset(265, 400)],
  '49-19': [Offset(345, 400), Offset(245, 500)],
  '55-39': [Offset(335, 415), Offset(265, 510)],
  '30-41': [Offset(305, 420), Offset(255, 550)],

  // Root connections
  '54-32': [Offset(160, 545), Offset(65, 420)],
  '38-28': [Offset(140, 515), Offset(55, 410)],
  '58-18': [Offset(150, 525), Offset(95, 425)],
  '52-9': [Offset(180, 550), Offset(180, 425)],
  '60-3': [Offset(185, 505), Offset(230, 425)],
  '53-42': [Offset(165, 500), Offset(240, 410)],
  '39-55': [Offset(270, 510), Offset(340, 415)],
  '19-49': [Offset(250, 500), Offset(350, 400)],
  '41-30': [Offset(260, 550), Offset(310, 420)],
};

/// Position data for a center
class CenterPosition {
  const CenterPosition({
    required this.center,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.shape,
  });

  final HumanDesignCenter center;
  final double x;
  final double y;
  final double width;
  final double height;
  final CenterShape shape;

  Offset get position => Offset(x, y);
  Size get size => Size(width, height);
  Rect get rect => Rect.fromCenter(center: position, width: width, height: height);
}

/// Shape types for centers
enum CenterShape {
  triangle,
  square,
  diamond,
}

/// Position data for a gate
class GatePosition {
  const GatePosition({
    required this.gate,
    required this.center,
    required this.x,
    required this.y,
  });

  final int gate;
  final HumanDesignCenter center;
  final double x;
  final double y;

  Offset get position => Offset(x, y);
}
