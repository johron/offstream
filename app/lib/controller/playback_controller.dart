import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:peik/controller/storage_controller.dart';
import 'package:peik/type/playlist_data.dart';
import 'package:peik/type/song_data.dart';

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

  final AudioPlayer _player = AudioPlayer();

  PlaybackState _state = PlaybackState.stopped;
  bool _shuffle = false;
  bool _repeat = false;
  Duration _position = Duration.zero;
  SongData? _currentSong;
  double _volume = 0.7;
  bool _muted = false;

  PlaybackState get state => _state;
  bool get isShuffling => _shuffle;
  bool get isRepeating => _repeat;
  Duration get position => _position;
  SongData? get currentSong => _currentSong;
  double get currentVolume => _volume;
  bool get isMuted => _muted;

  final _playbackStateController = StreamController<PlaybackState>.broadcast();
  final _currentSongController = StreamController<SongData?>.broadcast();
  final _currentPlaylistController = StreamController<PlaylistData?>.broadcast();
  final _shuffleController = StreamController<bool>.broadcast();
  final _repeatController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _volumeController = StreamController<double>.broadcast();

  Stream<PlaybackState> get onPlaybackStateChanged => _playbackStateController.stream;
  Stream<SongData?> get onCurrentSongChanged => _currentSongController.stream;
  Stream<PlaylistData?> get onCurrentPlaylistChanged => _currentPlaylistController.stream;
  Stream<bool> get onShuffleChanged => _shuffleController.stream;
  Stream<bool> get onRepeatChanged => _repeatController.stream;
  Stream<Duration> get onPositionChanged => _positionController.stream;
  Stream<double> get onVolumeChanged => _volumeController.stream;

  void init() {
    _player.positionStream.listen((pos) {
      _position = pos;
      _positionController.add(_position);
    });
  }

  void play() {
    if (_state == PlaybackState.playing) {
      _state = PlaybackState.paused;
      _player.pause();
    } else {
      _state = PlaybackState.playing;
      _player.play();
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

    _player.seek(position);

    print("Seeking to position: $_position");
  }

  int duration() {
    return _player.duration?.inSeconds ?? 0;
  }

  Duration get durationDuration {
    return _player.duration ?? Duration.zero;
  }

  void song(SongData song) {
    StorageController().getSongFilePath(song.uuid).then((filePath) {
      _player.setFilePath(filePath);

      _currentSong = song;
      _currentSongController.add(_currentSong);

      _state = PlaybackState.playing;
      _playbackStateController.add(_state);

      seek(Duration.zero);

      _player.play();

      print("Changing current song to: ${song.title}");
    });
  }

  void volume(double vol) {
    _volume = vol;
    _volumeController.add(_volume);

    _player.setVolume(_volume);

    print("Setting volume to: $_volume");
  }

  void mute() {
    _muted = !_muted;
    if (_muted) {
      _player.setVolume(0.0);
    } else {
      _player.setVolume(_volume);
    }
    print("Toggling mute: $_muted");
  }

  void dispose() {
    _playbackStateController.close();
    _currentSongController.close();
    _currentPlaylistController.close();
    _shuffleController.close();
    _repeatController.close();
    _positionController.close();
  }
}