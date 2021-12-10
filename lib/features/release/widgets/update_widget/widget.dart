import 'package:flutter/material.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/release/release.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateWidget extends StatefulWidget {
  const UpdateWidget({Key? key}) : super(key: key);

  @override
  UpdateWidgetState createState() => UpdateWidgetState();
}

class UpdateWidgetState extends State<UpdateWidget> {
  bool isDownloading = false;
  int downloadReceived = 0;
  int downloadTotal = 0;

  @override
  Widget build(BuildContext context) {
    if (!isDownloading) {
      return BlocProvider<ReleaseCubit>(
        create: (context) => sl<ReleaseCubit>()..getLatestRelease(),
        child: BlocConsumer<ReleaseCubit, ReleaseState>(
          listener: (context, state) {
            if (state is ReleaseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackbar(context, state.message),
              );
            }
          },
          builder: (context, state) {
            if (state is ReleaseLoading) {
              return buildLoading();
            } else if (state is ReleaseLoaded) {
              return buildLoaded(context, state.release);
            }
            return Container();
          },
        ),
      );
    } else {
      return buildDownloading(context);
    }
  }
}
