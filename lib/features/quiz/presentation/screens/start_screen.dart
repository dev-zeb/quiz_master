import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/learn_page_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_list_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/gradient_container.dart';
import 'package:learn_and_quiz/features/settings/presentation/pages/settings_page.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const SettingsScreen(),
      //           ),
      //         );
      //       },
      //       icon: const Icon(Icons.settings),
      //     ),
      //   ],
      // ),
      body: GradientContainer(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/quiz-logo.png',
                width: 300,
                color: const Color.fromARGB(150, 255, 255, 255),
              ),
              const SizedBox(height: 80),
              const Text(
                'Learn Topics the fun way!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizListScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Color.fromARGB(150, 255, 255, 255),
                      size: 24,
                    ),
                    label: const Text('Play Quiz'),
                  ),
                  // const SizedBox(width: 20),
                  // OutlinedButton.icon(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const LearnPageScreen(),
                  //       ),
                  //     );
                  //   },
                  //   style: OutlinedButton.styleFrom(
                  //     foregroundColor: Colors.white,
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 20,
                  //       vertical: 10,
                  //     ),
                  //   ),
                  //   icon: const Icon(Icons.book),
                  //   label: const Text('Learn'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
