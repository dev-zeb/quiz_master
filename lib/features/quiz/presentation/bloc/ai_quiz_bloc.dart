import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/quiz.dart';
import '../../domain/repositories/ai_quiz_repository.dart';
import 'ai_quiz_event.dart';
import 'ai_quiz_state.dart';

class AiQuizBloc extends Bloc<AiQuizEvent, AiQuizState> {
  AiQuizBloc(this._repo) : super(AiQuizState.initial()) {
    on<AiQuizGenerateFromTextRequested>(_onGenerateFromText);
    on<AiQuizGenerateFromFileRequested>(_onGenerateFromFile);
  }

  final AiQuizRepository _repo;

  static const _timeout = Duration(seconds: 90); // tune as you like
  static const int _maxFileBytes =
      6 * 1024 * 1024; // 6MB guardrail (client-side)

  Future<void> _onGenerateFromText(
    AiQuizGenerateFromTextRequested event,
    Emitter<AiQuizState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, quiz: null));
    try {
      final Quiz quiz = await _repo
          .generateQuizFromText(
            text: event.text,
            numQuestions: event.numQuestions,
            userId: event.userId,
            durationSeconds: event.durationSeconds,
          )
          .timeout(_timeout);

      emit(state.copyWith(isLoading: false, quiz: quiz, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e, quiz: null));
    }
  }

  Future<void> _onGenerateFromFile(
    AiQuizGenerateFromFileRequested event,
    Emitter<AiQuizState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, quiz: null));
    try {
      final PlatformFile file = event.file;

      if (file.size > _maxFileBytes) {
        throw StateError(
          'File too large (${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB). '
          'Please try a smaller file.',
        );
      }

      final bytes = file.bytes;
      if (bytes == null || bytes.isEmpty) {
        throw StateError(
          'Selected file could not be read (bytes were null). '
          'Please re-pick the file or try a smaller one.',
        );
      }

      final Quiz quiz = await _repo
          .generateQuizFromFile(
            bytes: bytes,
            filename: file.name,
            numQuestions: event.numQuestions,
            userId: event.userId,
            durationSeconds: event.durationSeconds,
            extraInstructions: event.extraInstructions,
          )
          .timeout(_timeout);

      emit(state.copyWith(isLoading: false, quiz: quiz, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e, quiz: null));
    }
  }
}
