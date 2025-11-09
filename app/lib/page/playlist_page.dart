import 'package:flutter/material.dart';
import 'package:peik/component/rounded.dart';
import 'package:peik/controller/user_controller.dart';
import 'package:peik/util/util.dart';

import '../controller/storage_controller.dart';
import '../type/playlist_data.dart';
import '../util/color.dart';
import '../util/time.dart';

class PlaylistPage extends StatefulWidget {
  final String uuid;

  const PlaylistPage({
    required this.uuid,
    super.key
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final userController = UserController();
  final storageController = StorageController();

  void updateState() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          FutureBuilder<PlaylistData>(
            future: getPlaylist(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error loading playlist: ${snapshot.error}");
              } else {
                var playlist = snapshot.data!;
                return Row(
                  children: [
                    SizedBox(
                      width: 92,
                      height: 92,
                      child: Rounded(
                        radius: 8,
                        child: Image.network(getMissingAlbumArtPath()),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        playlist.description == null || playlist.description == "" ?
                        Text(
                          playlist.songs.length == 1 ? "${playlist.songs.length} song" : "${playlist.songs.length} songs",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                        : Text(
                          "${playlist.description!} · ${playlist.songs.length == 1 ? "${playlist.songs.length} song" : "${playlist.songs.length} songs"}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),

                      ]
                    ),
                    Expanded(child: Container()),
                    IconButton(
                      icon: Icon(Icons.push_pin_rounded, size: 30, color: Colors.white70),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.shuffle_rounded, size: 30, color: Colors.white70),
                      onPressed: () {},
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.play_circle_rounded, size: 64, color: getToggledColor())),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 12),
          Divider(),
          SizedBox(height: 12),
          Expanded(
            // sortable, scrollable, resizable list of songs in the playlist, like spotify's
            child:
          ),
        ],
      )
    );
  }

  Future<PlaylistData> getPlaylist() async {
    if (widget.uuid != "0") {
      var user = await userController.user;

      return user.playlists.firstWhere((playlist) => playlist.uuid == widget.uuid);
    } else {
      var stream = await storageController.loadStream();
      if (stream == null) {
        throw Exception("Stream is null");
      }

      var songs = stream.songs;

      return PlaylistData(
        uuid: widget.uuid,
        title: "All Songs",
        songs: songs,
        created: DateTime.now(),
        lastUpdate: DateTime.now(),
      );
    }
  }
}