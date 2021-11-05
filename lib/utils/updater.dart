import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:release_repository/release_repository.dart';
import 'package:version/version.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Updater {
  static Future<bool> checkForUpdates(BuildContext context) async {
    Release latestRelease =
        await context.read<ReleaseRepository>().getLatestRelease();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Version latestVersion = Version.parse(latestRelease.tagName.substring(1));
    Version currentVersion = Version.parse(packageInfo.version);

    return Future.value(latestVersion > currentVersion);
  }
}
