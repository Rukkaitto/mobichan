import 'package:board_repository/board_repository.dart';

class Board extends BoardModel {
  Board({
    required String board,
    required String title,
    required int wsBoard,
    int? perPage,
    int? pages,
    int? maxFileSize,
    int? maxWebmFileSize,
    int? maxCommentChars,
    int? maxWebmDuration,
    int? bumpLimit,
    int? imageLimit,
    int? threadsCooldown,
    int? repliesCooldown,
    int? imagesCooldown,
    String? metaDescription,
    int? isArchived,
    int? forcedAnon,
    int? countryFlags,
    int? userIds,
    int? spoilers,
    int? customSpoilers,
  }) : super(
          board: board,
          title: title,
          wsBoard: wsBoard,
          perPage: perPage,
          pages: pages,
          maxFileSize: maxFileSize,
          maxWebmFileSize: maxWebmFileSize,
          maxCommentChars: maxCommentChars,
          maxWebmDuration: maxWebmDuration,
          bumpLimit: bumpLimit,
        );

  String get fullTitle {
    return '/$board/ - $title';
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      board: json['board'],
      title: json['title'],
      wsBoard: json['ws_board'],
      perPage: json['per_page'],
      pages: json['pages'],
      maxFileSize: json['max_filesize'],
      maxWebmFileSize: json['max_webm_filesize'],
      maxCommentChars: json['max_comment_chars'],
      maxWebmDuration: json['max_webm_duration'],
      bumpLimit: json['bump_limit'],
      imageLimit: json['image_limit'],
      threadsCooldown: json['cooldowns']?['threads'],
      repliesCooldown: json['cooldowns']?['replies'],
      imagesCooldown: json['cooldowns']?['images'],
      metaDescription: json['meta_description'],
      isArchived: json['is_archived'],
      forcedAnon: json['forced_anon'],
      countryFlags: json['country_flags'],
      userIds: json['user_ids'],
      spoilers: json['spoilers'],
      customSpoilers: json['custom_spoilers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'board': board,
      'title': title,
      'ws_board': wsBoard,
    };
  }
}
