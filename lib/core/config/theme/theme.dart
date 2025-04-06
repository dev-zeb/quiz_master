// app_themes.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Teal Palette
  static const Color primary = Color(0xFF013138);
  static const Color primaryVariant = Color(0xFF00282E);
  static const Color secondary = Color(0xFF03707D);
  static const Color secondaryVariant = Color(0xFF7CB3AC);
  static const Color tertiary = Color(0xFF8FBC8F);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onBackground = Colors.white;
  static const Color onSurface = Colors.white;

  // static const Color primaryDark = Color(0xFF02454E);
  static const Color primaryDark = Color(0xFF02454E);
  static const Color primaryVariantDark = Color(0xFF001E23);
  static const Color secondaryDark = Color(0xFF558B82);
  static const Color secondaryVariantDark = Color(0xFF7CB3AC);
  static const Color tertiaryDark = Color(0xFF669966);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onPrimaryDark = Colors.white;
  static const Color onSecondaryDark = Colors.white;
  static const Color onBackgroundDark = Colors.white;
  static const Color onSurfaceDark = Colors.white;

  // Semantic AppColors
  static const Color error = Color(0xFFE80F30);
  static const Color onError = Colors.white;
  static const Color successGreen = Color(0xFF29C531);
  static const Color warningOrange = Color(0xFFFFA000);
  static const Color transparent = Colors.transparent;
}

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryVariant,
          onPrimary: AppColors.background,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryVariant,
          onSecondary: AppColors.background,
          error: AppColors.error,
          onError: AppColors.background,
          surface: AppColors.background,
          onSurface: AppColors.primary,
          tertiary: AppColors.tertiary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.langarTextTheme(),
        iconTheme: const IconThemeData(color: AppColors.primary),
        splashFactory: InkRipple.splashFactory,
        highlightColor: AppColors.transparent,
        splashColor: AppColors.tertiary,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.background,
          primaryContainer: AppColors.primaryVariant,
          onPrimary: AppColors.primary,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryVariant,
          onSecondary: AppColors.primary,
          error: AppColors.error,
          onError: AppColors.primary,
          surface: AppColors.primary,
          onSurface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.background),
        splashFactory: InkRipple.splashFactory,
        highlightColor: AppColors.transparent,
        splashColor: AppColors.primary.withOpacity(0.1),
        textTheme: GoogleFonts.langarTextTheme(),
      );
}
