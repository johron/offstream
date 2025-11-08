import 'package:flutter/material.dart';

class OSnackBar {
  final String message;
  final int duration;

  const OSnackBar({
    required this.message,
    this.duration = 2,
  });

  void show(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    );
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}