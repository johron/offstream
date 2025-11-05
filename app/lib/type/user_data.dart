import 'package:offstream/type/playlist_data.dart';

import 'configuration_data.dart';

class UserData {
  final String username;
  final String? pin;
  final List<PlaylistData> playlists;
  final ConfigurationData configuration;

  const UserData({
    required this.username,
    required this.playlists,
    required this.configuration,
    this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'playlists': playlists.map((playlist) => playlist.toJson()).toList(),
      'configuration': configuration.toJson(),
      'pin': pin,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      pin: json['pin'],
      playlists: (json['playlists'] as List<dynamic>)
          .map((playlistJson) => PlaylistData.fromJson(playlistJson))
          .toList(),
      configuration:
          ConfigurationData.fromJson(json['configuration']),
    );
  }
}