import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/core/config/theme/app_themes.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeData>(
  () => ThemeNotifier(),
);

class ThemeNotifier extends Notifier<ThemeData> {
  late AppTheme _currentTheme;

  @override
  ThemeData build() {
    try {
      final preferences = ref.read(appPreferencesProvider);
      _currentTheme = preferences.getTheme();
      return _currentTheme == AppTheme.dark ? _darkTheme : _lightTheme;
    } catch (err) {
      debugPrint('Error occurred while building Theme Notifier');
      rethrow;
    }
  }

  bool get isDark => _currentTheme == AppTheme.dark;

  void toggleTheme(bool isDark) {
    final newTheme = isDark ? AppTheme.dark : AppTheme.light;
    _currentTheme = newTheme;
    ref.read(appPreferencesProvider).setTheme(newTheme);
    state = newTheme == AppTheme.dark ? _darkTheme : _lightTheme;
  }

  static final _lightTheme = AppThemes.lightTheme;

  static final _darkTheme = AppThemes.darkTheme;
}

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  try {
    final box = Hive.box<String>(AppStrings.themeBoxName);
    return AppPreferences(box);
  } catch (err, stk) {
    debugPrint('[sufi] error: $err\nstack: $stk');
    rethrow;
  }
});

class AppPreferences {
  static const String _themeKey = 'selected_theme';
  static const String _fontKey = 'default_font';
  static const String _fontColorKey = 'default_font_color';

  final Box<String> _box;

  AppPreferences(this._box);

  // Theme methods
  Future<void> setTheme(AppTheme theme) async {
    await _box.put(_themeKey, theme.toString());
  }

  AppTheme getTheme() {
    final theme = _box.get(_themeKey, defaultValue: AppTheme.light.toString());
    return AppTheme.values.firstWhere(
      (e) => e.toString() == theme,
      orElse: () => AppTheme.light,
    );
  }

  AppTheme getThemeSync() {
    final theme = _box.get(_themeKey, defaultValue: AppTheme.light.toString());
    return AppTheme.values.firstWhere(
      (e) => e.toString() == theme,
      orElse: () => AppTheme.light,
    );
  }

  // Font methods
  Future<void> setDefaultFont(double font) async {
    await _box.put(_fontKey, font.toString());
  }

  double getDefaultFont() {
    final fontString = _box.get(_fontKey);
    return fontString == null ? 20.0 : double.parse(_box.get(_fontKey)!);
  }

  // Font color methods
  Future<void> setDefaultFontColor(String color) async {
    await _box.put(_fontColorKey, color);
  }

  String? getDefaultFontColor() {
    final color = _box.get(_fontColorKey);
    return color;
  }
}
