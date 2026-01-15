import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';

class QuizStats {
  const QuizStats({
    required this.totalQuizzes,
    required this.synced,
    required this.pending,
    required this.failed,
    required this.localOnly,
    required this.historyCount,
    required this.averageScore,
    required this.lastPlayedAt,
    required this.lastSyncedAt,
  });

  final int totalQuizzes;
  final int synced;
  final int pending;
  final int failed;
  final int localOnly;
  final int historyCount;
  final double? averageScore;
  final DateTime? lastPlayedAt;
  final DateTime? lastSyncedAt;

  factory QuizStats.from(List<Quiz> quizzes, List<QuizHistory> histories) {
    final synced = quizzes
        .where((quiz) => quiz.syncStatus == SyncStatus.synced)
        .length;
    final pending = quizzes
        .where((quiz) => quiz.syncStatus == SyncStatus.pending)
        .length;
    final failed = quizzes
        .where((quiz) => quiz.syncStatus == SyncStatus.failed)
        .length;
    final localOnly = quizzes.where((quiz) => quiz.userId == null).length;

    DateTime? lastSyncedAt;
    for (final quiz in quizzes) {
      final candidate = quiz.lastSyncedAt;
      if (candidate == null) continue;
      if (lastSyncedAt == null || candidate.isAfter(lastSyncedAt)) {
        lastSyncedAt = candidate;
      }
    }

    DateTime? lastPlayedAt;
    double scoreAccumulator = 0;
    for (final history in histories) {
      if (lastPlayedAt == null || history.playedAt.isAfter(lastPlayedAt)) {
        lastPlayedAt = history.playedAt;
      }
      scoreAccumulator += history.scorePercent;
    }
    final averageScore = histories.isEmpty
        ? null
        : scoreAccumulator / histories.length;

    return QuizStats(
      totalQuizzes: quizzes.length,
      synced: synced,
      pending: pending,
      failed: failed,
      localOnly: localOnly,
      historyCount: histories.length,
      averageScore: averageScore,
      lastPlayedAt: lastPlayedAt,
      lastSyncedAt: lastSyncedAt,
    );
  }
}
