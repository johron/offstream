class SongData {
  final String uuid;
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final DateTime added;

  const SongData({
    required this.uuid,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.added,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration.inMilliseconds,
      'added': added.toIso8601String(),
    };
  }

  factory SongData.fromJson(Map<String, dynamic> json) {
    return SongData(
      uuid: json['uuid'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      duration: Duration(milliseconds: json['duration']),
      added: DateTime.parse(json['added']),
    );
  }
}