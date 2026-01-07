import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_master/core/ui/widgets/badge_item.dart';
import 'package:quiz_master/core/ui/widgets/popup_menu.dart';
import 'package:quiz_master/core/ui/widgets/popup_option_item.dart';
import 'package:quiz_master/core/utils/dialog_utils.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_editor_screen.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_play_screen.dart';

class QuizListItem extends StatelessWidget {
  final Quiz quiz;

  const QuizListItem({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final minutesInt = quiz.durationSeconds ~/ 60;
    final secondsInt = quiz.durationSeconds % 60;

    final timerText = minutesInt == 0
        ? '${secondsInt}s'
        : secondsInt == 0
            ? '${minutesInt}m'
            : '${minutesInt}m ${secondsInt}s';

    return Card(
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QuizPlayScreen(quiz: quiz)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow_rounded,
                  color: colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        BadgeItem(
                          badgeIcon: Icons.quiz,
                          badgeTitle: '${quiz.questions.length} Ques.',
                        ),
                        const SizedBox(width: 8),
                        BadgeItem(
                          badgeIcon: Icons.timer_outlined,
                          badgeTitle: timerText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _SyncStatusChip(status: quiz.syncStatus),
                  ],
                ),
              ),
              TopRightPopupMenuIcon<String>(
                iconColor: colorScheme.primary,
                iconSize: 28,
                menuBuilder: () => [
                  PopupMenuItem(
                    value: 'play',
                    child: PopupOptionItem(
                      color: colorScheme.onPrimary,
                      title: 'Play',
                      iconData: Icons.play_arrow,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: PopupOptionItem(
                      color: colorScheme.onPrimary,
                      title: 'Edit',
                      iconData: Icons.edit,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: PopupOptionItem(
                      color: colorScheme.onPrimary,
                      title: 'Delete',
                      iconData: Icons.delete,
                    ),
                  ),
                ],
                onSelected: (selected) async {
                  switch (selected) {
                    case 'play':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => QuizPlayScreen(quiz: quiz)),
                      );
                      break;

                    case 'edit':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => QuizEditorScreen(quiz: quiz)),
                      );
                      break;

                    case 'delete':
                      await showConfirmationDialog(
                        context,
                        title: 'Delete Quiz?',
                        content: 'This will delete the quiz permanently.',
                        okButtonText: 'Delete',
                        okButtonTap: () async {
                          context.read<QuizBloc>().add(QuizDeleted(quiz.id));
                          if (context.mounted) {
                            showSnackBar(
                              context: context,
                              message: 'Quiz deleted successfully',
                            );
                          }
                        },
                      );
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncStatusChip extends StatelessWidget {
  final SyncStatus status;

  const _SyncStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color bgColor;
    String label;
    IconData icon;

    switch (status) {
      case SyncStatus.synced:
        bgColor = colorScheme.tertiary.withValues(alpha: 0.2);
        label = 'Synced';
        icon = Icons.cloud_done;
        break;
      case SyncStatus.failed:
        bgColor = colorScheme.errorContainer;
        label = 'Sync failed';
        icon = Icons.cloud_off;
        break;
      case SyncStatus.pending:
        bgColor = colorScheme.primary.withValues(alpha: 0.1);
        label = 'Pending sync';
        icon = Icons.sync;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
