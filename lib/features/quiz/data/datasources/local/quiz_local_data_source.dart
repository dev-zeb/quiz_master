import 'package:hive/hive.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_history_model.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';

abstract class QuizLocalDataSource {
  Future<void> addQuiz(QuizModel quiz);

  Future<void> deleteQuizById(String id);

  Future<void> updateQuiz(QuizModel quiz);

  List<QuizModel> getQuizzes();

  QuizModel? getQuizById(String id);

  Future<void> addQuizHistory(QuizHistoryModel quizHistory);

  List<QuizHistoryModel> getQuizHistoryList();

  QuizHistoryModel? getQuizHistoryById(String id);
}

class HiveLocalDataSource implements QuizLocalDataSource {
  final Box<QuizModel> _quizBox;
  final Box<QuizHistoryModel> _historyBox;

  HiveLocalDataSource({
    required Box<QuizModel> quizBox,
    required Box<QuizHistoryModel> quizHistoryBox,
  })  : _quizBox = quizBox,
        _historyBox = quizHistoryBox;

  @override
  Future<void> addQuiz(QuizModel quiz) async {
    await _quizBox.put(quiz.id, quiz);
  }

  @override
  Future<void> deleteQuizById(String id) async {
    await _quizBox.delete(id);
  }

  @override
  Future<void> updateQuiz(QuizModel quiz) async {
    await _quizBox.put(quiz.id, quiz);
  }

  @override
  List<QuizModel> getQuizzes() {
    return _quizBox.values.toList(growable: false);
  }

  @override
  QuizModel? getQuizById(String id) => _quizBox.get(id);

  @override
  Future<void> addQuizHistory(QuizHistoryModel quizHistory) async {
    await _historyBox.put(quizHistory.id, quizHistory);
  }

  @override
  List<QuizHistoryModel> getQuizHistoryList() {
    return _historyBox.values.toList(growable: false);
  }

  @override
  QuizHistoryModel? getQuizHistoryById(String id) => _historyBox.get(id);
}
