import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

import 'thread_widget.dart';

extension ThreadWidgetHandlers on ThreadWidget {
  void handleReply(BuildContext context) {
    context.read<PostFormCubit>().reply(thread);
  }

  void handleReport() async {
    final url =
        'https://sys.4channel.org/${board.board}/imgboard.php?mode=report&no=${thread.no}';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, universalLinksOnly: true);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
