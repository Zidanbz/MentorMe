import 'package:flutter/material.dart';
import 'package:mentorme/app/constants/app_colors.dart';

class AppTextStyles {
  // Display Styles - For large headings
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.3,
  );

  // Headline Styles - For section headers
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Title Styles - For card titles and important text
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
    height: 1.5,
  );

  // Body Styles - For regular content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: 'OpenSans',
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.6,
  );

  // Label Styles - For buttons and form labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'OpenSans',
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.textHint,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // Special Styles
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'OpenSans',
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    letterSpacing: 0.25,
    height: 1.2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: 'OpenSans',
    color: AppColors.textHint,
    letterSpacing: 0.4,
    height: 1.3,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.textHint,
    letterSpacing: 1.5,
    height: 1.6,
  );

  // Interactive Styles
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.primary,
    letterSpacing: 0.25,
    height: 1.4,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );

  static const TextStyle linkLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.primary,
    letterSpacing: 0.15,
    height: 1.4,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );

  // Status Styles
  static const TextStyle success = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.success,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static const TextStyle warning = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.warning,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static const TextStyle error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.error,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static const TextStyle info = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSans',
    color: AppColors.info,
    letterSpacing: 0.25,
    height: 1.4,
  );

  // Gradient Text Styles (for special effects)
  static TextStyle gradientText({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    double height = 1.4,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: 'OpenSans',
      letterSpacing: letterSpacing,
      height: height,
      foreground: Paint()
        ..shader = AppColors.primaryGradient.createShader(
          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
        ),
    );
  }

  // Helper methods for dynamic styling
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withSize(TextStyle style, double fontSize) {
    return style.copyWith(fontSize: fontSize);
  }

  static TextStyle withWeight(TextStyle style, FontWeight fontWeight) {
    return style.copyWith(fontWeight: fontWeight);
  }

  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }
}

// Legacy support - keeping old class names for backward compatibility
class judulstyle {
  static const TextStyle defaultTextStyle = AppTextStyles.headlineMedium;
}

class Subjudulstyle {
  static const TextStyle defaultTextStyle = AppTextStyles.headlineSmall;
}

class Captionsstyle {
  static const TextStyle defaultTextStyle = AppTextStyles.caption;
}
