import 'package:flutter/material.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = "OK",
  String cancelText = "Cancel",
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onCancel != null) onCancel();
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
