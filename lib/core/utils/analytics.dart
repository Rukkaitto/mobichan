import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobichan/core/extensions/device_info_extension.dart';
import 'package:supabase/supabase.dart';

import '../../dependency_injector.dart';

class Analytics {
  static void sendDevice({required bool active}) async {
    final result = await sl<SupabaseClient>().from('Devices').upsert(
      [
        {
          'uuid': await DeviceInfoPlugin().getUUID(),
          'last_login': DateTime.now().toUtc().toIso8601String(),
          'active': active,
        }
      ],
      onConflict: 'uuid',
    ).execute();
    if (result.hasError) {
      log(result.error.toString());
    }
  }
}
