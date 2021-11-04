import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  void getFavorites() async {
    emit(FavoritesLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Board> favorites = List.empty();
    if (prefs.containsKey(BOARD_FAVORITES)) {
      favorites = prefs
          .getStringList(BOARD_FAVORITES)!
          .map((board) => Board.fromJson(jsonDecode(board)))
          .toList()
        ..sort((a, b) => a.board.compareTo(b.board));
    }
    emit(FavoritesLoaded(favorites));
  }
}
