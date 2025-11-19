// features/quiz/data/mappers/quiz_mappers.dart

import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';
import 'package:quiz_master/features/quiz/data/models/question_model.dart';

extension QuizToModel on Quiz {
  QuizModel toModel() {
    return QuizModel(
      id: id,
      title: title,
      questions: questions.map((q) => QuestionModel.fromEntity(q)).toList(),
      durationSeconds: durationSeconds,
      userId: userId,
      lastSyncedAt: lastSyncedAt,
      syncStatus: syncStatus.name,
      isPublic: isPublic,
      createdByUserId: createdByUserId,
      createdAt: createdAt,
      playCount: playCount,
      sumScorePercent: sumScorePercent,
      sumCorrectAnswers: sumCorrectAnswers,
      sumTotalQuestions: sumTotalQuestions,
    );
  }
}

extension QuizModelToEntity on QuizModel {
  Quiz toEntity() {
    return Quiz(
      id: id,
      title: title,
      questions: questions.map((q) => q.toEntity()).toList(),
      durationSeconds: durationSeconds ?? 120,
      userId: userId,
      lastSyncedAt: lastSyncedAt,
      syncStatus: _syncStatusFromString(syncStatus),
      isPublic: isPublic,
      createdByUserId: createdByUserId,
      createdAt: createdAt,
      playCount: playCount,
      sumScorePercent: sumScorePercent,
      sumCorrectAnswers: sumCorrectAnswers,
      sumTotalQuestions: sumTotalQuestions,
    );
  }

  SyncStatus _syncStatusFromString(String? value) {
    switch (value) {
      case 'synced':
        return SyncStatus.synced;
      case 'failed':
        return SyncStatus.failed;
      default:
        return SyncStatus.pending;
    }
  }
}
