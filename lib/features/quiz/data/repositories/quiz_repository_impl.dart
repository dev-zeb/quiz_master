import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/data/datasources/local/quiz_local_data_source.dart';
import 'package:learn_and_quiz/features/quiz/data/datasources/local/quiz_local_data_source_impl.dart';
import 'package:learn_and_quiz/features/quiz/data/models/quiz_model.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz_history.dart';
import 'package:learn_and_quiz/features/quiz/domain/repositories/quiz_repository.dart';

import '../models/quiz_history_model.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final quizLocalDataSource = ref.watch(hiveLocalDataSourceProvider);
  return QuizRepositoryImpl(quizLocalDataSource);
});

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource quizLocalDataSource;

  QuizRepositoryImpl(this.quizLocalDataSource);

  @override
  Future<void> addQuiz(Quiz quiz) async {
    await quizLocalDataSource.addQuiz(QuizModel.fromEntity(quiz));
  }

  @override
  Future<void> deleteQuizById(String id) async {
    await quizLocalDataSource.deleteQuizById(id);
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    await quizLocalDataSource.updateQuiz(QuizModel.fromEntity(quiz));
  }

  @override
  Quiz? getQuizById(String id) {
    final quizModel = quizLocalDataSource.getQuizById(id);
    return quizModel?.toEntity();
  }

  @override
  List<Quiz> getQuizzes() {
    final quizModelList = quizLocalDataSource.getQuizzes();
    return quizModelList.map((q) => q.toEntity()).toList();
  }

  @override
  Future<void> addQuizHistory(QuizHistory quizHistory) async {
    await quizLocalDataSource.addQuizHistory(
      QuizHistoryModel.fromEntity(quizHistory),
    );
  }

  @override
  List<QuizHistory> getQuizHistoryList() {
    final quizHistoryModelList = quizLocalDataSource.getQuizHistoryList();
    return quizHistoryModelList
        .map((quizHistoryModel) => quizHistoryModel.toEntity())
        .toList();
  }

  @override
  QuizHistory? getQuizHistoryById(String id) {
    final quizHistoryModel = quizLocalDataSource.getQuizHistoryById(id);
    return quizHistoryModel?.toEntity();
  }
}
