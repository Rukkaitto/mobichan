import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/classes/viewmodels/filtered_future_view_model.dart';
import 'package:mobichan/utils/utils.dart';

class BoardsViewModel extends FilteredFutureViewModel<Board> {
  //final _navigationService = locator<NavigationService>();
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  get isSearching => _isSearching;
  get searchController => _searchController;

  void startSearching(BuildContext context) {
    _isSearching = true;
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    notifyListeners();
  }

  void _stopSearching() {
    _isSearching = false;
    _searchController.clear();
    changeFilter('');
    notifyListeners();
  }

  @override
  Future<List<Board>> getDataFromServer() => Api.fetchBoards();

  @override
  List<Board> filterData(List<Board> list, String filter) {
    return list
        .where((element) =>
            element.board.contains(filter) ||
            element.title.toLowerCase().contains(filter))
        .toList();
  }

  void goToBoard(Board board) {
    // _navigationService.navigateTo(
    //   Routes.boardView,
    //   arguments: BoardViewArguments(board: board),
    // );
  }

  void onPressedFavorite(Board board) async {
    bool isBoardInFavorites = await Utils.isBoardInFavorites(board);
    isBoardInFavorites
        ? Utils.removeBoardFromFavorites(board)
        : Utils.addBoardToFavorites(board);
  }
}
