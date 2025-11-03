import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsLabel extends StatefulWidget {
  final String value;
  final String description;

  SettingsLabel({
    required this.value,
    required this.description,
    super.key
  });

  @override
  State<SettingsLabel> createState() => _SettingsLabelState();
}

class _SettingsLabelState extends State<SettingsLabel> {
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
          Text(widget.value, style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      )
    );
  }
}