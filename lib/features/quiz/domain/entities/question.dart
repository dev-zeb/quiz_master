class Question {
  final String id;
  final String text;
  final List<String> answers;

  const Question({required this.id, required this.text, required this.answers});

  Question copyWith({String? id, String? text, List<String>? answers}) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      answers: answers ?? this.answers,
    );
  }

  String get correctAnswer => answers[0];

  List<String> get shuffledAnswers {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
