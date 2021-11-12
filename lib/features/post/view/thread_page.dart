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

  Widget buildLoaded({required Post thread, required List<Post> replies}) {
    List<Post> rootReplies = replies
        .where((reply) =>
            reply.isRootPost || reply.replyingTo(replies).contains(thread.no))
        .toList();
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: rootReplies.length,
      itemBuilder: (context, index) {
        Post reply = rootReplies[index];
        return ReplyWidget(reply: reply, threadReplies: replies, recursion: 0);
      },
    );
  }
}
