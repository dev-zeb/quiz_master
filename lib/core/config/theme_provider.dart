import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:learn_and_quiz/core/config/colors.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/core/config/theme.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeProvider, ThemeMode>((ref) {
  return ThemeProvider();
});

class ThemeProvider extends StateNotifier<ThemeMode> {
  final String _themeModeKey = 'theme_mode';
  late Map<String, dynamic> currentThemeColors;
  final LightTheme lightTheme = LightTheme();
  final DarkTheme darkTheme = DarkTheme();

  ThemeProvider() : super(ThemeMode.light) {
    _loadThemeFromHive();
  }

  // Load the theme mode from Hive when the app starts
  void _loadThemeFromHive() {
    try {
      final Box<ThemeMode> box = Hive.box(AppStrings.themeDataBox);
      ThemeMode? mode = box.get(_themeModeKey, defaultValue: ThemeMode.system);
      _setTheme(mode == ThemeMode.dark);
    } catch (err, stk) {
      debugPrint("Error: $err");
      debugPrint("Stack: $stk");
    }
  }

  // Method to update the theme mode and switch between Light and Dark themes
  Future<void> updateThemeMode({required bool mode}) async {
    try {
      _setTheme(mode);
      await _saveThemeToHive(mode);
    } catch (err, stk) {
      debugPrint("Error: $err");
      debugPrint("Stack: $stk");
    }
  }

  // Set the theme based on the provided mode
  void _setTheme(bool isDarkOn) {
    try {
      state = (isDarkOn == true) ? ThemeMode.dark : ThemeMode.light;
      currentThemeColors = isDarkOn
          ? AppThemeColors.darkThemeColors
          : AppThemeColors.lightThemeColors;
    } catch (err, stk) {
      debugPrint("Error: $err");
      debugPrint("Stack: $stk");
    }
  }

  // Save the selected theme mode to Hive
  Future<void> _saveThemeToHive(bool mode) async {
    try {
      final Box<ThemeMode> box = Hive.box(AppStrings.themeDataBox);
      await box.put(_themeModeKey, mode ? ThemeMode.dark : ThemeMode.light);
    } catch (err, stk) {
      debugPrint("Error: $err");
      debugPrint("Stack: $stk");
    }
  }

  // Method to get the current theme mode
  ThemeMode get currentThemeMode => state;
}
