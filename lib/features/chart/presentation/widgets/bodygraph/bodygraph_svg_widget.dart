import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/human_design_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/human_design_chart.dart';

/// SVG-based bodygraph widget using hdkit's SVG structure
/// Dynamically colors centers and channels based on chart data
class BodygraphSvgWidget extends StatefulWidget {
  const BodygraphSvgWidget({
    super.key,
    required this.chart,
    this.onCenterTap,
    this.onChannelTap,
    this.showGateNumbers = true,
    this.interactive = true,
  });

  final HumanDesignChart chart;
  final void Function(HumanDesignCenter center)? onCenterTap;
  final void Function(String channelId)? onChannelTap;
  final bool showGateNumbers;
  final bool interactive;

  @override
  State<BodygraphSvgWidget> createState() => _BodygraphSvgWidgetState();
}

class _BodygraphSvgWidgetState extends State<BodygraphSvgWidget> {
  String? _svgString;
  String? _coloredSvg;

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  @override
  void didUpdateWidget(BodygraphSvgWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chart != widget.chart) {
      _applyChartColors();
    }
  }

  Future<void> _loadSvg() async {
    try {
      final svgString = await rootBundle.loadString('assets/svg/bodygraph.svg');
      setState(() {
        _svgString = svgString;
      });
      _applyChartColors();
    } catch (e) {
      debugPrint('Error loading bodygraph SVG: $e');
    }
  }

  void _applyChartColors() {
    if (_svgString == null) return;

    var coloredSvg = _svgString!;

    // Apply center colors
    coloredSvg = _applyCenterColors(coloredSvg);

    // Apply channel colors
    coloredSvg = _applyChannelColors(coloredSvg);

    setState(() {
      _coloredSvg = coloredSvg;
    });
  }

  String _applyCenterColors(String svg) {
    var result = svg;

    // Map HD center names to SVG IDs
    const centerIdMap = {
      HumanDesignCenter.head: 'Head',
      HumanDesignCenter.ajna: 'Ajna',
      HumanDesignCenter.throat: 'Throat',
      HumanDesignCenter.g: 'G',
      HumanDesignCenter.heart: 'Ego',
      HumanDesignCenter.spleen: 'Spleen',
      HumanDesignCenter.solarPlexus: 'Solar_Plexus',
      HumanDesignCenter.sacral: 'Sacral',
      HumanDesignCenter.root: 'Root',
    };

    // Center colors when defined (from hdkit + our style guide)
    const definedCenterColors = {
      'Head': '#FBBF24',        // Gold/Amber
      'Ajna': '#22C55E',        // Green
      'Throat': '#8B5CF6',      // Purple (changed from brown)
      'G': '#FBBF24',           // Gold/Amber
      'Ego': '#EF4444',         // Red
      'Spleen': '#8B4513',      // Brown
      'Solar_Plexus': '#F59E0B', // Orange (changed from brown)
      'Sacral': '#DC2626',      // Red
      'Root': '#8B4513',        // Brown
    };

    // Undefined center color
    const undefinedColor = '#FFFFFF';
    const strokeColor = '#9CA3AF';

    for (final entry in centerIdMap.entries) {
      final center = entry.key;
      final svgId = entry.value;
      final isDefined = widget.chart.definedCenters.contains(center);

      final fillColor = isDefined
          ? definedCenterColors[svgId] ?? '#FBBF24'
          : undefinedColor;

      // Replace fill color for this center
      // Match patterns like: id="Head" fill="#FCEE21"
      final pattern = RegExp(
        r'(id="' + svgId + r'"[^>]*?)fill="[^"]*"',
        multiLine: true,
      );

      if (pattern.hasMatch(result)) {
        result = result.replaceAllMapped(pattern, (match) {
          return '${match.group(1)}fill="$fillColor" stroke="$strokeColor" stroke-width="3"';
        });
      } else {
        // Try alternate pattern: fill="..." ... id="..."
        final altPattern = RegExp(
          r'(fill=")[^"]*("[^>]*id="' + svgId + r'")',
          multiLine: true,
        );
        result = result.replaceAllMapped(altPattern, (match) {
          return '${match.group(1)}$fillColor${match.group(2)}';
        });
      }
    }

    return result;
  }

  String _applyChannelColors(String svg) {
    var result = svg;

    // Get active channel IDs
    final activeChannelIds = <String, ({bool hasConscious, bool hasUnconscious})>{};
    for (final activation in widget.chart.activeChannels) {
      final channel = activation.channel;
      activeChannelIds['${channel.gate1}-${channel.gate2}'] = (
        hasConscious: activation.hasConscious,
        hasUnconscious: activation.hasUnconscious,
      );
      // Also store reverse for matching
      activeChannelIds['${channel.gate2}-${channel.gate1}'] = (
        hasConscious: activation.hasConscious,
        hasUnconscious: activation.hasUnconscious,
      );
    }

    // Find all channel paths and color them
    final channelPattern = RegExp(
      r'<path\s+id="Channel(\d+-\d+)(?:_\d+_)?"[^>]*>',
      multiLine: true,
    );

    result = result.replaceAllMapped(channelPattern, (match) {
      final fullMatch = match.group(0)!;
      final channelId = match.group(1)!;

      // Determine channel color
      String strokeColor;
      double strokeWidth;

      if (activeChannelIds.containsKey(channelId)) {
        final activation = activeChannelIds[channelId]!;
        if (activation.hasConscious && activation.hasUnconscious) {
          strokeColor = _colorToHex(AppColors.channelBoth);
        } else if (activation.hasConscious) {
          strokeColor = _colorToHex(AppColors.channelConscious);
        } else {
          strokeColor = _colorToHex(AppColors.channelUnconscious);
        }
        strokeWidth = 8;
      } else {
        // Inactive channel
        strokeColor = _colorToHex(AppColors.channelInactive);
        strokeWidth = 4;
      }

      // Replace stroke attributes
      var newPath = fullMatch;

      // Replace or add stroke color
      if (newPath.contains('stroke="')) {
        newPath = newPath.replaceAll(
          RegExp(r'stroke="[^"]*"'),
          'stroke="$strokeColor"',
        );
      } else {
        newPath = newPath.replaceFirst('>', ' stroke="$strokeColor">');
      }

      // Replace or add stroke-width
      if (newPath.contains('stroke-width="')) {
        newPath = newPath.replaceAll(
          RegExp(r'stroke-width="[^"]*"'),
          'stroke-width="$strokeWidth"',
        );
      } else {
        newPath = newPath.replaceFirst('>', ' stroke-width="$strokeWidth">');
      }

      // Add stroke-linecap for rounded ends
      if (!newPath.contains('stroke-linecap')) {
        newPath = newPath.replaceFirst('>', ' stroke-linecap="round">');
      }

      return newPath;
    });

    return result;
  }

  String _colorToHex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    if (_coloredSvg == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: SvgPicture.string(
            _coloredSvg!,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
