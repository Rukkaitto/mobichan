import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:release_repository/release_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateWidget extends StatefulWidget {
  const UpdateWidget({Key? key}) : super(key: key);

  @override
  _UpdateWidgetState createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
  bool _isDownloading = false;
  int _downloadReceived = 0;
  int _downloadTotal = 0;

  void updateDownloadProgress(int downloadReceived, int downloadTotal) {
    setState(() {
      _isDownloading = true;
      _downloadReceived = downloadReceived;
      _downloadTotal = downloadTotal;
    });
    if (_downloadReceived >= _downloadTotal) {
      Navigator.of(context).pop();
    }
  }

  void downloadAndInstallUpdate(Release latestRelease) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (await Permission.storage.request().isGranted) {
      Directory? storageDir = await getExternalStorageDirectory();
      String filePath = '${storageDir!.path}/apk-release.apk';
      await Dio().download(
        latestRelease.browserDownloadUrl,
        filePath,
        onReceiveProgress: (received, total) =>
            updateDownloadProgress(received, total),
      );

      InstallPlugin.installApk(filePath, packageInfo.packageName)
          .then((value) => print("Installed apk $value"))
          .catchError((error) => print(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDownloading) {
      return FutureBuilder(
        future: context.read<ReleaseRepository>().getLatestRelease(),
        builder: (BuildContext context, AsyncSnapshot<Release> snapshot) {
          if (snapshot.hasData) {
            return AlertDialog(
              title: Text(snapshot.data!.name),
              content: Text(snapshot.data!.body),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Later'),
                ),
                TextButton(
                  onPressed: () => downloadAndInstallUpdate(snapshot.data!),
                  child: Text(
                    'Update (${(snapshot.data!.size / 1000000).round()}MB)',
                  ),
                ),
              ],
            );
          }
          return AlertDialog(
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    } else {
      return AlertDialog(
        title: Text('Downloading update...'),
        content: LinearProgressIndicator(
          value: (_downloadReceived / _downloadTotal),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    }
  }
}
