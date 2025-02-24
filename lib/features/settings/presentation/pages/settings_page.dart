import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Text('Dark Mode'),
              Spacer(),
              Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  ref
                      .read(themeNotifierProvider.notifier)
                      .updateThemeMode(mode: value);
                },
                activeColor: Colors.green,
                activeTrackColor: Colors.greenAccent,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
