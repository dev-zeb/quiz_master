class QuizPlayRecord {
  final String id; // playId
  final String userId;
  final String quizId;
  final String quizTitle;
  final int correctAnswers;
  final int totalQuestions;
  final double scorePercent;
  final int elapsedTimeSeconds;
  final DateTime playedAt;

  const QuizPlayRecord({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.scorePercent,
    required this.elapsedTimeSeconds,
    required this.playedAt,
  });

  double get accuracy =>
      totalQuestions == 0 ? 0.0 : correctAnswers / totalQuestions;
}
