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
  final int? threadsCooldown;
  final int? repliesCooldown;
  final int? imagesCooldown;
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
    this.threadsCooldown,
    this.repliesCooldown,
    this.imagesCooldown,
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

  @override
  List<Object?> get props => [board, title];

  @override
  int compareTo(Board other) {
    return title.compareTo(other.title);
  }
}
