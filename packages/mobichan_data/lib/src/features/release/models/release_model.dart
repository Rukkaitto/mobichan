import 'package:mobichan_domain/mobichan_domain.dart';

class ReleaseModel extends Release {
  ReleaseModel({
    required String browserDownloadUrl,
    required String tagName,
    required String name,
    required String body,
    required int size,
  }) : super(
          browserDownloadUrl: browserDownloadUrl,
          tagName: tagName,
          name: name,
          body: body,
          size: size,
        );

  factory ReleaseModel.fromJson(Map<String, dynamic> json) {
    return ReleaseModel(
      browserDownloadUrl: json['assets'][0]['browser_download_url'],
      tagName: json['tag_name'],
      name: json['name'],
      body: json['body'],
      size: json['assets'][0]['size'],
    );
  }
}
