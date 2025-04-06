import 'package:blinking_timer/blinking_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/ui/widgets/app_bar_back_button.dart';
import 'package:learn_and_quiz/core/ui/widgets/border_progress_painter.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
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
  late int _startTime;

  @override
  void initState() {
    super.initState();
    _quizTimeSeconds = widget.quiz.durationSeconds ?? 120;
    _questions = widget.quiz.questions;
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  void _handleNextButtonClick() {
    if (_currentQuestionIndex == (_questions.length - 1)) {
      final elapsedTime =
          (DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            quiz: widget.quiz,
            elapsedTimeSeconds: elapsedTime,
            totalDurationSeconds: _quizTimeSeconds,
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
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BlinkingTimer(
              duration: Duration(seconds: _quizTimeSeconds),
              slowBlinkingThreshold: 0.5,
              fastBlinkingThreshold: 0.25,
              customTimerUI: (text, color, progress, _, isBlinking) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Custom border progress
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: CustomPaint(
                        painter: BorderProgressPainter(
                          progress: progress,
                          color: color,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined),
                        const SizedBox(width: 8),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            color: isBlinking ? color.withOpacity(0.7) : color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              onTimeUpThreshold: () {
                final answerList = ref.read(selectedAnswersProvider);
                final totalQuestions = widget.quiz.questions.length;

                while (answerList.length < totalQuestions) {
                  answerList.add(null);
                }
                ref
                    .read(selectedAnswersProvider.notifier)
                    .update((_) => answerList);

                final elapsedTime =
                    (DateTime.now().millisecondsSinceEpoch - _startTime) ~/
                        1000;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      quiz: widget.quiz,
                      elapsedTimeSeconds: elapsedTime,
                      totalDurationSeconds: _quizTimeSeconds,
                    ),
                  ),
                );
              },
            ),
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
