import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<AppUser?> authStateChanges() {
    return _dataSource.authStateChanges().map(_mapFirebaseUser);
  }

  @override
  AppUser? get currentUser => _mapFirebaseUser(_dataSource.currentUser);

  @override
  Future<AppUser?> signInWithGoogle() async {
    final credential = await _dataSource.signInWithGoogle();
    return _mapFirebaseUser(credential.user);
  }

  @override
  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _dataSource.signInWithEmail(
      email: email,
      password: password,
    );
    return _mapFirebaseUser(credential.user);
  }

  @override
  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _dataSource.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    return _mapFirebaseUser(credential.user);
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  AppUser? _mapFirebaseUser(dynamic user) {
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
