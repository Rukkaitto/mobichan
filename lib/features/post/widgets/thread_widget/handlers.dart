import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/core/core.dart';

import 'thread_widget.dart';

extension ThreadWidgetHandlers on ThreadWidget {
  void handleReply(BuildContext context) {
    context.read<PostFormCubit>().reply(thread);
  }
}
