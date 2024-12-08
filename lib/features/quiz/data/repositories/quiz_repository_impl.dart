import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final List<Quiz> _quizzes = [];

  @override
  List<Quiz> getQuizzes() => List.unmodifiable(_quizzes);

  @override
  void addQuiz(Quiz quiz) {
    _quizzes.add(quiz);
  }

  @override
  void removeQuiz(Quiz quiz) {
    _quizzes.remove(quiz);
  }

  @override
  Future<void> saveQuizzes() async {
    // TODO: Implement persistence
  }

  @override
  Future<void> loadQuizzes() async {
    // TODO: Implement loading from storage
  }
}
