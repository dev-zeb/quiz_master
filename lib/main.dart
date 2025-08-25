import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/core/config/hive_init.dart';
import 'package:quiz_master/core/config/theme/app_themes.dart';
import 'package:quiz_master/core/config/theme/theme_provider.dart';
import 'package:quiz_master/core/ui/screens/start_screen.dart';

// TODO:
// [-] Fix routing navigation.
// [-] Modify the UIs of the quiz add and quiz play screens.
// [] Integrate AI Quiz maker from text.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive();

  // Initialize theme before app starts
  final container = ProviderContainer();

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
    final themeData = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Quiz Master',
      debugShowCheckedModeBanner: false,
      darkTheme: AppThemes.darkTheme,
      theme: themeData,
      home: const StartScreen(),
    );
  }
}
