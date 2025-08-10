import 'package:blinking_timer/blinking_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/theme/theme.dart';
import 'package:learn_and_quiz/core/config/utils.dart';
import 'package:learn_and_quiz/core/ui/widgets/app_bar_back_button.dart';
import 'package:learn_and_quiz/core/ui/widgets/circular_border_progress_painter.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz_history.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_play_button.dart';
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
    _quizTimeSeconds = widget.quiz.durationSeconds;
    _questions = widget.quiz.questions
        .map((question) => question.copyWith(answers: question.shuffledAnswers))
        .toList();
    _startTime = DateTime.now().millisecondsSinceEpoch;
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
        titleSpacing: 0,
        leading: AppBarBackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.primary, width: 0.5),
            ),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                  style: TextStyle(fontSize: 16),
                ),
                BlinkingTimer(
                  duration: Duration(seconds: _quizTimeSeconds),
                  slowBlinkingThreshold: 0.5,
                  fastBlinkingThreshold: 0.25,
                  initialColor: AppColors.lightPink,
                  customTimerUI: (text, color, progress, _, isBlinking) {
                    final displayText = text == "Time Up!"
                        ? "00:00"
                        : convertToMinuteSecond(text);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 72,
                          height: 28,
                          child: CustomPaint(
                            painter: CircularBorderProgressPainter(
                              progress: progress,
                              color: color,
                              borderRadius: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 72,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: isBlinking
                                    ? color.withValues(alpha: 0.7)
                                    : color,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                // Add this to prevent text overflow
                                child: Text(
                                  displayText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isBlinking
                                        ? color.withValues(alpha: 0.7)
                                        : color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  onTimeUpThreshold: () async {
                    await _navigateToResultScreen(
                      title: "Time's Up!",
                      iconColor: Colors.redAccent,
                      delay: Duration(
                        milliseconds: 700,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: QuizQuestionCard(
              questionText: currentQuestion.text,
              questionIndex: _currentQuestionIndex,
              answers: currentQuestion.answers,
            ),
          ),
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentQuestionIndex != 0) ...[
                  QuizPlayButton(
                    key: ValueKey('previous_$_currentQuestionIndex'),
                    isIconFirst: true,
                    text: 'Previous',
                    iconWidget: Icon(Icons.arrow_circle_left),
                    onTap: () => setState(() {
                      _currentQuestionIndex--;
                    }),
                  ),
                  const SizedBox(width: 12),
                ],
                QuizPlayButton(
                  key: ValueKey('next_$_currentQuestionIndex'),
                  isIconFirst: false,
                  text: isLastQuestion ? 'Submit' : 'Next',
                  iconWidget: isLastQuestion
                      ? Transform.rotate(
                          angle: 4.7,
                          child: Icon(Icons.arrow_circle_right),
                        )
                      : Icon(Icons.arrow_circle_right),
                  onTap: _handleNextButtonClick,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNextButtonClick() async {
    final isLastQuestion = _currentQuestionIndex == (_questions.length - 1);
    if (isLastQuestion) {
      await _navigateToResultScreen(
        title: "Well Done!",
        iconColor: Colors.green,
        delay: Duration(
          milliseconds: 700,
        ),
      );
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  Future<void> _navigateToResultScreen({
    required String title,
    required Color iconColor,
    required Duration delay,
  }) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.alarm,
                size: 48,
                color: iconColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You're now being redirected to the results screen.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );

    final totalQuestions = widget.quiz.questions.length;

    final selectedAnswers = ref.read(selectedAnswersProvider);
    while (selectedAnswers.length < totalQuestions) {
      selectedAnswers.add('');
    }
    ref.read(selectedAnswersProvider.notifier).state = selectedAnswers;

    final elapsedTime =
        (DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000;

    final quizHistory = QuizHistory(
      id: UniqueKey().toString(),
      quizId: widget.quiz.id,
      quizTitle: widget.quiz.title,
      selectedAnswers: ref.read(selectedAnswersProvider),
      questions: _questions,
      playedAt: DateTime.now(),
      elapsedTimeSeconds: elapsedTime,
      totalDurationSeconds: widget.quiz.durationSeconds,
    );

    await ref.read(quizNotifierProvider.notifier).addQuizHistory(quizHistory);
    await Future.delayed(delay);

    ref.invalidate(selectedAnswersProvider);

    if (mounted) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            quiz: widget.quiz,
            quizHistory: quizHistory,
          ),
        ),
      );
    }
  }
}
