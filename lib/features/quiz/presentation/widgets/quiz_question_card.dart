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
  String? selected;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scrollbar(
      controller: _scrollController,
      interactive: true,
      scrollbarOrientation: ScrollbarOrientation.right,
      thickness: 4.0,
      thumbVisibility: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
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
                    (answer) => Card(
                      elevation: 2.0,
                      margin: EdgeInsets.only(bottom: 16),
                      child: RadioListTile<String>(
                        tileColor: Colors.white,
                        title: Text(
                          answer,
                          style: TextStyle(fontSize: 16),
                        ),
                        value: answer,
                        groupValue: selected,
                        onChanged: (String? value) {
                          final selectedAnswers =
                              ref.read(selectedAnswersProvider);
                          int currentQuestionIndex = selectedAnswers.length - 1;

                          if (selectedAnswers.isEmpty ||
                              currentQuestionIndex < widget.questionIndex) {
                            selectedAnswers.add(value!);
                          } else {
                            selectedAnswers[currentQuestionIndex] = value!;
                          }

                          ref
                              .read(selectedAnswersProvider.notifier)
                              .update((_) => selectedAnswers);

                          setState(() {
                            selected = value;
                          });
                        },
                        activeColor: colorScheme.secondaryContainer,
                        selectedTileColor: colorScheme.primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        selected: answer == selected,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
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
