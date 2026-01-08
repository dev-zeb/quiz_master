import 'package:equatable/equatable.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeBootstrapped extends ThemeEvent {}

class ThemeToggled extends ThemeEvent {
  final bool isDark;

  const ThemeToggled(this.isDark);

  @override
  List<Object?> get props => [isDark];
}
