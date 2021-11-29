part of 'setting_cubit.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class SettingUpdated extends SettingState {
  final Setting setting;

  const SettingUpdated({required this.setting});

  @override
  List<Object> get props => [setting];
}

class SettingError extends SettingState {
  final String message;

  const SettingError({required this.message});

  @override
  List<Object> get props => [message];
}
