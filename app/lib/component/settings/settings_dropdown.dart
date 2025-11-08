import 'package:flutter/material.dart';

class SettingsDropdown extends StatefulWidget {
  String? selectedValue;
  final List<String> values;
  final String description;
  final Function (String?)? onChanged;

  SettingsDropdown({
    required this.values,
    required this.selectedValue,
    required this.description,
    required this.onChanged,
    super.key
  });

  @override
  State<SettingsDropdown> createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {
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
          DropdownButton<String>(
            value: widget.selectedValue,
            items: widget.values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (String? newValue) {
              widget.selectedValue = newValue;
              updateState();
              widget.onChanged?.call(newValue);
            },
          ),
        ],
      )
    );
  }
}