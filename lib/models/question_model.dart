class QuestionModel {
  final String text;
  final List<String> answers;

  const QuestionModel({
    required this.text,
    required this.answers,
  });

  String get correctAnswer => answers[0];

  List<String> get shuffledAnswers {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'answers': answers,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      text: map['text'] as String,
      answers: List<String>.from(map['answers']),
    );
  }
}

class Quiz {
  final String title;
  final List<QuestionModel> questions;

  const Quiz({
    required this.title,
    required this.questions,
  });
}
