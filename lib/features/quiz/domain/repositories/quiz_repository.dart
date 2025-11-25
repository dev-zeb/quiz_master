import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';

abstract class QuizRepository {
  Future<void> addQuiz(Quiz quiz);

  Future<void> deleteQuizById(String id);

  Future<void> updateQuiz(Quiz quiz);

  List<Quiz> getQuizzes();

  Quiz? getQuizById(String id);

  Future<void> addQuizHistory(QuizHistory quizHistory);

  List<QuizHistory> getQuizHistoryList();

  QuizHistory? getQuizHistoryById(String id);

  Future<void> syncQuizzes({required String userId});
}
