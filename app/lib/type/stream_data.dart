import 'package:offstream/type/user_data.dart';

class StreamData {
  final int lastUpdate;
  final String version;
  final String token;
  final List<UserData> users;

  const StreamData({
    required this.lastUpdate,
    required this.version,
    required this.token,
    required this.users,
  });

  Map<String, dynamic> toJson() {
    return {
      'lastUpdate': lastUpdate,
      'version': version,
      'token': token,
      'users': users.map((user) => user.toJson()).toList(),
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
    );
  }

  static StreamData empty() {
    return StreamData(
      lastUpdate: 0,
      version: "0.0.0",
      token: "",
      users: [],
    );
  }
}