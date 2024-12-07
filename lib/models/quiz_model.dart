import 'package:learn_and_quiz/models/question_model.dart';

class QuizModel {
  final String title;
  final List<QuestionModel> questions;

  const QuizModel({
    required this.title,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      title: map['title'] as String,
      questions: (map['questions'] as List)
          .map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
          .toList(),
    );
  }
}
