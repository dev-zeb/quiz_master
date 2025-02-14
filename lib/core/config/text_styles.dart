import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle titleLarge = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleMedium = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle titleSmall = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyText = TextStyle(
    color: AppColors.white,
    fontSize: 16,
  );

  static TextStyle labelText = TextStyle(
    color: AppColors.whiteWithOpacity(0.8),
    fontSize: 14,
  );
}
