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

  const Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.durationSeconds,
    this.userId,
    this.lastSyncedAt,
    this.syncStatus = SyncStatus.pending,
  });

  Quiz copyWith({
    String? id,
    String? title,
    List<Question>? questions,
    int? durationSeconds,
    String? userId,
    DateTime? lastSyncedAt,
    SyncStatus? syncStatus,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      userId: userId ?? this.userId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
