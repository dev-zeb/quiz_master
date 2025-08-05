// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizHistoryModelAdapter extends TypeAdapter<QuizHistoryModel> {
  @override
  final int typeId = 3;

  @override
  QuizHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizHistoryModel(
      id: fields[0] as String,
      quizId: fields[1] as String,
      quizTitle: fields[2] as String,
      questions: (fields[3] as List).cast<QuestionModel>(),
      selectedAnswers: (fields[4] as List).cast<String?>(),
      playedAt: fields[5] as DateTime,
      elapsedTimeSeconds: fields[6] as int,
      totalDurationSeconds: fields[7] as int,
      userId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuizHistoryModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.quizId)
      ..writeByte(2)
      ..write(obj.quizTitle)
      ..writeByte(3)
      ..write(obj.questions)
      ..writeByte(4)
      ..write(obj.selectedAnswers)
      ..writeByte(5)
      ..write(obj.playedAt)
      ..writeByte(6)
      ..write(obj.elapsedTimeSeconds)
      ..writeByte(7)
      ..write(obj.totalDurationSeconds)
      ..writeByte(8)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
