class Board {
  late final String board;
  late final String title;
  late final int wsBoard;
  late final int perPage;
  late final int pages;
  late final int maxFileSize;
  late final int maxWebmFileSize;
  late final int maxCommentChars;
  late final int maxWebmDuration;
  late final int bumpLimit;
  late final int imageLimit;
  late final int threadsCooldown;
  late final int repliesCooldown;
  late final int imagesCooldown;
  late final String metaDescription;
  late int isArchived;
  late int forcedAnon;
  late int countryFlags;
  late int userIds;
  late int spoilers;
  late int customSpoilers;

  Board({
    required this.board,
    required this.title,
    required this.wsBoard,
    required this.perPage,
    required this.pages,
    required this.maxFileSize,
    required this.maxWebmFileSize,
    required this.maxCommentChars,
    required this.maxWebmDuration,
    required this.bumpLimit,
    required this.imageLimit,
    required this.threadsCooldown,
    required this.repliesCooldown,
    required this.imagesCooldown,
    required this.metaDescription,
    this.isArchived = 0,
    this.forcedAnon = 0,
    this.countryFlags = 0,
    this.userIds = 0,
    this.spoilers = 0,
    this.customSpoilers = 0,
  });

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
      threadsCooldown: json['cooldowns']['threads'],
      repliesCooldown: json['cooldowns']['replies'],
      imagesCooldown: json['cooldowns']['images'],
      metaDescription: json['meta_description'],
      isArchived: json['is_archived'],
      forcedAnon: json['forced_anon'],
      countryFlags: json['country_flags'],
      userIds: json['user_ids'],
      spoilers: json['spoilers'],
      customSpoilers: json['custom_spoilers'],
    );
  }
}
