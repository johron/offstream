import 'package:peik/type/song_data.dart';

import '../util/util.dart';

class PlaylistData {
  final String uuid;
  final String title;
  final String? description;
  final List<SongData> songs;
  final DateTime created;
  final DateTime lastUpdate;

  PlaylistData({
    required this.uuid,
    required this.title,
    required this.songs,
    required this.created,
    required this.lastUpdate,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'description': description,
      'songs': songs.map((song) => song.toJson()).toList(),
      'created': created.toIso8601String(),
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory PlaylistData.fromJson(Map<String, dynamic> json) {
    return PlaylistData(
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      songs: (json['songs'] as List<dynamic>)
          .map((songJson) => SongData.fromJson(songJson))
          .toList(),
      created: DateTime.parse(json['created']),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(json['lastUpdate']),
    );
  }
}