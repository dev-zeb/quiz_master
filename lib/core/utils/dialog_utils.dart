import 'package:flutter/material.dart';
import 'package:quiz_master/core/ui/widgets/dialog_button_widget.dart';

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
        style: TextStyle(
          color: textColor,
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

void showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Color okButtonColor,
  required IconData okButtonIcon,
  required String okButtonText,
  required Future<void> Function() okButtonTap,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: colorScheme.primary,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: colorScheme.primary.withValues(alpha: 0.75),
          ),
        ),
        actionsPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.only(bottom: 8),
        clipBehavior: Clip.antiAlias,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: DialogButtonWidget(
                  buttonText: 'Cancel',
                  buttonIcon: Icons.cancel_outlined,
                  buttonColor: colorScheme.primary,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ),
              Expanded(
                child: DialogButtonWidget(
                  buttonText: okButtonText,
                  buttonIcon: okButtonIcon,
                  buttonColor: okButtonColor,
                  onPressed: () async {
                    await okButtonTap();
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
