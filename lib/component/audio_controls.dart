import 'package:flutter/material.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.horizontal,
        children: [
          IconButton(
            icon: Icon(Icons.shuffle_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.skip_previous_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.play_arrow_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.skip_next_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.repeat_rounded),
            onPressed: () {},
          ),
        ]
    );
  }
}