import 'package:flutter/material.dart';
import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/core/utils/dialog_utils.dart';
import 'package:quiz_master/features/quiz/domain/entities/question.dart';

import 'question_option_item.dart';
import 'quiz_text_field.dart';

class QuizFormQuestionItem extends StatefulWidget {
  final Question? question;

  const QuizFormQuestionItem({super.key, this.question});

  @override
  State<QuizFormQuestionItem> createState() => QuizFormQuestionItemState();
}

class QuizFormQuestionItemState extends State<QuizFormQuestionItem> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  final GlobalKey<FormState> questionFormKey = GlobalKey();
  int _selectedAnswerIndex = 0;

  @override
  void initState() {
    super.initState();

    if (widget.question != null) {
      _questionController.text = widget.question!.text;
      widget.question?.answers.forEach((answer) {
        _addOption(optionText: answer);
      });
    } else {
      // Start with 2 options
      _addOption();
      _addOption();
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: questionFormKey,
          child: QuizTextField(
            hintText: 'Enter question',
            textEditingController: _questionController,
            onChanged: (_) {
              if (questionFormKey.currentState != null) {
                questionFormKey.currentState!.validate();
              }
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the question.';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(AppStrings.options, style: TextStyle(color: colorScheme.primary)),
        const SizedBox(height: 8),
        for (var i = 0; i < _optionControllers.length; i++)
          QuestionOptionItem(
            radioButtonValue: i,
            selectedAnswerIndex: _selectedAnswerIndex,
            isDeleteButtonDisabled: _optionControllers.length <= 2,
            optionTextController: _optionControllers[i],
            onRadioButtonTap: (value) => setState(() {
              _selectedAnswerIndex = value!;
            }),
            onRemoveOptionIconTap: _removeOption,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              color: colorScheme.primary,
              child: InkWell(
                onTap: _addOption,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.add, color: colorScheme.onPrimary, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.addOption,
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void _addOption({String? optionText}) {
    setState(() {
      _optionControllers.add(TextEditingController(text: optionText));
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
    final colorScheme = Theme.of(context).colorScheme;

    final question = _questionController.text.trim();
    if (question.isEmpty) {
      showSnackBar(
        context: context,
        message: AppStrings.pleaseEnterQuestionAndOptions,
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
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
      showSnackBar(
        context: context,
        message: AppStrings.optionsMustBeUnique,
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
      );
      return null;
    }

    if (options.length < 2) {
      showSnackBar(
        context: context,
        message: AppStrings.pleaseEnterQuestionAndOptions,
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
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
}
