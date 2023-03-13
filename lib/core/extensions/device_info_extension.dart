import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

extension DeviceInfoExtension on DeviceInfoPlugin {
  Future<String?> getUUID() async {
    if (Platform.isAndroid) {
      var androidDeviceInfo = await androidInfo;
      return androidDeviceInfo.id.toLowerCase();
    }
    return null;
  }
}
