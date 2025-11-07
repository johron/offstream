import 'package:flutter/material.dart';

import '../../controller/auth.dart';

class UserCreateDialog extends StatefulWidget {
  String username = "";
  String? pin;

  UserCreateDialog({super.key});

  @override
  State<UserCreateDialog> createState() => _UserCreateDialogState();
}

class _UserCreateDialogState extends State<UserCreateDialog> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create User'),
      content: Container(
        height: 150,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
              onChanged: (value) {
                widget.username = value;
                updateState();
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'PIN (optional)',
              ),
              onChanged: (value) {
                widget.pin = value.isEmpty ? null : value;
                updateState();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.username.isEmpty) {
                  return;
                }
                var success = AuthController().signup(widget.username, widget.pin);
                final snackBar = SnackBar(
                  content: Text(success ? "Signup successful" : "Signup failed"),
                );
                updateState();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}