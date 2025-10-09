
import 'package:flutter/material.dart';
import 'package:offstream/component/audio_controls.dart';
import 'package:offstream/component/player_progress.dart';

import '../component/song.dart';

class Multimedia extends StatelessWidget {
  const Multimedia({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 112,
      color: Colors.grey[900],
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Song(title: "Holy Diver", artist: "Dio", albumArtUrl: "https://upload.wikimedia.org/wikipedia/en/0/08/DioHolyDiver.jpg"),
              ),
            ),
            SizedBox(width: 500, child: Column(
                children: [
                  AudioControls(),
                  Expanded(child: PlayerProgress()),
                ]
            )),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text("Right"),
              ),
            ),
          ]
      )
    );
  }
}