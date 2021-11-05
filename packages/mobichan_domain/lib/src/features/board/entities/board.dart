class Board {
  final String board;
  final String title;
  final int wsBoard;
  final int? perPage;
  final int? pages;
  final int? maxFileSize;
  final int? maxWebmFileSize;
  final int? maxCommentChars;
  final int? maxWebmDuration;
  final int? bumpLimit;
  final int? imageLimit;
  final int? threadsCooldown;
  final int? repliesCooldown;
  final int? imagesCooldown;
  final String? metaDescription;
  final int? isArchived;
  final int? forcedAnon;
  final int? countryFlags;
  final int? userIds;
  final int? spoilers;
  final int? customSpoilers;

  Board({
    required this.board,
    required this.title,
    required this.wsBoard,
    this.perPage,
    this.pages,
    this.maxFileSize,
    this.maxWebmFileSize,
    this.maxCommentChars,
    this.maxWebmDuration,
    this.bumpLimit,
    this.imageLimit,
    this.threadsCooldown,
    this.repliesCooldown,
    this.imagesCooldown,
    this.metaDescription,
    this.isArchived,
    this.forcedAnon,
    this.countryFlags,
    this.userIds,
    this.spoilers,
    this.customSpoilers,
  });

  String get fullTitle {
    return '/$board/ - $title';
  }

  @override
  String toString() {
    return board;
  }
}
