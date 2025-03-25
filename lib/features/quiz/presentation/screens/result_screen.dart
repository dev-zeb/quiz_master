import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:learn_and_quiz/core/config/utils.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/helpers/dto_models/question_summary.dart';
import 'package:learn_and_quiz/features/quiz/presentation/helpers/dto_models/quiz_time.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_chart_item.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_result_list_item.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_time_widget.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final Quiz quiz;
  final int? elapsedTimeSeconds;

  const ResultScreen({
    super.key,
    required this.quiz,
    this.elapsedTimeSeconds,
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final Color correctColor = Colors.green;
  final Color wrongColor = Colors.red;
  final Color progressHigh = Colors.blue[500]!;
  final Color progressMedium = Colors.orange;
  final Color progressLow = Colors.red;
  final Color timeRemainingColor = const Color(0xFF29C531);

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
              color: Colors.red,
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
              color: Colors.green,
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
        const SizedBox(height: 12),
        _buildTag(Icons.play_circle_filled, "Total", total, progressHigh),
        const SizedBox(height: 12),
        _buildTag(Icons.check_circle, "Correct", correct, correctColor),
        const SizedBox(height: 12),
        _buildTag(
          Icons.cancel,
          "Wrong",
          total - correct,
          wrongColor,
        ),
      ],
    );
  }

  Widget _buildTimeChart({required int quizDuration}) {
    // Calculate remaining time
    final remainingTime = QuizTimeDTO.elapsedTimeSeconds;
    final [remainingMinutes, remainingSeconds] =
        getMinutesAndSeconds(remainingTime);

    // Calculate elapsed time
    final elapsedTime = quizDuration - remainingTime;
    final [elapsedMinutes, elapsedSeconds] = getMinutesAndSeconds(elapsedTime);

    // Format quiz duration
    final [quizDurationMinutes, quizDurationSecs] =
        getMinutesAndSeconds(quizDuration);

    double progress = remainingTime / quizDuration;
    Color progressColor = progress <= 0.2
        ? Colors.red
        : progress <= 0.5
            ? Colors.orange
            : Colors.blue[500]!;

    final colorScheme = Theme.of(context).colorScheme;

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
              backgroundColor: progressColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF29C531),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Time',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                elapsedTime > 0
                    ? "$quizDurationMinutes:$quizDurationSecs"
                    : "02:00",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
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
          optionValue: '$elapsedMinutes:$elapsedSeconds',
          optionColor: progressColor,
        ),
        SizedBox(height: 12),
        QuizTimeWidget(
          optionTitle: 'Remaining Time',
          optionValue: '$remainingMinutes:$remainingSeconds',
          optionColor: Color(0xFF29C531),
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
            QuizTimeDTO.elapsedTimeSeconds = widget.quiz.durationSeconds ?? 120;
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
