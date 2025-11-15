import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';

abstract class QuizRemoteDataSource {
  /// Upserts (creates or updates) a quiz for the given user.
  Future<void> upsertQuiz(QuizModel quiz);

  /// Deletes a quiz with [quizId] for [userId].
  Future<void> deleteQuiz({
    required String userId,
    required String quizId,
  });

  /// Fetches all quizzes for the given user from Firestore.
  Future<List<QuizModel>> fetchQuizzes(String userId);
}
