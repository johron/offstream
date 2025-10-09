import 'package:flutter/material.dart';
import 'package:offstream/util/time.dart';

class PlaybackProgress extends StatefulWidget {
  const PlaybackProgress({super.key});

  @override
  State<PlaybackProgress> createState() => _PlaybackProgressState();
}

class _PlaybackProgressState extends State<PlaybackProgress> {
  double _currentTime = 0;
  double _totalTime = 60;

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.horizontal,
      spacing: 10,
      children: [
        Text(formatSeconds(_currentTime)),
        Expanded(child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: SliderComponentShape.noThumb,
            overlayShape: SliderComponentShape.noThumb,
          ),
          child :
            Slider(
              value: _currentTime/_totalTime,
              onChanged: (value) {
                setState(() {
                  _currentTime = (value * _totalTime);
                });
              },
            )
          )
        ),
        Text(formatSeconds(_totalTime)),
      ],
    );
  }
}