import 'package:equatable/equatable.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AppUser user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final Object error;

  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
