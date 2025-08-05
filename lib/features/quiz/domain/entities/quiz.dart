import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;
  final int durationSeconds;

  const Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.durationSeconds,
  });

  Quiz copyWith({
    String? id,
    String? title,
    List<Question>? questions,
    int? durationSeconds,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }
}
