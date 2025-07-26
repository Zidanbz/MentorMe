import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF339989);
  static const Color primaryLight = Color(0xFFE0FFF3);
  static const Color primaryDark = Color(0xFF2A7A6B);

  // Secondary Colors
  static const Color secondary = Color(0xFF6C757D);
  static const Color accent = Color(0xFF007BFF);

  // Background Colors
  static const Color background = Colors.white;
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF343A40);

  // Text Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textLight = Colors.white;
  static const Color textHint = Colors.grey;

  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // UI Colors
  static const Color divider = Color(0xFFE9ECEF);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
