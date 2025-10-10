import 'package:flutter/material.dart';

class AudioControls extends StatefulWidget {
  const AudioControls({super.key});

  @override
  State<AudioControls> createState() => _AudioControlsState();
}

class _AudioControlsState extends State<AudioControls> {
  double volume = 1.0;
  bool muted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        IconButton(
          icon: Icon(muted ? Icons.volume_off_rounded : Icons.volume_up_rounded),
          onPressed: () {
            setState(() {
              muted = !muted;
            });
          },
        ),
        Container(
            width: 100,
            margin: EdgeInsets.only(right: 15),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: SliderComponentShape.noThumb,
                  overlayShape: SliderComponentShape.noThumb,
                ),
                child: Slider(
                  value: muted ? 0 : volume,
                  onChanged: (value) {
                    setState(() {
                      volume = value;
                    });
                  },
                )
            )
        ),
      ],
    );

    return ListTile(
      leading: IconButton(
        icon: Icon(muted ? Icons.volume_off_rounded : Icons.volume_up_rounded),
        onPressed: () {
          setState(() {
            muted = !muted;
          });
        },
      ),
      trailing: SizedBox(
        width: 100,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: SliderComponentShape.noThumb,
            overlayShape: SliderComponentShape.noThumb,
          ),
          child: Slider(
            value: muted ? 0 : volume,
            onChanged: (value) {
              setState(() {
                volume = value;
              });
            },
          )
        )
      )
    );
  }
}