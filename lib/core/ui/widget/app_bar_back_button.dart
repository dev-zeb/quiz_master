import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorScheme.primary,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        child: Icon(
          Icons.arrow_back_sharp,
          color: colorScheme.onPrimary,
        ),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
