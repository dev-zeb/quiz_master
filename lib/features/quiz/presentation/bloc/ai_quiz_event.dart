import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

sealed class AiQuizEvent extends Equatable {
  const AiQuizEvent();

  @override
  List<Object?> get props => [];
}

class AiQuizGenerateFromTextRequested extends AiQuizEvent {
  final String text;
  final int numQuestions;
  final int durationSeconds;
  final String? userId;

  const AiQuizGenerateFromTextRequested({
    required this.text,
    required this.numQuestions,
    required this.durationSeconds,
    required this.userId,
  });

  @override
  List<Object?> get props => [text, numQuestions, durationSeconds, userId];
}

class AiQuizGenerateFromFileRequested extends AiQuizEvent {
  final PlatformFile file;
  final int numQuestions;
  final int durationSeconds;
  final String? userId;
  final String? extraInstructions;

  const AiQuizGenerateFromFileRequested({
    required this.file,
    required this.numQuestions,
    required this.durationSeconds,
    required this.userId,
    required this.extraInstructions,
  });

  @override
  List<Object?> get props => [
    file.name,
    file.size,
    numQuestions,
    durationSeconds,
    userId,
    extraInstructions,
  ];
}
