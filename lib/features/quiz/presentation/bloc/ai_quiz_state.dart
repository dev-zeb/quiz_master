import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz.dart';

class AiQuizState extends Equatable {
  final bool isLoading;
  final Quiz? quiz;
  final Object? error;

  const AiQuizState({
    required this.isLoading,
    required this.quiz,
    required this.error,
  });

  factory AiQuizState.initial() => const AiQuizState(
        isLoading: false,
        quiz: null,
        error: null,
      );

  AiQuizState copyWith({
    bool? isLoading,
    Quiz? quiz,
    Object? error,
  }) {
    return AiQuizState(
      isLoading: isLoading ?? this.isLoading,
      quiz: quiz ?? this.quiz,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, quiz, error];
}
