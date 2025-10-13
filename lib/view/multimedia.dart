
import 'package:flutter/material.dart';
import 'package:offstream/controller/playback.dart';
import 'package:offstream/component/rounded.dart';
import 'package:offstream/util/color.dart';
import 'package:offstream/util/time.dart';
import 'package:offstream/util/util.dart';

class Multimedia extends StatefulWidget {
  const Multimedia({super.key});

  @override
  State<Multimedia> createState() => _MultimediaState();
}

class _MultimediaState extends State<Multimedia> {
  final PlaybackController _controller = PlaybackController();

  @override
  void initState() {
    super.initState();
    _controller.onPlaybackStateChanged.listen((event) {
      updateState();
    });
    _controller.onShuffleChanged.listen((event) {
      updateState();
    });
    _controller.onRepeatChanged.listen((event) {
      updateState();
    });
    _controller.onPositionChanged.listen((event) {
      updateState();
    });
    _controller.onCurrentSongChanged.listen((event) {
      updateState();
    });
    _controller.onVolumeChanged.listen((event) {
      updateState();
    });

    updateState();
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 100,
      color: Colors.grey[900],
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _controller.currentSong == null ? Container(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  leading: Rounded(child: Image.network(getMissingAlbumArtPath())),
                )) : Container(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  leading: Rounded(child: Image.network(_controller.currentSong!.albumArtPath)),
                  title: Text(_controller.currentSong!.title),
                  subtitle: Text(_controller.currentSong!.artist),
                ),
              ),
            ),
            SizedBox(width: 500, child: Column(
                children: [
                  Flex(
                      mainAxisAlignment: MainAxisAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shuffle_rounded),
                          color: _controller.isShuffling ? getToggledColor() : null,
                          onPressed: () {
                            if (_controller.currentSong == null) return;
                            _controller.shuffle();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_previous_rounded),
                          onPressed: () {
                            if (_controller.currentSong == null) return;
                            _controller.previous();
                          },
                        ),
                        IconButton(
                          icon: _controller.state == PlaybackState.playing ? Icon(Icons.pause_rounded) : Icon(Icons.play_arrow_rounded),
                          onPressed: () {
                            if (_controller.currentSong == null) return;
                            _controller.play();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next_rounded),
                          onPressed: () {
                            if (_controller.currentSong == null) return;
                            _controller.next();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.repeat_rounded),
                          color: _controller.isRepeating ? getToggledColor() : null,
                          onPressed: () {
                            if (_controller.currentSong == null) return;
                            _controller.repeat();
                          },
                        ),
                      ]
                  ),
                  Expanded(child: Flex(
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.horizontal,
                    spacing: 10,
                    children: [
                      Text(formatDuration(_controller.position)),
                      Expanded(child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: SliderComponentShape.noThumb,
                            overlayShape: SliderComponentShape.noThumb,
                          ),
                          child: Slider(
                            value: _controller.currentSong == null ? 0 : _controller.position.inSeconds/_controller.currentSong!.duration.inSeconds,
                            onChanged: (value) {
                              if (_controller.currentSong == null) return;
                              _controller.seek(multiplyDuration(_controller.currentSong!.duration, value));
                            },
                          )
                      )
                      ),
                      Text(formatDuration(_controller.currentSong == null ? Duration.zero : _controller.currentSong!.duration)),
                    ],
                  )),
                ]
            )),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    IconButton(
                      icon: Icon(_controller.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded),
                      onPressed: () {
                        setState(() {
                          _controller.mute();
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
                              value: _controller.isMuted ? 0 : _controller.currentVolume,
                              max: 1,
                              onChanged: (value) {
                                setState(() {
                                  _controller.volume(value);
                                });
                              },
                            )
                        )
                    ),
                  ],
                ),
              ),
            ),
          ]
      )
    );
  }
}