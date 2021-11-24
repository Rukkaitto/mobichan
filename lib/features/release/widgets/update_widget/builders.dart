import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'update_widget.dart';

extension UpdateWidgetBuilders on UpdateWidgetState {
  AlertDialog buildLoaded(BuildContext context, Release release) {
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
          onPressed: () => handleDownload(release),
          child: Text(
            'Update (${(release.size / 1000000).round()}MB)',
          ),
        ),
      ],
    );
  }

  AlertDialog buildLoading() => const AlertDialog(
        content: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget buildDownloading(BuildContext context) {
    return AlertDialog(
      title: const Text('Downloading update...'),
      content: LinearProgressIndicator(
        value: (downloadReceived / downloadTotal),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
