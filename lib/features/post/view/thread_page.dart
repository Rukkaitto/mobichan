import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/features/core/core.dart';

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
          title: Text(args.thread.displayTitle.removeHtmlTags),
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
        body: Builder(builder: (context) {
          return RefreshIndicator(
            onRefresh: () async => context
                .read<RepliesCubit>()
                .getReplies(args.board, args.thread),
            child: BlocBuilder<RepliesCubit, RepliesState>(
              builder: (context, state) {
                if (state is RepliesLoaded) {
                  return buildLoaded(
                    board: args.board,
                    thread: args.thread,
                    replies: state.replies,
                  );
                } else if (state is RepliesLoading) {
                  return buildLoading(args.board, args.thread);
                } else {
                  return Container();
                }
              },
            ),
          );
        }),
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
          child: Center(
            child: CircularProgressIndicator(),
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
      widgets.add(ReplyWidget(reply: rootReply, recursion: 0));
      widgets.addAll(_getReplies(rootReply, [], args.replies, 1));
    }
    return widgets;
  }

  static List<ReplyWidget> _getReplies(
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
          element,
          replies..add(ReplyWidget(reply: element, recursion: recursion)),
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
          thread: thread,
          replies: replies,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 0,
              thickness: 1,
            ),
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
  final Post thread;
  final List<Post> replies;

  ComputeArgs({required this.thread, required this.replies});
}
