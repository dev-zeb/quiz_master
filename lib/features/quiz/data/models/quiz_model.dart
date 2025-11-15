import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';

import 'question_model.dart';

part 'quiz_model.g.dart';

@HiveType(typeId: 1)
class QuizModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<QuestionModel> questions;
  @HiveField(3)
  final int? durationSeconds;
  @HiveField(4)
  final String? userId;
  @HiveField(5)
  final DateTime? lastSyncedAt;
  @HiveField(6)
  final String syncStatus;

  QuizModel({
    required this.id,
    required this.title,
    required this.questions,
    this.durationSeconds,
    this.userId,
    this.lastSyncedAt,
    this.syncStatus = 'pending',
  });

  QuizModel copyWith({
    String? id,
    String? title,
    List<QuestionModel>? questions,
    int? durationSeconds,
    String? userId,
    DateTime? lastSyncedAt,
    String? syncStatus,
  }) {
    return QuizModel(
      id: id ?? this.id,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      userId: userId ?? this.userId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  // Convert from domain entity to data model
  factory QuizModel.fromEntity(Quiz quiz) {
    return QuizModel(
      id: quiz.id,
      title: quiz.title,
      questions:
          quiz.questions.map((q) => QuestionModel.fromEntity(q)).toList(),
      durationSeconds: quiz.durationSeconds,
      userId: quiz.userId,
      lastSyncedAt: quiz.lastSyncedAt,
      syncStatus: quiz.syncStatus.name,
    );
  }

  // Convert from data model to domain entity
  Quiz toEntity() {
    return Quiz(
      id: id,
      title: title,
      questions: questions.map((q) => q.toEntity()).toList(),
      durationSeconds: durationSeconds ?? 120,
      userId: userId,
      lastSyncedAt: lastSyncedAt,
      syncStatus: _syncStatusFromString(syncStatus),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
      'durationSeconds': durationSeconds,
      'userId': userId,
      'lastSyncedAt': (lastSyncedAt ?? DateTime.now()).toUtc(),
      'syncStatus': syncStatus,
    };
  }

  factory QuizModel.fromFirestore(Map<String, dynamic> data) {
    final timestamp = data['lastSyncedAt'];
    DateTime? syncedAt;
    if (timestamp is Timestamp) {
      syncedAt = timestamp.toDate();
    } else if (timestamp is DateTime) {
      syncedAt = timestamp;
    } else if (timestamp is String) {
      syncedAt = DateTime.tryParse(timestamp);
    }

    return QuizModel(
      id: data['id'] as String,
      title: data['title'] as String,
      questions: (data['questions'] as List<dynamic>)
          .map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
          .toList(),
      durationSeconds: (data['durationSeconds'] as num?)?.toInt(),
      userId: data['userId'] as String?,
      lastSyncedAt: syncedAt,
      syncStatus: data['syncStatus'] as String? ?? 'synced',
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
