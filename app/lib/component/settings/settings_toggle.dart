import 'package:flutter/material.dart';

class SettingsToggle extends StatefulWidget {
  bool toggled;
  final String description;
  final Function (bool)? onPressed;

  SettingsToggle({
    required this.toggled,
    required this.description,
    required this.onPressed,
    super.key
  });

  @override
  State<SettingsToggle> createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<SettingsToggle> {
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
            Switch(
              value: widget.toggled,
              onChanged: (bool value) {
                widget.toggled = value;
                updateState();
                widget.onPressed?.call(value);
              },
            ),
          ],
        )
    );
  }
}