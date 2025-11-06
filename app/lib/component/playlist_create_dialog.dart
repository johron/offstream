import 'package:flutter/material.dart';
import 'package:offstream/util/util.dart';

class PlaylistCreateDialog extends StatefulWidget {
  String name = "Playlist";
  String description = "";

  PlaylistCreateDialog({super.key});

  @override
  State<PlaylistCreateDialog> createState() => _PlaylistCreateDialogState();
}

class _PlaylistCreateDialogState extends State<PlaylistCreateDialog> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Playlist'),
      content: Container(
        height: 225,
        child: Column(
          children: [
            ListTile(
              title: Text(widget.name == "" ? "Playlist" : widget.name),
              subtitle: Text(widget.description == "" ? "No description" : widget.description),
              leading: Image.network(getMissingAlbumArtPath()),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              onChanged: (value) {
                widget.name = value;
                updateState();
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                widget.description = value;
                updateState();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Create playlist: ${widget.name}, description: ${widget.description}");

              },
              child: Text('OK'),
            ),
          ],
        ),
      )
    );
  }
}