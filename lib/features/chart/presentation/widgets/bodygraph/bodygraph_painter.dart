import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/human_design_chart.dart';
import 'bodygraph_data.dart';

/// Custom painter for drawing the Human Design bodygraph
///
/// Implements layered rendering:
/// 1. Background (optional body silhouette)
/// 2. Inactive channels (all 36 channels in gray)
/// 3. Hanging gates (half-channels for gates without a complete channel)
/// 4. Active channels (user's defined channels with color)
/// 5. Centers (9 centers with defined/undefined styling)
/// 6. Inactive gates (all 64 gates, faded)
/// 7. Active gates (user's defined gates with color)
/// 8. Gate numbers (on active gates)
/// 9. Selection highlight
class BodygraphPainter extends CustomPainter {
  BodygraphPainter({
    required this.chart,
    this.layout,
    this.selectedElement,
    this.showGateNumbers = true,
    this.showInactiveGates = true,
    this.showInactiveChannels = true,
    this.animationValue = 1.0,
    this.drawBody = false,
  });

  final HumanDesignChart chart;
  final BodygraphLayout? layout;
  final BodygraphElement? selectedElement;
  final bool showGateNumbers;
  final bool showInactiveGates;
  final bool showInactiveChannels;
  final double animationValue;
  final bool drawBody;

  /// Get the current layout, defaulting to standard
  BodygraphLayout get _layout => layout ?? standardLayout;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate scale to fit the bodygraph in the available space
    final scale = math.min(size.width / bodygraphCanvasWidth, size.height / bodygraphCanvasHeight);
    canvas.save();

