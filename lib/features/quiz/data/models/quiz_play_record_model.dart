import 'package:hive/hive.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_play_record.dart';

part 'quiz_play_record_model.g.dart';

@HiveType(typeId: 4) // choose a free typeId
class QuizPlayRecordModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String quizId;

  @HiveField(3)
  final String quizTitle;

  @HiveField(4)
  final int correctAnswers;

  @HiveField(5)
  final int totalQuestions;

  @HiveField(6)
  final double scorePercent;

  @HiveField(7)
  final int elapsedTimeSeconds;

  @HiveField(8)
  final DateTime playedAt;

  QuizPlayRecordModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.scorePercent,
    required this.elapsedTimeSeconds,
    required this.playedAt,
  });

  factory QuizPlayRecordModel.fromEntity(QuizPlayRecord record) {
    return QuizPlayRecordModel(
      id: record.id,
      userId: record.userId,
      quizId: record.quizId,
      quizTitle: record.quizTitle,
      correctAnswers: record.correctAnswers,
      totalQuestions: record.totalQuestions,
      scorePercent: record.scorePercent,
      elapsedTimeSeconds: record.elapsedTimeSeconds,
      playedAt: record.playedAt,
    );
  }

  QuizPlayRecord toEntity() {
    return QuizPlayRecord(
      id: id,
      userId: userId,
      quizId: quizId,
      quizTitle: quizTitle,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      scorePercent: scorePercent,
      elapsedTimeSeconds: elapsedTimeSeconds,
      playedAt: playedAt,
    );
  }
}
