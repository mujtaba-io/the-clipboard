import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, bool canDismiss) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF0E0D14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      action: canDismiss
          ? SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            )
          : null,
    ),
  );
}
