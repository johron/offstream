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
}