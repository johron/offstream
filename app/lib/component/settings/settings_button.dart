import 'package:flutter/material.dart';

class SettingsButton extends StatefulWidget {
  final String description;
  final String buttonText;
  final Function ()? onPressed;

  const SettingsButton({
    required this.buttonText,
    required this.description,
    required this.onPressed,
    super.key
  });

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 150),
      child: Row(
        children: [
          Text(widget.description, style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
          Expanded(child: Container()),
          ElevatedButton(onPressed: () {
            updateState();
            widget.onPressed?.call();
          }, child: Text(widget.buttonText, overflow: TextOverflow.ellipsis))
        ],
      )
    );
  }
}