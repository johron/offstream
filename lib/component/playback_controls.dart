import 'package:flutter/material.dart';
import 'package:offstream/util/color.dart';
import 'package:offstream/util/color.dart';

class PlaybackControls extends StatefulWidget {
  const PlaybackControls({super.key});

  @override
  State<PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  bool shuffle = false;
  bool playing = false;
  bool repeat = false;

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