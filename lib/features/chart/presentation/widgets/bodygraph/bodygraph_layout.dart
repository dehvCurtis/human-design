import 'dart:ui';

import '../../../../../core/constants/human_design_constants.dart';

/// Layout type for the bodygraph visualization
enum BodygraphLayoutType {
  /// Traditional mybodygraph.com style layout with organic positioning
  standard,

  /// Clean geometric layout with mathematically computed positions
  geometric,
}

/// Position data for a center in the bodygraph
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
  heart,
  circle,
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

/// Abstract base class for bodygraph layouts
///
/// All coordinates are relative to a 400x600 canvas
abstract class BodygraphLayout {
  const BodygraphLayout();

  /// Canvas dimensions
  static const double canvasWidth = 400;
  static const double canvasHeight = 600;

  /// Get the layout type
  BodygraphLayoutType get layoutType;

  /// Get all center positions
  Map<HumanDesignCenter, CenterPosition> get centerPositions;

  /// Get all gate positions
  Map<int, GatePosition> get gatePositions;

  /// Get channel path between two gates
  /// Returns a list of points defining the path
  List<Offset> getChannelPath(int gate1, int gate2);

  /// Get all channel paths as a map
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

  /// Get gate position by gate number
  GatePosition? getGatePosition(int gateNumber) => gatePositions[gateNumber];

  /// Get center position by center type
  CenterPosition? getCenterPosition(HumanDesignCenter center) => centerPositions[center];

  /// Get gates for a specific center
  List<int> getGatesForCenter(HumanDesignCenter center) {
    return gates.entries
        .where((entry) => entry.value.center == center)
        .map((entry) => entry.key)
        .toList();
  }

  /// Generate a straight line path between two gate positions
  List<Offset> generateStraightPath(Offset from, Offset to) {
    return [from, to];
  }

  /// Generate a path with a midpoint for routing around obstacles
  List<Offset> generateRoutedPath(Offset from, Offset to, Offset midpoint) {
    return [from, midpoint, to];
  }

  /// Calculate the midpoint between two offsets
  static Offset midpoint(Offset a, Offset b) {
    return Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
  }

  /// Calculate offset at an angle from a center point
  static Offset offsetFromAngle(Offset center, double radius, double angleRadians) {
    return Offset(
      center.dx + radius * _cos(angleRadians),
      center.dy + radius * _sin(angleRadians),
    );
  }

  /// Simple cos function to avoid dart:math import in const contexts
  static double _cos(double radians) {
    // Approximation for layout calculations
    return _cosTable[(radians * 100).toInt() % 628] ?? 0.0;
  }

  /// Simple sin function to avoid dart:math import in const contexts
  static double _sin(double radians) {
    return _cosTable[((radians + 1.5708) * 100).toInt() % 628] ?? 0.0;
  }

  static const Map<int, double> _cosTable = {};
}

/// Factory to get a layout instance by type
class BodygraphLayoutFactory {
  static BodygraphLayout? _standardLayout;
  static BodygraphLayout? _geometricLayout;

  /// Get a layout instance by type
  static BodygraphLayout getLayout(BodygraphLayoutType type) {
    switch (type) {
      case BodygraphLayoutType.standard:
        return _standardLayout ??= _createStandardLayout();
      case BodygraphLayoutType.geometric:
        return _geometricLayout ??= _createGeometricLayout();
    }
  }

  static BodygraphLayout _createStandardLayout() {
    // Lazy import to avoid circular dependencies
    return _StandardLayoutProxy();
  }

  static BodygraphLayout _createGeometricLayout() {
    return _GeometricLayoutProxy();
  }

  /// Clear cached layouts (useful for testing)
  static void clearCache() {
    _standardLayout = null;
    _geometricLayout = null;
  }
}

/// Proxy class that defers to the actual standard layout
class _StandardLayoutProxy extends BodygraphLayout {
  late final BodygraphLayout _delegate;
  bool _initialized = false;

  void _ensureInitialized() {
    if (!_initialized) {
      // Will be set by the actual layout implementation
      _initialized = true;
    }
  }

  @override
  BodygraphLayoutType get layoutType => BodygraphLayoutType.standard;

  @override
  Map<HumanDesignCenter, CenterPosition> get centerPositions {
    _ensureInitialized();
    return _delegate.centerPositions;
  }

  @override
  Map<int, GatePosition> get gatePositions {
    _ensureInitialized();
    return _delegate.gatePositions;
  }

  @override
  List<Offset> getChannelPath(int gate1, int gate2) {
    _ensureInitialized();
    return _delegate.getChannelPath(gate1, gate2);
  }

  void setDelegate(BodygraphLayout delegate) {
    _delegate = delegate;
    _initialized = true;
  }
}

/// Proxy class that defers to the actual geometric layout
class _GeometricLayoutProxy extends BodygraphLayout {
  late final BodygraphLayout _delegate;
  bool _initialized = false;

  void _ensureInitialized() {
    if (!_initialized) {
      _initialized = true;
    }
  }

  @override
  BodygraphLayoutType get layoutType => BodygraphLayoutType.geometric;

  @override
  Map<HumanDesignCenter, CenterPosition> get centerPositions {
    _ensureInitialized();
    return _delegate.centerPositions;
  }

  @override
  Map<int, GatePosition> get gatePositions {
    _ensureInitialized();
    return _delegate.gatePositions;
  }

  @override
  List<Offset> getChannelPath(int gate1, int gate2) {
    _ensureInitialized();
    return _delegate.getChannelPath(gate1, gate2);
  }

  void setDelegate(BodygraphLayout delegate) {
    _delegate = delegate;
    _initialized = true;
  }
}
