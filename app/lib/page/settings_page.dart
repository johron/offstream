import 'package:flutter/material.dart';
import 'package:peik/component/dialog/user_create_dialog.dart';
import 'package:peik/component/settings/settings_button.dart';
import 'package:peik/component/settings/settings_dropdown.dart';
import 'package:peik/component/settings/settings_toggle.dart';
import 'package:peik/controller/auth_controller.dart';
import 'package:peik/controller/storage_controller.dart';
import 'package:peik/util/util.dart';

import '../component/dialog/user_pin_dialog.dart';
import '../component/settings/settings_label.dart';
import '../component/settings/settings_text.dart';
import '../component/snackbar.dart';
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
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error loading users");
                } else {
                  if (!snapshot.hasData || snapshot.data!.users.isEmpty) {
                    return Text("No users available. Please sign up.");
                  }

                  final users = snapshot.data!.users;
                  return SettingsDropdown(
                    values: users.map((e) => e.username).toList(),
                    selectedValue: users.first.username,
                    description: "Login",
                    onChanged: (username) async {
                      final success = await AuthController().login(username!);
                      if (!mounted) return;

                      if (AuthController().loggedInUser != null && AuthController().loggedInUser!.isAuthenticated == false && mounted) {
                        await carefulShowDialog(context: context, builder: (context) => UserPinDialog());
                      }

                      if (!success) {
                        OSnackBar(message: "Login failed").show(context);
                      }
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
              if (!success) {
                OSnackBar(message: "Logout failed").show(context);
              }
            },
          ),

        SizedBox(height: 10),

        SettingsButton(
          buttonText: 'Create',
          description: 'Create User',
          onPressed: () {
            carefulShowDialog(context: context, builder: (context) {
              return UserCreateDialog();
            });
            updateState();
          },
        ),

        SizedBox(height: 20),

        Text("Manage remote stream", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

        SettingsToggle(toggled: false, description: "Enable Sync", onPressed: (value) {
          print("Toggle pressed to: $value");
        }),

        SettingsText(value: "Path", description: "Stream Remote URL", onChanged: (text) {
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