import 'package:flutter/material.dart';
import 'package:offstream/component/settings/settings_toggle.dart';

import '../component/settings/settings_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
        ),
        Text('Settings', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        SizedBox(height: 50),

        Text('Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SettingsButton(buttonText: "Button", description: "Button description", onPressed: () {
          print("Button pressed");
        }),

        SettingsToggle(toggled: false, description: "Toggle description", onPressed: () {
          print("Toggle pressed");
        }),
      ],
    );
  }
}