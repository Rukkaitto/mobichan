import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'update_widget.dart';

extension UpdateWidgetHandlers on UpdateWidgetState {
  void handleLaterPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void handleProgress(int newDownloadReceived, int newDownloadTotal) {
    // ignore: invalid_use_of_protected_member
    setState(() {
      isDownloading = true;
      downloadReceived = newDownloadReceived;
      downloadTotal = newDownloadTotal;
    });
    if (newDownloadReceived >= newDownloadTotal) {
      Navigator.of(context).pop();
    }
  }

  void handleDownload(Release latestRelease) async {
    if (latestRelease.apkUrl == null) return;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (await Permission.storage.request().isGranted) {
      Directory? storageDir = await getExternalStorageDirectory();
      String filePath = '${storageDir!.path}/apk-release.apk';
      await Dio().download(
        latestRelease.apkUrl!,
        filePath,
        onReceiveProgress: (received, total) => handleProgress(received, total),
      );

      await InstallPlugin.installApk(filePath, packageInfo.packageName);
    }
  }
}
