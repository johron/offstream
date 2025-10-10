import 'package:flutter/material.dart';
import 'package:offstream/api/playback.dart';
import 'package:offstream/component/index_and_play.dart';
import 'package:offstream/type/playlist_data.dart';
import 'package:offstream/util/color.dart';

import '../component/rounded.dart';
import '../type/song_data.dart';
import '../util/time.dart';
import '../util/util.dart';

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
                width: 175,
                height: 175,
                fit: BoxFit.cover,
              )),
              Expanded(  // Add this Expanded widget
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playlist.title,
                        style: TextStyle(fontSize: calculateTitleFontSize(playlist.title),
                            fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                      Text(
                          '${playlist.songs.length} ${playlist.songs.length == 1 ? 'song' : 'songs'}',
                          style: TextStyle(fontSize: 16, color: Colors.white70)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 25),
        Flex(
          direction: Axis.horizontal,
          spacing: 5,
          children: [
            SizedBox(width: 30),
            IconButton(
              icon: Icon(Icons.play_circle, size: 70, color: getToggledColor()),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shuffle, size: 30, color: Colors.white70),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.push_pin_rounded, size: 30, color: Colors.white70),
              onPressed: () {},
            ),
            //Expanded(child: Container()),
            SizedBox(width: 30)
          ],
        ),
        //SizedBox(height: 25),
        Expanded(child: ListView(
          shrinkWrap: true,
          children: [DataTable(
            columns: [
              DataColumn(label: Container(
                  width: 90,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 17),
                      Text('#'),
                      SizedBox(width: 25),
                      Text("Title"),
                    ],
                  ),
              )),
              DataColumn(label: Text('Album', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('Date Added', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Icon(Icons.access_time, color: Colors.white70, size: 20), columnWidth: FixedColumnWidth(0)),
            ],
            rows: _buildSongRows(),
          ),
          ]
        )),
      ],
    );
  }

  List<DataRow> _buildSongRows() {
    List<DataRow> rows = [];
    for (SongData data in playlist.songs) {
      rows.add(DataRow(cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 40,
                alignment: Alignment.center,
                child: IndexAndPlay(
                  index: playlist.songs.indexOf(data),
                  onPlay: () {
                    print('Requesting to play ${data.title}');
                  }
                )
              ),
              SizedBox(width: 10),
              Rounded(
                radius: 5,
                child: Image.network(
                  data.albumArtPath ??
                      "https://community.spotify.com/t5/image/serverpage/image-id/55829iC2AD64ADB887E2A5/image-size/large?v=v2&px=999",
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Text(data.title, style: TextStyle(color: Colors.white70)),
            ],
          )
        ),
        DataCell(Text(data.album, style: TextStyle(color: Colors.white70))),
        DataCell(Text(formatDateTime(data.addedAt), style: TextStyle(color: Colors.white70))),
        DataCell(Text(formatDuration(data.duration), style: TextStyle(color: Colors.white70))),
      ]));
    }

    return rows;
  }
}

