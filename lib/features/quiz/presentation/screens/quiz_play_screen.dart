import 'package:blinking_timer/blinking_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_master/core/config/utils.dart';
import 'package:quiz_master/core/di/injection.dart';
import 'package:quiz_master/core/ui/widgets/circular_border_progress_painter.dart';
import 'package:quiz_master/core/utils/dialog_utils.dart';
import 'package:quiz_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_master/features/quiz/domain/entities/question.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_play_button.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_question_card.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({super.key, required this.quiz});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentQuestionIndex = 0;
  late int _quizTimeSeconds;

  late final List<Question> _questions;
  late final List<List<String>> _shuffledAnswers;
  late final int _startTimeMillis;

  late final List<String?> _selectedAnswers;

  @override
  void initState() {
    super.initState();
    _quizTimeSeconds = widget.quiz.durationSeconds;
    _questions = List<Question>.from(widget.quiz.questions);

    _shuffledAnswers =
        _questions.map((q) => List<String>.from(q.answers)..shuffle()).toList();

    _selectedAnswers = List<String?>.filled(_questions.length, null);
    _startTimeMillis = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final currentQuestion = _questions[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;
    final currentQuestionNumber = _currentQuestionIndex + 1;
    final totalNumberOfQuestions = _questions.length;

    final progressRate = currentQuestionNumber / totalNumberOfQuestions;
    final progressValue = (progressRate * 100).toStringAsFixed(2);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, res) async {
        if (didPop) return;

        final result = await showConfirmationDialog(
          context,
          title: 'Cancel Quiz?',
          content: 'The progress of this quiz session will be lost.',
          okButtonText: 'Yes',
          okButtonTap: () async {},
        );

        if (result == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                Material(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12.0),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 8, bottom: 8),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                    onTap: () async {
                      final result = await showConfirmationDialog(
                        context,
                        title: 'Cancel Quiz?',
                        content:
                            'The progress of this quiz session will be lost.',
                        okButtonText: 'Yes',
                        okButtonTap: () async {},
                      );
                      if (result == true && context.mounted) {
                        context.pop();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    widget.quiz.title,
                    style: TextStyle(color: colorScheme.primary, fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 5,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.secondary, width: 0.5),
              ),
              child: LinearProgressIndicator(
                value: progressRate,
                backgroundColor: colorScheme.onSecondary,
                valueColor:
                    AlwaysStoppedAnimation<Color>(colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Q: $currentQuestionNumber of $totalNumberOfQuestions',
                    style:
                        TextStyle(color: colorScheme.secondary, fontSize: 16),
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
                      await _finishAndGoToResults(
                        colorScheme,
                        title: "Time's Up!",
                        iconColor: colorScheme.error,
                        delay: const Duration(milliseconds: 700),
                      );
                    },
                  ),
                  Text(
                    "$progressValue%",
                    style:
                        TextStyle(color: colorScheme.secondary, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: QuizQuestionCard(
                questionText: currentQuestion.text,
                questionIndex: _currentQuestionIndex,
                answers: _shuffledAnswers[_currentQuestionIndex],
                selectedAnswer: _selectedAnswers[_currentQuestionIndex],
                onAnswerSelected: (ans) {
                  setState(() {
                    _selectedAnswers[_currentQuestionIndex] = ans;
                  });
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 12),
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
                      onTap: () => setState(() => _currentQuestionIndex--),
                    ),
                    const SizedBox(width: 12),
                  ],
                  QuizPlayButton(
                    key: ValueKey('next_$_currentQuestionIndex'),
                    isIconFirst: false,
                    text: isLastQuestion ? 'Submit' : 'Next',
                    iconWidget: Icon(
                      Icons.arrow_circle_right,
                      color: colorScheme.onPrimary,
                    ),
                    onTap: () async {
                      if (isLastQuestion) {
                        await _finishAndGoToResults(
                          colorScheme,
                          title: "Well Done!",
                          iconColor: colorScheme.tertiary,
                          delay: const Duration(milliseconds: 700),
                        );
                      } else {
                        setState(() => _currentQuestionIndex++);
                      }
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

  Future<void> _finishAndGoToResults(
    ColorScheme colorScheme, {
    required String title,
    required Color iconColor,
    required Duration delay,
  }) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.alarm, size: 48, color: iconColor),
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

    final elapsedTime =
        (DateTime.now().millisecondsSinceEpoch - _startTimeMillis) ~/ 1000;

    final userId = getIt<AuthRepository>().currentUser?.id;

    final quizHistory = QuizHistory(
      id: UniqueKey().toString(),
      quizId: widget.quiz.id,
      quizTitle: widget.quiz.title,
      selectedAnswers: _selectedAnswers,
      questions: _questions,
      playedAt: DateTime.now(),
      elapsedTimeSeconds: elapsedTime,
      totalDurationSeconds: widget.quiz.durationSeconds,
      userId: userId,
    );

    context.read<QuizBloc>().add(QuizHistoryAdded(quizHistory));
    await Future.delayed(delay);

    if (!mounted) return;
    context.pop(); // close dialog
    context.go('/result', extra: quizHistory);
  }
}
