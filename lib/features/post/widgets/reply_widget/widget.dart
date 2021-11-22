import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ReplyWidget extends StatelessWidget {
  final Board board;
  final Post reply;
  final List<Post> threadReplies;
  final int recursion;

  const ReplyWidget({
    required this.board,
    required this.reply,
    required this.threadReplies,
    required this.recursion,
    Key? key,
  }) : super(key: key);

  double computePadding(int recursion) {
    if (recursion == 0 || recursion == 1) {
      return 0;
    } else {
      return 15.0 * (recursion - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: computePadding(recursion)),
            child: Stack(
              children: [
                buildIndentBar(),
                Padding(
                  padding: EdgeInsets.only(left: recursion > 0 ? 14 : 0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildName(),
                          const SizedBox(width: 5),
                          buildNumber(context),
                        ],
                      ),
                      buildImage(),
                      const SizedBox(height: 5),
                      buildContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String insertATags(String? str) {
    if (str == null) {
      return '';
    }
    final regExp = RegExp(
      r'(?<!(href="))http[s?]:\/\/[^\s<]+(?!<\/a>)',
    );
    return str.removeWbr.replaceAllMapped(regExp, (match) {
      return '<a href="${match.group(0)}">${match.group(0)}</a>';
    });
  }
}
