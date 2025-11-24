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

  @HiveField(7)
  final bool isPublic;

  @HiveField(8)
  final String? createdByUserId;

  @HiveField(9)
  final DateTime? createdAt;

  @HiveField(10)
  final int playCount;

  @HiveField(11)
  final double sumScorePercent;

  @HiveField(12)
  final int sumCorrectAnswers;

  @HiveField(13)
  final int sumTotalQuestions;

  @HiveField(14)
  final bool isAiGenerated;

  QuizModel({
    required this.id,
    required this.title,
    required this.questions,
    this.durationSeconds,
    this.userId,
    this.lastSyncedAt,
    this.syncStatus = 'pending',
    this.isPublic = false,
    this.createdByUserId,
    this.createdAt,
    this.playCount = 0,
    this.sumScorePercent = 0.0,
    this.sumCorrectAnswers = 0,
    this.sumTotalQuestions = 0,
    this.isAiGenerated = false,
  });

  QuizModel copyWith({
    String? id,
    String? title,
    List<QuestionModel>? questions,
    int? durationSeconds,
    String? userId,
    DateTime? lastSyncedAt,
    String? syncStatus,
    bool? isPublic,
    String? createdByUserId,
    DateTime? createdAt,
    int? playCount,
    double? sumScorePercent,
    int? sumCorrectAnswers,
    int? sumTotalQuestions,
    bool? isAiGenerated,
  }) {
    return QuizModel(
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
      isPublic: quiz.isPublic,
      createdByUserId: quiz.createdByUserId,
      createdAt: quiz.createdAt,
      playCount: quiz.playCount,
      sumScorePercent: quiz.sumScorePercent,
      sumCorrectAnswers: quiz.sumCorrectAnswers,
      sumTotalQuestions: quiz.sumTotalQuestions,
      isAiGenerated: quiz.isAiGenerated,
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
      isPublic: isPublic,
      createdByUserId: createdByUserId,
      createdAt: createdAt,
      playCount: playCount,
      sumScorePercent: sumScorePercent,
      sumCorrectAnswers: sumCorrectAnswers,
      sumTotalQuestions: sumTotalQuestions,
      isAiGenerated: isAiGenerated,
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
      'isPublic': isPublic,
      'createdByUserId': createdByUserId,
      'createdAt': (createdAt ?? DateTime.now()).toUtc(),
      'playCount': playCount,
      'sumScorePercent': sumScorePercent,
      'sumCorrectAnswers': sumCorrectAnswers,
      'sumTotalQuestions': sumTotalQuestions,
      'isAiGenerated': isAiGenerated,
    };
  }

  factory QuizModel.fromFirestore(Map<String, dynamic> data) {
    return QuizModel(
      id: data['id'] as String,
      title: data['title'] as String,
      questions: (data['questions'] as List<dynamic>)
          .map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
          .toList(),
      durationSeconds: (data['durationSeconds'] as num?)?.toInt(),
      userId: data['userId'] as String?,
      lastSyncedAt: _parseNullableDate(data['lastSyncedAt']),
      syncStatus: data['syncStatus'] as String? ?? 'synced',
      isPublic: data['isPublic'] as bool? ?? false,
      createdByUserId: data['createdByUserId'] as String?,
      createdAt: _parseNullableDate(data['createdAt']),
      playCount: (data['playCount'] as num? ?? 0).toInt(),
      sumScorePercent: (data['sumScorePercent'] as num? ?? 0.0).toDouble(),
      sumCorrectAnswers: (data['sumCorrectAnswers'] as num? ?? 0).toInt(),
      sumTotalQuestions: (data['sumTotalQuestions'] as num? ?? 0).toInt(),
      isAiGenerated: (data['isAiGenerated']) as bool? ?? false,
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

/// Small helper to DRY up Timestamp / DateTime / String handling from Firestore.
DateTime? _parseNullableDate(dynamic value) {
  if (value == null) return null;

  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);

  return null;
}
