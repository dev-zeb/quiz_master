import 'package:flutter/material.dart';
import 'package:learn_and_quiz/core/config/colors.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/gradient_container.dart';

class LearnPageScreen extends StatelessWidget {
  const LearnPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      'Mathematics',
      'Science',
      'History',
      'Geography',
      'Literature',
      'Art',
      'Music',
      'Sports',
      'Technology',
      'Business',
      'Politics',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn'),
      ),
      body: GradientContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Learning Section',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Choose a topic to start learning',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: topics
                      .length, // topics is not defined in the original code, you might need to define it
                  itemBuilder: (context, index) {
                    return Card(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.whiteWithOpacity(0.2)
                          : AppColors.blackWithOpacity(0.2),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        title: Text(
                          topics[
                              index], // topics is not defined in the original code, you might need to define it
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onTap: () {
                          // Handle topic selection
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
