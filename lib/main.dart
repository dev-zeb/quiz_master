import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';
import 'package:learn_and_quiz/core/config/hive_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive();
  runApp(
    const ProviderScope(
      child: QuizMaster(),
    ),
  );
}

class QuizMaster extends ConsumerWidget {
  const QuizMaster({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Learn with Quiz',
      debugShowCheckedModeBanner: false,
      home: const StartScreen(),
    );
  }
}
