import 'package:flutter/material.dart';

class SplashedButton extends StatelessWidget {
  final Widget childWidget;
  final VoidCallback onTap;
  final ShapeBorder? shape;

  const SplashedButton({
    super.key,
    required this.childWidget,
    required this.onTap,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicWidth(
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
        color: colorScheme.primary,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          splashColor: colorScheme.secondary,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10,
            ),
            child: childWidget,
          ),
        ),
      ),
    );
  }
}
