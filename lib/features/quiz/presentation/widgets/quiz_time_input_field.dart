import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizTimeInputField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const QuizTimeInputField({
    super.key,
    required this.label,
    required this.textEditingController,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: 50,
          child: TextFormField(
            controller: textEditingController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary, width: 0.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary, width: 1.0),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            ),
            style: TextStyle(color: colorScheme.primary),
            onChanged: onChanged,
            validator: (value) {
              if (validator != null) {
                return validator!(value);
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2), // Max 2 digits
            ],
          ),
        ),
        Text(label, style: TextStyle(color: colorScheme.primary)),
      ],
    );
  }
}
