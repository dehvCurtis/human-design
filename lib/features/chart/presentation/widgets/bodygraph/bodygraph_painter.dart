import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/human_design_chart.dart';
import 'bodygraph_data.dart';

/// Custom painter for drawing the Human Design bodygraph
class BodygraphPainter extends CustomPainter {
  BodygraphPainter({
    required this.chart,
    this.selectedElement,
    this.showGateNumbers = true,
    this.animationValue = 1.0,
  });

  final HumanDesignChart chart;
  final BodygraphElement? selectedElement;
  final bool showGateNumbers;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate scale to fit the bodygraph in the available space
    final scale = math.min(size.width / 400, size.height / 600);
    canvas.save();

    // Center the bodygraph
    final offsetX = (size.width - 400 * scale) / 2;
    final offsetY = (size.height - 600 * scale) / 2;
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale);

    // Draw in order: body (back), channels, centers, gates (front)
    _drawBodySilhouette(canvas);
    _drawChannels(canvas);
    _drawCenters(canvas);
    _drawGates(canvas);

    canvas.restore();
  }

  void _drawBodySilhouette(Canvas canvas) {
    // Create a subtle gradient fill for the body - more visible but still subtle
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

    // Head - elliptical for better proportions
    final headRect = Rect.fromCenter(
      center: const Offset(200, 42),
      width: 62,
      height: 70,
    );
    bodyPath.addOval(headRect);

    // Main body outline with smooth curves
    final outlinePath = Path();

    // Start from left neck
    outlinePath.moveTo(178, 72);

    // Left neck to shoulder
    outlinePath.cubicTo(175, 85, 172, 100, 168, 115);
    outlinePath.cubicTo(162, 135, 145, 155, 115, 168);

    // Left shoulder curve
    outlinePath.cubicTo(90, 178, 72, 190, 62, 205);

    // Left arm (upper)
    outlinePath.cubicTo(50, 225, 42, 260, 38, 295);
    outlinePath.cubicTo(35, 325, 32, 355, 35, 375);

    // Left hand hint
    outlinePath.cubicTo(38, 390, 48, 395, 55, 388);
    outlinePath.cubicTo(62, 380, 58, 365, 55, 345);

    // Left arm (inner) back up
    outlinePath.cubicTo(52, 320, 58, 285, 68, 250);
    outlinePath.cubicTo(75, 225, 82, 205, 95, 190);

    // Left torso
    outlinePath.cubicTo(100, 210, 95, 260, 92, 310);
    outlinePath.cubicTo(90, 350, 92, 390, 100, 425);
    outlinePath.cubicTo(105, 448, 115, 465, 130, 478);

    // Left hip
    outlinePath.cubicTo(145, 490, 155, 498, 165, 502);

    // Left leg outer
    outlinePath.cubicTo(162, 530, 155, 560, 150, 590);

    // Left foot
    outlinePath.lineTo(150, 595);
    outlinePath.lineTo(165, 595);

    // Left leg inner
    outlinePath.cubicTo(170, 565, 178, 530, 182, 505);

    // Pelvis center
    outlinePath.cubicTo(190, 510, 200, 512, 210, 510);
    outlinePath.cubicTo(215, 508, 218, 505, 218, 505);

    // Right leg inner
    outlinePath.cubicTo(222, 530, 230, 565, 235, 595);

    // Right foot
    outlinePath.lineTo(250, 595);
    outlinePath.lineTo(250, 590);

    // Right leg outer
    outlinePath.cubicTo(245, 560, 238, 530, 235, 502);

    // Right hip
    outlinePath.cubicTo(245, 498, 255, 490, 270, 478);
    outlinePath.cubicTo(285, 465, 295, 448, 300, 425);

    // Right torso
    outlinePath.cubicTo(308, 390, 310, 350, 308, 310);
    outlinePath.cubicTo(305, 260, 300, 210, 305, 190);

    // Right arm (inner)
    outlinePath.cubicTo(318, 205, 325, 225, 332, 250);
    outlinePath.cubicTo(342, 285, 348, 320, 345, 345);

    // Right hand hint
    outlinePath.cubicTo(342, 365, 338, 380, 345, 388);
    outlinePath.cubicTo(352, 395, 362, 390, 365, 375);

    // Right arm (outer)
    outlinePath.cubicTo(368, 355, 365, 325, 362, 295);
    outlinePath.cubicTo(358, 260, 350, 225, 338, 205);

    // Right shoulder curve
    outlinePath.cubicTo(328, 190, 310, 178, 285, 168);

    // Right neck
    outlinePath.cubicTo(255, 155, 238, 135, 232, 115);
    outlinePath.cubicTo(228, 100, 225, 85, 222, 72);

    // Connect neck sides through head area
    outlinePath.cubicTo(215, 68, 185, 68, 178, 72);

    outlinePath.close();

    // Draw the filled body
    canvas.drawPath(outlinePath, fillPaint);

    // Draw subtle stroke
    canvas.drawPath(outlinePath, strokePaint);

    // Draw head with gradient
    final headFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withAlpha(20);
    canvas.drawOval(headRect, headFillPaint);
    canvas.drawOval(headRect, strokePaint);

    // Add subtle inner glow/highlight for depth
    final innerHighlight = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..color = AppColors.primary.withAlpha(8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawPath(outlinePath, innerHighlight);
  }

  void _drawChannels(Canvas canvas) {
    // Build set of active channel IDs for quick lookup
    final activeChannelIds = chart.activeChannels.map((c) => c.channel.id).toSet();

    // Draw ALL channels - inactive ones first (behind), then active ones on top
    // First pass: Draw inactive channels
    for (final channel in channels) {
      if (activeChannelIds.contains(channel.id)) continue;

      final path = _getChannelPath(channel.gate1, channel.gate2);
      if (path == null || path.isEmpty) continue;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.channelInactive.withValues(alpha: 0.35);

      _drawChannelPath(canvas, path, paint);
    }

    // Second pass: Draw active channels on top
    for (final channelActivation in chart.activeChannels) {
      final channel = channelActivation.channel;
      final path = _getChannelPath(channel.gate1, channel.gate2);
      if (path == null || path.isEmpty) continue;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;

      // Determine color based on activation type
      if (channelActivation.hasBoth) {
        // Draw striped pattern for both conscious and unconscious
        _drawStripedChannel(canvas, path, paint);
      } else if (channelActivation.hasConscious) {
        paint.color = AppColors.channelConscious;
        _drawChannelPath(canvas, path, paint);
      } else {
        paint.color = AppColors.channelUnconscious;
        _drawChannelPath(canvas, path, paint);
      }

      // Check if selected
      if (selectedElement is ChannelElement &&
          (selectedElement as ChannelElement).channelId == channel.id) {
        paint
          ..color = AppColors.primary
          ..strokeWidth = 6;
        _drawChannelPath(canvas, path, paint);
      }
    }
  }

  /// Get channel path by trying both gate orderings
  List<Offset>? _getChannelPath(int gate1, int gate2) {
    // Try the original order
    final path1 = channelPaths['$gate1-$gate2'];
    if (path1 != null) return path1;

    // Try reversed order
    final path2 = channelPaths['$gate2-$gate1'];
    if (path2 != null) return path2;

    return null;
  }

  void _drawChannelPath(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  void _drawStripedChannel(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;

    // Draw black base
    paint.color = AppColors.channelConscious;
    _drawChannelPath(canvas, points, paint);

    // Draw red dashes on top
    paint.color = AppColors.channelUnconscious;
    final dashPath = Path();
    dashPath.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      dashPath.lineTo(points[i].dx, points[i].dy);
    }

    // Create dashed effect
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.channelUnconscious;

    // Simple dashed line approximation
    canvas.drawPath(dashPath, dashPaint);
  }

  void _drawCenters(Canvas canvas) {
    for (final entry in centerPositions.entries) {
      final center = entry.key;
      final position = entry.value;
      final isDefined = chart.definedCenters.contains(center);

      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isDefined ? AppColors.centerDefined : AppColors.centerUndefined;

      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = isDefined
            ? AppColors.centerDefinedBorder
            : AppColors.centerUndefinedBorder;

      // Check if selected
      final isSelected = selectedElement is CenterElement &&
          (selectedElement as CenterElement).center == center;
      if (isSelected) {
        strokePaint
          ..color = AppColors.primary
          ..strokeWidth = 3;
      }

      switch (position.shape) {
        case CenterShape.triangle:
          _drawTriangle(canvas, position, fillPaint, strokePaint,
              inverted: center == HumanDesignCenter.ajna ||
                  center == HumanDesignCenter.heart ||
                  center == HumanDesignCenter.solarPlexus);
          break;
        case CenterShape.square:
          _drawSquare(canvas, position, fillPaint, strokePaint);
          break;
        case CenterShape.diamond:
          _drawDiamond(canvas, position, fillPaint, strokePaint);
          break;
      }
    }
  }

  void _drawTriangle(
    Canvas canvas,
    CenterPosition position,
    Paint fillPaint,
    Paint strokePaint, {
    bool inverted = false,
  }) {
    final path = Path();
    final halfWidth = position.width / 2;
    final halfHeight = position.height / 2;

    if (inverted) {
      path.moveTo(position.x - halfWidth, position.y - halfHeight);
      path.lineTo(position.x + halfWidth, position.y - halfHeight);
      path.lineTo(position.x, position.y + halfHeight);
    } else {
      path.moveTo(position.x, position.y - halfHeight);
      path.lineTo(position.x + halfWidth, position.y + halfHeight);
      path.lineTo(position.x - halfWidth, position.y + halfHeight);
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

  void _drawGates(Canvas canvas) {
    for (final entry in gatePositions.entries) {
      final gateNumber = entry.key;
      final position = entry.value;

      final isConscious = chart.consciousGates.contains(gateNumber);
      final isUnconscious = chart.unconsciousGates.contains(gateNumber);
      final isActive = isConscious || isUnconscious;

      if (!isActive && !showGateNumbers) continue;

      final radius = 10.0;

      // Draw gate circle
      final fillPaint = Paint()..style = PaintingStyle.fill;

      if (isConscious && isUnconscious) {
        // Half and half for both
        _drawHalfCircle(canvas, position.position, radius,
            AppColors.conscious, AppColors.unconscious);
      } else if (isConscious) {
        fillPaint.color = AppColors.conscious;
        canvas.drawCircle(position.position, radius, fillPaint);
      } else if (isUnconscious) {
        fillPaint.color = AppColors.unconscious;
        canvas.drawCircle(position.position, radius, fillPaint);
      } else {
        // Inactive gate
        fillPaint.color = AppColors.gateInactive.withValues(alpha: 0.3);
        canvas.drawCircle(position.position, radius * 0.7, fillPaint);
      }

      // Check if selected
      if (selectedElement is GateElement &&
          (selectedElement as GateElement).gateNumber == gateNumber) {
        final highlightPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.primary;
        canvas.drawCircle(position.position, radius + 2, highlightPaint);
      }

      // Draw gate number
      if (showGateNumbers && isActive) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: gateNumber.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
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
  }

  void _drawHalfCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Color color1,
    Color color2,
  ) {
    final paint1 = Paint()
      ..style = PaintingStyle.fill
      ..color = color1;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = color2;

    // Left half (conscious/black)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi / 2,
      math.pi,
      true,
      paint1,
    );

    // Right half (unconscious/red)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi,
      true,
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant BodygraphPainter oldDelegate) {
    return oldDelegate.chart != chart ||
        oldDelegate.selectedElement != selectedElement ||
        oldDelegate.showGateNumbers != showGateNumbers ||
        oldDelegate.animationValue != animationValue;
  }
}

/// Base class for bodygraph element selection
abstract class BodygraphElement {
  const BodygraphElement();
}

/// Represents a selected center
class CenterElement extends BodygraphElement {
  const CenterElement(this.center);
  final HumanDesignCenter center;
}

/// Represents a selected gate
class GateElement extends BodygraphElement {
  const GateElement(this.gateNumber);
  final int gateNumber;
}

/// Represents a selected channel
class ChannelElement extends BodygraphElement {
  const ChannelElement(this.channelId);
  final String channelId;
}
