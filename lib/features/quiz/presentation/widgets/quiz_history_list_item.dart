import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quiz_master/core/ui/widgets/badge_item.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';

class QuizHistoryListItem extends StatelessWidget {
  final QuizHistory quizHistory;

  const QuizHistoryListItem({super.key, required this.quizHistory});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = quizHistory.playedAt;
    final percent = quizHistory.scorePercent.toStringAsFixed(0);

    final formattedDate = DateFormat('MMM d, y').format(date);
    final formattedTime = DateFormat('hh:mm a').format(date);

    return Card(
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.push(
            '/history/detail',
            extra: quizHistory,
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
