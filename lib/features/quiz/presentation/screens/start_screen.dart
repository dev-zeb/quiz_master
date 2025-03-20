import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_list_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';
import 'package:learn_and_quiz/features/settings/presentation/pages/settings_page.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/learn_with_quiz_icon.png',
                color: colorScheme.primary,
                width: 300,
              ),
              const SizedBox(height: 60),
              QuizOutlinedButton(
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
              const SizedBox(height: 20),
              QuizOutlinedButton(
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
      ),
    );
  }
}
