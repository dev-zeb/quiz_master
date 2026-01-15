import 'package:quiz_master/features/quiz/domain/entities/question.dart';

class QuizHistory {
  final String id;
  final String quizId;
  final String quizTitle;
  final List<String?> selectedAnswers;
  final List<Question> questions;
  final DateTime playedAt;
  final int elapsedTimeSeconds;
  final int totalDurationSeconds;
  final String? userId; // null = offline/local

  QuizHistory({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.selectedAnswers,
    required this.questions,
    required this.playedAt,
    required this.elapsedTimeSeconds,
    required this.totalDurationSeconds,
    this.userId,
  });

  QuizHistory toEntity() {
    return QuizHistory(
      id: id,
      quizId: quizId,
      quizTitle: quizTitle,
      questions: questions,
      selectedAnswers: selectedAnswers,
      playedAt: playedAt,
      elapsedTimeSeconds: elapsedTimeSeconds,
      totalDurationSeconds: totalDurationSeconds,
      userId: userId,
    );
  }

  int get totalQuestions => questions.length;

  int get correctAnswers => List.generate(questions.length, (i) {
    final selected = selectedAnswers[i];
    final correct = questions[i].correctAnswer;
    return selected != null && selected == correct ? 1 : 0;
  }).fold(0, (a, b) => a + b);

  double get scorePercent =>
      totalQuestions == 0 ? 0.0 : (correctAnswers / totalQuestions) * 100;
}

// user_profile.dart (for future use)
class UserProfile {
  final String userId;
  final String name;
  final String email;

  UserProfile({required this.userId, required this.name, required this.email});
}
