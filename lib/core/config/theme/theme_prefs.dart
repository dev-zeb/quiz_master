import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quiz_master/core/config/strings.dart';

import 'app_themes.dart';

class ThemePrefs {
  static const _themeKey = 'selected_theme';

  Box<String> get _box => Hive.box<String>(AppStrings.themeBoxName);

  AppTheme getTheme() {
    final theme = _box.get(_themeKey, defaultValue: AppTheme.light.toString());
    return AppTheme.values.firstWhere(
      (e) => e.toString() == theme,
      orElse: () => AppTheme.light,
    );
  }

  Future<void> setTheme(AppTheme theme) =>
      _box.put(_themeKey, theme.toString());
}

ThemeMode toThemeMode(AppTheme theme) =>
    theme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light;
