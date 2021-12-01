import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Post', () {
    const tBoard = Board(board: 'g', title: 'Technology', wsBoard: 1);
    const tFirstPost = Post(
      no: 123123,
      com: """
        this is a comment replying to no one
      """,
      tim: 7839789,
      ext: '.png',
    );
    const tSecondPost = Post(
      no: 234234,
      com: """
        <a href="#p123123" class="quotelink">&gt;&gt;123123
        this is a comment replying to the first post
      """,
    );
    const tThirdPost = Post(
      no: 345345,
      com: """
        <a href="#p123123" class="quotelink">&gt;&gt;123123
        this is another comment replying to the first post
      """,
      tim: 4792974,
      ext: '.webm',
    );

    List<Post> posts = const [
      tFirstPost,
      tSecondPost,
      tThirdPost,
    ];

    group('getReplies', () {
      test('should return empty list if the post has no replies', () {
        final replies = tSecondPost.getReplies(posts);
        expect(replies, []);
      });

      test('should return a list of replies to a post', () {
        final replies = tFirstPost.getReplies(posts);
        expect(replies.isEmpty, false);
        expect(replies, [tSecondPost, tThirdPost]);
      });
    });

    group('replyingTo', () {
      test('should return empty list if the post is replying to no one', () {
        final replyingTo = tFirstPost.replyingTo(posts);
        expect(replyingTo, []);
      });

      test('should return a list of posts that the post is replying to', () {
        final replyingTo = tSecondPost.replyingTo(posts);
        expect(replyingTo.isEmpty, false);
        expect(replyingTo.contains(tFirstPost), true);
      });
    });

    group('isRootPost', () {
      test('should return true if the post is a root post', () {
        final isRootPost = tFirstPost.isRootPost;
        expect(isRootPost, true);
      });

      test('should return false if the post is not a root post', () {
        final isRootPost = tSecondPost.isRootPost;
        expect(isRootPost, false);
      });
    });

    group('getQuotedPost', () {
      test('should return null if the quotelinked post does not exist', () {
        final post = posts.getQuotedPost("#p666666");
        expect(post, null);
      });

      test('should return a post if given a list of posts and a quotelink', () {
        final post = posts.getQuotedPost("#p${tFirstPost.no}");
        expect(post, tFirstPost);
      });
    });

    group('getImageUrl', () {
      test('should return null if the post has no image', () {
        final imageUrl = tSecondPost.getImageUrl(tBoard);
        expect(imageUrl, null);
      });
      test('should return the url of the image if the post has an image', () {
        final imageUrl = tFirstPost.getImageUrl(tBoard);
        expect(
          imageUrl,
          "https://i.4cdn.org/${tBoard.board}/${tFirstPost.tim}${tFirstPost.ext}",
        );
      });
    });

    group('getThumbnailUrl', () {
      test('should return null if the post has no image', () {
        final imageUrl = tSecondPost.getThumbnailUrl(tBoard);
        expect(imageUrl, null);
      });
      test('should return the url of the thumbnail if the post has an image',
          () {
        final imageUrl = tFirstPost.getThumbnailUrl(tBoard);
        expect(
          imageUrl,
          "https://i.4cdn.org/${tBoard.board}/${tFirstPost.tim}s.jpg",
        );
      });
    });

    group('isWebm', () {
      test('should return false if the post has no file', () {
        final isWebm = tSecondPost.isWebm;
        expect(isWebm, false);
      });

      test('should return false if the post has an image', () {
        final isWebm = tFirstPost.isWebm;
        expect(isWebm, false);
      });

      test('should return true if the file is a webm', () {
        final isWebm = tThirdPost.isWebm;
        expect(isWebm, true);
      });
    });
  });
}