    // Center the bodygraph
    final offsetX = (size.width - bodygraphCanvasWidth * scale) / 2;
    final offsetY = (size.height - bodygraphCanvasHeight * scale) / 2;
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale);

    // Draw layers in order (back to front)
    if (drawBody) {
      _drawBodySilhouette(canvas);
    }

    // Layer 1: All inactive channels
    if (showInactiveChannels) {
      _drawInactiveChannels(canvas);
    }

    // Layer 2: Hanging gates (half-channels for gates without a complete channel)
    _drawHangingGates(canvas);

    // Layer 3: Active channels
    _drawActiveChannels(canvas);

    // Layer 4: Centers (between channels and gates for visual layering)
    _drawCenters(canvas);

    // Layer 5: All inactive gates
    if (showInactiveGates) {
      _drawInactiveGates(canvas);
    }

    // Layer 6: Active gates
    _drawActiveGates(canvas);

    // Layer 7: Gate numbers (on active gates)
    if (showGateNumbers) {
      _drawGateNumbers(canvas);
    }

    // Layer 8: Selection highlight
    _drawSelectionHighlight(canvas);

    canvas.restore();
  }

  /// Draw all 36 channels in inactive (gray) state
  void _drawInactiveChannels(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = channelStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.channelInactive;

    // Get all active channel IDs to skip them
    final activeChannelIds = chart.activeChannels.map((c) => c.channel.id).toSet();

    for (final channel in channels) {
      // Skip if this channel is active (will be drawn in active pass)
      if (activeChannelIds.contains(channel.id)) continue;

      final path = _layout.getChannelPath(channel.gate1, channel.gate2);
      if (path.isEmpty) continue;

      _drawChannelPath(canvas, path, paint);
    }
  }

  /// Draw hanging gates (half-channels for gates that don't complete a channel)
  ///
  /// In Human Design, when only one gate of a channel is activated,
  /// it shows as a "half-line" extending from the center toward the midpoint.
  void _drawHangingGates(Canvas canvas) {
    // Get all gates that are part of complete channels
    final Set<int> gatesInCompleteChannels = {};
    for (final channelActivation in chart.activeChannels) {
      gatesInCompleteChannels.add(channelActivation.channel.gate1);
      gatesInCompleteChannels.add(channelActivation.channel.gate2);
    }

    // Find all activated gates that are NOT part of a complete channel
    final allActivatedGates = {...chart.consciousGates, ...chart.unconsciousGates};
    final hangingGates = allActivatedGates.difference(gatesInCompleteChannels);

    // For each hanging gate, find its channel and draw a half-line
    for (final gateNumber in hangingGates) {
      // Find which channel this gate belongs to
      for (final channel in channels) {
        int? otherGate;
        if (channel.gate1 == gateNumber) {
          otherGate = channel.gate2;
        } else if (channel.gate2 == gateNumber) {
          otherGate = channel.gate1;
        }

        if (otherGate != null) {
          // Get the full channel path
          final fullPath = _layout.getChannelPath(channel.gate1, channel.gate2);
          if (fullPath.length < 2) continue;

          // Determine which end of the path corresponds to our gate
          final gatePos = _layout.gatePositions[gateNumber]?.position;
          if (gatePos == null) continue;

          // Find if our gate is closer to the start or end of the path
          final distToStart = (fullPath.first - gatePos).distance;
          final distToEnd = (fullPath.last - gatePos).distance;

          // Create half-path from the gate's end to the midpoint
          List<Offset> halfPath;
          if (distToStart < distToEnd) {
            // Gate is at the start, draw first half
            halfPath = _getFirstHalfOfPath(fullPath);
          } else {
            // Gate is at the end, draw second half
            halfPath = _getSecondHalfOfPath(fullPath);
          }

          if (halfPath.length < 2) continue;

          // Determine color based on activation type
          final isConscious = chart.consciousGates.contains(gateNumber);
          final isUnconscious = chart.unconsciousGates.contains(gateNumber);

          final paint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = channelStrokeWidthActive
            ..strokeCap = StrokeCap.round;

          if (isConscious && isUnconscious) {
            // Both: draw striped
            _drawStripedChannel(canvas, halfPath);
          } else if (isConscious) {
            paint.color = AppColors.channelConscious;
            _drawChannelPath(canvas, halfPath, paint);
          } else {
            paint.color = AppColors.channelUnconscious;
            _drawChannelPath(canvas, halfPath, paint);
          }
        }
      }
    }
  }

  /// Get the first half of a path (from start to midpoint)
  List<Offset> _getFirstHalfOfPath(List<Offset> fullPath) {
    if (fullPath.length < 2) return fullPath;

    // Calculate total path length
    double totalLength = 0;
    for (int i = 1; i < fullPath.length; i++) {
      totalLength += (fullPath[i] - fullPath[i - 1]).distance;
    }

    // Find midpoint
    final halfLength = totalLength / 2;
    double currentLength = 0;
    final halfPath = <Offset>[fullPath.first];

    for (int i = 1; i < fullPath.length; i++) {
      final segmentLength = (fullPath[i] - fullPath[i - 1]).distance;
      if (currentLength + segmentLength >= halfLength) {
        // Interpolate to exact midpoint
        final remaining = halfLength - currentLength;
        final t = remaining / segmentLength;
        final midpoint = Offset.lerp(fullPath[i - 1], fullPath[i], t)!;
        halfPath.add(midpoint);
        break;
      }
      halfPath.add(fullPath[i]);
      currentLength += segmentLength;
    }

    return halfPath;
  }

  /// Get the second half of a path (from midpoint to end)
  List<Offset> _getSecondHalfOfPath(List<Offset> fullPath) {
    if (fullPath.length < 2) return fullPath;

    // Calculate total path length
    double totalLength = 0;
    for (int i = 1; i < fullPath.length; i++) {
      totalLength += (fullPath[i] - fullPath[i - 1]).distance;
    }

    // Find midpoint
    final halfLength = totalLength / 2;
    double currentLength = 0;
    final halfPath = <Offset>[];

    for (int i = 1; i < fullPath.length; i++) {
      final segmentLength = (fullPath[i] - fullPath[i - 1]).distance;
      if (currentLength + segmentLength >= halfLength && halfPath.isEmpty) {
        // Interpolate to exact midpoint
        final remaining = halfLength - currentLength;
        final t = remaining / segmentLength;
        final midpoint = Offset.lerp(fullPath[i - 1], fullPath[i], t)!;
        halfPath.add(midpoint);
      }
      if (halfPath.isNotEmpty) {
        halfPath.add(fullPath[i]);
      }
      currentLength += segmentLength;
    }

    return halfPath;
  }

  /// Draw active channels with appropriate colors
  void _drawActiveChannels(Canvas canvas) {
    for (final channelActivation in chart.activeChannels) {
      final channel = channelActivation.channel;
      final path = _layout.getChannelPath(channel.gate1, channel.gate2);
      if (path.isEmpty) continue;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = channelStrokeWidthActive
        ..strokeCap = StrokeCap.round;

      // Determine color based on activation type
      if (channelActivation.hasBoth) {
        // Draw striped pattern for both conscious and unconscious
        _drawStripedChannel(canvas, path);
      } else if (channelActivation.hasConscious) {
        paint.color = AppColors.channelConscious;
        _drawChannelPath(canvas, path, paint);
      } else {
        paint.color = AppColors.channelUnconscious;
        _drawChannelPath(canvas, path, paint);
      }
    }
  }

  /// Draw all 9 centers with defined/undefined styling
  void _drawCenters(Canvas canvas) {
    for (final entry in _layout.centerPositions.entries) {
      final center = entry.key;
      final position = entry.value;
      final isDefined = chart.definedCenters.contains(center);

      // Use different colors for triangles (purple) vs squares/diamonds (yellow)
      final bool isTriangle = position.shape == CenterShape.triangle;

      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isDefined
            ? (isTriangle ? AppColors.triangleDefined : AppColors.centerDefined)
            : (isTriangle ? AppColors.triangleUndefined : AppColors.centerUndefined);

      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = isDefined
            ? (isTriangle ? AppColors.triangleDefinedBorder : AppColors.centerDefinedBorder)
            : (isTriangle ? AppColors.triangleUndefinedBorder : AppColors.centerUndefinedBorder);

      switch (position.shape) {
        case CenterShape.triangle:
          final orientation = _getTriangleOrientation(center);
          _drawTriangle(canvas, position, fillPaint, strokePaint, orientation: orientation);
          break;
        case CenterShape.square:
          _drawSquare(canvas, position, fillPaint, strokePaint);
          break;
        case CenterShape.diamond:
          _drawDiamond(canvas, position, fillPaint, strokePaint);
          break;
        case CenterShape.heart:
          _drawHeart(canvas, position, fillPaint, strokePaint);
          break;
      }
    }
  }

  /// Draw all 64 gates in inactive state
  /// Skip drawing here - circles are drawn in _drawGateNumbers for all gates
  void _drawInactiveGates(Canvas canvas) {
    // Circles are now drawn in _drawGateNumbers for consistency
    // This function is kept for the layer ordering but does nothing
  }

  /// Draw active gates with appropriate colors
  /// Skip drawing here - circles are drawn in _drawGateNumbers for all gates
  void _drawActiveGates(Canvas canvas) {
    // Circles are now drawn in _drawGateNumbers for consistency
    // This function is kept for the layer ordering but does nothing
  }

  /// Draw gate numbers on ALL gates with small circles
  void _drawGateNumbers(Canvas canvas) {
    // Circle radius: 30% smaller than before (was ~10, now ~7)
    const double circleRadius = 7.0;

    for (final entry in _layout.gatePositions.entries) {
      final gateNumber = entry.key;
      final position = entry.value;

      final isConscious = chart.consciousGates.contains(gateNumber);
      final isUnconscious = chart.unconsciousGates.contains(gateNumber);
      final isActive = isConscious || isUnconscious;

      // Draw circle background for ALL gates
      final bgPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isActive
            ? (isConscious && isUnconscious
                ? AppColors.channelConscious  // Both: use black
                : (isConscious ? AppColors.channelConscious : AppColors.channelUnconscious))
            : Colors.white;

      // Draw circle border
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = isActive
            ? Colors.white.withValues(alpha: 0.5)
            : AppColors.gateInactive;

      canvas.drawCircle(position.position, circleRadius, bgPaint);
      canvas.drawCircle(position.position, circleRadius, borderPaint);

      // Choose text color based on activation state
      Color textColor;
      if (isActive) {
        textColor = Colors.white;
      } else {
        textColor = AppColors.textPrimaryLight;
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: gateNumber.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          position.x - textPainter.width / 2,
          position.y - textPainter.height / 2,
        ),
      );
    }
  }

  /// Draw selection highlight for the currently selected element
  void _drawSelectionHighlight(Canvas canvas) {
    if (selectedElement == null) return;

    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = AppColors.primary;

    if (selectedElement is GateElement) {
      final gateNumber = (selectedElement as GateElement).gateNumber;
      final position = _layout.gatePositions[gateNumber];
      if (position != null) {
        canvas.drawCircle(position.position, gateRadius + 3, highlightPaint);
      }
    } else if (selectedElement is CenterElement) {
      final center = (selectedElement as CenterElement).center;
      final position = _layout.centerPositions[center];
      if (position != null) {
        highlightPaint.strokeWidth = 4;
        final rect = Rect.fromCenter(
          center: position.position,
          width: position.width + 8,
          height: position.height + 8,
        );
        canvas.drawRect(rect, highlightPaint);
      }
    } else if (selectedElement is ChannelElement) {
      final channelId = (selectedElement as ChannelElement).channelId;
      final parts = channelId.split('-');
      if (parts.length == 2) {
        final gate1 = int.tryParse(parts[0]);
        final gate2 = int.tryParse(parts[1]);
        if (gate1 != null && gate2 != null) {
          final path = _layout.getChannelPath(gate1, gate2);
          if (path.isNotEmpty) {
            highlightPaint.strokeWidth = channelStrokeWidthSelected;
            _drawChannelPath(canvas, path, highlightPaint);
          }
        }
      }
    }
  }

  /// Draw a straight channel path through multiple points
  void _drawChannelPath(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  /// Draw a striped channel for gates that are both conscious and unconscious
  void _drawStripedChannel(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    // Draw black base layer
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = channelStrokeWidthActive
      ..strokeCap = StrokeCap.round
      ..color = AppColors.channelConscious;
    _drawChannelPath(canvas, points, basePaint);

    // Draw red dashed overlay
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.channelUnconscious;

    // Create dashed effect by drawing segments
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Use pathMetrics to create dashes
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      const dashLength = 8.0;
      const gapLength = 8.0;
      bool draw = true;

      while (distance < metric.length) {
        if (draw) {
          final start = distance;
          final end = math.min(distance + dashLength, metric.length);
          final segment = metric.extractPath(start, end);
          canvas.drawPath(segment, dashPaint);
        }
        distance += draw ? dashLength : gapLength;
        draw = !draw;
      }
    }
  }

  /// Get the correct triangle orientation for each center
  _TriangleOrientation _getTriangleOrientation(HumanDesignCenter center) {
    switch (center) {
      case HumanDesignCenter.head:
        return _TriangleOrientation.up;
      case HumanDesignCenter.ajna:
        return _TriangleOrientation.down;
      case HumanDesignCenter.spleen:
        return _TriangleOrientation.right;
      case HumanDesignCenter.heart:
        return _TriangleOrientation.up;  // Triangle pointing UP (tip on top)
      case HumanDesignCenter.solarPlexus:
        return _TriangleOrientation.left;
      default:
        return _TriangleOrientation.up;
    }
  }

  void _drawTriangle(
    Canvas canvas,
    CenterPosition position,
    Paint fillPaint,
    Paint strokePaint, {
    _TriangleOrientation orientation = _TriangleOrientation.up,
  }) {
    final path = Path();
    // Use actual width and height for non-equilateral triangles
    final halfWidth = position.width / 2;
    final halfHeight = position.height / 2;

    switch (orientation) {
      case _TriangleOrientation.up:
        // Point at top, base at bottom
        path.moveTo(position.x, position.y - halfHeight);
        path.lineTo(position.x + halfWidth, position.y + halfHeight);
        path.lineTo(position.x - halfWidth, position.y + halfHeight);
        break;
      case _TriangleOrientation.down:
        // Point at bottom, base at top
        path.moveTo(position.x - halfWidth, position.y - halfHeight);
        path.lineTo(position.x + halfWidth, position.y - halfHeight);
        path.lineTo(position.x, position.y + halfHeight);
        break;
      case _TriangleOrientation.left:
        // Point at left, base at right
        path.moveTo(position.x - halfWidth, position.y);
        path.lineTo(position.x + halfWidth, position.y - halfHeight);
        path.lineTo(position.x + halfWidth, position.y + halfHeight);
        break;
      case _TriangleOrientation.right:
        // Point at right, base at left
        path.moveTo(position.x + halfWidth, position.y);
        path.lineTo(position.x - halfWidth, position.y - halfHeight);
        path.lineTo(position.x - halfWidth, position.y + halfHeight);
        break;
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawSquare(
    Canvas canvas,
    CenterPosition position,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final rect = Rect.fromCenter(
      center: Offset(position.x, position.y),
      width: position.width,
      height: position.height,
    );

    canvas.drawRect(rect, fillPaint);
    canvas.drawRect(rect, strokePaint);
  }

  void _drawDiamond(
    Canvas canvas,
    CenterPosition position,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final path = Path();
    final halfWidth = position.width / 2;
    final halfHeight = position.height / 2;

    path.moveTo(position.x, position.y - halfHeight);
    path.lineTo(position.x + halfWidth, position.y);
    path.lineTo(position.x, position.y + halfHeight);
    path.lineTo(position.x - halfWidth, position.y);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawHeart(
    Canvas canvas,
    CenterPosition position,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final path = Path();
    final halfWidth = position.width / 2;
    final halfHeight = position.height / 2;

    // Heart shape: start at bottom point, draw left lobe, then right lobe
    // Bottom point of heart
    path.moveTo(position.x, position.y + halfHeight);

    // Left side curve (bottom point to left top of heart)
    path.cubicTo(
      position.x - halfWidth * 0.8, position.y + halfHeight * 0.2,  // control 1
      position.x - halfWidth, position.y - halfHeight * 0.3,        // control 2
      position.x - halfWidth * 0.5, position.y - halfHeight * 0.8,  // left top
    );

    // Left lobe curve (left top to center top)
    path.cubicTo(
      position.x - halfWidth * 0.2, position.y - halfHeight,        // control 1
      position.x, position.y - halfHeight * 0.7,                    // control 2
      position.x, position.y - halfHeight * 0.4,                    // center dip
    );

    // Right lobe curve (center dip to right top)
    path.cubicTo(
      position.x, position.y - halfHeight * 0.7,                    // control 1
      position.x + halfWidth * 0.2, position.y - halfHeight,        // control 2
      position.x + halfWidth * 0.5, position.y - halfHeight * 0.8,  // right top
    );

    // Right side curve (right top to bottom point)
    path.cubicTo(
      position.x + halfWidth, position.y - halfHeight * 0.3,        // control 1
      position.x + halfWidth * 0.8, position.y + halfHeight * 0.2,  // control 2
      position.x, position.y + halfHeight,                          // bottom point
    );

    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawBodySilhouette(Canvas canvas) {
    // Create a subtle gradient fill for the body
    final bodyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withAlpha(15),
        AppColors.primary.withAlpha(25),
        AppColors.primary.withAlpha(15),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = bodyGradient.createShader(
        const Rect.fromLTWH(100, 10, 200, 580),
      );

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primary.withAlpha(60);

    // Create a refined human body silhouette path
    final bodyPath = Path();

    // Head ellipse
    final headRect = Rect.fromCenter(
      center: const Offset(200, 42),
      width: 62,
      height: 70,
    );
    bodyPath.addOval(headRect);

    // Main body outline
    final outlinePath = Path();
    outlinePath.moveTo(178, 72);
    outlinePath.cubicTo(175, 85, 172, 100, 168, 115);
    outlinePath.cubicTo(162, 135, 145, 155, 115, 168);
    outlinePath.cubicTo(90, 178, 72, 190, 62, 205);
    outlinePath.cubicTo(50, 225, 42, 260, 38, 295);
    outlinePath.cubicTo(35, 325, 32, 355, 35, 375);
    outlinePath.cubicTo(38, 390, 48, 395, 55, 388);
    outlinePath.cubicTo(62, 380, 58, 365, 55, 345);
    outlinePath.cubicTo(52, 320, 58, 285, 68, 250);
    outlinePath.cubicTo(75, 225, 82, 205, 95, 190);
    outlinePath.cubicTo(100, 210, 95, 260, 92, 310);
    outlinePath.cubicTo(90, 350, 92, 390, 100, 425);
    outlinePath.cubicTo(105, 448, 115, 465, 130, 478);
    outlinePath.cubicTo(145, 490, 155, 498, 165, 502);
    outlinePath.cubicTo(162, 530, 155, 560, 150, 590);
    outlinePath.lineTo(150, 595);
    outlinePath.lineTo(165, 595);
    outlinePath.cubicTo(170, 565, 178, 530, 182, 505);
    outlinePath.cubicTo(190, 510, 200, 512, 210, 510);
    outlinePath.cubicTo(215, 508, 218, 505, 218, 505);
    outlinePath.cubicTo(222, 530, 230, 565, 235, 595);
    outlinePath.lineTo(250, 595);
    outlinePath.lineTo(250, 590);
    outlinePath.cubicTo(245, 560, 238, 530, 235, 502);
    outlinePath.cubicTo(245, 498, 255, 490, 270, 478);
    outlinePath.cubicTo(285, 465, 295, 448, 300, 425);
    outlinePath.cubicTo(308, 390, 310, 350, 308, 310);
    outlinePath.cubicTo(305, 260, 300, 210, 305, 190);
    outlinePath.cubicTo(318, 205, 325, 225, 332, 250);
    outlinePath.cubicTo(342, 285, 348, 320, 345, 345);
    outlinePath.cubicTo(342, 365, 338, 380, 345, 388);
    outlinePath.cubicTo(352, 395, 362, 390, 365, 375);
    outlinePath.cubicTo(368, 355, 365, 325, 362, 295);
    outlinePath.cubicTo(358, 260, 350, 225, 338, 205);
    outlinePath.cubicTo(328, 190, 310, 178, 285, 168);
    outlinePath.cubicTo(255, 155, 238, 135, 232, 115);
    outlinePath.cubicTo(228, 100, 225, 85, 222, 72);
    outlinePath.cubicTo(215, 68, 185, 68, 178, 72);
    outlinePath.close();

    canvas.drawPath(outlinePath, fillPaint);
    canvas.drawPath(outlinePath, strokePaint);

    final headFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withAlpha(20);
    canvas.drawOval(headRect, headFillPaint);
    canvas.drawOval(headRect, strokePaint);
  }

  @override
  bool shouldRepaint(covariant BodygraphPainter oldDelegate) {
    return oldDelegate.chart != chart ||
        oldDelegate.layout != layout ||
        oldDelegate.selectedElement != selectedElement ||
        oldDelegate.showGateNumbers != showGateNumbers ||
        oldDelegate.showInactiveGates != showInactiveGates ||
        oldDelegate.showInactiveChannels != showInactiveChannels ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.drawBody != drawBody;
  }
}

/// Triangle orientation for center shapes
enum _TriangleOrientation {
  up,
  down,
  left,
  right,
}

/// Base class for bodygraph element selection
abstract class BodygraphElement {
  const BodygraphElement();
}

/// Represents a selected center
class CenterElement extends BodygraphElement {
  const CenterElement(this.center);
  final HumanDesignCenter center;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CenterElement && center == other.center;

  @override
  int get hashCode => center.hashCode;
}

/// Represents a selected gate
class GateElement extends BodygraphElement {
  const GateElement(this.gateNumber);
  final int gateNumber;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GateElement && gateNumber == other.gateNumber;

  @override
  int get hashCode => gateNumber.hashCode;
}

/// Represents a selected channel
class ChannelElement extends BodygraphElement {
  const ChannelElement(this.channelId);
  final String channelId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ChannelElement && channelId == other.channelId;

  @override
  int get hashCode => channelId.hashCode;
}
