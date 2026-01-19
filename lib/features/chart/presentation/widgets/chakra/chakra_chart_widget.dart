import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/human_design_chart.dart';
import 'chakra_data.dart';
import 'chakra_painter.dart';

/// Widget displaying the chakra system with HD center mappings
class ChakraChartWidget extends StatefulWidget {
  const ChakraChartWidget({
    super.key,
    required this.chart,
    this.onChakraTap,
    this.showLabels = true,
    this.interactive = true,
  });

  final HumanDesignChart chart;
  final void Function(Chakra chakra)? onChakraTap;
  final bool showLabels;
  final bool interactive;

  @override
  State<ChakraChartWidget> createState() => _ChakraChartWidgetState();
}

class _ChakraChartWidgetState extends State<ChakraChartWidget>
    with SingleTickerProviderStateMixin {
  int? _selectedChakraIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
                painter: ChakraPainter(
                  definedCenters: widget.chart.definedCenters,
                  selectedChakraIndex: _selectedChakraIndex,
                  animationValue: _animation.value,
                  showLabels: widget.showLabels,
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

    final centerX = size.width / 2;
    final totalHeight = size.height * 0.85;
    final startY = size.height * 0.1;
    final spacing = totalHeight / 7;
    final hitRadius = size.width * 0.15;

    // Check each chakra for hit
    for (int i = 0; i < chakras.length; i++) {
      final y = startY + spacing * (6 - i) + spacing / 2;
      final chakraCenter = Offset(centerX, y);

      final distance = (localPosition - chakraCenter).distance;
      if (distance <= hitRadius) {
        setState(() {
          _selectedChakraIndex = _selectedChakraIndex == i ? null : i;
        });
        if (_selectedChakraIndex != null) {
          widget.onChakraTap?.call(chakras[i]);
        }
        return;
      }
    }

    // Clear selection if tapped elsewhere
    setState(() {
      _selectedChakraIndex = null;
    });
  }

  /// Programmatically select a chakra
  void selectChakra(int index) {
    if (index >= 0 && index < chakras.length) {
      setState(() {
        _selectedChakraIndex = index;
      });
    }
  }

  /// Clear selection
  void clearSelection() {
    setState(() {
      _selectedChakraIndex = null;
    });
  }
}

/// A summary card showing chakra activation status
class ChakraSummaryCard extends StatelessWidget {
  const ChakraSummaryCard({
    super.key,
    required this.chart,
    this.onTap,
  });

  final HumanDesignChart chart;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final activatedCount = chakras
        .where((c) => c.isActivated(chart.definedCenters))
        .length;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.chakraCrown,
                          AppColors.chakraThirdEye,
                          AppColors.chakraThroat,
                          AppColors.chakraHeart,
                          AppColors.chakraSolarPlexus,
                          AppColors.chakraSacral,
                          AppColors.chakraRoot,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chakra Energy',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '$activatedCount of 7 chakras activated',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondaryLight,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Mini chakra indicator row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: chakras.reversed.map((chakra) {
                  final isActivated = chakra.isActivated(chart.definedCenters);
                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isActivated
                          ? chakra.color
                          : chakra.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActivated
                            ? chakra.color
                            : AppColors.dividerLight,
                        width: 2,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
