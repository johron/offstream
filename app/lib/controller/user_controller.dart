import 'dart:async';

import 'package:offstream/controller/auth.dart';
import 'package:offstream/controller/storage.dart';
import 'package:offstream/util/util.dart';

import '../type/playlist_data.dart';
import '../type/stream_data.dart';
import '../type/user_data.dart';

class UserController {
  UserController._internal();

  static final UserController _instance = UserController._internal();

  factory UserController() => _instance;

  final AuthController auth = AuthController();
  final StorageController storage = StorageController();

  final _userUpdateController = StreamController<UserData>.broadcast();
  Stream<UserData> get onUserUpdated => _userUpdateController.stream;

  // getter for AuthController find loggedInUser
  Future<UserData> get user async {
    var authUser = auth.loggedInUser;
    if (authUser == null) {
      throw Exception("No user is logged in");
    }

    var stream = await storage.loadStream();
    var user = stream?.users.firstWhere((u) => u.username == authUser.user.username);
    if (user == null) {
      throw Exception("Logged in user not found in storage");
    }

    return user;
}

  Future<bool> createPlaylist(String title, String description) async {
    var stream = await storage.loadStream();
    if (stream == null) {
      return false;
    }

    var user = await this.user;

    var newPlaylist = PlaylistData(
      uuid: generatePlaylistUUID(title),
      title: title,
      description: description,
      songs: [],
      created: DateTime.now(),
      lastUpdate: DateTime.now(),
    );

    var updatedPlaylists = List<PlaylistData>.from(user.playlists)..add(newPlaylist);
    var updatedUser = UserData(
      username: user.username,
      pin: user.pin,
      playlists: updatedPlaylists,
      configuration: user.configuration,
    );

    updateUser(updatedUser);

    return true;
  }

  void updateUser(UserData updatedUser) async {
    var stream = await storage.loadStream();
    if (stream == null) {
      return;
    }

    var updatedUsers = stream.users.map((u) {
      if (u.username == updatedUser.username) {
        return updatedUser;
      }
      return u;
    }).toList();

    var updatedStream = StreamData(
      lastUpdate: stream.lastUpdate,
      version: stream.version,
      token: stream.token,
      users: updatedUsers,
    );

    _userUpdateController.add(updatedUser);

    await storage.saveStream(updatedStream);
  }
}