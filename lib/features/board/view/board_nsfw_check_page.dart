import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';

class BoardNsfwCheckPage extends StatelessWidget {
  const BoardNsfwCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardCubit>(
          create: (context) => sl<BoardCubit>()..getLastVisitedBoard(),
        ),
        BlocProvider<TabsCubit>(
          create: (_) => sl<TabsCubit>()..getInitialTabs(),
        ),
      ],
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state is BoardLoaded) {
            return BlocProvider<NsfwWarningCubit>(
              create: (context) =>
                  sl<NsfwWarningCubit>()..checkNsfw(state.board),
              child: BlocBuilder<NsfwWarningCubit, bool>(
                builder: (context, showWarning) {
                  if (showWarning) {
                    return buildWarning(context.read<NsfwWarningCubit>());
                  } else {
                    return BoardPage();
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildWarning(NsfwWarningCubit cubit) {
    return Scaffold(
      appBar: AppBar(
        title: Text('nsfw_warning'.tr()),
      ),
      drawer: BoardDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(nsfw_warning_message).tr(),
            ElevatedButton(
              onPressed: () => cubit.dismiss(),
              child: Text(nsfw_warning_enter).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
