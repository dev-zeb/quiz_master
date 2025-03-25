import 'package:flutter/material.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';

class QuizFormQuestionItem extends StatefulWidget {
  const QuizFormQuestionItem({super.key});

  @override
  State<QuizFormQuestionItem> createState() => QuizFormQuestionItemState();
}

class QuizFormQuestionItemState extends State<QuizFormQuestionItem> {
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _questionController,
          style: TextStyle(
            color: colorScheme.primary,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Enter question',
            hintStyle: TextStyle(
              color: colorScheme.primary.withOpacity(0.3),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            contentPadding: EdgeInsets.only(bottom: 4),
          ),
          minLines: 1,
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.options,
              style: TextStyle(
                color: colorScheme.primary,
              ),
            ),
            GestureDetector(
              onTap: _addOption,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.addOption,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
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
                        return Colors.green;
                      }
                      return colorScheme.primary;
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
                    style: TextStyle(color: colorScheme.primary),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '${AppStrings.option} ${i + 1}',
                      hintStyle: TextStyle(
                        color: colorScheme.primary.withOpacity(0.3),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 4),
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: _optionControllers.length <= 2
                        ? colorScheme.primary.withOpacity(0.3)
                        : Colors.redAccent,
                  ),
                  onPressed: _optionControllers.length <= 2
                      ? null
                      : () => _removeOption(i),
                ),
              ],
            ),
          ),
        SizedBox(height: 16),
      ],
    );
  }
}
