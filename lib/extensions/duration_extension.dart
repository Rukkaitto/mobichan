extension DurationExtension on Duration {
  String get formatted {
    String minutes = this.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = this.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
