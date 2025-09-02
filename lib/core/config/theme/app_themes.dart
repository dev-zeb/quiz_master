import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static var langarTextFont = GoogleFonts.langarTextTheme();
}

enum AppTheme {
  light,
  dark,
}

class AppColors {
  /// Light Theme Colors
  static const Color primary = Color(0xFF025A65);
  static const Color onPrimary = surface;
  static const Color secondary = Color(0xFF83A39E);
  static const Color onSecondary = Color(0xFF00282E);
  static const Color surface = Colors.white;
  static const Color onSurface = primary;
  static const Color primaryVariant = Color(0xFF00282E);
  static const Color secondaryVariant = Color(0xFF2FB8A7);
  static const Color surfaceContainer = Color(0xFFF5F8F8);

  /// Dark Theme Colors
  static const Color primaryDark = Color(0xFF7CB3AC);
  static const Color onPrimaryDark = Color(0xFF011A1E);
  static const Color secondaryDark = Color(0xFF61AEA5);
  static const Color onSecondaryDark = Color(0xFF252C2C);

  static const Color surfaceDark = Color(0xFF252C2C);
  static const Color onSurfaceDark = Colors.white;
  static const Color primaryVariantDark = Color(0xFFF4F1F4);
  static const Color secondaryVariantDark = Color(0xFF39AACC);
  static const Color surfaceContainerDark = Color(0xFF404C49);

  /// Semantic App Colors
  static const Color error = Color(0xFFC14054);
  static const Color onError = Color(0xFFE3D7D9);
  static const Color errorDark = Color(0xFFAE5864);
  static const Color onErrorDark = Color(0xFFDAC7CA);
  static const Color successGreen = Color(0xFF009106);
  static const Color onSuccessGreen = Color(0xFFCFDACF);
  static const Color successGreenDark = Color(0xFF59A161);
  static const Color onSuccessGreenDark = Color(0xFFC7DCC9);
  static const Color warningOrange = Color(0xFFFFA000);
  static const Color transparent = Colors.transparent;
}

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.surfaceContainer,
          error: AppColors.error,
          onError: AppColors.onError,
          surface: AppColors.primaryDark,
          onSurface: AppColors.onPrimaryDark,
          primaryContainer: AppColors.primaryVariant,
          secondaryContainer: AppColors.secondaryVariant,
          surfaceContainer: AppColors.surfaceContainer,
          tertiary: AppColors.successGreen,
          onTertiary: AppColors.onSuccessGreen,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
        ),
        highlightColor: AppColors.transparent,
        iconTheme: const IconThemeData(color: AppColors.primary),
        scaffoldBackgroundColor: AppColors.surface,
        splashColor: AppColors.secondaryVariant.withValues(alpha: 0.5),
        splashFactory: InkRipple.splashFactory,
        textTheme: AppFonts.langarTextFont,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primaryDark,
          onPrimary: AppColors.onPrimaryDark,
          secondary: AppColors.secondaryDark,
          onSecondary: AppColors.onSecondaryDark,
          error: AppColors.errorDark,
          onError: AppColors.onErrorDark,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.onSurfaceDark,
          primaryContainer: AppColors.primaryVariantDark,
          secondaryContainer: AppColors.secondaryVariantDark,
          surfaceContainer: AppColors.surfaceContainerDark,
          tertiary: AppColors.successGreenDark,
          onTertiary: AppColors.onSuccessGreenDark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: AppColors.onSurfaceDark,
        ),
        highlightColor: AppColors.transparent,
        iconTheme: const IconThemeData(color: AppColors.surfaceContainer),
        scaffoldBackgroundColor: AppColors.surfaceDark,
        splashColor: AppColors.onPrimaryDark.withValues(alpha: 0.3),
        splashFactory: InkRipple.splashFactory,
        textTheme: AppFonts.langarTextFont,
      );
}
