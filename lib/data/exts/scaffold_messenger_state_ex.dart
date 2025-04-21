import 'package:flutter/material.dart';

extension ScaffoldMessengerStateEx on ScaffoldMessengerState {
  void show(String message, {Duration? duration}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(seconds: 2),
    );
    showSnackBar(snackBar);
  }
}
