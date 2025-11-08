import 'package:flutter/material.dart';
import 'package:offstream/controller/storage_controller.dart';
import 'package:offstream/controller/user_controller.dart';
import 'package:offstream/util/util.dart';

import '../../controller/auth_controller.dart';
import '../snackbar.dart';

class SongImportDialog extends StatefulWidget {
  String title = "Song";
  String artist = "Artist";
  String album = "Album";

  SongImportDialog({super.key});

  @override
  State<SongImportDialog> createState() => _SongImportDialogState();
}

class _SongImportDialogState extends State<SongImportDialog> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Import Song'),
      content: SizedBox(
        height: 320,
        width: 350,
        child: Column(
          children: [
            ListTile(
              title: Text(widget.title == "" ? "Song" : widget.title, overflow: TextOverflow.ellipsis),
              subtitle: Text("${widget.artist == "" ? "Artist" : widget.artist} - ${widget.album == "" ? "Album" : widget.album}", overflow: TextOverflow.ellipsis),
              leading: Image.network(getMissingAlbumArtPath()),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              maxLength: 50,
              onChanged: (value) {
                widget.title = value;
                updateState();
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Artist',
              ),
              maxLength: 50,
              onChanged: (value) {
                widget.artist = value;
                updateState();
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Album',
              ),
              maxLength: 50,
              onChanged: (value) {
                widget.album = value;
                updateState();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Create song: ${widget.title}, ${widget.artist}, ${widget.album}");
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      )
    );
  }
}