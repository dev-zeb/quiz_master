import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:learn_and_quiz/features/quiz/data/repositories/quiz_repository_impl.dart';

part 'quiz_provider.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  late final QuizRepository _repository;

  @override
  List<Quiz> build() {
    _repository = QuizRepositoryImpl();
    return _repository.getQuizzes();
  }

  void addQuiz(Quiz quiz) {
    _repository.addQuiz(quiz);
    state = _repository.getQuizzes();
  }

  void removeQuiz(Quiz quiz) {
    _repository.removeQuiz(quiz);
    state = _repository.getQuizzes();
  }

  Future<void> saveQuizzes() async {
    await _repository.saveQuizzes();
  }

  Future<void> loadQuizzes() async {
    await _repository.loadQuizzes();
    state = _repository.getQuizzes();
  }
}
