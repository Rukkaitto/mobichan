import 'package:mobichan_domain/mobichan_domain.dart';

class Post {
  final int no;
  final String now;
  final String? name;
  final int time;
  final int resto;
  final int? sticky;
  final int? closed;
  final String? sub;
  final String? com;
  final String? filename;
  final String? ext;
  final int? w;
  final int? h;
  final int? tnW;
  final int? tnH;
  final int? tim;
  final String? md5;
  final int? fsize;
  final String? capcode;
  final String? semanticUrl;
  final int? replies;
  final int? images;
  final int? uniqueIps;
  final String? trip;
  final int? lastModified;
  final String? country;
  final Board? board;

  Post({
    required this.no,
    required this.now,
    required this.name,
    required this.time,
    required this.resto,
    this.sticky,
    this.closed,
    this.sub,
    this.com,
    this.filename,
    this.ext,
    this.w,
    this.h,
    this.tnW,
    this.tnH,
    this.tim,
    this.md5,
    this.fsize,
    this.capcode,
    this.semanticUrl,
    this.replies,
    this.images,
    this.uniqueIps,
    this.trip,
    this.lastModified,
    this.country,
    this.board,
  });

  String getImageUrl(Board board) {
    return 'https://i.4cdn.org/${board.board}/$tim$ext';
  }

  String getThumbnailUrl(Board board) {
    return 'https://i.4cdn.org/${board.board}/${tim}s.jpg';
  }

  @override
  String toString() {
    return no.toString();
  }
}
