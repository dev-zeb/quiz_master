import 'package:flutter/material.dart';
import 'package:learn_and_quiz/core/config/colors.dart';
import 'package:learn_and_quiz/core/config/text_styles.dart';

abstract class Theme {
  ThemeData get themeData;
  ThemeColors get themeColors;
}

class ThemeColors {
  ThemeColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryVariant,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryVariant,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.backgroundGradient,
  });

  Color primary;
  Color onPrimary;
  Color primaryVariant;
  Color primaryContainer;
  Color onPrimaryContainer;
  Color secondary;
  Color onSecondary;
  Color secondaryVariant;
  Color background;
  Color onBackground;
  Color surface;
  Color onSurface;
  Color textPrimary;
  Color textSecondary;
  Color borderColor;
  Color focusedBorderColor;
  List<Color> backgroundGradient;
}

class LightTheme implements Theme {
  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColors.primary,
          primary: themeColors.primary,
          secondary: themeColors.secondary,
        ),
        scaffoldBackgroundColor: themeColors.primary,
        appBarTheme: AppBarTheme(
          backgroundColor: themeColors.primary,
          foregroundColor: themeColors.textPrimary,
          elevation: 0,
        ),
        textTheme: TextTheme(
          titleLarge:
              AppTextStyles.titleLarge.copyWith(color: themeColors.textPrimary),
          titleMedium: AppTextStyles.titleMedium
              .copyWith(color: themeColors.textPrimary),
          titleSmall:
              AppTextStyles.titleSmall.copyWith(color: themeColors.textPrimary),
          bodyLarge:
              AppTextStyles.bodyText.copyWith(color: themeColors.textSecondary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: AppTextStyles.labelText
              .copyWith(color: themeColors.textSecondary),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: themeColors.borderColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: themeColors.focusedBorderColor),
          ),
        ),
      );

  @override
  ThemeColors get themeColors => ThemeColors(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        primaryVariant: AppColors.primary.withOpacity(0.8),
        primaryContainer: AppColors.primary.withOpacity(0.2),
        onPrimaryContainer: AppColors.black,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        secondaryVariant: AppColors.secondary.withOpacity(0.8),
        background: AppColors.white,
        onBackground: AppColors.black,
        surface: AppColors.white,
        onSurface: AppColors.black,
        textPrimary: AppColors.black,
        textSecondary: AppColors.black,
        borderColor: AppColors.borderColor,
        focusedBorderColor: AppColors.focusedBorderColor,
        backgroundGradient: AppColors.backgroundGradient,
      );
}

class DarkTheme implements Theme {
  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColors.primary,
          primary: themeColors.primary,
          secondary: themeColors.secondary,
        ),
        scaffoldBackgroundColor: themeColors.primary,
        appBarTheme: AppBarTheme(
          backgroundColor: themeColors.primary,
          foregroundColor: themeColors.textPrimary,
          elevation: 0,
        ),
        textTheme: TextTheme(
          titleLarge:
              AppTextStyles.titleLarge.copyWith(color: themeColors.textPrimary),
          titleMedium: AppTextStyles.titleMedium
              .copyWith(color: themeColors.textPrimary),
          titleSmall:
              AppTextStyles.titleSmall.copyWith(color: themeColors.textPrimary),
          bodyLarge:
              AppTextStyles.bodyText.copyWith(color: themeColors.textSecondary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: AppTextStyles.labelText
              .copyWith(color: themeColors.textSecondary),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: themeColors.borderColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: themeColors.focusedBorderColor),
          ),
        ),
      );

  @override
  ThemeColors get themeColors => ThemeColors(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.white,
        primaryVariant: AppColors.darkPrimary.withOpacity(0.8),
        primaryContainer: AppColors.darkPrimary.withOpacity(0.2),
        onPrimaryContainer: AppColors.white,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.white,
        secondaryVariant: AppColors.darkSecondary.withOpacity(0.8),
        background: AppColors.darkBackground,
        onBackground: AppColors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.white,
        textPrimary: AppColors.darkTextPrimary,
        textSecondary: AppColors.darkTextSecondary,
        borderColor: AppColors.darkBorderColor,
        focusedBorderColor: AppColors.darkFocusedBorderColor,
        backgroundGradient: AppColors.darkBackgroundGradient,
      );
}
