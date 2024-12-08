import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';

class Quiz {
  final String title;
  final List<Question> questions;

  const Quiz({
    required this.title,
    required this.questions,
  });
}
