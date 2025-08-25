import 'package:hive/hive.dart';
import 'package:quiz_master/features/quiz/domain/entities/question.dart';

part 'question_model.g.dart';

@HiveType(typeId: 2)
class QuestionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final List<String> answers;

  QuestionModel({
    required this.id,
    required this.text,
    required this.answers,
  });

  // Convert from domain entity to data model
  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      text: question.text,
      answers: question.answers,
    );
  }

  // Convert from data model to domain entity
  Question toEntity() {
    return Question(
      id: id,
      text: text,
      answers: answers,
    );
  }
}
