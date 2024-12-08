import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/config/strings.dart';
import 'package:learn_and_quiz/config/theme.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: Quiz(),
    ),
  );
}

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.theme,
      home: const StartScreen(),
    );
  }
}
