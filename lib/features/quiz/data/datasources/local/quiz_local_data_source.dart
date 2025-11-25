import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_history_model.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';

/// Provider that exposes a QuizLocalDataSource backed by Hive.
final hiveLocalDataSourceProvider = Provider<QuizLocalDataSource>((ref) {
  final quizBox = Hive.box<QuizModel>(AppStrings.quizBoxName);
  final quizHistoryBox =
      Hive.box<QuizHistoryModel>(AppStrings.quizHistoryBoxName);

  return HiveLocalDataSource(
    quizBox,
    quizHistoryBox,
  );
});

/// Abstraction for local quiz persistence (data-layer detail).
abstract class QuizLocalDataSource {
  QuizModel? getQuizById(String id);

  List<QuizModel> getQuizzes();

  Future<void> addQuiz(QuizModel quiz);

  Future<void> deleteQuizById(String id);

  Future<void> updateQuiz(QuizModel quiz);

  Future<void> upsertQuizzes(List<QuizModel> quizzes);

  // Detailed history
  Future<void> addQuizHistory(QuizHistoryModel quizHistory);

  List<QuizHistoryModel> getQuizHistoryList();

  QuizHistoryModel? getQuizHistoryById(String id);
}

/// Hive-based implementation of [QuizLocalDataSource].
class HiveLocalDataSource implements QuizLocalDataSource {
  final Box<QuizModel> quizBox;
  final Box<QuizHistoryModel> quizHistoryBox;

  HiveLocalDataSource(
    this.quizBox,
    this.quizHistoryBox,
  );

  @override
  Future<void> addQuiz(QuizModel quiz) async {
    await quizBox.put(quiz.id, quiz);
  }

  @override
  Future<void> deleteQuizById(String id) async {
    await quizBox.delete(id);
  }

  @override
  QuizModel? getQuizById(String id) {
    return quizBox.get(id);
  }

  @override
  List<QuizModel> getQuizzes() {
    return quizBox.values.toList();
  }

  @override
  Future<void> updateQuiz(QuizModel quiz) async {
    await quizBox.put(quiz.id, quiz);
  }

  @override
  Future<void> upsertQuizzes(List<QuizModel> quizzes) async {
    await quizBox.putAll({
      for (final quiz in quizzes) quiz.id: quiz,
    });
  }

  @override
  Future<void> addQuizHistory(QuizHistoryModel quizHistory) async {
    await quizHistoryBox.put(quizHistory.id, quizHistory);
  }

  @override
  List<QuizHistoryModel> getQuizHistoryList() {
    return quizHistoryBox.values.toList();
  }

  @override
  QuizHistoryModel? getQuizHistoryById(String id) {
    return quizHistoryBox.get(id);
  }
}
