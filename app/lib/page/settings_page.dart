import 'package:flutter/material.dart';
import 'package:offstream/component/settings/settings_button.dart';
import 'package:offstream/component/settings/settings_dropdown.dart';
import 'package:offstream/component/settings/settings_signup.dart';
import 'package:offstream/component/settings/settings_toggle.dart';
import 'package:offstream/controller/auth.dart';
import 'package:offstream/controller/storage.dart';

import '../component/settings/settings_label.dart';
import '../component/settings/settings_text.dart';
import '../type/stream_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    AuthController().onAuthenticatedStream.listen((event) {
      updateState();
    });

    super.initState();
  }

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

        Text("Authentication", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        AuthController().loggedInUser == null
          ? FutureBuilder<StreamData?>(
              future: StorageController().loadStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading users...");
                } else if (snapshot.hasError) {
                  return Text("Error loading users");
                } else {
                  if (!snapshot.hasData || snapshot.data!.users.isEmpty) {
                    // return empty widget
                    return Text("No users available. Please sign up.");
                  }

                  final users = snapshot.data?.users;
                  return SettingsDropdown(
                    values: users?.map((e) => e.username).toList() ?? [],
                    selectedValue: users?.first.username,
                    description: "Login",
                    onChanged: (username) {
                      AuthController().login(username!).then((success) {
                        final snackBar = SnackBar(
                          content: Text(success ? "Login successful" : "Login failed"),
                        );
                        updateState();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                      updateState();
                    },
                  );
                }
              },
            )
          : SettingsButton(
              buttonText: "Logout",
              description: "Logged in as '${AuthController().loggedInUser!.user.username}'",
              onPressed: () {
                var success = AuthController().logout();
                updateState();
                final snackBar = SnackBar(
                  content: Text(success ? "Logged out" : "Logout failed"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),

        AuthController().loggedInUser != null && !AuthController().loggedInUser!.isAuthenticated
          ? SettingsText(
              value: "",
              description: "Enter PIN",
              onChanged: (pin) {
                var success = AuthController().verifyPin(pin);
                final snackBar = SnackBar(
                  content: Text(success ? "PIN correct, logged in" : "Incorrect PIN"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                updateState();
              },
            )
          : Container(),

        SettingsSignup(
          description: "Create User",
          onSignup: (username, pin) {
            var success = AuthController().signup(username, pin);
            final snackBar = SnackBar(
              content: Text(success ? "Signup successful" : "Signup failed"),
            );
            updateState();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),

        SizedBox(height: 20),

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
          future: StorageController().loadStream(),
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
      ],
    );
  }
}