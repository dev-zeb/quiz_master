import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/theme/bloc/theme_bloc.dart';
import '../../config/theme/bloc/theme_event.dart';
import '../../config/theme/bloc/theme_state.dart';
import '../widgets/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: 'Settings',
        hasBackButton: true,
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.surfaceContainer,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: themeState.isDark,
                      onChanged: (value) {
                        context.read<ThemeBloc>().add(ThemeToggled(value));
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
          );
        },
      ),
    );
  }
}
