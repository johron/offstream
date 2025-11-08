import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:peik/controller/auth_controller.dart';
import 'package:peik/type/local_store.dart';
import 'package:peik/util/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peik/type/stream_data.dart';

import '../type/playlist_data.dart';
import '../type/user_data.dart';

class StorageController {
  StorageController._internal();

  static final StorageController _instance = StorageController._internal();

  factory StorageController() => _instance;

  final AuthController auth = AuthController();

  Future<void> init() async {
    var streamData = await loadStream();
    if (streamData == null) {
      var initialStream = StreamData(
        lastUpdate: DateTime
            .now()
            .millisecondsSinceEpoch,
        version: version,
        token: auth.hashSha256(auth.generateToken()!),
        users: [],
        songs: [],
      );
      await saveStream(initialStream);
    }
  }

  Future<String> get _localPath async {
    // Linux: ~/.config/peik
    // Windows: %APPDATA%\Peik
    // macOS: ~/Library/Application Support/Peik
    // Android/iOS and others: use path_provider

    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '.';
      final dir = Directory('$home/.config/peik');
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir.path;
    }

    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'] ?? Platform.environment['USERPROFILE'] ?? '.';
      final dir = Directory('$appData${Platform.pathSeparator}Peik');
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir.path;
    }

    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'] ?? '.';
      final dir = Directory('$home/Library/Application Support/Peik');
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir.path;
    }

    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _streamFile async {
    final path = await _localPath;
    // Make sure the directory exists
    final dir = Directory(path);
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('$path/stream.json');
  }

  Future<File> saveStream(StreamData data) async {
    final file = await _streamFile;
    final String stream = jsonEncode(data);
    return file.writeAsString(stream);
  }

  Future<StreamData?> loadStream() async {
    try {
      final file = await _streamFile;
      final String contents = await file.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(contents);
      return StreamData.fromJson(jsonData);
    } catch (e) {
      print('Error loading stream data: $e');
      return null;
    }
  }

  Future<File> get _localStoreFile async {
    final path = await _localPath;
    // Make sure the directory exists
    final dir = Directory(path);
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('$path/local.json');
  }

  Future<File> saveLocalStore(LocalStore data) async {
    final file = await _localStoreFile;
    final String store = jsonEncode(data);
    return file.writeAsString(store);
  }

  Future<LocalStore?> loadLocalStore() async {
    try {
      final file = await _localStoreFile;
      final String contents = await file.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(contents);
      return LocalStore.fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addUser(UserData user) async {
    var stream = await loadStream();
    if (stream == null) {
      print("No stream data available to add user.");
      return false;
    }

    var newStream = stream;
    newStream.users.add(user);

    saveStream(newStream);

    print("User ${user.username} added successfully.");

    return true;
  }

  bool setToken(String token) {
    loadStream().then((data) {
      if (data == null) {
        print("No stream data available to set token.");
        return false;
      }

      if (data.token != "") {
        print("Token is already set.");
        return false;
      }

      var newStream = data;
      newStream = StreamData(
        lastUpdate: newStream.lastUpdate,
        version: newStream.version,
        token: token,
        users: newStream.users,
        songs: newStream.songs,
      );

      saveStream(newStream);

      print("Token set successfully.");
      return true;
    });

    return true;
  }
}