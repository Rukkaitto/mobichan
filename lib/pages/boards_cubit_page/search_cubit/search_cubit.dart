import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void startSearching() {
    updateInput('');
  }

  void stopSearching() {
    emit(SearchInitial());
  }

  void updateInput(String input) {
    emit(Searching(input));
  }
}
