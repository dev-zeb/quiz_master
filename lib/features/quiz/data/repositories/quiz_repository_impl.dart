import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/data/datasources/local/quiz_local_data_source.dart';
import 'package:learn_and_quiz/features/quiz/data/datasources/local/quiz_local_data_source_impl.dart';
import 'package:learn_and_quiz/features/quiz/data/models/quiz_model.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/domain/repositories/quiz_repository.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final quizLocalDataSource = ref.watch(hiveLocalDataSourceProvider);
  return QuizRepositoryImpl(quizLocalDataSource);
});

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource quizLocalDataSource;

  QuizRepositoryImpl(this.quizLocalDataSource);

  @override
  List<Quiz> getQuizzes() {
    return quizLocalDataSource.getQuizzes().map((q) => q.toEntity()).toList();
  }

  @override
  void addQuiz(Quiz quiz) {
    quizLocalDataSource.addQuiz(QuizModel.fromEntity(quiz));
  }

  @override
  void deleteQuizById(String id) {
    quizLocalDataSource.deleteQuizById(id);
  }

  @override
  Quiz? getQuizById(String id) {
    final quizModel = quizLocalDataSource.getQuizById(id);
    return quizModel?.toEntity();
  }

  @override
  void updateQuiz(Quiz quiz) {
    quizLocalDataSource.updateQuiz(QuizModel.fromEntity(quiz));
  }
}

