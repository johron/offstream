import 'package:flutter/material.dart';
import 'package:offstream/component/settings/settings_toggle.dart';
import 'package:offstream/controller/storage.dart';
import 'package:offstream/type/user_data.dart';

import '../component/settings/settings_label.dart';
import '../component/settings/settings_text.dart';
import '../type/stream_data.dart';

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

        SizedBox(height: 20),
        Text('Application', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FutureBuilder<StreamData?>(
          future: StorageController().load(),
          builder: (context, snapshot) {
            final version = snapshot.data?.version;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SettingsLabel(value: "Loading...", description: "Version");
            } else if (snapshot.hasError) {
              return SettingsLabel(value: "Error", description: "Version");
            } else {
              return SettingsLabel(value: version ?? "Unknown", description: "Version");
            }
          },
        ),
        // list out all users, with their usernames and uuid
        FutureBuilder<StreamData?>(
          future: StorageController().load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading users...");
            } else if (snapshot.hasError) {
              return Text("Error loading users");
            } else {
              final users = snapshot.data?.users;
              return Column(
                children: users != null && users.isNotEmpty
                    ? [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Index')),
                              DataColumn(label: Text('Username')),
                            ],
                            rows: users.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final user = entry.value;
                              return DataRow(cells: [
                                DataCell(Text((idx + 1).toString())),
                                DataCell(Text(user.username)),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ]
                    : [Text("No users found")],
              );
            }
          },
        ),
      ],
    );
  }
}