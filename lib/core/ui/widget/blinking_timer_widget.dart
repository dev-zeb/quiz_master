import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learn_and_quiz/features/quiz/presentation/helpers/dto_models/quiz_time.dart';

class BlinkingTimerWidget extends StatefulWidget {
  final int maxSeconds;
  final Function() onTimeUp;

  const BlinkingTimerWidget({
    super.key,
    required this.maxSeconds,
    required this.onTimeUp,
  });

  @override
  State<BlinkingTimerWidget> createState() => _BlinkingTimerWidgetState();
}

class _BlinkingTimerWidgetState extends State<BlinkingTimerWidget> {
  /// For timer widget
  Timer? countdownTimer;

  /// For blinking effect
  Timer? blinkTimer;
  bool showText = true;

  @override
  void initState() {
    super.initState();
    startCountdownTimer();
  }

  /// Starts the main countdown timer
  void startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (QuizTimeDTO.elapsedTimeSeconds > 0) {
        setState(() {
          QuizTimeDTO.elapsedTimeSeconds--;
        });
        updateBlinking();
      } else {
        stopBlinking();
        timer.cancel();
        widget.onTimeUp();
      }
    });
  }

  /// Controls the blinking timer based on remaining time
  void updateBlinking() {
    stopBlinking(); // Stop any existing blinking timer

    if (QuizTimeDTO.elapsedTimeSeconds <= (widget.maxSeconds * 0.25)) {
      int blinkSpeed =
          QuizTimeDTO.elapsedTimeSeconds <= (widget.maxSeconds * 0.10)
              ? 200
              : 400;
      blinkTimer = Timer.periodic(Duration(milliseconds: blinkSpeed), (timer) {
        setState(() {
          showText = !showText;
        });
      });
    }
  }

  /// Stops the blinking effect
  void stopBlinking() {
    blinkTimer?.cancel();
    blinkTimer = null;
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = QuizTimeDTO.elapsedTimeSeconds / widget.maxSeconds;

    // Determine progress bar and text color based on time left
    Color progressColor = Colors.blue;
    if (progress <= 0.50) progressColor = Colors.orange;
    if (progress <= 0.25) progressColor = Colors.redAccent;
    if (progress <= 0.10) progressColor = Colors.red;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 40,
            child: CircularProgressIndicator(
              value: QuizTimeDTO.elapsedTimeSeconds > 0 ? progress : 1.0,
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                QuizTimeDTO.elapsedTimeSeconds > 0
                    ? progressColor
                    : Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            QuizTimeDTO.elapsedTimeSeconds > 0
                ? "${(QuizTimeDTO.elapsedTimeSeconds ~/ 60).toString().padLeft(2, '0')}:${(QuizTimeDTO.elapsedTimeSeconds % 60).toString().padLeft(2, '0')}"
                : "Time Up!",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: !showText && QuizTimeDTO.elapsedTimeSeconds > 0
                  ? Colors.transparent
                  : QuizTimeDTO.elapsedTimeSeconds > 0
                      ? progressColor
                      : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
