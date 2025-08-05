import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  Duration snackDuration = const Duration(milliseconds: 1000),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: snackDuration,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      showCloseIcon: true,
    ),
  );
}
