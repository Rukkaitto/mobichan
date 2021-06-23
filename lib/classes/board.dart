class Board {
  late final String board;
  late final String title;

  Board({required this.board, required this.title});

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(board: json['board'], title: json['title']);
  }
}
