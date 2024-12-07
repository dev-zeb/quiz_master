import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 78, 13, 151);
  static const Color secondary = Color.fromARGB(255, 107, 15, 168);
  static const Color white = Colors.white;
  static const Color green = Colors.green;

  // Gradient colors
  static const List<Color> backgroundGradient = [
    primary,
    secondary,
  ];

  // Opacity colors
  static Color whiteWithOpacity(double opacity) => white.withOpacity(opacity);
}
