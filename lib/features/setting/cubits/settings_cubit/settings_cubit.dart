import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingRepository repository;

  SettingsCubit({required this.repository}) : super(SettingsInitial());

  Future<void> getSettings() async {
    List<Setting> settings = await repository.getSettings();
    emit(SettingsLoaded(settings));
  }
}
