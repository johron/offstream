import 'package:flutter/material.dart';
import 'package:offstream/util/util.dart';

import '../controller/auth.dart';
import 'dialog/user_pin_dialog.dart';

class Pin extends StatelessWidget {
  static bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = AuthController().loggedInUser?.isAuthenticated;
    if (!_dialogShown && isAuthenticated == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        carefulShowDialog(context: context, builder: (context) => UserPinDialog());
      });
      _dialogShown = true;
    }
    return const SizedBox.shrink();
  }
}