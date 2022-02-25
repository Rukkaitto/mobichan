import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<List<Setting>?> {
  final SettingRepository repository;

  SettingsCubit({required this.repository}) : super(null);

  Future<void> getSettings() async {
    List<Setting> settings = await repository.getSettings();
    emit(settings);
  }

  Future<void> updateSetting(Setting setting) async {
    if (setting.title == 'analytics') {
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(setting.value);
    }
    await repository.setSetting(setting);
    getSettings();
  }
}
