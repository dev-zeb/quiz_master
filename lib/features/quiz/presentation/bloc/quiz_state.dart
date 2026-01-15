import 'package:equatable/equatable.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';

class QuizState extends Equatable {
  final bool isLoading;
  final List<Quiz> quizzes;
  final List<QuizHistory> histories;
  final Object? error;

  const QuizState({
    required this.isLoading,
    required this.quizzes,
    required this.histories,
    this.error,
  });

  factory QuizState.initial() =>
      const QuizState(isLoading: true, quizzes: [], histories: []);

  QuizState copyWith({
    bool? isLoading,
    List<Quiz>? quizzes,
    List<QuizHistory>? histories,
    Object? error,
  }) {
    return QuizState(
      isLoading: isLoading ?? this.isLoading,
      quizzes: quizzes ?? this.quizzes,
      histories: histories ?? this.histories,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, quizzes, histories, error];
}
