import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title, message;
  const ErrorDialog({super.key, required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close", key: key),
        ),
      ],
    );
  }
}
