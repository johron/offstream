import 'package:flutter/material.dart';
import 'package:offstream/component/playlist.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      //height: MediaQuery.of(context).size.height,
      color: Colors.grey[900],
      child: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                //Expanded(child: Container()),
                ElevatedButton(
                  child: Icon(Icons.library_music),
                  onPressed: () {  },
                ),
                ElevatedButton(
                  child: Icon(Icons.settings),
                  onPressed: () {  },
                ),
                ElevatedButton(
                  child: Icon(Icons.playlist_add),
                  onPressed: () {  },
                ),
              ],
            )
          ),
          Divider(),
          Column(
            children: getPlaylists(),
          )
        ],
      ),
    );
  }
}

getPlaylists() {
  return [
    Playlist(title: "Playlist 1", icon: Icons.sunny_snowing, repo: "github.com/example/offstream"),
    Playlist(title: "Playlist 2", icon: Icons.sunny_snowing, repo: "gitlab.com/example/offstream"),
    Playlist(title: "Playlist 3", icon: Icons.sunny_snowing, repo: "git.example.com/offstream"),
  ];
}