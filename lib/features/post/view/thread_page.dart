import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:shimmer/shimmer.dart';

class ThreadPageArguments {
  final Board board;
  final Post thread;

  ThreadPageArguments({required this.board, required this.thread});
}

class ThreadPage extends StatelessWidget {
  static const routeName = '/thread';

  const ThreadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ThreadPageArguments;

    return BlocProvider<RepliesCubit>(
      create: (context) =>
          sl<RepliesCubit>()..getReplies(args.board, args.thread),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.edit),
        ),
        appBar: AppBar(
          title:
              Text(args.thread.displayTitle.replaceBrWithSpace.removeHtmlTags),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'test',
                  child: Text('Test'),
                ),
              ],
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<RepliesCubit>()
                  .getReplies(args.board, args.thread),
              child: BlocBuilder<RepliesCubit, RepliesState>(
                builder: (context, state) {
                  if (state is RepliesLoaded) {
                    return Stack(
                      children: [
                        buildLoaded(
                          board: args.board,
                          thread: args.thread,
                          replies: state.replies,
                        ),
                        FormWidget(
                          board: args.board,
                          thread: args.thread,
                        ),
                      ],
                    );
                  } else if (state is RepliesLoading) {
                    return buildLoading(args.board, args.thread);
                  } else {
                    return Container();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildLoading(Board board, Post thread) {
    return Column(
      children: [
        Hero(
          tag: thread.no,
          child: ThreadWidget(
            thread: thread,
            board: board,
            inThread: true,
          ),
        ),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade700,
            highlightColor: Colors.grey.shade600,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: RandomUtils.randomInt(0, 6) * 15.0 + 8.0,
                      top: 8.0,
                      bottom: 8.0,
                      right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        width: 300,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: 250,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  static List<ReplyWidget> _computeReplies(ComputeArgs args) {
    List<ReplyWidget> widgets = [];
    List<Post> rootReplies = args.replies
        .where((reply) =>
            reply.isRootPost ||
            reply.replyingTo(args.replies).first == args.thread.no)
        .toList();
    for (Post rootReply in rootReplies) {
      widgets.add(
        ReplyWidget(
          board: args.board,
          reply: rootReply,
          threadReplies: args.replies,
          recursion: 0,
        ),
      );
      widgets.addAll(_getReplies(args.board, rootReply, [], args.replies, 0));
    }
    return widgets;
  }

  static List<ReplyWidget> _getReplies(
    Board board,
    Post reply,
    List<ReplyWidget> replies,
    List<Post> threadReplies,
    int recursion,
  ) {
    List<Post> postReplies = reply
        .getReplies(threadReplies)
        .where((element) => element.replyingTo(threadReplies).first == reply.no)
        .toList();
    if (postReplies.isEmpty) {
      return replies;
    } else {
      List<ReplyWidget> result = [];
      for (Post element in postReplies) {
        result = _getReplies(
          board,
          element,
          replies
            ..add(
              ReplyWidget(
                board: board,
                reply: element,
                threadReplies: threadReplies,
                recursion: recursion,
              ),
            ),
          threadReplies,
          recursion + 1,
        );
      }
      return result;
    }
  }

  Widget buildLoaded({
    required Board board,
    required Post thread,
    required List<Post> replies,
  }) {
    return FutureBuilder<List<ReplyWidget>>(
      future: compute<ComputeArgs, List<ReplyWidget>>(
        _computeReplies,
        ComputeArgs(
          board: board,
          thread: thread,
          replies: replies,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Hero(
                  tag: thread.no,
                  child: ThreadWidget(
                    thread: thread,
                    board: board,
                    inThread: true,
                  ),
                );
              }
              ReplyWidget widget = snapshot.data![index];
              return widget;
            },
          );
        } else {
          return buildLoading(board, thread);
        }
      },
    );
  }
}

class ComputeArgs {
  final Board board;
  final Post thread;
  final List<Post> replies;

  ComputeArgs(
      {required this.board, required this.thread, required this.replies});
}
