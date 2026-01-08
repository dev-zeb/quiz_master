import 'package:equatable/equatable.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';

sealed class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class QuizBootstrapped extends QuizEvent {}

class QuizReloadRequested extends QuizEvent {}

class QuizAdded extends QuizEvent {
  final Quiz quiz;

  const QuizAdded(this.quiz);

  @override
  List<Object?> get props => [quiz];
}

class QuizUpdated extends QuizEvent {
  final Quiz quiz;

  const QuizUpdated(this.quiz);

  @override
  List<Object?> get props => [quiz];
}

class QuizDeleted extends QuizEvent {
  final String id;

  const QuizDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class QuizHistoryAdded extends QuizEvent {
  final QuizHistory history;

  const QuizHistoryAdded(this.history);

  @override
  List<Object?> get props => [history];
}

class QuizSyncRequested extends QuizEvent {
  final String userId;

  const QuizSyncRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
