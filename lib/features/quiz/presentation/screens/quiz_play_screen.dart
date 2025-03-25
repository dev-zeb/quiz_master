import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/ui/widget/app_bar_back_button.dart';
import 'package:learn_and_quiz/core/ui/widget/blinking_timer_widget.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/helpers/dto_models/quiz_time.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/result_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_question_card.dart';

final selectedAnswersProvider = StateProvider<List<String?>>((ref) {
  return [];
});

class QuizPlayScreen extends ConsumerStatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({super.key, required this.quiz});

  @override
  ConsumerState<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends ConsumerState<QuizPlayScreen> {
  int _currentQuestionIndex = 0;
  late int _quizTimeSeconds;
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _quizTimeSeconds = widget.quiz.durationSeconds ?? 120;
    _questions = widget.quiz.questions;
  }

  void _handleNextButtonClick() {
    if (_currentQuestionIndex == (_questions.length - 1)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            quiz: widget.quiz,
          ),
        ),
      );
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentQuestion = _questions[_currentQuestionIndex];
    final isLastQuestion =
        _currentQuestionIndex == widget.quiz.questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        leading: AppBarBackButton(),
        actions: [
          BlinkingTimerWidget(
            maxSeconds: _quizTimeSeconds,
            onTimeUp: () {
              final answerList = ref.read(selectedAnswersProvider);
              final totalQuestions = widget.quiz.questions.length;

              while (answerList.length < totalQuestions) {
                answerList.add(null);
              }
              ref
                  .read(selectedAnswersProvider.notifier)
                  .update((_) => answerList);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    quiz: widget.quiz,
                    elapsedTimeSeconds: QuizTimeDTO.elapsedTimeSeconds,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.primary, width: 0.5),
            ),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 20,
            ),
            child: Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
            ),
          ),
          Expanded(
            child: QuizQuestionCard(
              questionText: currentQuestion.text,
              questionIndex: _currentQuestionIndex,
              answers: currentQuestion.shuffledAnswers,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 60,
              vertical: 20,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _handleNextButtonClick,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastQuestion ? 'Submit' : 'Next',
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      isLastQuestion
                          ? Icons.arrow_upward_outlined
                          : Icons.arrow_right_alt_rounded,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
