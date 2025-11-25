import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';
import 'package:quiz_master/features/auth/domain/repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});

final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.maybeWhen(data: (user) => user, orElse: () => null);
});

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthRepository _repository;
  StreamSubscription<AppUser?>? _subscription;

  AuthController(this._repository) : super(const AsyncValue.loading()) {
    _subscription = _repository.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    }, onError: (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    });
  }

  Future<void> signInWithGoogle() async {
    await _guard(() => _repository.signInWithGoogle());
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _guard(
      () => _repository.signInWithEmail(email: email, password: password),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await _guard(
      () => _repository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  Future<void> signOut() async {
    await _guard(() async {
      await _repository.signOut();
      return null;
    });
  }

  Future<void> _guard(Future<AppUser?> Function() operation) async {
    state = const AsyncValue.loading();
    try {
      final user = await operation();
      state = AsyncValue.data(user);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
