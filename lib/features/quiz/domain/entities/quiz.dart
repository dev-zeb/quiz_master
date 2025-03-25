import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;
  final int? durationSeconds;

  const Quiz({
    required this.id,
    required this.title,
    required this.questions,
    this.durationSeconds,
  });
}
