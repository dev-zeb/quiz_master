import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  // static const Color primary = Color.fromARGB(255, 78, 13, 151);
  // static const Color secondary = Color.fromARGB(255, 107, 15, 168);
  static const Color primary = Color.fromARGB(255, 6, 65, 92);
  static const Color secondary = Color.fromARGB(255, 0, 54, 49);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  static const Color grey = Colors.grey;

  // Dark Theme Colors
  static const Color darkPrimary = Color.fromARGB(255, 0, 13, 19);
  static const Color darkSecondary = Color.fromARGB(255, 0, 0, 0);
  static const Color darkBackground = Color(0xDD000000);
  static const Color darkSurface = Color(0xFF000000);

  // Gradient colors
  static const List<Color> backgroundGradient = [
    primary,
    secondary,
  ];

  static const List<Color> darkBackgroundGradient = [
    darkPrimary,
    darkSecondary,
  ];

  // Opacity colors
  static Color whiteWithOpacity(double opacity) => white.withOpacity(opacity);
  static Color blackWithOpacity(double opacity) => black.withOpacity(opacity);

  // Text colors
  static const Color textPrimary = white;
  static const Color textSecondary = Colors.white70;
  static const Color darkTextPrimary = white;
  static const Color darkTextSecondary = Colors.white70;

  // Border colors
  static Color borderColor = whiteWithOpacity(0.3);
  static const Color focusedBorderColor = white;
  static const Color darkBorderColor = Colors.white54;
  static const Color darkFocusedBorderColor = white;
}

class AppThemeColors {
  static final lightThemeColors = {
    'primary': AppColors.primary,
    'secondary': AppColors.secondary,
    'backgroundGradient': AppColors.backgroundGradient,
    'textPrimary': AppColors.textPrimary,
    'textSecondary': AppColors.textSecondary,
    'borderColor': AppColors.borderColor,
  };

  static const darkThemeColors = {
    'primary': AppColors.darkPrimary,
    'secondary': AppColors.darkSecondary,
    'backgroundGradient': AppColors.darkBackgroundGradient,
    'textPrimary': AppColors.darkTextPrimary,
    'textSecondary': AppColors.darkTextSecondary,
    'borderColor': AppColors.darkBorderColor,
  };
}
