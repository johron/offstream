import 'package:flutter/material.dart';
import 'package:peik/controller/storage_controller.dart';
import 'package:peik/controller/user_controller.dart';
import 'package:peik/type/song_data.dart';
import 'package:peik/util/util.dart';

import '../../controller/auth_controller.dart';
import '../file_picker_field.dart';
import '../snackbar.dart';

class SongImportDialog extends StatefulWidget {
  String title = "Song";
  String artist = "Artist";
  String album = "Album";

  String importMethod = "From File";
  String path = "";

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
        width: 400,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(widget.title == "" ? "Song" : widget.title, overflow: TextOverflow.ellipsis),
                    subtitle: Text("${widget.artist == "" ? "Artist" : widget.artist} - ${widget.album == "" ? "Album" : widget.album}", overflow: TextOverflow.ellipsis),
                    leading: Image.network(getMissingAlbumArtPath()),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 120),
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(5),
                    isExpanded: false,
                    value: widget.importMethod,
                    items: <String>['From File', 'From URL', 'From YouTube'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          widget.importMethod = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            widget.importMethod == "From File"
              ? FilePickerField(
                  label: "Select Audio File",
                  filePath: widget.path,
                  onPickFile: (filePath) {
                    widget.path = filePath;
                  },
                )
              : TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: widget.importMethod == "From URL" ? 'Enter Audio URL' : 'Enter YouTube URL',
                  ),
                  onChanged: (value) {
                    widget.path = value;
                  },
                ),
            SizedBox(height: 12),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Artist',
                    ),
                    maxLength: 50,
                    onChanged: (value) {
                      widget.artist = value;
                      updateState();
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Album',
                    ),
                    maxLength: 50,
                    onChanged: (value) {
                      widget.album = value;
                      updateState();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (widget.title == "" || widget.artist == "" || widget.album == "" || widget.path == "") {
                  OSnackBar(message: "Please fill in all fields").show(context);
                  return;
                }
                print("Create song: ${widget.title}, ${widget.artist}, ${widget.album}");
                Navigator.of(context).pop();

                SongData songData = SongData(
                  uuid: generateSongUUID(widget.title, widget.artist, widget.album),
                  title: widget.title,
                  artist: widget.artist,
                  album: widget.album,
                  duration: Duration.zero, // TODO: Mp3 ripper to get duration
                  added: DateTime.now(),
                );

                StorageController().addSong(songData);
              },
              child: Text('OK'),
            ),
          ],
        ),
      )
    );
  }
}