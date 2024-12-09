import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_and_quiz/config/strings.dart';
import 'package:learn_and_quiz/config/theme.dart';
import 'package:learn_and_quiz/config/theme_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // Initialize SharedPreferences

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
    final isDarkMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const StartScreen(),
    );
  }
}
