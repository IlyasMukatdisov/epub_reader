
import 'package:flutter/material.dart';

class Utils {
  static void showMessage({
    required BuildContext context,
    required String message,
  }) {
    showMessageWithAction(context: context, message: message);
  }

  static Future<void> showMyDialog({
    required BuildContext context,
    required String title,
    required String text,
    required String positiveText,
    required String negativeText,
    required VoidCallback onPositivePressed,
    required VoidCallback onNegativePressed,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: onNegativePressed,
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onPositivePressed,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showMessageWithAction({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        action: actionLabel != null
            ? SnackBarAction(label: actionLabel, onPressed: onPressed!)
            : null,
        content: Text(message),
      ),
    );
  }
}
