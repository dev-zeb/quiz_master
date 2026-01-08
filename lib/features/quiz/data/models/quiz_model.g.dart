// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizModelAdapter extends TypeAdapter<QuizModel> {
  @override
  final int typeId = 1;

  @override
  QuizModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return QuizModel(
      id: fields[0] as String,
      title: fields[1] as String,
      questions:
          (fields[2] as List?)?.cast<QuestionModel>() ?? <QuestionModel>[],
      durationSeconds: fields[3] as int?,
      userId: fields[4] as String?,
      lastSyncedAt: fields[5] as DateTime?,
      syncStatus: (fields[6] as String?) ?? 'pending',
      isPublic: (fields[7] as bool?) ?? false,
      createdByUserId: fields[8] as String?,
      createdAt: fields[9] as DateTime?,
      playCount: (fields[10] as int?) ?? 0,
      sumScorePercent: (fields[11] as double?) ?? 0.0,
      sumCorrectAnswers: (fields[12] as int?) ?? 0,
      sumTotalQuestions: (fields[13] as int?) ?? 0,
      isAiGenerated: (fields[14] as bool?) ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, QuizModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.questions)
      ..writeByte(3)
      ..write(obj.durationSeconds)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.lastSyncedAt)
      ..writeByte(6)
      ..write(obj.syncStatus)
      ..writeByte(7)
      ..write(obj.isPublic)
      ..writeByte(8)
      ..write(obj.createdByUserId)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.playCount)
      ..writeByte(11)
      ..write(obj.sumScorePercent)
      ..writeByte(12)
      ..write(obj.sumCorrectAnswers)
      ..writeByte(13)
      ..write(obj.sumTotalQuestions)
      ..writeByte(14)
      ..write(obj.isAiGenerated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
