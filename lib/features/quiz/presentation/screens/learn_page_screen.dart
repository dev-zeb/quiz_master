import 'package:flutter/material.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/gradient_container.dart';

class LearnPageScreen extends StatelessWidget {
  const LearnPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Flutter'),
        backgroundColor: const Color.fromARGB(255, 78, 13, 151),
        foregroundColor: Colors.white,
      ),
      body: GradientContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Learn Flutter Fundamentals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'Coming Soon: Comprehensive Flutter Learning Resources',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Icon(
                Icons.school,
                size: 100,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
