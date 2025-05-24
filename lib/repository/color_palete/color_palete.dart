import 'package:flutter/material.dart';

class ColorPalette {
  // Main Theme Colors - These are the common colors used across all screens
  static const Color primaryColor = Color(0xFF009085);    // Teal
  static const Color secondaryColor = Color(0xFF2F4858);  // Dark Blue
  static const Color accentColor = Color(0xFFF6C445);     // Gold/Yellow
  static const Color darkAccent = Color(0xFF006B7C);      // Dark Teal
  static const Color lightAccent = Color(0xFFFDD90D);     // Bright Yellow

  // Additional Colors
  static const Color success = Color(0xFF27AF34);         // Green
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFFC5C5C5);

  // Material Theme Colors for App Theme
  static MaterialColor primarySwatch = MaterialColor(0xFF009085, {
    50: const Color(0xFFE0F2F1),
    100: const Color(0xFFB2DFDB),
    200: const Color(0xFF80CBC4),
    300: const Color(0xFF4DB6AC),
    400: const Color(0xFF26A69A),
    500: primaryColor,
    600: const Color(0xFF00897B),
    700: const Color(0xFF00796B),
    800: const Color(0xFF00695C),
    900: const Color(0xFF004D40),
  });
}
