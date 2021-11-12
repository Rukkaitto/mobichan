import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

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
        appBar: AppBar(
          title: Text(args.thread.displayTitle),
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
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                Hero(
                  child: ThreadWidget(
                    thread: args.thread,
                    board: args.board,
                  ),
                  tag: args.thread.no,
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                BlocBuilder<RepliesCubit, RepliesState>(
                  builder: (context, state) {
                    if (state is RepliesLoaded) {
                      return buildLoaded(
                        thread: args.thread,
                        replies: state.replies,
                      );
                    } else if (state is RepliesLoading) {
                      return buildLoading();
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
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

  Widget buildLoaded({required Post thread, required List<Post> replies}) {
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
            separatorBuilder: (context, index) => Divider(),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              ReplyWidget widget = snapshot.data![index];
              return widget;
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
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
