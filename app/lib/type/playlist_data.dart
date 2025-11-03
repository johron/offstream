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

  factory PlaylistData.fromJson(Map<String, dynamic> json) {
    return PlaylistData(
      title: json['title'],
      songs: (json['songs'] as List<dynamic>)
          .map((songJson) => SongData.fromJson(songJson))
          .toList(),
      created: DateTime.parse(json['created']),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(json['lastUpdate']),
    );
  }
}