import 'package:equatable/equatable.dart';

class Board extends Equatable with Comparable<Board> {
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
  final String? metaDescription;
  final int? isArchived;
  final int? forcedAnon;
  final bool countryFlags;
  final int? userIds;
  final int? spoilers;
  final int? customSpoilers;

  const Board({
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
    this.metaDescription,
    this.isArchived,
    this.forcedAnon,
    this.countryFlags = false,
    this.userIds,
    this.spoilers,
    this.customSpoilers,
  });

  String get fullTitle {
    return '/$board/ - $title';
  }

  static Board get initial {
    return const Board(board: 'g', title: 'Technology', wsBoard: 1);
  }

  static String databaseQuery(String tableName) {
    return '''
      CREATE TABLE $tableName(
        board TEXT PRIMARY KEY,
        title TEXT,
        ws_board INTEGER,
        per_page INTEGER,
        pages INTEGER,
        max_filesize INTEGER,
        max_webm_filesize INTEGER,
        max_comment_chars INTEGER,
        max_webm_duration INTEGER,
        bump_limit INTEGER,
        image_limit INTEGER,
        meta_description TEXT,
        is_archived INTEGER,
        forced_anon INTEGER,
        country_flags INTEGER,
        user_ids INTEGER,
        spoilers INTEGER,
        custom_spoilers INTEGER,
        cooldowns JSON1
      )
    ''';
  }

  @override
  List<Object?> get props => [board, title];

  @override
  int compareTo(Board other) {
    return title.compareTo(other.title);
  }
}
