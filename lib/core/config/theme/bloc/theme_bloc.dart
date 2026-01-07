import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_master/core/config/theme/bloc/theme_event.dart';
import 'package:quiz_master/core/config/theme/bloc/theme_state.dart';

import '../app_themes.dart';
import '../theme_prefs.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(this._prefs)
      : super(ThemeState(
          themeData: AppThemes.lightTheme,
          isDark: false,
        )) {
    on<ThemeBootstrapped>(_onBootstrapped);
    on<ThemeToggled>(_onToggled);
  }

  final ThemePrefs _prefs;

  Future<void> _onBootstrapped(
    ThemeBootstrapped event,
    Emitter<ThemeState> emit,
  ) async {
    final stored = _prefs.getTheme();
    final isDark = stored == AppTheme.dark;
    emit(
      ThemeState(
        themeData: isDark ? AppThemes.darkTheme : AppThemes.lightTheme,
        isDark: isDark,
      ),
    );
  }

  Future<void> _onToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    final theme = event.isDark ? AppTheme.dark : AppTheme.light;
    await _prefs.setTheme(theme);
    emit(
      ThemeState(
        themeData: event.isDark ? AppThemes.darkTheme : AppThemes.lightTheme,
        isDark: event.isDark,
      ),
    );
  }
}
