import 'package:flutter/material.dart';
import 'package:offstream/controller/storage.dart';
import 'package:offstream/controller/user_controller.dart';
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
                Navigator.of(context).pop();
                UserController().createPlaylist(widget.name, widget.description).then((success) {
                  final snackBar = SnackBar(
                    content: Text(success ? "Created playlist" : "Could not create playlist"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: Text('OK'),
            ),
          ],
        ),
      )
    );
  }
}