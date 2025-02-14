import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/colors.dart';
import 'package:learn_and_quiz/core/config/theme_provider.dart';

class GradientContainer extends ConsumerWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientContainer({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: themeMode == ThemeMode.light
              ? AppColors.backgroundGradient
              : AppColors.darkBackgroundGradient,
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}
