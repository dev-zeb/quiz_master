import 'package:hive/hive.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
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

  QuizModel({
    required this.id,
    required this.title,
    required this.questions,
  });

  // Convert from domain entity to data model
  factory QuizModel.fromEntity(Quiz quiz) {
    return QuizModel(
      id: quiz.id,
      title: quiz.title,
      questions: quiz.questions.map((q) => QuestionModel.fromEntity(q)).toList(),
    );
  }

  // Convert from data model to domain entity
  Quiz toEntity() {
    return Quiz(
      id: id,
      title: title,
      questions: questions.map((q) => q.toEntity()).toList(),
    );
  }
}
