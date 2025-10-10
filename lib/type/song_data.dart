class SongData {
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final String? albumArtPath;

  const SongData({
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    this.albumArtPath,
  });
}