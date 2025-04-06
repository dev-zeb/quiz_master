import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:learn_and_quiz/core/config/utils.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/helpers/dto_models/question_summary.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_chart_item.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_result_list_item.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_time_widget.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final Quiz quiz;
  final int? elapsedTimeSeconds;
  final int? totalDurationSeconds;

  const ResultScreen({
    super.key,
    required this.quiz,
    this.elapsedTimeSeconds,
    this.totalDurationSeconds,
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final Color progressHigh = Color(0xFF004350);
  final Color progressMedium = Color(0xFFA87700);
  final Color progressLow = Color(0xFFAF0000);
  final Color correctColor = const Color(0xFF009106);

  bool _showSummary = false;

  List<QuestionSummary> getSummaryData(List<String?> chosenAnswers) {
    return List.generate(chosenAnswers.length, (i) {
      return QuestionSummary(
        index: i,
        question: widget.quiz.questions[i].text,
        correctAnswer: widget.quiz.questions[i].answers[0],
        userAnswer: chosenAnswers[i],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final summaryData = getSummaryData(ref.watch(selectedAnswersProvider));

    final numOfTotalQuestions = widget.quiz.questions.length;
    final numOfCorrectAnswers =
        summaryData.where((summary) => summary.isCorrect).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        centerTitle: true,
        leading: Container(),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildScoreChart(numOfCorrectAnswers, numOfTotalQuestions),
            const SizedBox(height: 20),
            _buildTimeChart(
              quizDuration: widget.quiz.durationSeconds ?? 120,
            ),
            const SizedBox(height: 20),
            _buildSummaryToggleButton(),
            if (_showSummary)
              _buildQuestionSummaryList(summaryData, colorScheme),
            if (!_showSummary) Spacer(),
            _buildActionButtons(),
          ],
        ),
      ),
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

  Widget _buildTimeChart({required int quizDuration}) {
    final elapsedTime = widget.elapsedTimeSeconds ?? 0;
    final remainingTime = (widget.totalDurationSeconds ?? 120) - elapsedTime;

    final [remainingMinutes, remainingSeconds] =
        getMinutesAndSeconds(remainingTime);
    final [elapsedMinutes, elapsedSeconds] = getMinutesAndSeconds(elapsedTime);
    final [totalMinutes, totalSeconds] =
        getMinutesAndSeconds(widget.totalDurationSeconds ?? 120);

    double progress = elapsedTime / (widget.totalDurationSeconds ?? 120);
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

  /// Toggle Button for Question Summary
  Widget _buildSummaryToggleButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showSummary = !_showSummary;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(_showSummary ? "Hide Answers" : "Show Answers"),
              const Spacer(),
              Icon(
                _showSummary ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Question Summary List
  Widget _buildQuestionSummaryList(
    List<QuestionSummary> summaryData,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: summaryData.length,
        itemBuilder: (context, index) {
          final questionSummary = summaryData[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: QuizResultListItem(
              questionSummary: questionSummary,
            ),
          );
        },
      ),
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
            ref.invalidate(selectedAnswersProvider);
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartScreen(),
              ),
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
