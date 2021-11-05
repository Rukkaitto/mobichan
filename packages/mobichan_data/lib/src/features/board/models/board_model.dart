import 'package:mobichan_domain/mobichan_domain.dart';

class BoardModel extends Board {
  BoardModel({
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
          imageLimit: imageLimit,
          threadsCooldown: threadsCooldown,
          repliesCooldown: repliesCooldown,
          imagesCooldown: imagesCooldown,
          metaDescription: metaDescription,
          isArchived: isArchived,
          forcedAnon: forcedAnon,
          countryFlags: countryFlags,
          userIds: userIds,
          spoilers: spoilers,
          customSpoilers: customSpoilers,
        );

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
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

  factory BoardModel.fromEntity(Board board) {
    return BoardModel(
      board: board.board,
      title: board.title,
      wsBoard: board.wsBoard,
      perPage: board.perPage,
      pages: board.pages,
      maxFileSize: board.maxFileSize,
      maxWebmFileSize: board.maxWebmFileSize,
      maxCommentChars: board.maxCommentChars,
      maxWebmDuration: board.maxWebmDuration,
      bumpLimit: board.bumpLimit,
      imageLimit: board.imageLimit,
      threadsCooldown: board.threadsCooldown,
      repliesCooldown: board.repliesCooldown,
      imagesCooldown: board.imagesCooldown,
      metaDescription: board.metaDescription,
      isArchived: board.isArchived,
      forcedAnon: board.forcedAnon,
      countryFlags: board.countryFlags,
      userIds: board.userIds,
      spoilers: board.spoilers,
      customSpoilers: board.customSpoilers,
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
