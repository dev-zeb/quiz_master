import 'package:flutter/material.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_form_question_item.dart';

class QuestionCard extends StatelessWidget {
  final GlobalKey globalKey;
  final int questionIndex;
  final bool isDeleteButtonEnable;
  final QuizFormQuestionItem quizFormQuestionItem;
  final VoidCallback onDeleteButtonPress;

  const QuestionCard({
    super.key,
    required this.globalKey,
    required this.questionIndex,
    required this.isDeleteButtonEnable,
    required this.quizFormQuestionItem,
    required this.onDeleteButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      key: globalKey,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${questionIndex + 1}',
                  style: TextStyle(
                    color: colorScheme.primary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: isDeleteButtonEnable
                        ? colorScheme.error
                        : colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  onPressed: onDeleteButtonPress,
                ),
              ],
            ),
            quizFormQuestionItem,
          ],
        ),
      ),
    );
  }
}
