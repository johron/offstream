import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:offstream/type/stream_data.dart';

class StorageController {
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

  Future<File> save(StreamData data) async {
    final file = await _localFile;
    final String stream = jsonEncode(data);
    print(file.path);
    print(stream);
    return file.writeAsString(stream);
  }

  Future<StreamData?> load() async {
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
}