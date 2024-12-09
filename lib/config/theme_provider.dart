// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends StateNotifier<bool> {
  final String _key = 'theme_mode';

  ThemeProvider() : super(false) {
    _loadThemeFromPrefs();
  }

  Future<void> toggleTheme() async {
    state = !state;
    await _saveThemeToPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeProvider, bool>((ref) {
  return ThemeProvider();
});
