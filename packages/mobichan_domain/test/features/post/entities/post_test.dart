import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Post', () {
    group('replyingTo', () {
      const firstPost = Post(no: 123123);
      const secondPost = Post(no: 234234);
      const thirdPost = Post(no: 345345);

      List<Post> posts = const [
        firstPost,
        secondPost,
        thirdPost,
      ];

      test('should return empty list if the post is replying to no one', () {
        Post post = const Post(
          com: """
            this is a comment with no replies
          """,
        );

        final replyingTo = post.getReplies(posts);
        expect(replyingTo, []);
      });

      test('should return a list of posts that the post is replying to', () {
        Post post = const Post(
          com: """
            <a href="#p123123" class="quotelink">&gt;&gt;84520835
            this is a reply
            <a href="#p345345" class="quotelink">&gt;&gt;84520835
            this is another reply
            <a href="#p999999" class="quotelink">&gt;&gt;84520835
            this is a reply to a post that doesn't exist
          """,
        );

        final replyingTo = post.replyingTo(posts);
        expect(replyingTo.isEmpty, false);
        expect(replyingTo.contains(firstPost), true);
        expect(replyingTo.contains(thirdPost), true);
      });
    });
  });
}
