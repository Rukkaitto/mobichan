import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ReplyWidget extends StatelessWidget {
  final Post reply;
  final List<Post> threadReplies;
  final int recursion;
  final int maxRecursion = 5;

  const ReplyWidget(
      {required this.reply,
      required this.threadReplies,
      required this.recursion,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Html(data: reply.com ?? ''),
        buildReplies() ?? Container(),
      ],
    );
  }

  Widget? buildReplies() {
    List<Post> replies = reply.getReplies(threadReplies);
    if (recursion < maxRecursion) {
      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: ListView.builder(
          itemCount: replies.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return FutureBuilder<Widget>(
              future: compute(
                _computeWidget,
                ComputeArgs(
                  reply: replies[index],
                  threadReplies: threadReplies,
                  recursion: recursion + 1,
                ),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          },
        ),
      );
    }
  }

  static Widget _computeWidget(ComputeArgs args) {
    return ReplyWidget(
      reply: args.reply,
      threadReplies: args.threadReplies,
      recursion: args.recursion,
    );
  }
}

class ComputeArgs {
  final Post reply;
  final List<Post> threadReplies;
  final int recursion;

  ComputeArgs(
      {required this.reply,
      required this.threadReplies,
      required this.recursion});
}
