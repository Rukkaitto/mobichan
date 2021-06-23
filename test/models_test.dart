import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/classes/models/post.dart';

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

  group('Post', () {
    test('should parse Json correctly', () {
      const json = <String, dynamic>{
        "no": 570368,
        "sticky": 1,
        "closed": 1,
        "now": "12/31/18(Mon)17:05:48",
        "name": "Anonymous",
        "sub": "Welcome to /po/!",
        "com":
            "Welcome to /po/! We specialize in origami, papercraft, and everything that’s relevant to paper engineering. This board is also an great library of relevant PDF books and instructions, one of the best resource of its kind on the internet.<br><br>Questions and discussions of papercraft and origami are welcome. Threads for topics covered by paper engineering in general are also welcome, such as kirigami, bookbinding, printing technology, sticker making, gift boxes, greeting cards, and more.<br><br>Requesting is permitted, even encouraged if it’s a good request; fulfilled requests strengthens this board’s role as a repository of books and instructions. However do try to keep requests in relevant threads, if you can.<br><br>/po/ is a slow board! Do not needlessly bump threads.",
        "filename": "yotsuba_folding",
        "ext": ".png",
        "w": 530,
        "h": 449,
        "tn_w": 250,
        "tn_h": 211,
        "tim": 1546293948883,
        "time": 1546293948,
        "md5": "uZUeZeB14FVR+Mc2ScHvVA==",
        "fsize": 516657,
        "resto": 0,
        "capcode": "mod",
        "semantic_url": "welcome-to-po",
        "replies": 2,
        "images": 2,
        "unique_ips": 1
      };

      Post post = Post.fromJson(json);
      expect(post.no, 570368);
      expect(post.sticky, 1);
      expect(post.closed, 1);
      expect(post.now, '12/31/18(Mon)17:05:48');
      expect(post.name, 'Anonymous');
      expect(post.sub, 'Welcome to /po/!');
      expect(post.com,
          'Welcome to /po/! We specialize in origami, papercraft, and everything that’s relevant to paper engineering. This board is also an great library of relevant PDF books and instructions, one of the best resource of its kind on the internet.<br><br>Questions and discussions of papercraft and origami are welcome. Threads for topics covered by paper engineering in general are also welcome, such as kirigami, bookbinding, printing technology, sticker making, gift boxes, greeting cards, and more.<br><br>Requesting is permitted, even encouraged if it’s a good request; fulfilled requests strengthens this board’s role as a repository of books and instructions. However do try to keep requests in relevant threads, if you can.<br><br>/po/ is a slow board! Do not needlessly bump threads.');
      expect(post.filename, 'yotsuba_folding');
      expect(post.ext, '.png');
      expect(post.w, 530);
      expect(post.h, 449);
      expect(post.tnW, 250);
      expect(post.tnH, 211);
      expect(post.tim, 1546293948883);
      expect(post.time, 1546293948);
      expect(post.md5, 'uZUeZeB14FVR+Mc2ScHvVA==');
      expect(post.fsize, 516657);
      expect(post.resto, 0);
      expect(post.capcode, 'mod');
      expect(post.semanticUrl, 'welcome-to-po');
      expect(post.replies, 2);
      expect(post.images, 2);
      expect(post.uniqueIps, 1);
    });
  });
}
