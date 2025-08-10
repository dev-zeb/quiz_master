import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:learn_and_quiz/core/config/utils.dart';
import 'package:learn_and_quiz/core/ui/widgets/app_bar_back_button.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz_history.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_history_detail.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_chart_item.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_time_widget.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  final Quiz quiz;
  final QuizHistory quizHistory;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.quizHistory,
  });

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  final Color progressHigh = Color(0xFF004350);
  final Color progressMedium = Color(0xFFA87700);
  final Color progressLow = Color(0xFFAF0000);
  final Color correctColor = const Color(0xFF009106);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final quizHistory = widget.quizHistory;
    final numOfTotalQuestions = widget.quiz.questions.length;
    int numOfCorrectAnswers = 0;
    final selectedAnswers = widget.quizHistory.selectedAnswers;
    final questions = widget.quiz.questions;

    for (int idx = 0; idx < selectedAnswers.length; idx++) {
      if (questions[idx].correctAnswer == selectedAnswers[idx]) {
        numOfCorrectAnswers++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        titleSpacing: 0,
        leading: AppBarBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildScoreChart(numOfCorrectAnswers, numOfTotalQuestions),
                    const SizedBox(height: 12),
                    _buildTimeChart(quizHistory: quizHistory),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Your Answers:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildQuestionSummaryList(
                      questions,
                      selectedAnswers,
                      colorScheme,
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionSummaryList(
    List<Question> questions,
    List<String?> selectedAnswers,
    ColorScheme colorScheme,
  ) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: questions.length + 1,
      itemBuilder: (context, index) {
        if (index == questions.length) {
          return SizedBox(height: 20);
        }
        return QuizHistoryDetailItem(
          question: questions[index],
          questionIndex: index,
          selectedAnswer: selectedAnswers[index],
        );
      },
    );
  }

  /// Correct Answers Chart
  Widget _buildScoreChart(int correct, int total) {
    final correctAnswerPercentage = getCorrectAnswerPercentage(
      correctAnswers: correct,
      totalQuestions: total,
    );
    final wrongAnswerPercentage = getWrongAnswerPercentage(
      correctAnswers: correct,
      totalQuestions: total,
    );
    final isTitleCenter = (correct == 0) || (correct == total);
    final titleOffset = isTitleCenter ? 0.0 : 0.65;

    return QuizChartItem(
      chartTitle: 'Quiz Score',
      chartWidget: PieChart(
        PieChartData(
          centerSpaceRadius: 0,
          sectionsSpace: 2,
          sections: [
            PieChartSectionData(
              color: progressLow,
              value: (total - correct).toDouble(),
              title: '$wrongAnswerPercentage%',
              radius: 72,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titlePositionPercentageOffset: titleOffset,
            ),
            PieChartSectionData(
              color: correctColor,
              value: correct.toDouble(),
              title: '$correctAnswerPercentage%',
              radius: 72,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titlePositionPercentageOffset: titleOffset,
            ),
          ],
        ),
      ),
      infoWidget: [
        const SizedBox(height: 16),
        _buildTag(Icons.list_alt, "Total", total, progressHigh),
        const SizedBox(height: 4),
        _buildTag(Icons.check_circle_outline, "Correct", correct, correctColor),
        const SizedBox(height: 4),
        _buildTag(Icons.cancel_outlined, "Wrong", total - correct, progressLow),
      ],
    );
  }

  Widget _buildTimeChart({required QuizHistory quizHistory}) {
    final elapsedTime = quizHistory.elapsedTimeSeconds;
    final remainingTime = quizHistory.totalDurationSeconds - elapsedTime;

    final [remainingMinutes, remainingSeconds] =
        getMinutesAndSeconds(remainingTime);
    final [elapsedMinutes, elapsedSeconds] = getMinutesAndSeconds(elapsedTime);
    final [totalMinutes, totalSeconds] =
        getMinutesAndSeconds(quizHistory.totalDurationSeconds);

    double progress = elapsedTime / (quizHistory.totalDurationSeconds);
    double remainingProgress = 1 - progress;
    Color progressColor = remainingProgress <= 0.2
        ? progressLow
        : remainingProgress <= 0.5
            ? progressMedium
            : progressHigh;

    return QuizChartItem(
      chartTitle: 'Time Stats',
      chartWidget: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 132,
            width: 132,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 12,
              backgroundColor: correctColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Time',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '$totalMinutes:${totalSeconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      infoWidget: [
        const SizedBox(height: 12),
        QuizTimeWidget(
          optionTitle: 'Elapsed Time',
          optionValue:
              '$elapsedMinutes:${elapsedSeconds.toString().padLeft(2, '0')}',
          optionColor: progressColor,
        ),
        const SizedBox(height: 12),
        QuizTimeWidget(
          optionTitle: 'Remaining Time',
          optionValue:
              '$remainingMinutes:${remainingSeconds.toString().padLeft(2, '0')}',
          optionColor: correctColor,
        ),
      ],
    );
  }

  /// Action Buttons
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuizOutlinedButton(
          text: 'Restart Quiz',
          icon: Icons.restart_alt_outlined,
          onTap: () {
            // Update the remaining time here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPlayScreen(quiz: widget.quiz),
              ),
            );
          },
          isRightAligned: false,
        ),
        const SizedBox(width: 16),
        QuizOutlinedButton(
          text: 'Go To Home',
          icon: Icons.home_outlined,
          onTap: () {
            Navigator.popUntil(
              context,
              (route) => route.isFirst,
            );
          },
          isRightAligned: false,
        ),
      ],
    );
  }

  /// Reusable Tag Widget
  Widget _buildTag(IconData icon, String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
