import 'package:flutter/material.dart';
import 'package:offstream/controller/playback_controller.dart';
import 'package:offstream/component/index_and_play.dart';
import 'package:offstream/controller/user_controller.dart';
import 'package:offstream/type/playlist_data.dart';
import 'package:offstream/util/color.dart';

import '../component/rounded.dart';
import '../type/song_data.dart';
import '../util/time.dart';
import '../util/util.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistData playlist;

  PlaylistPage({
    required this.playlist,
    super.key
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final PlaybackController _controller = PlaybackController();

  @override
  void initState() {
    super.initState();
  }

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
              /*playlist.songs.first.albumArtPath ??*/ getMissingAlbumArtPath(),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )),
              Expanded(  // Add this Expanded widget
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.playlist.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 56,
                            fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                      Text(
                          '${widget.playlist.songs.length} ${widget.playlist.songs.length == 1 ? 'song' : 'songs'}',
                          style: TextStyle(fontSize: 16, color: Colors.white70)),
                      // calculate total duration
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
              icon: Icon(Icons.play_circle_rounded, size: 70, color: getToggledColor()),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shuffle_rounded, size: 30, color: Colors.white70),
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
    for (SongData data in widget.playlist.songs) {
      rows.add(DataRow(cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 40,
                alignment: Alignment.center,
                child: IndexAndPlay(
                  index: widget.playlist.songs.indexOf(data),
                  onPlay: () {
                    _controller.song(data);
                  }
                )
              ),
              SizedBox(width: 10),
              Rounded(
                radius: 5,
                child: Image.network(
                  getMissingAlbumArtPath(),
                  //data.albumArtPath,
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.title, style: TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
                  Text(data.artist, style: TextStyle(color: Colors.white54, fontSize: 12), overflow: TextOverflow.ellipsis),
                ],
              )
            ],
          )
        ),
        DataCell(Text(data.album, style: TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis)),
        DataCell(Text(formatDateTime(data.added), style: TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis)),
        DataCell(Text(formatDuration(data.duration), style: TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis)),
      ]));
    }

    return rows;
  }
}

