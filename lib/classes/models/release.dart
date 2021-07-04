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

  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
      browserDownloadUrl: json['assets'][0]['browser_download_url'],
      tagName: json['tag_name'],
      name: json['name'],
      body: json['body'],
      size: json['assets'][0]['size'],
    );
  }
}
