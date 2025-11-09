import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerField extends StatefulWidget {
  final String label;
  final Function(String) onPickFile;
  String filePath;

  FilePickerField({
    required this.label,
    required this.onPickFile,
    this.filePath = "",
    super.key
  });

  @override
  State<FilePickerField> createState() => _FilePickerFieldState();
}

class _FilePickerFieldState extends State<FilePickerField> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: widget.filePath),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Audio File',
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.folder_open_rounded),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  dialogTitle: "Select Audio File",
                  type: FileType.audio,
                );

                if (result == null) {
                  print("No file selected");
                  return;
                }
                File file = File(result.files.single.path!);
                widget.filePath = file.path;
                updateState();
                widget.onPickFile(file.path);
              },
            ),
          ],
        ),
      ],
    );
  }
}