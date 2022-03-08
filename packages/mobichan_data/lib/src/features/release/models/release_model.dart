import 'package:mobichan_domain/mobichan_domain.dart';

class ReleaseModel extends Release {
  ReleaseModel({
    required String? apkUrl,
    required String? ipaUrl,
    required String tagName,
    required String name,
    required String body,
    required int size,
  }) : super(
          apkUrl: apkUrl,
          ipaUrl: ipaUrl,
          tagName: tagName,
          name: name,
          body: body,
          size: size,
        );

  factory ReleaseModel.fromJson(Map<String, dynamic> json) {
    return ReleaseModel(
      apkUrl: (json['assets'] as List)
          .firstWhere(
            (element) => element['name'].contains('.apk'),
            orElse: () => null,
          )
          ?.cast<String, dynamic>()['browser_download_url'],
      ipaUrl: (json['assets'] as List)
          .firstWhere(
            (element) => element['name'].contains('.ipa'),
            orElse: () => null,
          )
          ?.cast<String, dynamic>()['browser_download_url'],
      tagName: json['tag_name'],
      name: json['name'],
      body: json['body'],
      size: json['assets'][0]['size'],
    );
  }
}
