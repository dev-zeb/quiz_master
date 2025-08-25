import 'package:blinking_timer/blinking_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/core/config/utils.dart';
import 'package:quiz_master/core/ui/widgets/circular_border_progress_painter.dart';
import 'package:quiz_master/core/ui/widgets/clickable_text_widget.dart';
import 'package:quiz_master/features/quiz/domain/entities/question.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';
import 'package:quiz_master/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_play_button.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_question_card.dart';

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
    final currentQuestionNumber = _currentQuestionIndex + 1;
    final totalNumberOfQuestions = widget.quiz.questions.length;
    final progressRate = currentQuestionNumber / totalNumberOfQuestions;
    final progressValue = (progressRate * 100).toStringAsFixed(2);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, res) async {
        if (didPop) return;

        await showConfirmationDialog(context);
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 12),
                Material(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12.0),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(left: 6, top: 8, bottom: 8),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                    onTap: () async {
                      final result = await showConfirmationDialog(context);

                      if (result == true && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: Text(
                    widget.quiz.title,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.secondary,
                  width: 0.5,
                ),
              ),
              child: LinearProgressIndicator(
                value: progressRate,
                backgroundColor: colorScheme.onSecondary,
                valueColor:
                    AlwaysStoppedAnimation<Color>(colorScheme.secondary),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Q: $currentQuestionNumber of $totalNumberOfQuestions',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                  BlinkingTimer(
                    duration: Duration(seconds: _quizTimeSeconds),
                    slowBlinkingThreshold: 0.5,
                    fastBlinkingThreshold: 0.25,
                    initialColor: colorScheme.secondary,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                        colorScheme,
                        title: "Time's Up!",
                        iconColor: colorScheme.error,
                        delay: Duration(milliseconds: 700),
                      );
                    },
                  ),
                  Text(
                    "$progressValue%",
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontSize: 16,
                    ),
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
                      iconWidget: Icon(
                        Icons.arrow_circle_left,
                        color: colorScheme.onPrimary,
                      ),
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
                            child: Icon(
                              Icons.arrow_circle_right,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Icon(
                            Icons.arrow_circle_right,
                            color: colorScheme.onPrimary,
                          ),
                    onTap: () {
                      _handleNextButtonClick(colorScheme);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNextButtonClick(colorScheme) async {
    final isLastQuestion = _currentQuestionIndex == (_questions.length - 1);
    if (isLastQuestion) {
      await _navigateToResultScreen(
        colorScheme,
        title: "Well Done!",
        iconColor: colorScheme.tertiary,
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

  Future<void> _navigateToResultScreen(
    colorScheme, {
    required String title,
    required Color iconColor,
    required Duration delay,
  }) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surfaceContainer,
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
                  color: colorScheme.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You're now being redirected to the results screen.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.primary.withValues(alpha: 0.75),
                  fontSize: 16,
                ),
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
          builder: (context) => QuizResultScreen(quizHistory: quizHistory),
        ),
      );
    }
  }

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Cancel Quiz?',
          style: TextStyle(
            fontSize: 20,
            color: colorScheme.primary,
          ),
        ),
        content: Text(
          'Do you want to cancel the quiz?',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.primary,
          ),
        ),
        actions: [
          ClickableTextWidget(
            fontSize: 16,
            text: 'No',
            buttonColor: colorScheme.error,
            textColor: colorScheme.onError,
            onTap: () => Navigator.of(dialogContext).pop(false),
          ),
          SizedBox(width: 4),
          ClickableTextWidget(
            fontSize: 16,
            text: 'Yes',
            buttonColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            onTap: () {
              ref.invalidate(selectedAnswersProvider);
              Navigator.of(dialogContext).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
