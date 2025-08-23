import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
      child: Material(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(
              Icons.arrow_back_ios,
              color: colorScheme.onPrimary,
              size: 20,
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
