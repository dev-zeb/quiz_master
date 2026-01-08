import 'package:flutter/material.dart';

class QuizQuestionCard extends StatefulWidget {
  final String questionText;
  final int questionIndex;
  final List<String> answers;

  final String? selectedAnswer;
  final void Function(String answer) onAnswerSelected;

  const QuizQuestionCard({
    super.key,
    required this.questionText,
    required this.questionIndex,
    required this.answers,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  State<QuizQuestionCard> createState() => _QuizQuestionCardState();
}

class _QuizQuestionCardState extends State<QuizQuestionCard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = widget.selectedAnswer;

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
                  ...widget.answers.map((answer) {
                    final isSelected = answer == selected;

                    return Card(
                      color: isSelected
                          ? colorScheme.secondary
                          : colorScheme.surfaceContainer,
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
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
                            if (value == null) return;
                            widget.onAnswerSelected(value);
                            setState(
                              () {},
                            ); // ensure visuals update if parent doesn't rebuild immediately
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }),
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
