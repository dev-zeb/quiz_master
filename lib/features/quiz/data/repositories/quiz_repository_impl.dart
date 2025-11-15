import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/features/quiz/data/datasources/local/quiz_local_data_source.dart';
import 'package:quiz_master/features/quiz/data/datasources/local/quiz_local_data_source_impl.dart';
import 'package:quiz_master/features/quiz/data/datasources/remote/quiz_remote_data_source.dart';
import 'package:quiz_master/features/quiz/data/datasources/remote/quiz_remote_data_source_impl.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';
import 'package:quiz_master/features/quiz/domain/repositories/quiz_repository.dart';

import '../models/quiz_history_model.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final quizLocalDataSource = ref.watch(hiveLocalDataSourceProvider);
  final quizRemoteDataSource = ref.watch(quizRemoteDataSourceProvider);
  return QuizRepositoryImpl(quizLocalDataSource, quizRemoteDataSource);
});

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource quizLocalDataSource;
  final QuizRemoteDataSource quizRemoteDataSource;

  QuizRepositoryImpl(this.quizLocalDataSource, this.quizRemoteDataSource);

  @override
  Future<void> addQuiz(Quiz quiz) async {
    final now = DateTime.now();
    final pendingQuiz =
        quiz.copyWith(lastSyncedAt: now, syncStatus: SyncStatus.pending);
    await quizLocalDataSource.addQuiz(QuizModel.fromEntity(pendingQuiz));
    await _syncQuizIfPossible(pendingQuiz);
  }

  @override
  Future<void> deleteQuizById(String id) async {
    final quiz = quizLocalDataSource.getQuizById(id)?.toEntity();
    await quizLocalDataSource.deleteQuizById(id);
    if (quiz?.userId != null) {
      await quizRemoteDataSource.deleteQuiz(
        userId: quiz!.userId!,
        quizId: quiz.id,
      );
    }
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    final updatedQuiz = quiz.copyWith(
      lastSyncedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await quizLocalDataSource.updateQuiz(QuizModel.fromEntity(updatedQuiz));
    await _syncQuizIfPossible(updatedQuiz);
  }

  @override
  Quiz? getQuizById(String id) {
    final quizModel = quizLocalDataSource.getQuizById(id);
    return quizModel?.toEntity();
  }

  @override
  List<Quiz> getQuizzes() {
    final quizModelList = quizLocalDataSource.getQuizzes();
    return quizModelList.map((q) => q.toEntity()).toList();
  }

  @override
  Future<void> addQuizHistory(QuizHistory quizHistory) async {
    await quizLocalDataSource.addQuizHistory(
      QuizHistoryModel.fromEntity(quizHistory),
    );
  }

  @override
  List<QuizHistory> getQuizHistoryList() {
    final quizHistoryModelList = quizLocalDataSource.getQuizHistoryList();
    return quizHistoryModelList
        .map((quizHistoryModel) => quizHistoryModel.toEntity())
        .toList();
  }

  @override
  QuizHistory? getQuizHistoryById(String id) {
    final quizHistoryModel = quizLocalDataSource.getQuizHistoryById(id);
    return quizHistoryModel?.toEntity();
  }

  @override
  Future<void> syncQuizzes({required String userId}) async {
    final localQuizzes = quizLocalDataSource.getQuizzes();
    final remoteQuizzes = await quizRemoteDataSource.fetchQuizzes(userId);

    final localMap = {for (final quiz in localQuizzes) quiz.id: quiz};
    final remoteMap = {for (final quiz in remoteQuizzes) quiz.id: quiz};
    final allIds = {...localMap.keys, ...remoteMap.keys};

    for (final id in allIds) {
      final local = localMap[id];
      final remote = remoteMap[id];

      if (remote == null && local != null) {
        var localQuiz = local.toEntity();
        if (localQuiz.userId == null) {
          localQuiz = localQuiz.copyWith(
            userId: userId,
            lastSyncedAt: DateTime.now(),
          );
          await quizLocalDataSource.updateQuiz(
            QuizModel.fromEntity(localQuiz),
          );
        }
        await _syncQuizIfPossible(localQuiz);
      } else if (local == null && remote != null) {
        final remoteQuiz =
            remote.toEntity().copyWith(syncStatus: SyncStatus.synced);
        await quizLocalDataSource.addQuiz(QuizModel.fromEntity(remoteQuiz));
      } else if (local != null && remote != null) {
        final localDate =
            local.lastSyncedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final remoteDate =
            remote.lastSyncedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

        if (localDate.isAfter(remoteDate)) {
          var localQuiz = local.toEntity();
          if (localQuiz.userId == null) {
            localQuiz = localQuiz.copyWith(
              userId: userId,
              lastSyncedAt: DateTime.now(),
            );
            await quizLocalDataSource.updateQuiz(
              QuizModel.fromEntity(localQuiz),
            );
          }
          await _syncQuizIfPossible(localQuiz);
        } else {
          final remoteQuiz =
              remote.toEntity().copyWith(syncStatus: SyncStatus.synced);
          await quizLocalDataSource
              .updateQuiz(QuizModel.fromEntity(remoteQuiz));
        }
      }
    }
  }

  Future<void> _syncQuizIfPossible(Quiz quiz) async {
    if (quiz.userId == null) return;
    try {
      final syncedQuiz = quiz.copyWith(
        syncStatus: SyncStatus.synced,
        lastSyncedAt: DateTime.now(),
      );
      await quizRemoteDataSource.upsertQuiz(QuizModel.fromEntity(syncedQuiz));
      await quizLocalDataSource.updateQuiz(QuizModel.fromEntity(syncedQuiz));
    } catch (_) {
      final failedQuiz = quiz.copyWith(syncStatus: SyncStatus.failed);
      await quizLocalDataSource.updateQuiz(QuizModel.fromEntity(failedQuiz));
    }
  }
}
