class Release {
  final String browserDownloadUrl;
  final String tagName;
  final String name;
  final String body;
  final int size;

  Release({
    required this.browserDownloadUrl,
    required this.tagName,
    required this.name,
    required this.body,
    required this.size,
  });
}
