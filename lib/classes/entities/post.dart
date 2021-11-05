import 'package:mobichan/constants.dart';
import 'package:post_repository/post_repository.dart';

class Post extends PostModel {
  Post({
    required int no,
    required String now,
    required int time,
    required int resto,
    String? name,
    int? sticky,
    int? closed,
    String? sub,
    String? com,
    String? filename,
    String? ext,
    int? w,
    int? h,
    int? tnW,
    int? tnH,
    int? tim,
    String? md5,
    int? fsize,
    String? capcode,
    String? semanticUrl,
    int? replies,
    int? images,
    int? uniqueIps,
    String? trip,
    int? lastModified,
    String? country,
    String? board,
  }) : super(
          no: no,
          now: now,
          time: time,
          resto: resto,
          name: name,
          sticky: sticky,
          closed: closed,
          sub: sub,
          com: com,
          filename: filename,
          ext: ext,
          w: w,
          h: h,
          tnW: tnW,
          tnH: tnH,
          tim: tim,
          md5: md5,
          fsize: fsize,
          capcode: capcode,
          semanticUrl: semanticUrl,
          replies: replies,
          images: images,
          uniqueIps: uniqueIps,
          trip: trip,
          lastModified: lastModified,
          country: country,
          board: board,
        );

  String getImageUrl(String board) {
    return '$API_IMAGES_URL/$board/$tim$ext';
  }

  String getThumbnailUrl(String board) {
    return '$API_IMAGES_URL/$board/${tim}s.jpg';
  }
}
