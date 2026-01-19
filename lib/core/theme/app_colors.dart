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
  // Style guide: Purple/violet theme with clear differentiation
  // ===========================================

  // Conscious (Personality) - activations at birth
  // Dark indigo for clear visibility
  static const Color conscious = Color(0xFF3730A3);        // Indigo-800
  static const Color consciousLight = Color(0xFF4F46E5);   // Indigo-600

  // Unconscious (Design) - activations 88 degrees before birth
  // Magenta/pink for contrast against purple
  static const Color unconscious = Color(0xFFDB2777);      // Pink-600
  static const Color unconsciousLight = Color(0xFFF472B6); // Pink-400

  // Both (when both conscious and unconscious)
  static const Color both = Color(0xFF7C3AED);             // Violet-600

  // Defined center (colored/active) - light purple fill, dark purple border
  static const Color centerDefined = Color(0xFFDDD6FE);        // Violet-200
  static const Color centerDefinedBorder = Color(0xFF7C3AED);  // Violet-600

  // Defined triangle center - same as other centers for consistency
  static const Color triangleDefined = Color(0xFFDDD6FE);       // Violet-200
  static const Color triangleDefinedBorder = Color(0xFF7C3AED); // Violet-600

  // Undefined center (white/open with purple outline)
  static const Color centerUndefined = Color(0xFFFFFFFF);
  static const Color centerUndefinedBorder = Color(0xFFC4B5FD); // Violet-300

  // Undefined triangle center - same as other undefined centers
  static const Color triangleUndefined = Color(0xFFFFFFFF);
  static const Color triangleUndefinedBorder = Color(0xFFC4B5FD); // Violet-300

  // Channel colors - using style guide colors
  static const Color channelConscious = Color(0xFF3730A3);     // Indigo-800 (dark, visible)
  static const Color channelUnconscious = Color(0xFFDB2777);   // Pink-600 (contrasting)
  static const Color channelBoth = Color(0xFF7C3AED);          // Violet-600
  static const Color channelInactive = Color(0xFFE9D5FF);      // Purple-200 (light purple tint)

  // Gate colors - matching channel colors
  static const Color gateActive = Color(0xFF3730A3);           // Indigo-800
  static const Color gateInactive = Color(0xFFE9D5FF);         // Purple-200

  // Center-specific colors (all using purple palette)
  static const Color headCenter = Color(0xFFDDD6FE);           // Violet-200
  static const Color ajnaCenter = Color(0xFFDDD6FE);           // Violet-200
  static const Color throatCenter = Color(0xFFDDD6FE);         // Violet-200
  static const Color gCenter = Color(0xFFDDD6FE);              // Violet-200
  static const Color heartCenter = Color(0xFFDDD6FE);          // Violet-200
  static const Color sacralCenter = Color(0xFFDDD6FE);         // Violet-200
  static const Color solarPlexusCenter = Color(0xFFDDD6FE);    // Violet-200
  static const Color spleenCenter = Color(0xFFDDD6FE);         // Violet-200
  static const Color rootCenter = Color(0xFFDDD6FE);           // Violet-200

  // Transit overlay colors - using cyan/teal for clear distinction from chart
  static const Color transitActive = Color(0xFF0891B2);       // Cyan-600
  static const Color transitActiveLight = Color(0xFF22D3EE);  // Cyan-400

  // Composite chart colors - person differentiation
  static const Color person1 = Color(0xFF6366F1);             // Primary indigo
  static const Color person2 = Color(0xFFEC4899);             // Pink-500
  static const Color electromagneticConnection = Color(0xFF8B5CF6); // Violet-500

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

  // ===========================================
  // Chakra Colors (derived from app palette)
  // ===========================================

  // Crown Chakra (7th) - Violet/Purple - maps to Head center
  static const Color chakraCrown = Color(0xFF8B5CF6); // secondary
  static const Color chakraCrownLight = Color(0xFFA78BFA); // secondaryLight

  // Third Eye Chakra (6th) - Indigo - maps to Ajna center
  static const Color chakraThirdEye = Color(0xFF6366F1); // primary
  static const Color chakraThirdEyeLight = Color(0xFF818CF8); // primaryLight

  // Throat Chakra (5th) - Blue - maps to Throat center
  static const Color chakraThroat = Color(0xFF3B82F6); // info
  static const Color chakraThroatLight = Color(0xFF60A5FA);

  // Heart Chakra (4th) - Green - maps to G center
  static const Color chakraHeart = Color(0xFF22C55E); // success
  static const Color chakraHeartLight = Color(0xFF4ADE80);

  // Solar Plexus Chakra (3rd) - Yellow - maps to Heart/Ego center
  static const Color chakraSolarPlexus = Color(0xFFFBBF24); // accentLight
  static const Color chakraSolarPlexusLight = Color(0xFFFDE68A);

  // Sacral Chakra (2nd) - Orange - maps to Sacral center
  static const Color chakraSacral = Color(0xFFF59E0B); // accent
  static const Color chakraSacralLight = Color(0xFFFBBF24);

  // Root Chakra (1st) - Red - maps to Root center
  static const Color chakraRoot = Color(0xFFEF4444); // error
  static const Color chakraRootLight = Color(0xFFF87171);

  // Chakra glow effect color
  static const Color chakraGlow = Color(0xFFFFFFFF);
  static const Color chakraInactive = Color(0xFF94A3B8); // textSecondaryDark
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
