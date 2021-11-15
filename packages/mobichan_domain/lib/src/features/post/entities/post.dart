import 'package:equatable/equatable.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class Post extends Equatable {
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

  const Post({
    this.no = 0,
    this.now = '',
    this.name = 'Anonymous',
    this.time = 0,
    this.resto = 0,
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

  List<Post> getReplies(List<Post> posts) {
    List<Post> replies = List.empty(growable: true);
    for (var otherPost in posts) {
      final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
      final matches = regExp
          .allMatches(otherPost.com ?? '')
          .map((match) => int.parse(match.group(0) ?? ""));

      // if another post quotes this post
      if (matches.contains(no)) {
        // add other post to replies list
        replies.add(otherPost);
      }
    }
    return replies;
  }

  List<int> replyingTo(List<Post> posts) {
    final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
    final matches = regExp
        .allMatches(com ?? '')
        .map((match) => int.parse(match.group(0) ?? ""))
        .toList();
    return matches;
  }

  bool get isRootPost {
    final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
    final matches = regExp
        .allMatches(com ?? '')
        .map((match) => int.parse(match.group(0) ?? ""))
        .toList();
    return matches.isEmpty;
  }

  static Post getQuotedPost(List<Post> posts, int no) {
    return posts.firstWhere((post) => post.no == no);
  }

  String getImageUrl(Board board) {
    return 'https://i.4cdn.org/${board.board}/$tim$ext';
  }

  String getThumbnailUrl(Board board) {
    return 'https://i.4cdn.org/${board.board}/${tim}s.jpg';
  }

  bool get isWebm {
    return ext == '.webm';
  }

  String get displayTitle {
    return sub ?? com ?? '';
  }

  String get userName {
    return name ?? 'Anonymous';
  }

  @override
  String toString() {
    return no.toString();
  }

  @override
  List<Object?> get props => [no, board];
}
