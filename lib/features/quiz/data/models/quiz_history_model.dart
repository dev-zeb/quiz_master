import 'package:hive/hive.dart';
import 'package:quiz_master/features/quiz/data/models/question_model.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';

part 'quiz_history_model.g.dart';

@HiveType(typeId: 3)
class QuizHistoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String quizId;

  @HiveField(2)
  final String quizTitle;

  @HiveField(3)
  final List<QuestionModel> questions;

  @HiveField(4)
  final List<String?> selectedAnswers;

  @HiveField(5)
  final DateTime playedAt;

  @HiveField(6)
  final int elapsedTimeSeconds;

  @HiveField(7)
  final int totalDurationSeconds;

  @HiveField(8)
  final String? userId;

  QuizHistoryModel({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.questions,
    required this.selectedAnswers,
    required this.playedAt,
    required this.elapsedTimeSeconds,
    required this.totalDurationSeconds,
    required this.userId,
  });

  // Convert from domain entity to data model
  factory QuizHistoryModel.fromEntity(QuizHistory quizHistory) {
    return QuizHistoryModel(
      id: quizHistory.id,
      quizId: quizHistory.quizId,
      quizTitle: quizHistory.quizTitle,
      questions: quizHistory.questions
          .map((question) => QuestionModel.fromEntity(question))
          .toList(),
      selectedAnswers: quizHistory.selectedAnswers,
      playedAt: quizHistory.playedAt,
      elapsedTimeSeconds: quizHistory.elapsedTimeSeconds,
      totalDurationSeconds: quizHistory.totalDurationSeconds,
      userId: quizHistory.userId,
    );
  }

  // Convert from data model to domain entity
  QuizHistory toEntity() {
    return QuizHistory(
      id: id,
      quizId: quizId,
      quizTitle: quizTitle,
      selectedAnswers: selectedAnswers,
      questions: questions.map((question) => question.toEntity()).toList(),
      playedAt: playedAt,
      elapsedTimeSeconds: elapsedTimeSeconds,
      totalDurationSeconds: totalDurationSeconds,
      userId: userId,
    );
  }
}
