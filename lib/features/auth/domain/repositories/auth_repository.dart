import 'package:quiz_master/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  Future<AppUser?> signInWithGoogle();

  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> signOut();

  AppUser? get currentUser;
}
