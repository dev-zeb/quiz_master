import 'package:learn_and_quiz/features/quiz/data/models/quiz_history_model.dart';
import 'package:learn_and_quiz/features/quiz/data/models/quiz_model.dart';

abstract class QuizLocalDataSource {
  QuizModel? getQuizById(String id);

  List<QuizModel> getQuizzes();

  Future<void> addQuiz(QuizModel quiz);

  Future<void> deleteQuizById(String id);

  Future<void> updateQuiz(QuizModel quiz);

  Future<void> addQuizHistory(QuizHistoryModel quizHistory);

  List<QuizHistoryModel> getQuizHistoryList();

  QuizHistoryModel? getQuizHistoryById(String id);
}
