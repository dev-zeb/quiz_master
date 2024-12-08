import 'package:flutter/material.dart';
import 'package:learn_and_quiz/config/strings.dart';
import 'package:learn_and_quiz/config/text_styles.dart';
import 'package:learn_and_quiz/models/question_model.dart';

// ignore: must_be_immutable
class QuestionFormItem extends StatefulWidget {
  final questionController = TextEditingController();
  final List<TextEditingController> optionControllers = [];
  int selectedAnswerIndex = 0;

  QuestionFormItem({super.key}) {
    // Start with 2 options
    addOption();
    addOption();
  }

  void dispose() {
    questionController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
  }

  void addOption() {
    optionControllers.add(TextEditingController());
  }

  void removeOption(int index) {
    if (optionControllers.length <= 2) return; // Maintain minimum 2 options
    optionControllers[index].dispose();
    optionControllers.removeAt(index);
    if (selectedAnswerIndex >= optionControllers.length) {
      selectedAnswerIndex = optionControllers.length - 1;
    }
  }

  QuestionModel? getQuestion() {
    final question = questionController.text.trim();
    if (question.isEmpty) return null;

    // Get all non-empty options
    final options = optionControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (options.length < 2) return null;

    // Move the selected answer to the first position
    if (selectedAnswerIndex < options.length) {
      final selectedAnswer = options[selectedAnswerIndex];
      options.removeAt(selectedAnswerIndex);
      options.insert(0, selectedAnswer);
    }

    return QuestionModel(
      text: question,
      answers: options,
    );
  }

  @override
  State<QuestionFormItem> createState() => _QuestionFormItemState();
}

class _QuestionFormItemState extends State<QuestionFormItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: TextField(
            controller: widget.questionController,
            style: AppTextStyles.bodyText,
            decoration: InputDecoration(
              labelText: AppStrings.question,
              labelStyle: AppTextStyles.labelText,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.options,
              style: AppTextStyles.titleMedium,
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  widget.addOption();
                });
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: Text(
                AppStrings.addOption,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < widget.optionControllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: widget.selectedAnswerIndex,
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white.withOpacity(0.6);
                    },
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.selectedAnswerIndex = value!;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: widget.optionControllers[i],
                    style: AppTextStyles.bodyText,
                    decoration: InputDecoration(
                      labelText: '${AppStrings.option} ${i + 1}',
                      labelStyle: AppTextStyles.labelText,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: widget.optionControllers.length <= 2
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.9),
                  ),
                  onPressed: widget.optionControllers.length <= 2
                      ? null
                      : () {
                          setState(() {
                            widget.removeOption(i);
                          });
                        },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
