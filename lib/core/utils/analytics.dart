import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobichan/core/extensions/device_info_extension.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:supabase/supabase.dart';

import '../../dependency_injector.dart';

/// This class is used to send analytics data to supabase.
class Analytics {
  /// Sends device information to supabase. This is called automatically when
  /// the app is started and when the app is resumed/stopped/paused.
  ///
  /// [active] indicates if the user is currently using the app.
  static void sendDeviceInfo({
    required bool active,
    bool updateLastLogin = false,
  }) async {
    // Checks if analytics are enabled
    final analytics = await sl<SettingRepository>().getSetting('analytics');
    if (!analytics?.value) return;

    // Gets device info
    final uuid = await DeviceInfoPlugin().getUUID();
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    Map<String, dynamic> data = {
      'uuid': uuid,
      'device_info': deviceInfo.toMap(),
      'active': active,
    };

    if (updateLastLogin) {
      data['last_login'] = DateTime.now().toUtc().toIso8601String();
    }

    // Sends device info to supabase
    final result = await sl<SupabaseClient>()
        .from('Devices')
        .upsert(
          data,
          onConflict: 'uuid',
        )
        .execute();
    if (result.hasError) {
      log(result.error.toString());
    }
  }
}
