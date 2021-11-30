import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Post', () {
    const firstPost = Post(
      no: 123123,
      com: """
        this is a comment replying to no one
      """,
    );
    const secondPost = Post(
      no: 234234,
      com: """
        <a href="#p123123" class="quotelink">&gt;&gt;123123
        this is a comment replying to the first post
      """,
    );
    const thirdPost = Post(
      no: 345345,
      com: """
        <a href="#p123123" class="quotelink">&gt;&gt;123123
        this is another comment replying to the first post
      """,
    );

    List<Post> posts = const [
      firstPost,
      secondPost,
      thirdPost,
    ];

    group('getReplies', () {
      test('should return empty list if the post has no replies', () {
        final replies = secondPost.getReplies(posts);
        expect(replies, []);
      });

      test('should return a list of replies to a post', () {
        final replies = firstPost.getReplies(posts);
        expect(replies.isEmpty, false);
        expect(replies, [secondPost, thirdPost]);
      });
    });

    group('replyingTo', () {
      test('should return empty list if the post is replying to no one', () {
        final replyingTo = firstPost.replyingTo(posts);
        expect(replyingTo, []);
      });

      test('should return a list of posts that the post is replying to', () {
        final replyingTo = secondPost.replyingTo(posts);
        expect(replyingTo.isEmpty, false);
        expect(replyingTo.contains(firstPost), true);
      });
    });
  });
}
