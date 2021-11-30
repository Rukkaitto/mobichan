import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/core/widgets/snackbars/success_snackbar.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

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

  void handleSave(BuildContext context) async {
    final image = await screenshotController.capture();
    final result = await ImageGallerySaver.saveImage(
      image!,
      name: "post_${thread.no}",
      quality: 60,
    );
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackbar(context, savePostSuccess.tr()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackbar(context, savePostError.tr()),
      );
    }
  }

  void handleShare() async {
    Share.share(
      'https://boards.4channel.org/${board.board}/thread/${thread.no}',
    );
  }
}
