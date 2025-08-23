import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/theme/theme_provider.dart';
import 'package:learn_and_quiz/core/ui/widgets/custom_app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppBar(
        context: context,
        ref: ref,
        title: 'Settings',
        hasBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surfaceContainer,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Switch(
                  value: ref.watch(themeProvider.notifier).isDark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme(value);
                  },
                  activeColor: colorScheme.primary,
                  activeTrackColor:
                      colorScheme.primary.withValues(alpha: 0.5),
                  inactiveThumbColor: colorScheme.primary,
                  inactiveTrackColor: colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
