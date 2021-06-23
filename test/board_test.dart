import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/classes/models/board.dart';

void main() {
  group('Board', () {
    test('should parse Json correctly', () {
      const json = <String, dynamic>{
        "board": "3",
        "title": "3DCG",
        "ws_board": 1,
        "per_page": 15,
        "pages": 10,
        "max_filesize": 4194304,
        "max_webm_filesize": 3145728,
        "max_comment_chars": 2000,
        "max_webm_duration": 120,
        "bump_limit": 310,
        "image_limit": 150,
        "cooldowns": {"threads": 600, "replies": 60, "images": 60},
        "meta_description":
            "&quot;/3/ - 3DCG&quot; is 4chan's board for 3D modeling and imagery.",
        "is_archived": 1
      };

      Board board = Board.fromJson(json);
      expect(board.board, "3");
      expect(board.title, "3DCG");
      expect(board.wsBoard, 1);
      expect(board.perPage, 15);
      expect(board.pages, 10);
      expect(board.maxFileSize, 4194304);
      expect(board.maxWebmFileSize, 3145728);
      expect(board.maxCommentChars, 2000);
      expect(board.maxWebmDuration, 120);
      expect(board.bumpLimit, 310);
      expect(board.imageLimit, 150);
      expect(board.threadsCooldown, 600);
      expect(board.repliesCooldown, 60);
      expect(board.imagesCooldown, 60);
      expect(board.metaDescription,
          "&quot;/3/ - 3DCG&quot; is 4chan's board for 3D modeling and imagery.");
      expect(board.isArchived, 1);
    });
  });
}
