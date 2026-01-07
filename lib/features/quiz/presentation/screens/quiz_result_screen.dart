import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_master/core/config/theme/app_themes.dart';
import 'package:quiz_master/core/config/utils.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_chart_item.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_history_question_item.dart';
import 'package:quiz_master/core/ui/widgets/circular_border_button.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_time_widget.dart';

class QuizResultScreen extends StatefulWidget {
  final QuizHistory quizHistory;

  const QuizResultScreen({super.key, required this.quizHistory});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late QuizHistory quizHistory;

  @override
  void initState() {
    super.initState();
    quizHistory = widget.quizHistory;
  }

  @override
  Widget build(BuildContext context) {
    final numOfTotalQuestions = quizHistory.questions.length;
    int numOfCorrectAnswers = 0;
    final selectedAnswers = quizHistory.selectedAnswers;
    final questions = quizHistory.questions;

    for (int idx = 0; idx < selectedAnswers.length; idx++) {
      if (questions[idx].correctAnswer == selectedAnswers[idx]) {
        numOfCorrectAnswers++;
      }
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: 'Quiz Result',
        hasBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
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
                          color: colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    _buildQuestionSummaryList(),
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

  Widget _buildQuestionSummaryList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: quizHistory.questions.length + 1,
      itemBuilder: (context, index) {
        final questions = quizHistory.questions;
        if (index == questions.length) return const SizedBox(height: 20);
        return QuizHistoryQuestionItem(
          question: questions[index],
          questionIndex: index,
          selectedAnswer: quizHistory.selectedAnswers[index],
        );
      },
    );
  }

  Widget _buildScoreChart(int correct, int total) {
    final colorScheme = Theme.of(context).colorScheme;
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
              color: colorScheme.error,
              value: (total - correct).toDouble(),
              title: '$wrongAnswerPercentage%',
              radius: 72,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onError,
              ),
              titlePositionPercentageOffset: titleOffset,
            ),
            PieChartSectionData(
              color: colorScheme.tertiary,
              value: correct.toDouble(),
              title: '$correctAnswerPercentage%',
              radius: 72,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onTertiary,
              ),
              titlePositionPercentageOffset: titleOffset,
            ),
          ],
        ),
      ),
      infoWidget: [
        const SizedBox(height: 16),
        _buildTag(Icons.list_alt, "Total", total, colorScheme.primary),
        const SizedBox(height: 4),
        _buildTag(Icons.check_circle_outline, "Correct", correct,
            colorScheme.tertiary),
        const SizedBox(height: 4),
        _buildTag(
            Icons.cancel_outlined, "Wrong", total - correct, colorScheme.error),
      ],
    );
  }

  Widget _buildTimeChart({required QuizHistory quizHistory}) {
    final colorScheme = Theme.of(context).colorScheme;
    final elapsedTime = quizHistory.elapsedTimeSeconds;
    final remainingTime = quizHistory.totalDurationSeconds - elapsedTime;

    final [remainingMinutes, remainingSeconds] =
        getMinutesAndSeconds(remainingTime);
    final [elapsedMinutes, elapsedSeconds] = getMinutesAndSeconds(elapsedTime);
    final [totalMinutes, totalSeconds] =
        getMinutesAndSeconds(quizHistory.totalDurationSeconds);

    final progress = elapsedTime / quizHistory.totalDurationSeconds;
    final remainingProgress = 1 - progress;
    final progressColor = remainingProgress <= 0.2
        ? colorScheme.error
        : remainingProgress <= 0.5
            ? AppColors.warningOrange
            : colorScheme.primary;

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
              backgroundColor: colorScheme.tertiary,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Time',
                  style: TextStyle(fontSize: 14, color: colorScheme.primary)),
              Text(
                '$totalMinutes:${totalSeconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
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
          optionColor: colorScheme.tertiary,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularBorderedButton(
            text: 'Restart Quiz',
            icon: Icons.restart_alt_outlined,
            onTap: () {
              final quiz =
                  context.read<QuizBloc>().getQuizById(quizHistory.quizId);
              if (quiz == null) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizPlayScreen(quiz: quiz)),
              );
            },
            isRightAligned: false,
          ),
          const SizedBox(width: 16),
          CircularBorderedButton(
            text: 'Go To Home',
            icon: Icons.home_outlined,
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            isRightAligned: false,
          ),
        ],
      ),
    );
  }

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
