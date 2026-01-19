import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../domain/models/human_design_chart.dart';
import 'bodygraph_data.dart';
import 'bodygraph_painter.dart';

/// Interactive Human Design bodygraph widget
///
/// Supports two layout options:
/// - Standard: Traditional mybodygraph.com style layout
/// - Geometric: Clean modern layout with parallel lines
class BodygraphWidget extends StatefulWidget {
  const BodygraphWidget({
    super.key,
    required this.chart,
    this.layoutType = BodygraphLayoutType.standard,
    this.onCenterTap,
    this.onGateTap,
    this.onChannelTap,
    this.showGateNumbers = true,
    this.showInactiveGates = true,
    this.showInactiveChannels = true,
    this.interactive = true,
    this.drawBody = false,
  });

  /// The Human Design chart data to display
  final HumanDesignChart chart;

  /// The layout type to use for rendering
  final BodygraphLayoutType layoutType;

  /// Callback when a center is tapped
  final void Function(HumanDesignCenter center)? onCenterTap;

  /// Callback when a gate is tapped
  final void Function(int gateNumber)? onGateTap;

  /// Callback when a channel is tapped
  final void Function(String channelId)? onChannelTap;

  /// Whether to show gate numbers on active gates
  final bool showGateNumbers;

  /// Whether to show inactive gates
  final bool showInactiveGates;

  /// Whether to show inactive channels
  final bool showInactiveChannels;

  /// Whether the widget responds to taps
  final bool interactive;

  /// Whether to draw the body silhouette behind the bodygraph
  final bool drawBody;

  @override
  State<BodygraphWidget> createState() => _BodygraphWidgetState();
}

class _BodygraphWidgetState extends State<BodygraphWidget>
    with SingleTickerProviderStateMixin {
  BodygraphElement? _selectedElement;
  late AnimationController _animationController;
  late Animation<double> _animation;

  /// Get the current layout based on layoutType
  BodygraphLayout get _layout => getLayout(widget.layoutType);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BodygraphWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate when chart changes
    if (oldWidget.chart != widget.chart) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: widget.interactive ? _handleTap : null,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: BodygraphPainter(
                  chart: widget.chart,
                  layout: _layout,
                  selectedElement: _selectedElement,
                  showGateNumbers: widget.showGateNumbers,
                  showInactiveGates: widget.showInactiveGates,
                  showInactiveChannels: widget.showInactiveChannels,
                  animationValue: _animation.value,
                  drawBody: widget.drawBody,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _handleTap(TapDownDetails details) {
    final localPosition = details.localPosition;
    final size = context.size;
    if (size == null) return;

    // Calculate scale factor used by painter
    final scale = math.min(
      size.width / bodygraphCanvasWidth,
      size.height / bodygraphCanvasHeight,
    );
    final offsetX = (size.width - bodygraphCanvasWidth * scale) / 2;
    final offsetY = (size.height - bodygraphCanvasHeight * scale) / 2;

    // Convert tap position to bodygraph coordinates
    final bodygraphX = (localPosition.dx - offsetX) / scale;
    final bodygraphY = (localPosition.dy - offsetY) / scale;

    // Check gates first (smallest hit targets)
    for (final entry in _layout.gatePositions.entries) {
      final gateNumber = entry.key;
      final position = entry.value;
      final distance = _distance(bodygraphX, bodygraphY, position.x, position.y);

      if (distance <= gateHitTestRadius) {
        setState(() {
          _selectedElement = GateElement(gateNumber);
        });
        widget.onGateTap?.call(gateNumber);
        return;
      }
    }

    // Check centers
    for (final entry in _layout.centerPositions.entries) {
      final center = entry.key;
      final position = entry.value;

      if (_isInCenter(bodygraphX, bodygraphY, position)) {
        setState(() {
          _selectedElement = CenterElement(center);
        });
        widget.onCenterTap?.call(center);
        return;
      }
    }

    // Check channels (check if tap is near any active channel line)
    for (final channelActivation in widget.chart.activeChannels) {
      final channel = channelActivation.channel;
      final channelId = channel.id;
      final path = _layout.getChannelPath(channel.gate1, channel.gate2);
      if (path.isEmpty) continue;

      if (_isNearPath(bodygraphX, bodygraphY, path, threshold: channelHitTestThreshold)) {
        setState(() {
          _selectedElement = ChannelElement(channelId);
        });
        widget.onChannelTap?.call(channelId);
        return;
      }
    }

    // Clear selection if tapped on empty space
    setState(() {
      _selectedElement = null;
    });
  }

  double _distance(double x1, double y1, double x2, double y2) {
    final dx = x1 - x2;
    final dy = y1 - y2;
    return math.sqrt(dx * dx + dy * dy);
  }

  bool _isInCenter(double x, double y, CenterPosition position) {
    final halfWidth = position.width / 2 + centerHitTestPadding;
    final halfHeight = position.height / 2 + centerHitTestPadding;

    return (x - position.x).abs() <= halfWidth &&
        (y - position.y).abs() <= halfHeight;
  }

  bool _isNearPath(double x, double y, List<Offset> path, {double threshold = 8}) {
    for (int i = 0; i < path.length - 1; i++) {
      final p1 = path[i];
      final p2 = path[i + 1];

      final distance = _pointToLineDistance(x, y, p1.dx, p1.dy, p2.dx, p2.dy);
      if (distance <= threshold) {
        return true;
      }
    }
    return false;
  }

  double _pointToLineDistance(
    double px,
    double py,
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    final lengthSquared = dx * dx + dy * dy;

    if (lengthSquared == 0) {
      return _distance(px, py, x1, y1);
    }

    var t = ((px - x1) * dx + (py - y1) * dy) / lengthSquared;
    t = t.clamp(0.0, 1.0);

    final nearestX = x1 + t * dx;
    final nearestY = y1 + t * dy;

    return _distance(px, py, nearestX, nearestY);
  }

  /// Clear the current selection
  void clearSelection() {
    setState(() {
      _selectedElement = null;
    });
  }

  /// Select a specific gate
  void selectGate(int gateNumber) {
    setState(() {
      _selectedElement = GateElement(gateNumber);
    });
  }

  /// Select a specific center
  void selectCenter(HumanDesignCenter center) {
    setState(() {
      _selectedElement = CenterElement(center);
    });
  }

  /// Select a specific channel
  void selectChannel(String channelId) {
    setState(() {
      _selectedElement = ChannelElement(channelId);
    });
  }

  /// Get the currently selected element
  BodygraphElement? get selectedElement => _selectedElement;
}

/// Widget that displays a comparison between two bodygraph layouts
class BodygraphLayoutComparison extends StatelessWidget {
  const BodygraphLayoutComparison({
    super.key,
    required this.chart,
    this.showLabels = true,
  });

  final HumanDesignChart chart;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              if (showLabels)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Standard Layout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              Expanded(
                child: BodygraphWidget(
                  chart: chart,
                  layoutType: BodygraphLayoutType.standard,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              if (showLabels)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Geometric Layout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              Expanded(
                child: BodygraphWidget(
                  chart: chart,
                  layoutType: BodygraphLayoutType.geometric,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
