import 'package:quiz_master/features/quiz/domain/entities/question.dart';

enum SyncStatus { synced, pending, failed }

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;
  final int durationSeconds;

  final String? userId;
  final DateTime? lastSyncedAt;
  final SyncStatus syncStatus;

  final bool isPublic;
  final String? createdByUserId;
  final DateTime? createdAt;

  final int playCount;
  final double sumScorePercent;
  final int sumCorrectAnswers;
  final int sumTotalQuestions;

  final bool isAiGenerated;

  const Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.durationSeconds,
    this.userId,
    this.lastSyncedAt,
    this.syncStatus = SyncStatus.pending,
    this.isPublic = false,
    this.createdByUserId,
    this.createdAt,
    this.playCount = 0,
    this.sumScorePercent = 0.0,
    this.sumCorrectAnswers = 0,
    this.sumTotalQuestions = 0,
    this.isAiGenerated = false,
  });

  Quiz copyWith({
    String? id,
    String? title,
    List<Question>? questions,
    int? durationSeconds,
    String? userId,
    DateTime? lastSyncedAt,
    SyncStatus? syncStatus,
    bool? isPublic,
    String? createdByUserId,
    DateTime? createdAt,
    int? playCount,
    double? sumScorePercent,
    int? sumCorrectAnswers,
    int? sumTotalQuestions,
    bool? isAiGenerated,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      userId: userId ?? this.userId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isPublic: isPublic ?? this.isPublic,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdAt: createdAt ?? this.createdAt,
      playCount: playCount ?? this.playCount,
      sumScorePercent: sumScorePercent ?? this.sumScorePercent,
      sumCorrectAnswers: sumCorrectAnswers ?? this.sumCorrectAnswers,
      sumTotalQuestions: sumTotalQuestions ?? this.sumTotalQuestions,
      isAiGenerated: isAiGenerated ?? this.isAiGenerated,
    );
  }

  double get averageScorePercent =>
      playCount == 0 ? 0.0 : (sumScorePercent / playCount);

  double get averageAccuracy =>
      sumTotalQuestions == 0 ? 0.0 : sumCorrectAnswers / sumTotalQuestions;
}
