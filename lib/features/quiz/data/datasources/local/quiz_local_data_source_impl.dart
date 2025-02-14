import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/features/quiz/data/datasources/local/quiz_local_data_source.dart';
import 'package:learn_and_quiz/features/quiz/data/models/quiz_model.dart';

final hiveLocalDataSourceProvider = Provider<QuizLocalDataSource>((ref) {
  final quizBox = Hive.box<QuizModel>(AppStrings.quizDataBox);
  return HiveLocalDataSource(quizBox);
});

class HiveLocalDataSource implements QuizLocalDataSource {
  final Box<QuizModel> quizBox;
  HiveLocalDataSource(this.quizBox);

  @override
  void addQuiz(QuizModel quiz) {
    quizBox.put(quiz.id, quiz);
  }

  @override
  void deleteQuizById(String id) {
    quizBox.delete(id);
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
  void updateQuiz(QuizModel quiz) {
    quizBox.put(quiz.id, quiz);
  }
}
