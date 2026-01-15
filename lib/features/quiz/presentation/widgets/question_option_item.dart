import 'package:flutter/material.dart';
import 'package:quiz_master/core/config/strings.dart';

import 'quiz_text_field.dart';

class QuestionOptionItem extends StatelessWidget {
  final int radioButtonValue;
  final int selectedAnswerIndex;
  final bool isDeleteButtonDisabled;

  final GlobalKey<FormState> optionFormKey = GlobalKey();

  final TextEditingController optionTextController;
  final ValueChanged<int?>? onRadioButtonTap;
  final void Function(int index) onRemoveOptionIconTap;

  QuestionOptionItem({
    super.key,
    required this.radioButtonValue,
    required this.selectedAnswerIndex,
    required this.isDeleteButtonDisabled,
    required this.optionTextController,
    this.onRadioButtonTap,
    required this.onRemoveOptionIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          RadioGroup(
            groupValue: selectedAnswerIndex,
            onChanged: (val) {
              if (onRadioButtonTap != null) onRadioButtonTap?.call(val);
            },
            child: Radio<int>(
              value: radioButtonValue,
              fillColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.primary;
                }
                return colorScheme.primary.withValues(alpha: 0.6);
              }),
            ),
          ),
          Expanded(
            child: Form(
              key: optionFormKey,
              child: QuizTextField(
                hintText: '${AppStrings.option} ${radioButtonValue + 1}',
                textEditingController: optionTextController,
                onChanged: (_) {
                  if (optionFormKey.currentState != null) {
                    optionFormKey.currentState!.validate();
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the option';
                  }
                  return null;
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              color: isDeleteButtonDisabled
                  ? colorScheme.primary.withValues(alpha: 0.3)
                  : colorScheme.error,
            ),
            onPressed: isDeleteButtonDisabled
                ? null
                : () => onRemoveOptionIconTap(radioButtonValue),
          ),
        ],
      ),
    );
  }
}
