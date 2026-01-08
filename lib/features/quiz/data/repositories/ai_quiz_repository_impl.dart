import 'dart:typed_data';
import 'package:quiz_master/features/quiz/data/datasources/remote/ai_quiz_remote_data_source.dart';
import 'package:quiz_master/features/quiz/domain/entities/question.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/repositories/ai_quiz_repository.dart';

class AiQuizRepositoryImpl implements AiQuizRepository {
  final AiQuizRemoteDataSource _remote;

  AiQuizRepositoryImpl(this._remote);

  @override
  Future<Quiz> generateQuizFromText({
    required String text,
    required int numQuestions,
    required String? userId,
    required int durationSeconds,
  }) async {
    final json = await _remote.generateFromText(
      text: text,
      numQuestions: numQuestions,
    );

    return _mapApiResponseToQuiz(
      quizJson: json,
      userId: userId,
      durationSeconds: durationSeconds,
    );
  }

  @override
  Future<Quiz> generateQuizFromFile({
    required List<int> bytes,
    required String filename,
    required int numQuestions,
    required String? userId,
    required int durationSeconds,
    String? extraInstructions,
  }) async {
    final json = await _remote.generateFromFile(
      bytes: Uint8List.fromList(bytes),
      filename: filename,
      numQuestions: numQuestions,
      extraInstructions: extraInstructions,
    );

    return _mapApiResponseToQuiz(
      quizJson: json,
      userId: userId,
      durationSeconds: durationSeconds,
    );
  }

  Quiz _mapApiResponseToQuiz({
    required Map<String, dynamic> quizJson,
    required String? userId,
    required int durationSeconds,
  }) {
    final id = quizJson['id'] as String;
    final title = quizJson['title'] as String;
    final questionsJson = quizJson['questions'] as List<dynamic>;

    final questions = questionsJson.map((q) {
      final qMap = q as Map<String, dynamic>;
      return Question(
        id: qMap['id'] as String,
        text: qMap['text'] as String,
        answers: List<String>.from(qMap['answers'] as List<dynamic>),
      );
    }).toList();

    return Quiz(
      id: id,
      title: title,
      questions: questions,
      durationSeconds: durationSeconds,
      userId: userId,
      lastSyncedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
      isPublic: false,
      createdByUserId: userId,
      createdAt: DateTime.now(),
      playCount: 0,
      sumScorePercent: 0,
      sumCorrectAnswers: 0,
      sumTotalQuestions: questions.length,
      isAiGenerated: true,
    );
  }
}
