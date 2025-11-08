import 'package:offstream/type/song_data.dart';
import 'package:offstream/type/user_data.dart';

class StreamData {
  final int lastUpdate;
  final String version;
  final String token;
  final List<UserData> users;
  final List<SongData> songs;

  const StreamData({
    required this.lastUpdate,
    required this.version,
    required this.token,
    required this.users,
    required this.songs,
  });

  Map<String, dynamic> toJson() {
    return {
      'lastUpdate': lastUpdate,
      'version': version,
      'token': token,
      'users': users.map((user) => user.toJson()).toList(),
      'songs': songs.map((song) => song.toJson()).toList(),
    };
  }

  factory StreamData.fromJson(Map<String, dynamic> json) {
    return StreamData(
      lastUpdate: json['lastUpdate'],
      version: json['version'],
      token: json['token'],
      users: (json['users'] as List<dynamic>)
          .map((userJson) => UserData.fromJson(userJson))
          .toList(),
      songs: (json['songs'] as List<dynamic>)
          .map((songJson) => SongData.fromJson(songJson))
          .toList(),
    );
  }
}