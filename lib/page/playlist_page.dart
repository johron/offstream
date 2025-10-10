import 'package:flutter/material.dart';
import 'package:offstream/component/playlist/song.dart';
import 'package:offstream/type/playlist_data.dart';

import '../component/rounded.dart';

// The API/util is going to return a playlist object which has all the data and ill just display it here, and give an example playlist object before i actually implement git fetching of it form internet and local

class PlaylistPage extends StatelessWidget {
  final PlaylistData playlist;

  const PlaylistPage({
    required this.playlist,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50, left: 50),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Rounded(radius: 10, child: Image.network(
                playlist.iconPath ?? 'https://community.spotify.com/t5/image/serverpage/image-id/55829iC2AD64ADB887E2A5/image-size/large?v=v2&px=999',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(playlist.title,
                      style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.bold)
                    ),
                    Text(
                      '${playlist.songs.length} ${playlist.songs.length == 1 ? 'song' : 'songs'}',
                      style: TextStyle(fontSize: 16, color: Colors.white70)),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 50),
        Expanded(child: ListView(
          shrinkWrap: true,
          children: _buildSongList(),
        )),
      ],
    );
  }

  List<StatelessWidget> _buildSongList() {
    List<StatelessWidget> songWidgets = [];
    for (var song in playlist.songs) {
      songWidgets.add(Song(data: song, index: playlist.songs.indexOf(song)));
    }
    return songWidgets;
  }
}

