// Bodygraph visualization data and layout exports
//
// This file provides the coordinate system and layout options for
// rendering the Human Design bodygraph.
//
// Two layout options are available:
// - Standard: Traditional mybodygraph.com style layout
// - Geometric: Clean modern layout with parallel lines

import 'dart:ui';

import '../../../../../core/constants/human_design_constants.dart';
import 'bodygraph_layout.dart';
import 'bodygraph_layout_geometric.dart';
import 'bodygraph_layout_standard.dart';

// Re-export layout types and classes
export 'bodygraph_layout.dart'
    show
        BodygraphLayout,
        BodygraphLayoutType,
        CenterPosition,
        CenterShape,
        GatePosition;
export 'bodygraph_layout_geometric.dart' show GeometricBodygraphLayout, geometricLayout;
export 'bodygraph_layout_standard.dart' show StandardBodygraphLayout, standardLayout;

/// Default layout type for the bodygraph
const BodygraphLayoutType defaultLayoutType = BodygraphLayoutType.standard;

/// Get a layout instance by type
BodygraphLayout getLayout(BodygraphLayoutType type) {
  switch (type) {
    case BodygraphLayoutType.standard:
      return standardLayout;
    case BodygraphLayoutType.geometric:
      return geometricLayout;
  }
}

/// Convenience accessor for the current layout's center positions
/// Uses standard layout by default
Map<HumanDesignCenter, CenterPosition> get centerPositions => standardLayout.centerPositions;

/// Convenience accessor for the current layout's gate positions
/// Uses standard layout by default
Map<int, GatePosition> get gatePositions => standardLayout.gatePositions;

/// Convenience accessor for channel paths using standard layout
/// Returns paths for all 36 channels
Map<String, List<Offset>> get channelPaths => standardLayout.allChannelPaths;

/// Get channel path for a specific gate pair using standard layout
List<Offset> getChannelPath(int gate1, int gate2) {
  return standardLayout.getChannelPath(gate1, gate2);
}

/// Canvas dimensions for the bodygraph
const double bodygraphCanvasWidth = 400;
const double bodygraphCanvasHeight = 600;

/// Gate radius for rendering
const double gateRadius = 12.0;
const double gateRadiusInactive = 10.0;

/// Center size multipliers
const double centerSizeMultiplier = 1.0;

/// Channel stroke widths
const double channelStrokeWidth = 3.0;
const double channelStrokeWidthActive = 4.0;
const double channelStrokeWidthSelected = 6.0;

/// Hit test thresholds
const double gateHitTestRadius = 15.0;
const double centerHitTestPadding = 5.0;
const double channelHitTestThreshold = 15.0;
