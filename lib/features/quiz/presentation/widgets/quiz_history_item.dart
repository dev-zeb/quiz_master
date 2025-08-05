import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_and_quiz/core/ui/widgets/badge_item.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz_history.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_history_detail.dart';

class QuizHistoryItem extends StatelessWidget {
  final QuizHistory quizHistory;

  const QuizHistoryItem({super.key, required this.quizHistory});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = quizHistory.playedAt;
    final percent = quizHistory.scorePercent.toStringAsFixed(0);

    final formattedDate = DateFormat('MMM d, y').format(date);
    final formattedTime = DateFormat('hh:mm a').format(date);

    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 1.5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizAttemptDetail(entry: quizHistory),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                color: colorScheme.primary,
                size: 28,
              ),
              SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quizHistory.quizTitle,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        BadgeItem(
                          badgeIcon: Icons.play_arrow_rounded,
                          badgeTitle: '$formattedDate, $formattedTime',
                        ),
                        SizedBox(width: 6),
                        BadgeItem(
                          badgeIcon: Icons.emoji_events,
                          badgeTitle: 'Score: $percent%',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
