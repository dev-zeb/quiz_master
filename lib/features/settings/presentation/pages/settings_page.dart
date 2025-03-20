import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/theme/theme_provider.dart';
import 'package:learn_and_quiz/core/ui/widget/app_bar_back_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: AppBarBackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Spacer(),
              Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                activeColor: Colors.tealAccent,
                activeTrackColor: Colors.teal,
                inactiveThumbColor: colorScheme.primary,
                inactiveTrackColor: colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
