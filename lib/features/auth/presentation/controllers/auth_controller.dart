import 'dart:async';
import 'package:quiz_master/core/di/injection.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';
import 'package:quiz_master/features/auth/domain/repositories/auth_repository.dart';

/// Deprecated: Use AuthBloc instead.
/// This exists only to avoid breaking older imports.
@Deprecated('Use AuthBloc for auth state and actions.')
class AuthController {
  AuthController() : _repository = getIt<AuthRepository>();

  final AuthRepository _repository;

  Stream<AppUser?> authStateChanges() => _repository.authStateChanges();

  AppUser? get currentUser => _repository.currentUser;

  Future<AppUser?> signInWithGoogle() => _repository.signInWithGoogle();

  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _repository.signInWithEmail(email: email, password: password);

  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) =>
      _repository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

  Future<void> signOut() => _repository.signOut();
}
