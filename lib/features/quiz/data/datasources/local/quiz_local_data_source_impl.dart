import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/features/quiz/data/datasources/local/quiz_local_data_source.dart';
import 'package:learn_and_quiz/features/quiz/data/models/quiz_history_model.dart';
import 'package:learn_and_quiz/features/quiz/data/models/quiz_model.dart';

final hiveLocalDataSourceProvider = Provider<QuizLocalDataSource>((ref) {
  final quizBox = Hive.box<QuizModel>(AppStrings.quizBoxName);
  final quizHistoryBox = Hive.box<QuizHistoryModel>(AppStrings.quizHistoryBoxName);
  return HiveLocalDataSource(quizBox, quizHistoryBox);
});

class HiveLocalDataSource implements QuizLocalDataSource {
  final Box<QuizModel> quizBox;
  final Box<QuizHistoryModel> quizHistoryBox;

  HiveLocalDataSource(this.quizBox, this.quizHistoryBox);

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
