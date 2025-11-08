import 'package:flutter/material.dart';
import 'package:offstream/component/snackbar.dart';

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
      content: SizedBox(
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
                OSnackBar(message: success ? "Signup successful" : "Signup failed").show(context);
                updateState();
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