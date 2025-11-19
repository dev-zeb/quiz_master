// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_play_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizPlayRecordModelAdapter extends TypeAdapter<QuizPlayRecordModel> {
  @override
  final int typeId = 4;

  @override
  QuizPlayRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizPlayRecordModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      quizId: fields[2] as String,
      quizTitle: fields[3] as String,
      correctAnswers: fields[4] as int,
      totalQuestions: fields[5] as int,
      scorePercent: fields[6] as double,
      elapsedTimeSeconds: fields[7] as int,
      playedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QuizPlayRecordModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.quizId)
      ..writeByte(3)
      ..write(obj.quizTitle)
      ..writeByte(4)
      ..write(obj.correctAnswers)
      ..writeByte(5)
      ..write(obj.totalQuestions)
      ..writeByte(6)
      ..write(obj.scorePercent)
      ..writeByte(7)
      ..write(obj.elapsedTimeSeconds)
      ..writeByte(8)
      ..write(obj.playedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizPlayRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
