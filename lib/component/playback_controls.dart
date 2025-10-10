import 'package:flutter/material.dart';
import 'package:offstream/api/playback.dart';
import 'package:offstream/util/color.dart';
import 'package:offstream/util/color.dart';

class PlaybackControls extends StatefulWidget {
  const PlaybackControls({super.key});

  @override
  State<PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  final PlaybackController _controller = PlaybackController();

  bool shuffle = false;
  bool playing = false;
  bool repeat = false;

  @override
  void initState() {
    super.initState();
    _controller.onPlaybackStateChanged.listen((state) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.horizontal,
        children: [
          IconButton(
            icon: Icon(Icons.shuffle_rounded),
            color: shuffle ? getToggledColor() : null,
            onPressed: () {
              setState(() {
                shuffle = !shuffle;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_previous_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: playing ? Icon(Icons.pause_rounded) : Icon(Icons.play_arrow_rounded),
            onPressed: () {
              print("tapped");
              _controller.togglePlayPause();
              setState(() {
                playing = !playing;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_next_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.repeat_rounded),
            color: repeat ? getToggledColor() : null,
            onPressed: () {
              setState(() {
                repeat = !repeat;
              });
            },
          ),
        ]
    );
  }
}