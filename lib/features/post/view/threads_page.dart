import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ThreadsPage extends StatelessWidget {
  final Board board;

  const ThreadsPage(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThreadsCubit>(
      create: (context) => sl<ThreadsCubit>()..getThreads(board, Sort.initial),
      child: BlocConsumer<ThreadsCubit, ThreadsState>(
        listener: (context, state) {
          if (state is ThreadsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackbar(
                context,
                state.message,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ThreadsLoaded) {
            return buildLoaded(state);
          } else {
            return buildLoading();
          }
        },
      ),
    );
  }

  Widget buildLoaded(ThreadsLoaded state) {
    return BlocListener<SearchCubit, SearchState>(
      listener: (context, state) {
        final threadsCubit = context.read<ThreadsCubit>();
        if (state is Searching) {
          threadsCubit.search(state.input);
        }
        if (state is NotSearching) {
          threadsCubit.search('');
        }
      },
      child: ListView.separated(
        itemCount: state.threads.length,
        separatorBuilder: (context, index) => const Divider(
          height: 0,
          thickness: 1,
        ),
        itemBuilder: (context, index) {
          Post thread = state.threads[index];
          return ThreadWidget(
            thread: thread,
            board: board,
          );
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
