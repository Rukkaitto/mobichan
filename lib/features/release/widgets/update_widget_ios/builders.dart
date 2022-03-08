import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'update_widget_ios.dart';

extension UpdateWidgetIosBuilders on UpdateWidgetIos {
  Widget buildLoaded(BuildContext context, Release release) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(release.name),
      content: Text(release.body),
      actions: [
        TextButton(
          onPressed: () => handleLaterPressed(context),
          child: const Text('Later'),
        ),
        TextButton(
          onPressed: () => handleGoToReleasePage(release),
          child: const Text(
            'Go to release page',
          ),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return const AlertDialog(
      content: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
