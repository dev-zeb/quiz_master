class QuestionSummary {
  final int index;
  final String question;
  final String correctAnswer;
  final String? userAnswer;

  QuestionSummary({
    required this.index,
    required this.question,
    required this.correctAnswer,
    required this.userAnswer,
  });

  bool get isCorrect => correctAnswer == userAnswer;
}
