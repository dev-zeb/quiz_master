import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:learn_and_quiz/core/config/strings.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeModeKey = 'theme_mode';
  late final Box<ThemeMode> _themeBox;

  ThemeNotifier() : super(ThemeMode.system);

  Future<void> initializeTheme() async {
    try {
      _themeBox = Hive.box<ThemeMode>(AppStrings.themeBoxName);
      final savedTheme = _themeBox.get(_themeModeKey, defaultValue: ThemeMode.system);
      state = savedTheme ?? ThemeMode.system;
    } catch (err, stk) {
      debugPrint("Error initializing theme: $err");
      debugPrint("Stack: $stk");
      state = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    try {
      final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      await _themeBox.put(_themeModeKey, newTheme);
      state = newTheme;
    } catch (err, stk) {
      debugPrint("Error toggling theme: $err");
      debugPrint("Stack: $stk");
    }
  }

  ThemeMode get currentThemeMode => state;
}
