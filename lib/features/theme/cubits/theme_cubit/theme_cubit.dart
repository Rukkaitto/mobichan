import 'package:bloc/bloc.dart';
import 'package:mobichan/theme.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(theme);

  void changeTheme(ThemeData theme) => emit(theme);
}
