import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';

abstract class AiQuizRepository {
  Future<Quiz> generateQuizFromText({
    required String text,
    required int numQuestions,
    required String? userId,
    required int durationSeconds,
  });

  Future<Quiz> generateQuizFromFile({
    required List<int> bytes,
    required String filename,
    required int numQuestions,
    required String? userId,
    required int durationSeconds,
    String? extraInstructions,
  });
}
