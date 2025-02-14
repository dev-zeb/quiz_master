import 'package:learn_and_quiz/features/quiz/data/models/quiz_model.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';

abstract class QuizLocalDataSource {
  List<QuizModel> getQuizzes();   // ✅ Now returns List<QuizModel>
  void addQuiz(QuizModel quiz);   // ✅ Now accepts QuizModel
  void deleteQuizById(String id);
  QuizModel? getQuizById(String id);  // ✅ Now returns QuizModel?
  void updateQuiz(QuizModel quiz);  // ✅ Now accepts QuizModel
}
