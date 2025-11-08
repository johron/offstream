import 'package:flutter/material.dart';
import 'package:offstream/controller/storage_controller.dart';
import 'package:offstream/controller/user_controller.dart';
import 'package:offstream/util/util.dart';

import '../../controller/auth_controller.dart';
import '../snackbar.dart';

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
      content: SizedBox(
        height: 260,
        width: 350,
        child: Column(
          children: [
            ListTile(
              title: Text(widget.name == "" ? "Playlist" : widget.name, overflow: TextOverflow.ellipsis),
              subtitle: Text(widget.description == "" ? "No description" : widget.description, overflow: TextOverflow.ellipsis,),
              leading: Image.network(getMissingAlbumArtPath()),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              maxLength: 50,
              onChanged: (value) {
                widget.name = value;
                updateState();
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              maxLength: 50,
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
                if (AuthController().loggedInUser == null) {
                  OSnackBar(message: "You must be logged in to create a playlist").show(context);
                  return;
                }
                UserController().createPlaylist(widget.name, widget.description).then((success) {
                  if (!success) {
                    OSnackBar(message: "Could not create playlist").show(context);
                  }
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