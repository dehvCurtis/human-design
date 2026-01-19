import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import 'chakra_data.dart';

/// Custom painter for drawing the chakra visualization
class ChakraPainter extends CustomPainter {
  ChakraPainter({
    required this.definedCenters,
    this.selectedChakraIndex,
    this.animationValue = 1.0,
    this.showLabels = true,
  });

  final Set<HumanDesignCenter> definedCenters;
  final int? selectedChakraIndex;
  final double animationValue;
  final bool showLabels;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final totalHeight = size.height * 0.85;
    final startY = size.height * 0.1;
    final spacing = totalHeight / 7;

    // Draw connecting spine line first (behind chakras)
    _drawSpineLine(canvas, centerX, startY, spacing);

    // Draw each chakra from bottom (Root) to top (Crown)
    for (int i = 0; i < chakras.length; i++) {
      final chakra = chakras[i];
      // Reverse Y position so Root is at bottom, Crown at top
      final y = startY + spacing * (6 - i) + spacing / 2;
      final isActivated = chakra.isActivated(definedCenters);
      final isSelected = selectedChakraIndex == i;

      _drawChakra(
        canvas,
        Offset(centerX, y),
        chakra,
        isActivated: isActivated,
        isSelected: isSelected,
        size: size,
      );
    }
  }

  void _drawSpineLine(Canvas canvas, double centerX, double startY, double spacing) {
    final paint = Paint()
      ..color = AppColors.dividerLight.withValues(alpha: 0.5)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw a subtle curved spine line
    final path = Path();
    path.moveTo(centerX, startY + spacing / 2);
    path.lineTo(centerX, startY + spacing * 6.5);

    canvas.drawPath(path, paint);
  }

  void _drawChakra(
    Canvas canvas,
    Offset center,
    Chakra chakra,
    {
    required bool isActivated,
    required bool isSelected,
    required Size size,
  }) {
    final baseRadius = size.width * 0.12;
    final radius = isActivated ? baseRadius : baseRadius * 0.8;
    final glowRadius = radius * 1.5;

    // Determine opacity based on activation
    final opacity = isActivated ? 1.0 : 0.35;
    final color = chakra.color.withValues(alpha: opacity);
    final lightColor = chakra.lightColor.withValues(alpha: opacity * 0.6);

    // Draw glow effect for activated chakras
    if (isActivated) {
      final glowPaint = Paint()
        ..color = chakra.lightColor.withValues(alpha: 0.3 * animationValue)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius * 0.4);
      canvas.drawCircle(center, glowRadius * 0.8, glowPaint);

      // Inner glow
      final innerGlowPaint = Paint()
        ..color = chakra.color.withValues(alpha: 0.4 * animationValue)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, radius * 1.2, innerGlowPaint);
    }

    // Draw outer ring
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isActivated ? 3 : 2;
    canvas.drawCircle(center, radius, ringPaint);

    // Draw gradient fill
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          lightColor,
          color,
        ],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius - 2, gradientPaint);

    // Draw inner symbol (simplified lotus petals pattern)
    _drawChakraSymbol(canvas, center, radius * 0.6, chakra, isActivated);

    // Draw selection highlight
    if (isSelected) {
      final selectionPaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(center, radius + 6, selectionPaint);
    }

    // Draw label
    if (showLabels) {
      _drawLabel(canvas, center, radius, chakra, isActivated);
    }
  }

  void _drawChakraSymbol(
    Canvas canvas,
    Offset center,
    double radius,
    Chakra chakra,
    bool isActivated,
  ) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: isActivated ? 0.9 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw lotus petal pattern based on chakra
    final petalCount = _getPetalCount(chakra.index);
    final petalRadius = radius * 0.7;

    for (int i = 0; i < petalCount; i++) {
      final angle = (2 * math.pi / petalCount) * i - math.pi / 2;
      final petalCenter = Offset(
        center.dx + math.cos(angle) * petalRadius * 0.5,
        center.dy + math.sin(angle) * petalRadius * 0.5,
      );

      // Draw small petal circles
      canvas.drawCircle(petalCenter, petalRadius * 0.25, paint);
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.white.withValues(alpha: isActivated ? 0.8 : 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.15, centerPaint);
  }

  int _getPetalCount(int chakraIndex) {
    // Traditional lotus petal counts for each chakra
    switch (chakraIndex) {
      case 0: return 4;   // Root
      case 1: return 6;   // Sacral
      case 2: return 10;  // Solar Plexus
      case 3: return 12;  // Heart
      case 4: return 16;  // Throat
      case 5: return 2;   // Third Eye
      case 6: return 0;   // Crown (1000 petals, simplified to none)
      default: return 4;
    }
  }

  void _drawLabel(
    Canvas canvas,
    Offset center,
    double radius,
    Chakra chakra,
    bool isActivated,
  ) {
    final textStyle = TextStyle(
      color: isActivated
          ? AppColors.textPrimaryLight
          : AppColors.textSecondaryLight,
      fontSize: 12,
      fontWeight: isActivated ? FontWeight.w600 : FontWeight.normal,
    );

    final textSpan = TextSpan(text: chakra.name, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Position label to the right of the chakra
    final labelOffset = Offset(
      center.dx + radius + 16,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, labelOffset);

    // Draw HD center mapping indicator
    if (isActivated) {
      final hdText = chakra.hdCenters.map((c) => c.displayName).join(', ');
      final hdStyle = TextStyle(
        color: AppColors.textSecondaryLight,
        fontSize: 10,
      );
      final hdSpan = TextSpan(text: hdText, style: hdStyle);
      final hdPainter = TextPainter(
        text: hdSpan,
        textDirection: TextDirection.ltr,
      );
      hdPainter.layout();

      final hdOffset = Offset(
        center.dx + radius + 16,
        center.dy + textPainter.height / 2 + 2,
      );
      hdPainter.paint(canvas, hdOffset);
    }
  }

  @override
  bool shouldRepaint(covariant ChakraPainter oldDelegate) {
    return oldDelegate.definedCenters != definedCenters ||
        oldDelegate.selectedChakraIndex != selectedChakraIndex ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.showLabels != showLabels;
  }
}
