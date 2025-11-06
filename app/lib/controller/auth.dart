import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:offstream/controller/storage.dart';
import 'package:offstream/controller/user_controller.dart';
import 'package:offstream/type/configuration_data.dart';
import 'package:offstream/type/local_store.dart';
import 'package:offstream/type/user_data.dart';
import 'package:offstream/util/util.dart';

class AuthUser {
  final UserData user;
  final bool isAuthenticated;

  AuthUser({
    required this.user,
    required this.isAuthenticated,
  });
}

class AuthController {
  AuthController._internal();

  static final AuthController _instance = AuthController._internal();

  factory AuthController() => _instance;

  AuthUser? _loggedInUser;

  AuthUser? get loggedInUser => _loggedInUser;

  final _authenticatedStateController = StreamController<AuthUser?>.broadcast();

  Stream<AuthUser?> get onAuthenticatedStream => _authenticatedStateController.stream;

  void init() {
    var storage = StorageController();
    var userController = UserController();

    userController.onUserUpdated.listen((userData) {
      _loggedInUser = AuthUser(user: userData, isAuthenticated: _loggedInUser?.isAuthenticated ?? false);
    });

    // var newUser = UserData(
    //   username: "username",
    //   //pin: hashSha256(1234.toString()),
    //   playlists: [
    //     getSamplePlaylist(),
    //   ],
    //   configuration: ConfigurationData(),
    // );
    // storage.addUser(newUser);

    var user = storage.loadLocalStore().then((localStore) {
      if (localStore == null) {
        return null;
      }

      var username = localStore.loggedInUser;
      var streamData = storage.loadStream();

      return streamData.then((data) {
        if (data == null) {
          return null;
        }

        for (var user in data.users) {
          if (user.username == username) {
            return AuthUser(user: user, isAuthenticated: user.pin == null);
          }
        }

        return null;
      });
    });

    user.then((authUser) {
      if (authUser != null) {
        _loggedInUser = authUser;
        _authenticatedStateController.add(_loggedInUser);
      }
    });
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

  bool signup(String username, String? pin) {
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
        playlists: [],
        configuration: ConfigurationData(),
        pin: pin != null ? hashSha256(pin) : null,
      );

      storage.addUser(newUser);

      _loggedInUser = AuthUser(user: newUser, isAuthenticated: pin == null);

      return true;
    });

    return true;
  }

  Future<bool> login(String username) async {
    var storage = StorageController();
    var stream = await storage.loadStream();

    if (stream == null) {
      print("No stream data available for login.");
      return false;
    }

    for (var user in stream.users) {
      if (user.username == username) {
        if (user.pin != null) {
          _loggedInUser = AuthUser(user: user, isAuthenticated: false);
        } else {
          _loggedInUser = AuthUser(user: user, isAuthenticated: true);
        }

        print("User ${user.username} logged in successfully.");

        _authenticatedStateController.add(_loggedInUser);

        await storage.saveLocalStore(LocalStore(loggedInUser: _loggedInUser!.user.username));

        return true;
      }
    }

    print("Login failed for user $username.");
    return false;
  }

  bool verifyPin(String pin) {
    if (_loggedInUser == null) {
      return false;
    }

    var hashedPin = hashSha256(pin);

    if (_loggedInUser!.user.pin == hashedPin) {
      _loggedInUser = AuthUser(user: _loggedInUser!.user, isAuthenticated: true);

      _authenticatedStateController.add(_loggedInUser);

      return true;
    } else {
      return false;
    }
  }

  bool logout() {
    if (_loggedInUser != null) {
      _loggedInUser = null;

      _authenticatedStateController.add(_loggedInUser);

      return true;
    } else {
      return false;
    }
  }
}