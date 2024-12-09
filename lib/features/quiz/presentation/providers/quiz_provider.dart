import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:learn_and_quiz/features/quiz/data/repositories/quiz_repository_impl.dart';

class QuizNotifier extends StateNotifier<List<Quiz>> {
  late final QuizRepository _repository;

  QuizNotifier() : super([]) {
    _repository = QuizRepositoryImpl();
    state = _repository.getQuizzes();
  }

  void addQuiz(Quiz quiz) {
    _repository.addQuiz(quiz);
    state = _repository.getQuizzes();
  }

  void removeQuiz(Quiz quiz) {
    _repository.removeQuiz(quiz);
    state = _repository.getQuizzes();
  }

  Future<void> saveQuizzes() async {
    await _repository.saveQuizzes();
  }

  Future<void> loadQuizzes() async {
    await _repository.loadQuizzes();
    state = _repository.getQuizzes();
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, List<Quiz>>((ref) {
  return QuizNotifier();
});
