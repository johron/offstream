import 'package:offstream/type/playlist_data.dart';

import 'configuration_data.dart';

class UserData {
  final String username;
  final String password;
  final List<PlaylistData> playlists;
  final ConfigurationData configuration;

  const UserData({
    required this.username,
    required this.password,
    required this.playlists,
    required this.configuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'playlists': playlists.map((playlist) => playlist.toJson()).toList(),
      'configuration': configuration.toJson(),
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      password: json['password'],
      playlists: (json['playlists'] as List<dynamic>)
          .map((playlistJson) => PlaylistData.fromJson(playlistJson))
          .toList(),
      configuration:
          ConfigurationData.fromJson(json['configuration']),
    );
  }
}