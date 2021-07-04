import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/models/release.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:version/version.dart';
import 'package:install_plugin/install_plugin.dart';

class Updater {
  static void checkForUpdates() async {
    Release latestRelease = await Api.fetchLatestRelease();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Version latestVersion = Version.parse(latestRelease.tagName.substring(1));
    Version currentVersion = Version.parse(packageInfo.version);

    if (latestVersion > currentVersion) {
      print("Updating...");
      if (await Permission.storage.request().isGranted) {
        Directory? storageDir = await getExternalStorageDirectory();
        String filePath = '${storageDir!.path}/apk-release.apk';
        await Dio().download(latestRelease.browserDownloadUrl, filePath);

        if (await Permission.requestInstallPackages.request().isGranted) {
          print("Installing apk...");
          InstallPlugin.installApk(filePath, packageInfo.packageName)
              .then((value) => print("Installed apk $value"))
              .catchError((error) => print(error));
        }
      }
    }
  }
}
