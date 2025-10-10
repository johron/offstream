import 'dart:async';

import 'package:offstream/type/playlist_data.dart';
import 'package:offstream/type/song_data.dart';

import 'package:just_audio/just_audio.dart';


enum PlaybackState {
  playing,
  paused,
  stopped,
  loading,
  error,
}

class PlaybackController {
  static final PlaybackController _instance = PlaybackController._internal();
  factory PlaybackController() => _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Current state tracking
  PlaybackState _state = PlaybackState.stopped;
  SongData? _currentSong;
  PlaylistData? _currentPlaylist;
  int _currentIndex = -1;

  final _playbackStateController = StreamController<PlaybackState>.broadcast();
  final _currentSongController = StreamController<SongData?>.broadcast();
  final _currentPlaylistController = StreamController<PlaylistData?>.broadcast();

  Stream<PlaybackState> get onPlaybackStateChanged => _playbackStateController.stream;
  Stream<SongData?> get onCurrentSongChanged => _currentSongController.stream;
  Stream<PlaylistData?> get onCurrentPlaylistChanged => _currentPlaylistController.stream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  PlaybackState get state => _state;
  SongData? get currentSong => _currentSong;
  PlaylistData? get currentPlaylist => _currentPlaylist;
  int get currentIndex => _currentIndex;
  Duration get position => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;

  PlaybackController._internal() {
    _playbackStateController.add(_state);
  }

  Future<void> play() async {
    if (_currentSong != null) {
      await _audioPlayer.play();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _state = PlaybackState.stopped;
    _playbackStateController.add(_state);
  }

  Future<void> next() async {
    if (_currentPlaylist != null && _currentIndex < _currentPlaylist!.songs.length - 1) {
      _currentIndex++;
      await _loadAndPlaySong(_currentPlaylist!.songs[_currentIndex]);
    }
  }

  Future<void> previous() async {
    if (_currentPlaylist != null && _currentIndex > 0) {
      _currentIndex--;
      await _loadAndPlaySong(_currentPlaylist!.songs[_currentIndex]);
    }
  }

  // Play a specific song from a playlist
  Future<void> playFromPlaylist(PlaylistData playlist, int songIndex) async {
    if (songIndex >= 0 && songIndex < playlist.songs.length) {
      _setCurrentPlaylist(playlist);
      _currentIndex = songIndex;
      await _loadAndPlaySong(playlist.songs[songIndex]);
    }
  }

  // Play a single song (not from a playlist)
  Future<void> playSpecificSong(SongData song) async {
    _currentPlaylist = null;
    _currentIndex = -1;
    await _loadAndPlaySong(song);
  }

  // Seek to position
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  // Toggle between play and pause
  Future<void> togglePlayPause() async {
    print('Toggling play/pause from state: $_state');
    if (_state == PlaybackState.playing) {
      await pause();
    } else {
      await play();
    }
  }

  // Helper methods
  Future<void> _loadAndPlaySong(SongData song) async {
    try {
      _state = PlaybackState.loading;
      _playbackStateController.add(_state);

      _setCurrentSong(song);

      // Get audio source (implement this method based on where your audio is stored)
      final audioUrl = await _getSongUrl(song);

      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
      await _audioPlayer.play();
    } catch (e) {
      _state = PlaybackState.error;
      _playbackStateController.add(_state);
      print('Error playing song: $e');
    }
  }

  // This would be implemented based on how your songs are stored
  Future<String> _getSongUrl(SongData song) async {
    // TODO: Implement based on your storage mechanism
    // For example, it could be a local file or a network URL
    return 'https://example.com/audio/${song.title}.mp3';
  }

  void _setCurrentSong(SongData song) {
    _currentSong = song;
    _currentSongController.add(_currentSong);
  }

  void _setCurrentPlaylist(PlaylistData playlist) {
    _currentPlaylist = playlist;
    _currentPlaylistController.add(_currentPlaylist);
  }

  // Clean up resources
  void dispose() {
    _audioPlayer.dispose();
    _playbackStateController.close();
    _currentSongController.close();
    _currentPlaylistController.close();
  }
}