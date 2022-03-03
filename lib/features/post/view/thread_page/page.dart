import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/core/core.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ThreadPageArguments {
  final Board board;
  final Post thread;

  ThreadPageArguments({required this.board, required this.thread});
}

class ComputeArgs {
  final Board board;
  final Post thread;
  final List<Post> replies;

  ComputeArgs({
    required this.board,
    required this.thread,
    required this.replies,
  });
}

class ThreadPage extends StatelessWidget {
  static const routeName = '/thread';
  static const maxRecursion = 7;
  final List<int> repliesCountHistory = [];

  final ItemScrollController itemScrollController = ItemScrollController();

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
        BlocProvider<SettingsCubit>(
          create: (context) => sl<SettingsCubit>()..getSettings(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocConsumer<RepliesCubit, RepliesState>(
            listener: buildListener,
            builder: (context, repliesState) => buildBuilder(
              context: context,
              repliesState: repliesState,
              args: args,
            ),
          );
        },
      ),
    );
  }
}
