import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';

class QuizQuestionCard extends ConsumerStatefulWidget {
  final String questionText;
  final int questionIndex;
  final List<String> answers;

  const QuizQuestionCard({
    super.key,
    required this.questionText,
    required this.questionIndex,
    required this.answers,
  });

  @override
  ConsumerState<QuizQuestionCard> createState() => _QuestionItemState();
}

class _QuestionItemState extends ConsumerState<QuizQuestionCard> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedAnswers = ref.watch(selectedAnswersProvider);
    final selected = widget.questionIndex < selectedAnswers.length
        ? selectedAnswers[widget.questionIndex]
        : null;

    return Scrollbar(
      controller: _scrollController,
      interactive: true,
      scrollbarOrientation: ScrollbarOrientation.right,
      thickness: 4.0,
      thumbVisibility: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                widget.questionText,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.answers.map(
                    (answer) {
                      final isSelected = answer == selected;

                      return Card(
                        color: isSelected
                            ? colorScheme.secondary
                            : colorScheme.surfaceContainer,
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 16),
                        child: RadioTheme(
                          data: RadioThemeData(
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return colorScheme.onSecondary;
                                }
                                return colorScheme.primary;
                              },
                            ),
                          ),
                          child: RadioListTile<String>(
                            title: Text(
                              answer,
                              style: TextStyle(
                                color: isSelected
                                    ? colorScheme.onSecondary
                                    : colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                            dense: true,
                            groupValue: selected,
                            value: answer,
                            selected: isSelected,
                            activeColor: colorScheme.onSecondary,
                            selectedTileColor: colorScheme.primary,
                            tileColor: colorScheme.surfaceContainer,
                            controlAffinity: ListTileControlAffinity.leading,
                            visualDensity: VisualDensity.compact,
                            onChanged: (String? value) {
                              ref
                                  .read(selectedAnswersProvider.notifier)
                                  .update((state) {
                                final newState = [...state];
                                while (
                                    newState.length <= widget.questionIndex) {
                                  newState.add(null);
                                }
                                newState[widget.questionIndex] = value;
                                return newState;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
