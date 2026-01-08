import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';
import 'package:quiz_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_master/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_master/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInWithGoogleRequested>(_onGoogle);
    on<AuthSignInWithEmailRequested>(_onEmail);
    on<AuthSignUpWithEmailRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
    _registerInternalHandlers();
  }

  final AuthRepository _repo;
  StreamSubscription<AppUser?>? _sub;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    await _sub?.cancel();
    _sub = _repo.authStateChanges().listen(
      (user) {
        if (user == null) {
          add(_AuthInternalUnauthed());
        } else {
          add(_AuthInternalAuthed(user));
        }
      },
      onError: (e) => add(_AuthInternalError(e)),
    );
  }

  Future<void> _onGoogle(
      AuthSignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signInWithGoogle();
      if (user == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthFailure(e));
      rethrow;
    }
  }

  Future<void> _onEmail(
      AuthSignInWithEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signInWithEmail(
          email: event.email, password: event.password);
      if (user == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthFailure(e));
      rethrow;
    }
  }

  Future<void> _onSignUp(
      AuthSignUpWithEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signUpWithEmail(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );
      if (user == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthFailure(e));
      rethrow;
    }
  }

  Future<void> _onSignOut(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repo.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e));
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

// Internal events for stream updates
class _AuthInternalAuthed extends AuthEvent {
  final AppUser user;

  const _AuthInternalAuthed(this.user);

  @override
  List<Object?> get props => [user];
}

class _AuthInternalUnauthed extends AuthEvent {}

class _AuthInternalError extends AuthEvent {
  final Object error;

  const _AuthInternalError(this.error);

  @override
  List<Object?> get props => [error];
}

// Handle internal events
extension on AuthBloc {
  void _registerInternalHandlers() {
    on<_AuthInternalAuthed>((e, emit) => emit(AuthAuthenticated(e.user)));
    on<_AuthInternalUnauthed>((e, emit) => emit(AuthUnauthenticated()));
    on<_AuthInternalError>((e, emit) => emit(AuthFailure(e.error)));
  }
}
