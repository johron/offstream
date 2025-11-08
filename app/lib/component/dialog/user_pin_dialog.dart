import 'package:flutter/material.dart';
import 'package:peik/component/snackbar.dart';

import '../../controller/auth_controller.dart';

class UserPinDialog extends StatefulWidget {
  late String pin;

  UserPinDialog({super.key});

  @override
  State<UserPinDialog> createState() => _UsePineDialogState();
}

class _UsePineDialogState extends State<UserPinDialog> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter PIN'),
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'PIN',
              ),
              maxLength: 50,
              onChanged: (value) {
                widget.pin = value;
                updateState();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.pin.isEmpty) {
                  return;
                }
                var success = AuthController().verifyPin(widget.pin);
                if (!success) {
                  AuthController().logout();
                  widget.pin = "";
                  Navigator.of(context).pop();
                  return;
                }
                OSnackBar(message: success ? "PIN correct, logged in" : "Incorrect PIN").show(context);
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