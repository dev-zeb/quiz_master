import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_bar_back_button.dart';

AppBar customAppBar({
  required BuildContext context,
  required WidgetRef? ref,
  required String title,
  bool hasBackButton = false,
  bool hasSettingsButton = false,
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
        const SizedBox(width: 8),
      ],
    ],
  );
}
