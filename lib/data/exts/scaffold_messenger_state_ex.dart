import 'package:flutter/material.dart';

extension ScaffoldMessengerStateEx on ScaffoldMessengerState {
  void show(String message, {Duration? duration}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(seconds: 4),
    );
    showSnackBar(snackBar);
  }

  void showIcon(String message, Icon icon, {Duration? duration}) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [icon, const SizedBox(width: 8), Text(message)],
      ),
      duration: duration ?? const Duration(seconds: 4),
    );
    showSnackBar(snackBar);
  }

  void showSuccess(String message, {Duration? duration}) => showIcon(
    message,
    Icon(Icons.check_circle, color: Colors.green),
    duration: duration,
  );

  void showError(String message, {Duration? duration}) => showIcon(
    message,
    Icon(Icons.error, color: Colors.red),
    duration: duration,
  );
}
