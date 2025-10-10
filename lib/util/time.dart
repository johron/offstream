String formatSeconds(double seconds) {
  final int minutes = seconds ~/ 60;
  final int remainingSeconds = seconds.toInt() % 60;
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}

String formatDuration(Duration duration) {
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}