extension DurationExtension on Duration {
  String get formatted {
    String minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
