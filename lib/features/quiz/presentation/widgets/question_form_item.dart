import 'package:flutter/material.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/core/config/text_styles.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';

class QuestionFormItem extends StatefulWidget {
  const QuestionFormItem({super.key});

  @override
  State<QuestionFormItem> createState() => QuestionFormItemState();
}

class QuestionFormItemState extends State<QuestionFormItem> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  int _selectedAnswerIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start with 2 options
    _addOption();
    _addOption();
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= 2) return; // Maintain minimum 2 options
    setState(() {
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
      if (_selectedAnswerIndex >= _optionControllers.length) {
        _selectedAnswerIndex = _optionControllers.length - 1;
      }
    });
  }

  bool _hasDuplicateOptions() {
    // Get all non-empty options and trim them
    final options = _optionControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    // Check for duplicates
    final uniqueOptions = options.toSet();
    return uniqueOptions.length != options.length;
  }

  Question? getQuestion() {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.pleaseEnterQuestionAndOptions),
        ),
      );
      return null;
    }

    // Get all non-empty options
    final options = _optionControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    // Check for duplicate options
    if (_hasDuplicateOptions()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.optionsMustBeUnique),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    if (options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.pleaseEnterQuestionAndOptions),
        ),
      );
      return null;
    }

    // Move the selected answer to the first position
    if (_selectedAnswerIndex < options.length) {
      final selectedAnswer = options[_selectedAnswerIndex];
      options.removeAt(_selectedAnswerIndex);
      options.insert(0, selectedAnswer);
    }

    return Question(
      id: UniqueKey().toString(),
      text: question,
      answers: options,
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Fix border colors
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _questionController,
          style: AppTextStyles.bodyText,
          decoration: InputDecoration(
            labelText: AppStrings.question,
            labelStyle: AppTextStyles.labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF013138)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF013138)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          maxLines: 2,
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
              onPressed: _addOption,
              icon: const Icon(Icons.add, color: Color(0xFF013138), size: 20),
              label: Text(
                AppStrings.addOption,
                style: TextStyle(
                  color: Color(0xFF013138),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < _optionControllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: _selectedAnswerIndex,
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Color(0xFF013138);
                      }
                      return Color(0xFF013138);
                    },
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswerIndex = value!;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _optionControllers[i],
                    style: AppTextStyles.bodyText,
                    decoration: InputDecoration(
                      labelText: '${AppStrings.option} ${i + 1}',
                      labelStyle: AppTextStyles.labelText,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF013138)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF013138)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: _optionControllers.length <= 2
                        ? Color(0xFF013138).withOpacity(0.3)
                        : Color(0xFF013138).withOpacity(0.9),
                  ),
                  onPressed: _optionControllers.length <= 2
                      ? null
                      : () => _removeOption(i),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
