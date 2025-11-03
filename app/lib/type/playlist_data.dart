import 'package:offstream/type/song_data.dart';

class PlaylistData {
  final String title;
  final List<SongData> songs;
  final DateTime created;
  final DateTime lastUpdate;

  const PlaylistData({
    required this.title,
    required this.songs,
    required this.created,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'songs': songs.map((song) => song.toJson()).toList(),
      'created': created.toIso8601String(),
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }
}