import 'package:offstream/type/song_data.dart';

class PlaylistData {
  final String repo;
  final String title;
  final List<SongData> songs;
  final String? iconPath;

  const PlaylistData({
    required this.repo,
    required this.title,
    required this.songs,
    this.iconPath,
  });
}