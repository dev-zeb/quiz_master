/// Calculates the percentage of correct answers.
String getCorrectAnswerPercentage({
  required int correctAnswers,
  required int totalQuestions,
}) {
  if (totalQuestions == 0) {
    return "0.00";
  }
  double percentage = (correctAnswers / totalQuestions) * 100;
  return percentage.toStringAsFixed(2);
}

/// Calculates the percentage of wrong answers.
String getWrongAnswerPercentage({
  required int correctAnswers,
  required int totalQuestions,
}) {
  if (totalQuestions == 0) {
    return "0.00";
  }
  final wrongAnswers = totalQuestions - correctAnswers;
  return getCorrectAnswerPercentage(
      correctAnswers: wrongAnswers, totalQuestions: totalQuestions);
}

List<String> getMinutesAndSeconds(int timeInSeconds) {
  String minutes = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
  String seconds = (timeInSeconds % 60).toString().padLeft(2, '0');

  return [minutes, seconds];
}
