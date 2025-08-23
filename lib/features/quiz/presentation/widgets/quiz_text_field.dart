import 'package:flutter/material.dart';

class QuizTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const QuizTextField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: textEditingController,
      style: TextStyle(color: colorScheme.primary),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorScheme.primary.withValues(alpha: 0.6),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 0.25,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.0,
          ),
        ),
      ),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      validator: (value) {
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
      minLines: 1,
      maxLines: 4,
    );
  }
}
