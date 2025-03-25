import 'package:learn_and_quiz/features/quiz/data/models/quiz_model.dart';

abstract class QuizLocalDataSource {
  List<QuizModel> getQuizzes();
  void addQuiz(QuizModel quiz);
  void deleteQuizById(String id);
  QuizModel? getQuizById(String id);
  void updateQuiz(QuizModel quiz);
}
