import 'package:flutter/material.dart';
import 'package:offstream/type/song_data.dart';
import 'package:offstream/util/time.dart';

import '../rounded.dart';

class Song extends StatelessWidget {
  final SongData data;
  final int index;

  const Song({required this.data, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    //return ListTile(
    //  leading: Rounded(child: Image.network(data.albumArtPath ?? "https://community.spotify.com/t5/image/serverpage/image-id/55829iC2AD64ADB887E2A5/image-size/large?v=v2&px=999")),
    //  title: Text(data.title),
    //  subtitle: Text(data.artist),
    //);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Text('${index + 1}', style: TextStyle(color: Colors.white70)),
          SizedBox(width: 20),
          Rounded(
            radius: 5,
            child: Image.network(
              data.albumArtPath ??
                  "https://community.spotify.com/t5/image/serverpage/image-id/55829iC2AD64ADB887E2A5/image-size/large?v=v2&px=999",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title,
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(data.artist, style: TextStyle(color: Colors.white70)),
            ],
          ),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                data.album,
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                  formatDuration(data.duration),
                  style: TextStyle(color: Colors.white70)
              ),
            ],
          ))
        ],
      ),
    );
  }
}