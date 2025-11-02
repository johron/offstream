import 'package:flutter/material.dart';
import 'package:offstream/component/settings/settings_dropdown.dart';
import 'package:offstream/component/settings/settings_toggle.dart';

import '../component/settings/settings_button.dart';
import '../component/settings/settings_text.dart';

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

        Text("Manage remote stream", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

        SettingsToggle(toggled: false, description: "Enable Sync", onPressed: (value) {
          print("Toggle pressed to: $value");
        }),

        SettingsText(value: "http://127.0.0.1:8080", description: "Stream Remote URL", onChanged: (text) {
          print("Text changed to: $text");
        }),
      ],
    );
  }
}