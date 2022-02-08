import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
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
  final String? boardId;
  final String? boardTitle;
  final int? boardWs;

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
    this.boardId,
    this.boardTitle,
    this.boardWs,
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

  List<Post> replyingTo(List<Post> posts) {
    final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
    final matches = regExp
        .allMatches(com ?? '')
        .map((match) => int.parse(match.group(0) ?? ""))
        .toList();
    return posts
        .where((post) => matches.where((match) => match == post.no).isNotEmpty)
        .toList();
  }

  bool get isRootPost {
    final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
    final matches = regExp
        .allMatches(com ?? '')
        .map((match) => int.parse(match.group(0) ?? ""))
        .toList();
    return matches.isEmpty;
  }

  String? getImageUrl(Board board) {
    if (tim != null) {
      return 'https://i.4cdn.org/${board.board}/$tim$ext';
    }
  }

  String? getThumbnailUrl(Board board) {
    if (tim != null) {
      return 'https://i.4cdn.org/${board.board}/${tim}s.jpg';
    }
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

  String? get countryFlagUrl {
    if (country != null) {
      return 'https://s.4cdn.org/image/country/${country?.toLowerCase()}.gif';
    }
  }

  static String databaseQuery(String tableName) {
    return '''
      CREATE TABLE $tableName(
        no INTEGER PRIMARY KEY,
        now TEXT,
        time INTEGER,
        resto INTEGER,
        name STRING,
        sticky INTEGER,
        closed INTEGER,
        sub TEXT,
        com TEXT,
        filename TEXT,
        ext TEXT,
        w INTEGER,
        h INTEGER,
        tn_w INTEGER,
        tn_h INTEGER,
        tim INTEGER,
        md5 TEXT,
        fsize INTEGER,
        capcode TEXT,
        semantic_url TEXT,
        replies INTEGER,
        images INTEGER,
        unique_ips INTEGER,
        trip TEXT,
        last_modified INTEGER,
        country TEXT,
        board_id TEXT,
        board_title TEXT,
        board_ws INTEGER
      )
    ''';
  }

  @override
  List<Object?> get props => [no, boardId];
}

extension PostListExtension on List<Post> {
  List<Post> get imagePosts {
    return where((post) => post.tim != null).toList();
  }

  Post? getQuotedPost(String quotelink) {
    int? quotedNo = int.tryParse(quotelink.substring(2));
    if (quotedNo == null) {
      return null;
    }
    return firstWhereOrNull((post) => post.no == quotedNo);
  }
}
