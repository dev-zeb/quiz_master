import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';

abstract class QuizRepository {
  List<Quiz> getQuizzes();
  void addQuiz(Quiz quiz);
  void removeQuiz(Quiz quiz);
  Future<void> saveQuizzes();
  Future<void> loadQuizzes();
}
