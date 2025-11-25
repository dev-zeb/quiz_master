import 'package:flutter/material.dart';

class ScrollToButton extends StatelessWidget {
  final double bottomPosition;
  final bool isVisible;
  final IconData iconData;
  final VoidCallback onTap;
  final ScrollController scrollController;

  const ScrollToButton({
    super.key,
    required this.bottomPosition,
    required this.isVisible,
    required this.iconData,
    required this.onTap,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Visibility(
      visible: isVisible,
      child: Positioned(
        bottom: bottomPosition,
        left: 16,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.primary,
            ),
            child: Icon(
              iconData,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
