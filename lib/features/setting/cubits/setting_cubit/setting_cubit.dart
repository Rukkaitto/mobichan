import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<Setting?> {
  final SettingRepository repository;

  SettingCubit({required this.repository}) : super(null);

  void getSetting(String key) async {
    final setting = await repository.getSetting(key);
    emit(setting);
  }

  void updateSetting(Setting setting, dynamic value) async {
    Setting updatedSetting =
        Setting(title: setting.title, value: value, type: setting.type);
    await repository.setSetting(updatedSetting);
    emit(updatedSetting);
  }
}
