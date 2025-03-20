import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
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

  void getQuizzes() {
    state = repository.getQuizzes();
  }

  void addQuiz(Quiz quiz) {
    repository.addQuiz(quiz);
    getQuizzes();
  }

  Quiz? getQuizById(String id) => repository.getQuizById(id);

  void deleteQuiz(String id) {
    repository.deleteQuizById(id);
    getQuizzes();
  }

  void updateQuiz(Quiz quiz) {
    repository.updateQuiz(quiz);
    getQuizzes();
  }
}
