class Release {
  final String browserDownloadUrl;
  final String tagName;

  Release({
    required this.browserDownloadUrl,
    required this.tagName,
  });

  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
      browserDownloadUrl: json['assets'][0]['browser_download_url'],
      tagName: json['tag_name'],
    );
  }
}
