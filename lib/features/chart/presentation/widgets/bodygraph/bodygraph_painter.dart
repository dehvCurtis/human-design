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

    // Draw in order: channels (back), centers (middle), gates (front)
    _drawChannels(canvas);
    _drawCenters(canvas);
    _drawGates(canvas);

    canvas.restore();
  }

  void _drawChannels(Canvas canvas) {
    for (final channelActivation in chart.activeChannels) {
      final channelId = channelActivation.channel.id;
      final path = channelPaths[channelId];
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
          (selectedElement as ChannelElement).channelId == channelId) {
        paint
          ..color = AppColors.primary
          ..strokeWidth = 6;
        _drawChannelPath(canvas, path, paint);
      }
    }

    // Draw inactive channels with light color
    for (final channel in channels) {
      final isActive = chart.activeChannels.any((c) => c.channel.id == channel.id);
      if (!isActive) {
        final path = channelPaths[channel.id];
        if (path == null || path.isEmpty) continue;

        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = AppColors.channelInactive.withOpacity(0.3);

        _drawChannelPath(canvas, path, paint);
      }
    }
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
        fillPaint.color = AppColors.gateInactive.withOpacity(0.3);
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
