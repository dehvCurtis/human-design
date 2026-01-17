import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../domain/models/human_design_chart.dart';
import 'bodygraph_data.dart';
import 'bodygraph_painter.dart';

/// Interactive Human Design bodygraph widget
class BodygraphWidget extends StatefulWidget {
  const BodygraphWidget({
    super.key,
    required this.chart,
    this.onCenterTap,
    this.onGateTap,
    this.onChannelTap,
    this.showGateNumbers = true,
    this.interactive = true,
  });

  final HumanDesignChart chart;
  final void Function(HumanDesignCenter center)? onCenterTap;
  final void Function(int gateNumber)? onGateTap;
  final void Function(String channelId)? onChannelTap;
  final bool showGateNumbers;
  final bool interactive;

  @override
  State<BodygraphWidget> createState() => _BodygraphWidgetState();
}

class _BodygraphWidgetState extends State<BodygraphWidget>
    with SingleTickerProviderStateMixin {
  BodygraphElement? _selectedElement;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
                  selectedElement: _selectedElement,
                  showGateNumbers: widget.showGateNumbers,
                  animationValue: _animation.value,
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
    final scale = (size.width / 400).clamp(0.0, size.height / 600);
    final offsetX = (size.width - 400 * scale) / 2;
    final offsetY = (size.height - 600 * scale) / 2;

    // Convert tap position to bodygraph coordinates
    final bodygraphX = (localPosition.dx - offsetX) / scale;
    final bodygraphY = (localPosition.dy - offsetY) / scale;

    // Check gates first (smallest hit targets)
    for (final entry in gatePositions.entries) {
      final gateNumber = entry.key;
      final position = entry.value;
      final distance = _distance(bodygraphX, bodygraphY, position.x, position.y);

      if (distance <= 15) {
        setState(() {
          _selectedElement = GateElement(gateNumber);
        });
        widget.onGateTap?.call(gateNumber);
        return;
      }
    }

    // Check centers
    for (final entry in centerPositions.entries) {
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

    // Check channels (check if tap is near any channel line)
    for (final channelActivation in widget.chart.activeChannels) {
      final channelId = channelActivation.channel.id;
      final path = channelPaths[channelId];
      if (path == null) continue;

      if (_isNearPath(bodygraphX, bodygraphY, path, threshold: 10)) {
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
    final halfWidth = position.width / 2 + 5; // Add padding
    final halfHeight = position.height / 2 + 5;

    return (x - position.x).abs() <= halfWidth &&
        (y - position.y).abs() <= halfHeight;
  }

  bool _isNearPath(double x, double y, List<Offset> path,
      {double threshold = 8}) {
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
      double px, double py, double x1, double y1, double x2, double y2) {
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
}
