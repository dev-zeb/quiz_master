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
    correctAnswers: wrongAnswers,
    totalQuestions: totalQuestions,
  );
}

List<String> getMinutesAndSeconds(int timeInSeconds) {
  String minutes = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
  String seconds = (timeInSeconds % 60).toString().padLeft(2, '0');

  return [minutes, seconds];
}

String convertToMinuteSecond(String input) {
  if (input == "Time Up!") {
    return "00:00";
  }

  try {
    final cleaned = input.replaceAll('Text:', '').trim();
    final parts = cleaned.split(':').map(int.parse).toList();

    int hours = 0, minutes = 0, seconds = 0;

    if (parts.length == 3) {
      hours = parts[0];
      minutes = parts[1];
      seconds = parts[2];
    } else if (parts.length == 2) {
      minutes = parts[0];
      seconds = parts[1];
    }

    final totalMinutes = hours * 60 + minutes;
    return '${totalMinutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  } catch (e) {
    return "00:00";
  }
}
