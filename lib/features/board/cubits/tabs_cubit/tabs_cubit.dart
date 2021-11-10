import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class Tabs {
  final List<Board> boards;
  final Board current;

  Tabs({required this.boards, required this.current});
}

class TabsCubit extends Cubit<Tabs> {
  final BoardRepository repository;
  TabsCubit({required this.repository})
      : super(Tabs(boards: [], current: Board.initial));

  Future<void> getInitialTabs() async {
    final tabs = await repository.getFavoriteBoards();
    final lastVisitedBoard = await repository.getLastVisitedBoard();
    List<Board> newTabs = _addTab(tabs, lastVisitedBoard);
    print(newTabs);
    emit(Tabs(boards: newTabs, current: lastVisitedBoard));
  }

  void addTab(Board board) {
    List<Board> newTabs = _addTab(state.boards, board);
    emit(Tabs(boards: newTabs, current: board));
  }

  Future<void> setCurrentTab(Board board) async {
    await repository.saveLastVisitedBoard(board);
    emit(Tabs(boards: state.boards, current: board));
  }

  List<Board> _addTab(List<Board> tabs, Board tab) {
    List<Board> newTabs = List.from(tabs);
    if (!tabs.contains(tab)) {
      newTabs.add(tab);
    }

    return newTabs;
  }
}
