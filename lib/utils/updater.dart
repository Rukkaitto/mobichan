import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/models/release.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class Updater {
  static Future<bool> checkForUpdates() async {
    Release latestRelease = await Api.fetchLatestRelease();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Version latestVersion = Version.parse(latestRelease.tagName.substring(1));
    Version currentVersion = Version.parse(packageInfo.version);

    return Future.value(latestVersion > currentVersion);
  }
}
