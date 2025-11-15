import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';
import 'package:quiz_master/features/auth/presentation/controllers/auth_controller.dart';
import 'package:quiz_master/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';
import 'package:quiz_master/features/quiz/domain/repositories/quiz_repository.dart';

final quizNotifierProvider =
    StateNotifierProvider<QuizNotifier, AsyncValue<List<Quiz>>>((ref) {
  final repository = ref.watch(quizRepositoryProvider);
  final notifier = QuizNotifier(ref, repository);
  ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (previous, next) {
    final user = next.valueOrNull;
    if (user != null) {
      notifier.syncForUser(user.id);
    }
  });
  return notifier;
});

class QuizNotifier extends StateNotifier<AsyncValue<List<Quiz>>> {
  final QuizRepository repository;
  final Ref ref;

  QuizNotifier(this.ref, this.repository) : super(const AsyncValue.loading()) {
    _loadLocal();
  }

  void _loadLocal() {
    try {
      final quizzes = repository.getQuizzes();
      state = AsyncValue.data(quizzes);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Quiz? getQuizById(String id) => repository.getQuizById(id);

  Future<void> addQuiz(Quiz quiz) async {
    await _guard(() => repository.addQuiz(quiz));
  }

  Future<void> deleteQuiz(String id) async {
    await _guard(() => repository.deleteQuizById(id));
  }

  Future<void> updateQuiz(Quiz quiz) async {
    await _guard(() => repository.updateQuiz(quiz));
  }

  Future<void> addQuizHistory(QuizHistory quizHistory) async {
    await repository.addQuizHistory(quizHistory);
  }

  List<QuizHistory> getQuizHistoryList() {
    return repository.getQuizHistoryList();
  }

  QuizHistory? getQuizHistoryById(String id) {
    return repository.getQuizHistoryById(id);
  }

  Future<void> syncForUser(String userId) async {
    await _guard(() => repository.syncQuizzes(userId: userId));
  }

  Future<void> _guard(Future<void> Function() operation) async {
    try {
      state = const AsyncValue.loading();
      await operation();
      _loadLocal();
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}
