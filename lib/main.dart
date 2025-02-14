import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/theme.dart';
import 'package:learn_and_quiz/core/config/theme_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';
import 'package:learn_and_quiz/core/config/hive_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive();
  runApp(
    const ProviderScope(
      child: Quiz(),
    ),
  );
}

class Quiz extends ConsumerWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Learn and Quiz',
      debugShowCheckedModeBanner: false,
      theme: LightTheme().themeData,
      themeMode: ref.watch(themeNotifierProvider),
      darkTheme: DarkTheme().themeData,
      home: const StartScreen(),
    );
  }
}
