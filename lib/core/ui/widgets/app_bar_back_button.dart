import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: colorScheme.primary,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          splashColor: colorScheme.secondary,
          child: Icon(
            Icons.arrow_back_sharp,
            color: colorScheme.secondaryContainer,
            size: 20,
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
