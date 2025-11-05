import 'package:flutter/material.dart';

class SettingsSignup extends StatefulWidget {
  String username = "";
  String? pin;
  final String description;
  final Function (String, String?) onSignup;

  SettingsSignup({
    required this.description,
    required this.onSignup,
    super.key
  });

  @override
  State<SettingsSignup> createState() => _SettingsSignupState();
}

class _SettingsSignupState extends State<SettingsSignup> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 150),
        child: Row(
          children: [
            Text(widget.description, style: TextStyle(fontSize: 16)),
            Expanded(child: Container()),
            Expanded(
              child: TextField(
                onChanged: (text) {
                  widget.username = text;
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                obscureText: true,
                onChanged: (text) {
                  if (text.isEmpty) {
                    widget.pin = null;
                    return;
                  }
                  widget.pin = text;
                },
              ),
            ),
            ElevatedButton(child: Text("OK"), onPressed: () {
              if (widget.username.isEmpty) {
                return;
              }

              widget.onSignup.call(widget.username, widget.pin);
            })
          ],
        )
    );
  }
}