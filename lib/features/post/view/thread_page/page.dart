import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/extensions/platform_extension.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/features/core/core.dart';

class ThreadPageArguments {
  final Board board;
  final Post thread;

  ThreadPageArguments({required this.board, required this.thread});
}

class ComputeArgs {
  final Board board;
  final Post thread;
  final List<Post> replies;

  ComputeArgs(
      {required this.board, required this.thread, required this.replies});
}

class ThreadPage extends StatelessWidget {
  static const routeName = '/thread';

  final ScrollController scrollController = ScrollController();

  ThreadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ThreadPageArguments;

    return MultiBlocProvider(
      providers: [
        BlocProvider<RepliesCubit>(
          create: (context) =>
              sl<RepliesCubit>()..getReplies(args.board, args.thread),
        ),
        BlocProvider<PostFormCubit>(
          create: (context) => PostFormCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => handleFormButtonPressed(context),
              child: Icon(Icons.edit),
            ),
            appBar: AppBar(
              title: Text(
                  args.thread.displayTitle.replaceBrWithSpace.removeHtmlTags),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                buildPopupMenuButton(
                  context: context,
                  scrollController: scrollController,
                  board: args.board,
                  thread: args.thread,
                ),
              ],
            ),
            body: Builder(
              builder: (context) {
                return Center(
                  child: SizedBox(
                    width: PlatformExtension.isDesktop
                        ? MediaQuery.of(context).size.width / 2
                        : double.infinity,
                    child: RefreshIndicator(
                      onRefresh: () async =>
                          handleRefresh(context, args.board, args.thread),
                      child: BlocBuilder<RepliesCubit, RepliesState>(
                        builder: (context, state) {
                          if (state is RepliesLoaded) {
                            return Stack(
                              children: [
                                buildLoaded(
                                  board: args.board,
                                  thread: args.thread,
                                  replies: state.replies,
                                  scrollController: scrollController,
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
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
