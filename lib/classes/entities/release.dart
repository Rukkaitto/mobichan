import 'package:release_repository/release_repository.dart';

class Release extends ReleaseModel {
  Release({
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
}
