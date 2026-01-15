import 'package:flutter/material.dart';
import 'package:quiz_master/core/ui/widgets/clickable_text_widget.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  Color? textColor,
  Color? backgroundColor,
  Duration snackDuration = const Duration(milliseconds: 1500),
}) {
  final colorScheme = Theme.of(context).colorScheme;

  textColor ??= colorScheme.onSecondary;
  backgroundColor ??= colorScheme.secondary;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      closeIconColor: textColor,
      content: Text(
        message,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      duration: snackDuration,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      showCloseIcon: true,
    ),
  );
}

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Future<void> Function() okButtonTap,
  String okButtonText = 'Yes',
  String cancelButtonText = 'No',
}) async {
  final colorScheme = Theme.of(context).colorScheme;

  final res = await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(fontSize: 20, color: colorScheme.primary),
        ),
        content: Text(
          content,
          style: TextStyle(fontSize: 16, color: colorScheme.primary),
        ),
        actionsPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.only(bottom: 8),
        clipBehavior: Clip.antiAlias,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 8.0),
            child: ClickableTextWidget(
              fontSize: 16,
              text: cancelButtonText,
              buttonColor: colorScheme.error,
              textColor: colorScheme.onError,
              onTap: () => Navigator.of(dialogContext).pop(false),
            ),
          ),
          SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
            child: ClickableTextWidget(
              fontSize: 16,
              text: okButtonText,
              buttonColor: colorScheme.primary,
              textColor: colorScheme.onPrimary,
              onTap: () {
                okButtonTap();
                if (dialogContext.mounted) {
                  return Navigator.of(dialogContext).pop(true);
                }
              },
            ),
          ),
        ],
      );
    },
  );

  return res ?? false;
}
