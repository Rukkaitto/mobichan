part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final List<Setting> settings;

  SettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);

  @override
  List<Object> get props => [message];
}
