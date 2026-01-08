import 'package:flutter/material.dart';

import '../../../features/auth/domain/entities/app_user.dart';
import '../../../features/auth/presentation/screens/profile_screen.dart';
import '../../../features/auth/presentation/widgets/user_profile_chip.dart';
import 'app_bar_back_button.dart';

AppBar customAppBar({
  required BuildContext context,
  required String title,
  bool hasBackButton = false,
  bool hasSettingsButton = false,
  AppUser? user,
  List<Widget>? actionButtons,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
    ),
    titleSpacing: 0,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    leading: hasBackButton ? AppBarBackButton() : null,
    actions: [
      if (actionButtons != null) ...[
        ...actionButtons,
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: UserProfileChip(
              user: user,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ),
        const SizedBox(width: 8),
      ],
    ],
  );
}
