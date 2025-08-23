import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_history_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_list_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';
import 'package:learn_and_quiz/features/settings/presentation/pages/settings_page.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/learn_with_quiz_icon.png',
              color: colorScheme.primary,
              width: 180,
            ),
            const SizedBox(height: 60),
            CircularBorderedButton(
              text: 'Play Quiz',
              icon: Icons.play_arrow,
              isRightAligned: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizListScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CircularBorderedButton(
              text: 'History ',
              icon: Icons.history,
              isRightAligned: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizHistoryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CircularBorderedButton(
              text: 'Settings ',
              icon: Icons.settings,
              isRightAligned: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
