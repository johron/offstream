import 'package:offstream/type/playlist_data.dart';
import 'package:offstream/type/song_data.dart';

PlaylistData getSamplePlaylist() {
  return PlaylistData(
    repo: 'github.com/user/offstream',
    title: 'Playlist 1',
    songs: [
      SongData(title: "Song 1", artist: "Artist 1", album: "Album 1", duration: Duration(minutes: 3, seconds: 30)),
      SongData(title: "Song 2", artist: "Artist 2", album: "Album 2", duration: Duration(minutes: 4, seconds: 0)),
      SongData(title: "Song 3", artist: "Artist 3", album: "Album 3", duration: Duration(minutes: 2, seconds: 45)),
      SongData(title: "Song 4", artist: "Artist 4", album: "Album 4", duration: Duration(minutes: 5, seconds: 15)),
      SongData(title: "Song 4", artist: "Artist 4", album: "Album 4", duration: Duration(minutes: 5, seconds: 15)),
      SongData(title: "Song 4", artist: "Artist 4", album: "Album 4", duration: Duration(minutes: 5, seconds: 15)),
      SongData(title: "Song 4", artist: "Artist 4", album: "Album 4", duration: Duration(minutes: 5, seconds: 15)),
      SongData(title: "Song 4", artist: "Artist 4", album: "Album 4", duration: Duration(minutes: 5, seconds: 15)),
      SongData(title: "Song 4", artist: "Artist 4", album: "Album 4", duration: Duration(minutes: 5, seconds: 15)),
    ],
  );
}

String getPlaylistPath(PlaylistData playlist) {
  return '${playlist.repo}/${playlist.title}';
}