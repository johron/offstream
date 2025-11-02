import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsText extends StatefulWidget {
  String value;
  final String description;
  final Function (String)? onChanged;

  SettingsText({
    required this.value,
    required this.description,
    required this.onChanged,
    super.key
  });

  @override
  State<SettingsText> createState() => _SettingsTextState();
}

class _SettingsTextState extends State<SettingsText> {
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
              controller: TextEditingController(text: widget.value),
              onChanged: (text) {
                widget.value = text;
              },
              onEditingComplete: () {
                updateState();
                widget.onChanged?.call(widget.value);
              },
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
                updateState();
                widget.onChanged?.call(widget.value);
              },
            ),
          )
        ],
      )
    );
  }
}