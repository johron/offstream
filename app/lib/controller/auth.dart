import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:offstream/controller/storage.dart';
import 'package:offstream/type/configuration_data.dart';
import 'package:offstream/type/user_data.dart';
import 'package:offstream/util/util.dart';

class AuthController {
  AuthController._internal();

  static final AuthController _instance = AuthController._internal();

  factory AuthController() => _instance;

  UserData? get loggedInUser => _loggedInUser;

  UserData? _loggedInUser;

  void init() {
    var newUser = UserData(
      username: "username",
      password: hashSha256("password"),
      playlists: [
        getSamplePlaylist(),
      ],
      configuration: ConfigurationData(),
    );
    StorageController().addUser(newUser);
  }

  String hashSha256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  String? generateToken() {
    var storage = StorageController();

    storage.loadStream().then((data) {
      if (data == null) {
        return null;
      }

      if (data.token != "") {
        return null;
      }
    });

    var tokenBytes = List<int>.generate(16, (i) => i + DateTime.now().millisecondsSinceEpoch % 256);
    var token = base64Url.encode(tokenBytes);

    return token;
  }

  bool signup(String username, String password) {
    var storage = StorageController();

    storage.loadStream().then((data) {
      if (data == null) {
        return false;
      }

      for (var user in data.users) {
        if (user.username == username) {
          return false;
        }
      }

      var newUser = UserData(
        username: username,
        password: hashSha256(password),
        playlists: [],
        configuration: ConfigurationData(),
      );

      storage.addUser(newUser);

      return true;
    });

    return true;
  }

  Future<bool> login(String username, String password) async {
    var storage = StorageController();
    var stream = await storage.loadStream();

    if (stream == null) {
      print("No stream data available for login.");
      return false;
    }

    for (var user in stream.users) {
      if (user.username == username && user.password == hashSha256(password)) {
        _loggedInUser = user;
        print("User ${user.username} logged in successfully.");
        return true;
      }
    }

    print(password);
    print(hashSha256(password));

    print("Login failed for user $username.");
    return false;
  }

  void logout() {
    // Implement logout logic here
    print("Not yet implemented: logout()");
  }
}