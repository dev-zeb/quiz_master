import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz_history.dart';
import 'package:learn_and_quiz/features/quiz/domain/repositories/quiz_repository.dart';

final quizNotifierProvider =
    StateNotifierProvider<QuizNotifier, List<Quiz>>((ref) {
  final repository = ref.watch(quizRepositoryProvider);
  return QuizNotifier(repository);
});

class QuizNotifier extends StateNotifier<List<Quiz>> {
  final QuizRepository repository;

  QuizNotifier(this.repository) : super([]) {
    getQuizzes();
  }

  Quiz? getQuizById(String id) => repository.getQuizById(id);

  void getQuizzes() {
    state = repository.getQuizzes();
  }

  Future<void> addQuiz(Quiz quiz) async {
    await repository.addQuiz(quiz);
    getQuizzes();
  }

  Future<void> deleteQuiz(String id) async {
    await repository.deleteQuizById(id);
    getQuizzes();
  }

  Future<void> updateQuiz(Quiz quiz) async {
    await repository.updateQuiz(quiz);
    getQuizzes();
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
}
