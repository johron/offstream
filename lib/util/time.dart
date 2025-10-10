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

String _getMonthName(int month) {
  const List<String> monthNames = [
    'jan', 'feb', 'mar', 'apr', 'may', 'jun',
    'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
  ];
  return monthNames[month - 1];
}

String formatDateTime(DateTime dateTime) {
  return '${dateTime.day.toString().padLeft(2, '0')}. ${_getMonthName(dateTime.month)} ${dateTime.year}';
}