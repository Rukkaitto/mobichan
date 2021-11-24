import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const NotSearching());

  void startSearching(BuildContext context) {
    updateInput('');
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
  }

  void stopSearching() {
    emit(const NotSearching());
  }

  void updateInput(String input) {
    emit(Searching(input));
  }
}
