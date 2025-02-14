import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';

abstract class QuizRepository {
  void addQuiz(Quiz quiz);
  void deleteQuizById(String id);
  void updateQuiz(Quiz quiz);
  Quiz? getQuizById(String id);
  List<Quiz> getQuizzes();
}
