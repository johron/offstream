import 'package:flutter/material.dart';
import 'package:offstream/component/playlist.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      color: Color(0x0AFFFFFF),
      padding: const EdgeInsets.only(left: 5, top: 10, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.search, color: Colors.white),
            title: Text('Search', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          Divider(color: Colors.grey[700]),
          Expanded(
            child: ListView(
              children: getPlaylists(),
            ),
          ),
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