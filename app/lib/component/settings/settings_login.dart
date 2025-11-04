import 'package:flutter/material.dart';

class SettingsLogin extends StatefulWidget {
  String value = "";
  String? selectedValue;
  final List<String> values;
  final String description;
  final Function (String, String)? onLogin;

  SettingsLogin({
    required this.values,
    required this.selectedValue,
    required this.description,
    required this.onLogin,
    super.key
  });

  @override
  State<SettingsLogin> createState() => _SettingsLoginState();
}

class _SettingsLoginState extends State<SettingsLogin> {
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
          DropdownButton<String>(
            value: widget.selectedValue,
            items: widget.values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              widget.selectedValue = newValue;
              updateState();
            },
          ),
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              obscureText: true,
              onChanged: (text) {
                widget.value = text;
              },
              onSubmitted: (text) {
                if (widget.selectedValue == null) return;

                widget.onLogin?.call(widget.selectedValue!, widget.value);
              },
            ),
          ),
          ElevatedButton(child: Text("OK"), onPressed: () {
            if (widget.selectedValue == null) return;

            widget.onLogin?.call(widget.selectedValue!, widget.value);
          })
        ],
      )
    );
  }
}