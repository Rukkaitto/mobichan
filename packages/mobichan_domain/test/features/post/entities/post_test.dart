import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Post', () {
    const tBoard = Board(board: 'g', title: 'Technology', wsBoard: 1);
    const tOP = Post(
      no: 123123,
      sub: 'This is a subject',
      name: 'Name',
      com: """
        This is an OP
      """,
      tim: 7839789,
      ext: '.png',
      country: 'FR',
    );
    const tNoFileReply = Post(
      no: 234234,
      com: """
        <a href="#p123123" class="quotelink">&gt;&gt;123123
        this is a comment replying to the first post
      """,
    );
    const tWebmReply = Post(
      no: 345345,
      com: """
        <a href="#p123123" class="quotelink">&gt;&gt;123123
        this is another comment replying to the first post
      """,
      tim: 4792974,
      ext: '.webm',
    );
    const tImagePost = Post(
      no: 794794,
      tim: 9483945,
      ext: '.png',
    );

    List<Post> posts = const [
      tOP,
      tNoFileReply,
      tWebmReply,
    ];

    group('getReplies', () {
      test('should return empty list if the post has no replies', () {
        final replies = tNoFileReply.getReplies(posts);
        expect(replies, []);
      });

      test('should return a list of replies to a post', () {
        final replies = tOP.getReplies(posts);
        expect(replies.isEmpty, false);
        expect(replies, [tNoFileReply, tWebmReply]);
      });
    });

    group('replyingTo', () {
      test('should return empty list if the post is replying to no one', () {
        final replyingTo = tOP.replyingTo(posts);
        expect(replyingTo, []);
      });

      test('should return a list of posts that the post is replying to', () {
        final replyingTo = tNoFileReply.replyingTo(posts);
        expect(replyingTo.isEmpty, false);
        expect(replyingTo.contains(tOP), true);
      });
    });

    group('isRootPost', () {
      test('should return true if the post is a root post', () {
        final isRootPost = tOP.isRootPost;
        expect(isRootPost, true);
      });

      test('should return false if the post is not a root post', () {
        final isRootPost = tNoFileReply.isRootPost;
        expect(isRootPost, false);
      });
    });

    group('getQuotedPost', () {
      test('should return null if the quotelinked post does not exist', () {
        final post = posts.getQuotedPost("#p666666");
        expect(post, null);
      });

      test('should return a post if given a list of posts and a quotelink', () {
        final post = posts.getQuotedPost("#p${tOP.no}");
        expect(post, tOP);
      });
    });

    group('getImageUrl', () {
      test('should return null if the post has no image', () {
        final imageUrl = tNoFileReply.getImageUrl(tBoard);
        expect(imageUrl, null);
      });
      test('should return the url of the image if the post has an image', () {
        final imageUrl = tOP.getImageUrl(tBoard);
        expect(
          imageUrl,
          "https://i.4cdn.org/${tBoard.board}/${tOP.tim}${tOP.ext}",
        );
      });
    });

    group('getThumbnailUrl', () {
      test('should return null if the post has no image', () {
        final imageUrl = tNoFileReply.getThumbnailUrl(tBoard);
        expect(imageUrl, null);
      });
      test('should return the url of the thumbnail if the post has an image',
          () {
        final imageUrl = tOP.getThumbnailUrl(tBoard);
        expect(
          imageUrl,
          "https://i.4cdn.org/${tBoard.board}/${tOP.tim}s.jpg",
        );
      });
    });

    group('isWebm', () {
      test('should return false if the post has no file', () {
        final isWebm = tNoFileReply.isWebm;
        expect(isWebm, false);
      });

      test('should return false if the post has an image', () {
        final isWebm = tOP.isWebm;
        expect(isWebm, false);
      });

      test('should return true if the file is a webm', () {
        final isWebm = tWebmReply.isWebm;
        expect(isWebm, true);
      });
    });

    group('displayTitle', () {
      test('should return the subject of the post if there is one', () {
        final displayTitle = tOP.displayTitle;
        expect(displayTitle, tOP.sub);
      });

      test('should return the comment of the post if there is no subject', () {
        final displayTitle = tNoFileReply.displayTitle;
        expect(displayTitle, tNoFileReply.com);
      });

      test(
          'should return an empty string if there is no subject and no comment',
          () {
        final displayTitle = tImagePost.displayTitle;
        expect(displayTitle, '');
      });
    });

    group('userName', () {
      test('should return "Anonymous" if the poster has no name', () {
        final userName = tImagePost.userName;
        expect(userName, "Anonymous");
      });

      test('should return the name of the poster if they have one', () {
        final userName = tOP.userName;
        expect(userName, tOP.name);
      });
    });

    group('countryFlagUrl', () {
      test('should return null if the post has no country', () {
        final countryFlagUrl = tNoFileReply.countryFlagUrl;
        expect(countryFlagUrl, null);
      });

      test('should return the country flag image url if the post has a country',
          () {
        final countryFlagUrl = tOP.countryFlagUrl;
        expect(countryFlagUrl,
            'https://s.4cdn.org/image/country/${tOP.country?.toLowerCase()}.gif');
      });
    });
  });
}
