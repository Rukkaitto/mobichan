import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class ExpansionCubit extends Cubit<List<bool>> {
  final List<bool> expansions;

  ExpansionCubit({required this.expansions}) : super(expansions);

  void toggleExpansion(int index) {
    expansions[index] = !expansions[index];
    emit(expansions);
  }
}
