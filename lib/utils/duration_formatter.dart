String formatDuration(Duration duration) {
  final s = duration.inSeconds.clamp(0, 1 << 53);
  final sec = (s % 60).toString().padLeft(2, '0');
  final min = ((s ~/ 60) % 60).toString().padLeft(2, '0');
  return s >= 3600 ? '${s ~/ 3600}:$min:$sec' : '${s ~/ 60}:$sec';
}
