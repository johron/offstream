import 'dart:async';

import 'package:offstream/type/playlist_data.dart';
import 'package:offstream/type/song_data.dart';

enum PlaybackState {
  playing,
  paused,
  stopped,
  loading,
  error,
}

class PlaybackController {
  PlaybackController._internal();

  static final PlaybackController _instance = PlaybackController._internal();

  factory PlaybackController() => _instance;

  PlaybackState _state = PlaybackState.stopped;
  bool _shuffle = false;
  bool _repeat = false;
  Duration _position = Duration.zero;
  SongData? _currentSong;

  PlaybackState get state => _state;
  bool get isShuffling => _shuffle;
  bool get isRepeating => _repeat;
  Duration get position => _position;
  SongData? get currentSong => _currentSong;

  final _playbackStateController = StreamController<PlaybackState>.broadcast();
  final _currentSongController = StreamController<SongData?>.broadcast();
  final _currentPlaylistController = StreamController<PlaylistData?>.broadcast();
  final _shuffleController = StreamController<bool>.broadcast();
  final _repeatController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();

  Stream<PlaybackState> get onPlaybackStateChanged => _playbackStateController.stream;
  Stream<SongData?> get onCurrentSongChanged => _currentSongController.stream;
  Stream<PlaylistData?> get onCurrentPlaylistChanged => _currentPlaylistController.stream;
  Stream<bool> get onShuffleChanged => _shuffleController.stream;
  Stream<bool> get onRepeatChanged => _repeatController.stream;
  Stream<Duration> get onPositionChanged => _positionController.stream;

  void play() {
    if (_state == PlaybackState.playing) {
      _state = PlaybackState.paused;
    } else {
      _state = PlaybackState.playing;
    }
    _playbackStateController.add(_state);
    print("Toggling playback: $_state");
  }

  void shuffle() {
    _shuffle = !_shuffle;
    _shuffleController.add(_shuffle);
    print("Toggling shuffle: $_shuffle");
  }

  void repeat() {
    _repeat = !_repeat;
    _repeatController.add(_repeat);
    print("Toggling repeat: $_repeat");
  }

  void next() {
    print("Skipping to next track");
  }

  void previous() {
    print("Skipping to previous track");
  }

  void seek(Duration position) {
    _position = position;
    _positionController.add(_position);
    print("Seeking to position: $_position");
  }

  void song(SongData song) {
    _currentSong = song;
    _currentSongController.add(_currentSong);

    _state = PlaybackState.playing;
    _playbackStateController.add(_state);

    seek(Duration.zero);

    print("Changing current song to: ${song.title}");
  }
}