import 'dart:math' as math;

import 'package:offstream/type/playlist_data.dart';
import 'package:offstream/type/song_data.dart';

PlaylistData getSamplePlaylist() {
  return PlaylistData(
    repo: 'github.com/user/offstream',
    title: 'Playlist 1',
    songs: [
      SongData(
        title: "Holy Diver",
        artist: "Dio",
        album: "Holy Diver",
        albumArtPath: "https://m.media-amazon.com/images/I/81exki0oztL._UF1000,1000_QL80_.jpg",
        addedAt: DateTime(1983, 5, 25),
        duration: Duration(minutes: 5, seconds: 52),
      ),
      getSampleSong(1),
      getSampleSong(2),
      getSampleSong(3),
    ],
  );
}

SongData getSampleSong(int num) {
  return SongData(
      title: "Song $num",
      artist: "Artist $num",
      album: "Album $num",
      albumArtPath: getMissingAlbumArtPath(),
      addedAt: DateTime.now(),
      duration: Duration(minutes: 3, seconds: num * 10)
  );
}

String getPlaylistPath(PlaylistData playlist) {
  return '${playlist.repo}/${playlist.title}';
}

double calculateTitleFontSize(String title) {
  int length = title.length;

  if (length <= 10) {
    // For titles with 10 or fewer characters
    // Scale up to maximum of 80 for shorter titles
    return 72 + (10 - length) * 0.8; // 0.8 = (80-72)/10
  } else {
    // For titles longer than 10 characters
    // Scale down as length increases
    return math.max(30.0, 72 - (length - 10) * 2);
  }
}

Duration multiplyDuration(Duration duration, double factor) {
  return Duration(milliseconds: (duration.inMilliseconds * factor).round());
}

String getMissingAlbumArtPath() {
  return 'https://community.spotify.com/t5/image/serverpage/image-id/55829iC2AD64ADB887E2A5/image-size/large?v=v2&px=999';
}