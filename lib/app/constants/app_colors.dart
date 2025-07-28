import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Using requested palette
  static const Color primary = Color(0xFF339989);
  static const Color primaryLight = Color(0xFFE0FFF3);
  static const Color primaryDark = Color(0xFF3C493F);
  static const Color primaryAccent = Color(0xFF4CAF50);

  // Enhanced Primary Variations
  static const Color primarySoft = Color(0xFF7FCCBF);
  static const Color primaryMuted = Color(0xFFB8E6D9);
  static const Color primaryGlow = Color(0xFF5DCCAA);

  // Secondary Colors
  static const Color secondary = Color(0xFF6C757D);
  static const Color secondaryLight = Color(0xFFADB5BD);
  static const Color secondaryDark = Color(0xFF495057);
  static const Color accent = Color(0xFF007BFF);

  // Background Colors
  static const Color background = Colors.white;
  static const Color backgroundLight = Color(0xFFF8FDFC);
  static const Color backgroundSoft = Color(0xFFF0FDF9);
  static const Color backgroundDark = Color(0xFF1A1F1C);
  static const Color backgroundCard = Color(0xFFFEFFFE);

  // Surface Colors
  static const Color surface = Colors.white;
  static const Color surfaceLight = Color(0xFFF9FFFE);
  static const Color surfaceDark = Color(0xFF2D3A32);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1F1C);
  static const Color textSecondary = Color(0xFF4A5A4F);
  static const Color textTertiary = Color(0xFF6B7B70);
  static const Color textLight = Colors.white;
  static const Color textHint = Color(0xFF9CA3A0);
  static const Color textDisabled = Color(0xFFBDC3C0);

  // Interactive Colors
  static const Color interactive = Color(0xFF339989);
  static const Color interactiveHover = Color(0xFF2A7A6B);
  static const Color interactivePressed = Color(0xFF1F5A4F);
  static const Color interactiveDisabled = Color(0xFFB8E6D9);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // UI Colors
  static const Color divider = Color(0xFFE5F3F0);
  static const Color dividerLight = Color(0xFFF0F9F6);
  static const Color border = Color(0xFFD1E7E0);
  static const Color borderLight = Color(0xFFE8F5F1);
  static const Color shadow = Color(0x0F339989);
  static const Color shadowLight = Color(0x08339989);
  static const Color shadowDark = Color(0x1A339989);
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Glassmorphism Colors
  static const Color glass = Color(0x1A339989);
  static const Color glassLight = Color(0x0D339989);
  static const Color glassBorder = Color(0x33339989);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primarySoftGradient = LinearGradient(
    colors: [primaryLight, primarySoft],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGlowGradient = LinearGradient(
    colors: [primary, primaryGlow, primarySoft],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundLight, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [backgroundCard, backgroundSoft],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFE8F5F1),
      Color(0xFFF0F9F6),
      Color(0xFFE8F5F1),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  // Radial Gradients
  static const RadialGradient primaryRadialGradient = RadialGradient(
    colors: [primaryGlow, primary, primaryDark],
    stops: [0.0, 0.5, 1.0],
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [
      Color(0x33339989),
      Color(0x1A339989),
      Color(0x00339989),
    ],
    stops: [0.0, 0.7, 1.0],
  );

  // Animation Colors
  static const Color ripple = Color(0x1A339989);
  static const Color rippleLight = Color(0x0D339989);
  static const Color highlight = Color(0x0F339989);

  // Theme-specific colors
  static const Color appBarBackground = primary;
  static const Color scaffoldBackground = backgroundLight;
  static const Color cardBackground = backgroundCard;
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = primaryLight;

  // Helper methods for dynamic colors
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  // Color schemes for different contexts
  static const Map<String, Color> successScheme = {
    'primary': success,
    'light': successLight,
    'dark': Color(0xFF059669),
    'text': Color(0xFF065F46),
  };

  static const Map<String, Color> warningScheme = {
    'primary': warning,
    'light': warningLight,
    'dark': Color(0xFFD97706),
    'text': Color(0xFF92400E),
  };

  static const Map<String, Color> errorScheme = {
    'primary': error,
    'light': errorLight,
    'dark': Color(0xFFDC2626),
    'text': Color(0xFF991B1B),
  };

  static const Map<String, Color> infoScheme = {
    'primary': info,
    'light': infoLight,
    'dark': Color(0xFF2563EB),
    'text': Color(0xFF1E40AF),
  };
}
