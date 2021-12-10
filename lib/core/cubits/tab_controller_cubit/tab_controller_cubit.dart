import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabControllerCubit extends Cubit<TabController> {
  TabController tabController;

  TabControllerCubit({required this.tabController}) : super(tabController);

  void animateTo(int index) {
    tabController.animateTo(index);
    emit(tabController);
  }
}
