import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/hive_init.dart';
import 'package:learn_and_quiz/core/config/theme/theme.dart';
import 'package:learn_and_quiz/core/config/theme/theme_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive();

  // Initialize theme before app starts
  final container = ProviderContainer();
  await container.read(themeProvider.notifier).initializeTheme();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const QuizMaster(),
    ),
  );
}

class QuizMaster extends ConsumerWidget {
  const QuizMaster({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Quiz Master',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
      home: const StartScreen(),
    );
  }
}
