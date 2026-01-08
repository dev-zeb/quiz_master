import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_state.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({
    required QuizRepository quizRepository,
    required AuthRepository authRepository,
  })  : _repo = quizRepository,
        _authRepo = authRepository,
        super(QuizState.initial()) {
    on<QuizBootstrapped>(_onBootstrapped);
    on<QuizReloadRequested>(_onReload);
    on<QuizAdded>(_onAdd);
    on<QuizUpdated>(_onUpdate);
    on<QuizDeleted>(_onDelete);
    on<QuizHistoryAdded>(_onHistoryAdded);
    on<QuizSyncRequested>(_onSync);
  }

  final QuizRepository _repo;
  final AuthRepository _authRepo;

  Future<void> _onBootstrapped(
      QuizBootstrapped event, Emitter<QuizState> emit) async {
    await _loadLocal(emit);

    final user = _authRepo.currentUser;
    if (user != null) {
      add(QuizSyncRequested(user.id));
    }
  }

  Future<void> _onReload(
      QuizReloadRequested event, Emitter<QuizState> emit) async {
    await _loadLocal(emit);
  }

  Future<void> _onAdd(QuizAdded event, Emitter<QuizState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _repo.addQuiz(event.quiz);
      await _loadLocal(emit);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  Future<void> _onUpdate(QuizUpdated event, Emitter<QuizState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _repo.updateQuiz(event.quiz);
      await _loadLocal(emit);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  Future<void> _onDelete(QuizDeleted event, Emitter<QuizState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _repo.deleteQuizById(event.id);
      await _loadLocal(emit);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  Future<void> _onHistoryAdded(
      QuizHistoryAdded event, Emitter<QuizState> emit) async {
    try {
      await _repo.addQuizHistory(event.history);
      final histories = _repo.getQuizHistoryList();
      emit(state.copyWith(histories: histories));
    } catch (e) {
      emit(state.copyWith(error: e));
    }
  }

  Future<void> _onSync(QuizSyncRequested event, Emitter<QuizState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _repo.syncQuizzes(userId: event.userId);
      await _loadLocal(emit);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  Future<void> _loadLocal(Emitter<QuizState> emit) async {
    try {
      final quizzes = _repo.getQuizzes();
      final histories = _repo.getQuizHistoryList();
      emit(
        state.copyWith(
          isLoading: false,
          quizzes: quizzes,
          histories: histories,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  Quiz? getQuizById(String id) => _repo.getQuizById(id);
}
