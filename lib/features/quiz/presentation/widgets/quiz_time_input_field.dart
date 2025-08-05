import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizTimeInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const QuizTimeInputField({
    super.key,
    required this.textEditingController,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 50,
      child: TextFormField(
        controller: textEditingController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 4,
          ),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (validator != null) {
            return validator!(value);
          }
          return null;
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
          // Max 2 digits
        ],
      ),
    );
  }
}
