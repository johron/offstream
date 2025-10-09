String formatSeconds(double seconds) {
  final int minutes = seconds ~/ 60;
  final int remainingSeconds = seconds.toInt() % 60;
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}