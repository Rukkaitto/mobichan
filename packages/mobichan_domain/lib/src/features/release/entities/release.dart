class Release {
  final String? apkUrl;
  final String? ipaUrl;
  final String tagName;
  final String name;
  final String body;
  final int size;

  Release({
    required this.apkUrl,
    required this.ipaUrl,
    required this.tagName,
    required this.name,
    required this.body,
    required this.size,
  });
}
