import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:offstream/type/stream_data.dart';

import '../type/user_data.dart';

class StorageController {
  StorageController._internal();

  static final StorageController _instance = StorageController._internal();

  factory StorageController() => _instance;

  StreamData cachedStream = StreamData.empty();

  Timer? _periodicCacheTimer;

  void init() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      loadStream().then((data) {
        if (data != null) {
          cachedStream = data;
        }
      });
    });
  }

  Future<String> get _localPath async {
    // Linux: ~/.config/offstream
    // Windows: %APPDATA%\Offstream
    // macOS: ~/Library/Application Support/Offstream
    // Android/iOS and others: use path_provider

    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '.';
      final dir = Directory('$home/.config/offstream');
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir.path;
    }

    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'] ?? Platform.environment['USERPROFILE'] ?? '.';
      final dir = Directory('$appData${Platform.pathSeparator}Offstream');
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir.path;
    }

    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'] ?? '.';
      final dir = Directory('$home/Library/Application Support/Offstream');
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir.path;
    }

    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    // Make sure the directory exists
    final dir = Directory(path);
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('$path/stream.json');
  }

  Future<File> saveStream(StreamData data) async {
    final file = await _localFile;
    final String stream = jsonEncode(data);
    return file.writeAsString(stream);
  }

  Future<StreamData?> loadStream() async {
    try {
      final file = await _localFile;
      final String contents = await file.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(contents);
      return StreamData.fromJson(jsonData);
    } catch (e) {
      print('Error loading stream data: $e');
      return null;
    }
  }

  bool addUser(UserData user) {
    loadStream().then((data) {
      if (data == null) {
        print("No stream data available to add user.");
        return false;
      }

      var newStream = data;
      newStream.users.add(user);

      saveStream(newStream);

      print("User ${user.username} added successfully.");
      return true;
    });

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
      );

      saveStream(newStream);

      print("Token set successfully.");
      return true;
    });

    return true;
  }
}