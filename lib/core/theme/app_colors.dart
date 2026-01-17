import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary colors
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF7C3AED);

  // Accent colors
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // Background colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);

  // Surface colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Divider colors
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF334155);

  // Status colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ===========================================
  // Human Design Bodygraph Colors
  // ===========================================

  // Conscious (Personality/Black) - activations at birth
  static const Color conscious = Color(0xFF1A1A1A);
  static const Color consciousLight = Color(0xFF374151);

  // Unconscious (Design/Red) - activations 88 degrees before birth
  static const Color unconscious = Color(0xFFDC2626);
  static const Color unconsciousLight = Color(0xFFF87171);

  // Both (Striped pattern for when both conscious and unconscious)
  static const Color both = Color(0xFF7C2D12);

  // Defined center (colored/active)
  static const Color centerDefined = Color(0xFFFBBF24);
  static const Color centerDefinedBorder = Color(0xFFD97706);

  // Undefined center (white/open)
  static const Color centerUndefined = Color(0xFFFFFFFF);
  static const Color centerUndefinedBorder = Color(0xFF9CA3AF);

  // Channel colors
  static const Color channelConscious = Color(0xFF1A1A1A);
  static const Color channelUnconscious = Color(0xFFDC2626);
  static const Color channelBoth = Color(0xFF7C2D12);
  static const Color channelInactive = Color(0xFFE5E7EB);

  // Gate colors
  static const Color gateActive = Color(0xFF1A1A1A);
  static const Color gateInactive = Color(0xFFE5E7EB);

  // Center-specific colors (for visualization variety)
  static const Color headCenter = Color(0xFFFBBF24);
  static const Color ajnaCenter = Color(0xFF22C55E);
  static const Color throatCenter = Color(0xFF8B5CF6);
  static const Color gCenter = Color(0xFFFBBF24);
  static const Color heartCenter = Color(0xFFEF4444);
  static const Color sacralCenter = Color(0xFFDC2626);
  static const Color solarPlexusCenter = Color(0xFF8B4513);
  static const Color spleenCenter = Color(0xFF8B4513);
  static const Color rootCenter = Color(0xFF8B4513);

  // Transit overlay colors
  static const Color transitActive = Color(0xFF3B82F6);
  static const Color transitActiveLight = Color(0xFF93C5FD);

  // Composite chart colors
  static const Color person1 = Color(0xFF6366F1);
  static const Color person2 = Color(0xFFEC4899);
  static const Color electromagneticConnection = Color(0xFF8B5CF6);

  // Gamification colors
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);

  // Badge tier colors
  static const Color badgeCommon = Color(0xFF9CA3AF);
  static const Color badgeRare = Color(0xFF3B82F6);
  static const Color badgeEpic = Color(0xFF8B5CF6);
  static const Color badgeLegendary = Color(0xFFFFD700);

  // Streak colors
  static const Color streakActive = Color(0xFFF59E0B);
  static const Color streakInactive = Color(0xFF6B7280);

  // Premium colors
  static const Color premiumGradientStart = Color(0xFF6366F1);
  static const Color premiumGradientEnd = Color(0xFF8B5CF6);
}

/// Extension for easy color access in bodygraph rendering
extension BodygraphColors on AppColors {
  /// Get center color based on defined status
  static Color getCenterColor(bool isDefined) {
    return isDefined ? AppColors.centerDefined : AppColors.centerUndefined;
  }

  /// Get center border color based on defined status
  static Color getCenterBorderColor(bool isDefined) {
    return isDefined
        ? AppColors.centerDefinedBorder
        : AppColors.centerUndefinedBorder;
  }

  /// Get channel color based on activation type
  static Color getChannelColor({
    required bool hasConscious,
    required bool hasUnconscious,
  }) {
    if (hasConscious && hasUnconscious) {
      return AppColors.channelBoth;
    } else if (hasConscious) {
      return AppColors.channelConscious;
    } else if (hasUnconscious) {
      return AppColors.channelUnconscious;
    } else {
      return AppColors.channelInactive;
    }
  }
}
