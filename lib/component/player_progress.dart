import 'package:flutter/material.dart';
import 'package:offstream/util/time.dart';

class PlayerProgress extends StatefulWidget {
  const PlayerProgress({super.key});

  @override
  State<PlayerProgress> createState() => _PlayerProgressState();
}

class _PlayerProgressState extends State<PlayerProgress> {
  double _currentTime = 0;
  double _totalTime = 60;

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.horizontal,
      children: [
        Text(formatSeconds(_currentTime)),
        Expanded(child: Slider(
          value: _currentTime/_totalTime,
          onChanged: (value) {
            setState(() {
              _currentTime = (value * _totalTime);
            });
          },
        )),
        Text(formatSeconds(_totalTime)),
      ],
    );
  }
}