import 'package:flutter/material.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/release/release.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'update_widget.dart';

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
        child: AsyncBlocBuilder<Release, ReleaseCubit, ReleaseState,
            ReleaseLoading, ReleaseLoaded, ReleaseError>(
          builder: (context, release) {
            return buildLoaded(context, release);
          },
        ),
      );
    } else {
      return buildDownloading(context);
    }
  }
}
